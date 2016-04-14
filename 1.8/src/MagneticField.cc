/// \file MagneticField.cc
/// Contains:
/// - get_magnetic_Fields: fills Magnetic Field Map 
///   based on Database definitions.\n\n
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UniformMagField.hh"
#include "G4PropagatorInField.hh"
#include "G4TransportationManager.hh"
#include "G4Mag_UsualEqRhs.hh"
#include "G4MagIntegratorStepper.hh"
#include "G4ChordFinder.hh"
#include "G4ClassicalRK4.hh"
#include "G4HelixSimpleRunge.hh"

// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QtSql>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "detector.h"
#include "MagneticField.h"
#include "usage.h"
#include "string_utilities.h"

map<string, MagneticField> get_magnetic_Fields(gemc_opts Opt)
{
	string hd_msg          = Opt.args["LOG_MSG"].args + " Magnetic Field >> " ;
	double MGN_VERBOSITY   = Opt.args["MGN_VERBOSITY"].arg;
	string database        = Opt.args["DATABASE"].args;
	string dbtable         = "magnetic_fields";
	string dbhost          = Opt.args["DBHOST"].args;

	string dbUser          = Opt.args["DBUSER"].args;
	string dbPswd          = Opt.args["DBPSWD"].args;
	
	vector<opts> FIELD_SCALES = Opt.get_args("SCALE_FIELD");
	map<string, double> SCALES;
	for(unsigned int f=0; f<FIELD_SCALES.size(); f++)
	{
		string SCALEF = FIELD_SCALES[f].args;
		string fieldname;
		int ppos = SCALEF.find(",");
		fieldname.assign(SCALEF, 0, ppos);
		SCALEF.assign(SCALEF, ppos+1, SCALEF.size());
		SCALES[fieldname] = atof(SCALEF.c_str());
	}

	map<string, MagneticField> FieldMap;

	QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
	db.setHostName(dbhost.c_str());
	db.setDatabaseName(database.c_str());
	db.setUserName( dbUser.c_str() );
	db.setPassword( dbPswd.c_str() );

	bool ok = db.open();

	if(!ok)
	{
		cout << hd_msg << " Database not connected. Exiting." << endl;
		exit(-1);
	}

	MagneticField magneticField;
	QSqlQuery q;
	string dbexecute = "select name, type, magnitude, swim_method, description from " + dbtable ;
	q.exec(dbexecute.c_str());

	if(MGN_VERBOSITY>2)
		cout << hd_msg << " Available Magnetic Fields: " << endl  << endl;

	while (q.next())
	{
		magneticField.name         = TrimSpaces(gemc_tostring(q.value(0).toString()));
		magneticField.type         = gemc_tostring(q.value(1).toString());
		magneticField.magnitude    = gemc_tostring(q.value(2).toString());
		magneticField.swim_method  = gemc_tostring(q.value(3).toString());
		magneticField.description  = gemc_tostring(q.value(4).toString());

		// Sets MFM pointer to NULL
		magneticField.init_MFM();
		magneticField.gemcOpt = Opt;

		// Adjust Field Scale Factor if any
		magneticField.scale_factor = 1;
		if(SCALES.find(magneticField.name) != SCALES.end())
		{
			magneticField.scale_factor = SCALES[magneticField.name];
			cout << hd_msg << " SCALE FACTOR: Magnetic Field " << magneticField.name << " scaled by: " << magneticField.scale_factor << endl;

		}	

		FieldMap[magneticField.name] = magneticField;

		if(MGN_VERBOSITY>2)
		{
			cout << "      ";
			cout.width(15);
			cout << magneticField.name << "   |   ";
			cout << magneticField.description << endl;
			cout << "      ";
			cout.width(15);
			cout << magneticField.name << "   |  type:        |  ";
			cout << magneticField.type << endl;
			cout << "      ";
			cout.width(15);
			cout << magneticField.name << "   |  Magnitude:   |  ";
			cout << magneticField.magnitude << endl;
			cout << "      ";
			cout.width(15);
			cout << magneticField.name << "   |  Swim Method: |  ";
			cout << magneticField.swim_method << endl;
			cout << "          --------------------------------------------------------------  " << endl;
		}
	}
	db.close();

	cout << endl;
	db = QSqlDatabase();
	db.removeDatabase("qt_sql_default_connection");

	return FieldMap;
}


void MagneticField::create_MFM()
{
	string hd_msg         = gemcOpt.args["LOG_MSG"].args + " Magnetic Field: >> ";
	double MGN_VERBOSITY  = gemcOpt.args["MGN_VERBOSITY"].arg;
	string catch_v        = gemcOpt.args["CATCH"].args;

	stringstream vars;
	string var, format, symmetry, MapFile;
	string var1, var2, var3, dim;
	string dimSpc, dimFld;

	string integration_method;      	///< Swim Method. Current Choices: RangeKutta.

	vars << type;
	vars >> var >> format >> symmetry >> MapFile;

	mappedfield = NULL;

	// %%%%%%%%%%%%%%%%%%%%%%
	// Uniform Magnetic Field
	// %%%%%%%%%%%%%%%%%%%%%%
	if(var == "uniform")
	{
		vars.clear();
		vars << magnitude;
		double x,y,z;
		vars >> var; x = scale_factor*get_number(var);
		vars >> var; y = scale_factor*get_number(var);
		vars >> var; z = scale_factor*get_number(var);
		if(MGN_VERBOSITY>3)
		{
			cout << hd_msg << " <" << name << "> is a uniform magnetic field type, scaled by " << scale_factor  << endl;
			cout << hd_msg << " <" << name << "> dimensions:" ;
			cout << "      (" << x/gauss << ", " << y/gauss << ", " << z/gauss << ") gauss." << endl;
		}
		G4UniformMagField* magField = new G4UniformMagField(G4ThreeVector((x/gauss)*gauss, (y/gauss)*gauss, (z/gauss)*gauss));

		G4Mag_UsualEqRhs*       iEquation    = new G4Mag_UsualEqRhs(magField);
		G4MagIntegratorStepper* iStepper     = new G4ClassicalRK4(iEquation);
		G4ChordFinder*          iChordFinder = new G4ChordFinder(magField, 1.0e-2*mm, iStepper);

		MFM = new G4FieldManager(magField, iChordFinder);

		return;
	}

	// %%%%%%%%%%%%%%%%%%%%%%%
	// Mapped Field
	// 1D-dipole field
	// Dependent on 2 transverse, longitudinal
	// cartesian coordinates
	// %%%%%%%%%%%%%%%%%%%%%%%
	// For now it's "z-z" We'll see if in the future we need a more general 
	// code.
	if(var == "mapped" && symmetry == "Dipole-y")
	{
		vars.clear();
		vars << magnitude;
		int TNPOINTS, LNPOINTS;         	///< Number of cells in Tranverse, Longitudinal dimensions
		double tlimits[2], llimits[2];  	///< Boundaries in  Tranverse, Longitudinal dimensions
		double mapOrigin[3];            	///< Displacemept of the mapped field
		string units[5];                	///< Units for table dimensions and field
		
		vars >> var;
		LNPOINTS  = (int) get_number(var);
		vars >> var1 >> var2 >> dim;
		llimits[0]   =  get_number(var1 + "*" + dim);
		llimits[1]   =  get_number(var2 + "*" + dim);
		units[0].assign(dim);
		
		vars >> var;
		TNPOINTS  = (int) get_number(var);
		vars >> var1 >> var2 >> dim;
		tlimits[0]   =  get_number(var1 + "*" + dim);
		tlimits[1]   =  get_number(var2 + "*" + dim);
		units[1].assign(dim);
		
		
		// Origin and Units
		vars >> var1 >> var2 >> var3 >> dimSpc >> dimFld;
		mapOrigin[0] = get_number(var1 + "*" + dimSpc);
		mapOrigin[1] = get_number(var2 + "*" + dimSpc);
		mapOrigin[2] = get_number(var3 + "*" + dimSpc);
		units[3].assign( dimSpc );
		units[4].assign( dimFld);
		
		vars.clear();
		vars << swim_method;
		vars >> integration_method;
		vars.clear();
		vars << swim_method;
		vars >> integration_method;
		if(MGN_VERBOSITY>3)
		{
			cout << hd_msg << " <" << name << "> is a " << symmetry << " mapped field in cartesian coordinates" << endl;;
			cout << hd_msg << " <" << name << "> has (" << TNPOINTS << ", " << LNPOINTS << ") points." << endl;;
			cout << hd_msg << " Tranverse Boundaries:     (" << tlimits[0]/cm << ", " << tlimits[1]/cm << ") cm." << endl;
			cout << hd_msg << " Longitudinal Boundaries:  (" << llimits[0]/cm << ", " << llimits[1]/cm << ") cm." << endl;
			cout << hd_msg << " Map Displacement:  (" << mapOrigin[0]/cm << ", "
			<< mapOrigin[1]/cm << ", "
			<< mapOrigin[2]/cm << ") cm." << endl;
			cout << hd_msg << " Integration Method: " << integration_method << endl;
			cout << hd_msg << " Map Field Units: " << units[4] << endl;
			cout << hd_msg << " Map File: " << MapFile << endl;
		}
		mappedfield = new MappedField(gemcOpt, TNPOINTS, LNPOINTS, tlimits, llimits, MapFile, mapOrigin, units, scale_factor, symmetry);
	}

	// %%%%%%%%%%%%%%%%%%%%%%%
	// Mapped Field
	// phi-symmetric
	// cylindrical coordinates
	// %%%%%%%%%%%%%%%%%%%%%%%
  
  // by default the symmetry is around z. But it could be around x or y axis
	if(var == "mapped" && (symmetry == "cylindrical" || symmetry == "cylindrical-x" || symmetry == "cylindrical-y"))
	{
		vars.clear();
		vars << magnitude;
		int TNPOINTS, LNPOINTS;         	///< Number of cells in Tranverse, Longitudinal dimensions
		double tlimits[2], llimits[2];  	///< Boundaries in  Tranverse, Longitudinal dimensions
		double mapOrigin[3];            	///< Displacemept of the mapped field
		string units[5];                	///< Units for table dimensions and field

		vars >> var;
		TNPOINTS  = (int) get_number(var);
		vars >> var1 >> var2 >> dim;
		tlimits[0]   =  get_number(var1 + "*" + dim);
		tlimits[1]   =  get_number(var2 + "*" + dim);
		units[0].assign(dim);


		vars >> var;
		LNPOINTS  = (int) get_number(var);
		vars >> var1 >> var2 >> dim;
		llimits[0]   =  get_number(var1 + "*" + dim);
		llimits[1]   =  get_number(var2 + "*" + dim);
		units[1].assign(dim);

			// Origin and Units
		vars >> var1 >> var2 >> var3 >> dimSpc >> dimFld;
		mapOrigin[0] = get_number(var1 + "*" + dimSpc);
		mapOrigin[1] = get_number(var2 + "*" + dimSpc);
		mapOrigin[2] = get_number(var3 + "*" + dimSpc);
		units[3].assign( dimSpc );
		units[4].assign( dimFld);
		
		vars.clear();
		vars << swim_method;
		vars >> integration_method;
		vars.clear();
		vars << swim_method;
		vars >> integration_method;
		if(MGN_VERBOSITY>3)
		{
			cout << hd_msg << " <" << name << "> is a phi-symmetric mapped field in cylindrical coordinates" << endl;;
			cout << hd_msg << " <" << name << "> has (" << TNPOINTS << ", " << LNPOINTS << ") points." << endl;;
			cout << hd_msg << " Tranverse Boundaries:     (" << tlimits[0]/cm << ", " << tlimits[1]/cm << ") cm." << endl;
			cout << hd_msg << " Longitudinal Boundaries:  (" << llimits[0]/cm << ", " << llimits[1]/cm << ") cm." << endl;
			cout << hd_msg << " Map Displacement:  (" << mapOrigin[0]/cm << ", "
					<< mapOrigin[1]/cm << ", "
					<< mapOrigin[2]/cm << ") cm." << endl;
			cout << hd_msg << " Integration Method: " << integration_method << endl;
			cout << hd_msg << " Map Field Units: " << units[4] << endl;
			cout << hd_msg << " Map File: " << MapFile << endl;
		}
    // last argument is dummy
		mappedfield = new MappedField(gemcOpt, TNPOINTS, LNPOINTS, tlimits, llimits, MapFile, mapOrigin, units, scale_factor, symmetry, 0);
	}



	// %%%%%%%%%%%%%%%%%%%%%%%
	// Mapped Field
	// phi-segmented
	// cylindrical coordinates
	// %%%%%%%%%%%%%%%%%%%%%%%
	if(var == "mapped" && symmetry == "phi-segmented")
	{
		vars.clear();
		vars << magnitude;
		int TNPOINTS, PNPOINTS, LNPOINTS;            	///< Number of cells in Tranverse, Azimuthal, Longitudinal dimensions
		double plimits[2], tlimits[2], llimits[2];   	///< Boundaries in  Tranverse, Azimuthal, Longitudinal dimensions
		double mapOrigin[3];                         	///< Displacemept of the mapped field
		string units[5];                             	///< Units for table dimensions and field

		vars >> var ;
		PNPOINTS  = (int) get_number(var);
		vars >> var1 >> var2 >> dim;
		plimits[0]   =  get_number(var1 + "*" + dim);
		plimits[1]   =  get_number(var2 + "*" + dim);
		units[0].assign(dim);

		vars >> var ;
		TNPOINTS  = (int) get_number(var);
		vars >> var1 >> var2 >> dim;
		tlimits[0]   =  get_number(var1 + "*" + dim);
		tlimits[1]   =  get_number(var2 + "*" + dim);
		units[1].assign(dim);

		vars >> var ;
		LNPOINTS  = (int) get_number(var);
		vars >> var1 >> var2 >> dim;
		llimits[0]   =  get_number(var1 + "*" + dim);
		llimits[1]   =  get_number(var2 + "*" + dim);
		units[2].assign(dim);

			// Origin and Units
		vars >> var1 >> var2 >> var3 >> dimSpc >> dimFld;
		mapOrigin[0] = get_number(var1 + "*" + dimSpc);
		mapOrigin[1] = get_number(var2 + "*" + dimSpc);
		mapOrigin[2] = get_number(var3 + "*" + dimSpc);
		units[3].assign( dimSpc );
		units[4].assign( dimFld);
		
		vars.clear();
		vars << swim_method;
		vars >> integration_method;
		vars.clear();
		vars << swim_method;
		vars >> integration_method;
		double segm_phi_span = 2*(plimits[1] - plimits[0]);  	// factor of two: the map is assumed to cover half the segment
		int nsegments = (int) (360.0/(segm_phi_span/deg));
		if( fabs( segm_phi_span*nsegments/deg - 360 ) > 1.0e-2 )
		{
			cout << hd_msg << " <" << name << "> segmentation is wrong:  " << nsegments << " segments, each span "
					<< segm_phi_span/deg << ": it doesn't add to 360, but " << segm_phi_span*nsegments/deg << " Exiting." << endl;
			exit(0);

		}
		if(MGN_VERBOSITY>3)
		{
			cout << hd_msg << " <" << name << "> is a phi-segmented mapped field in cylindrical coordinates" << endl;;
			cout << hd_msg << " <" << name << "> has (" << PNPOINTS << ", " << TNPOINTS << ", " << LNPOINTS << ") points" << endl;;
			cout << hd_msg << " Azimuthal Boundaries:     (" << plimits[0]/deg << ", " << plimits[1]/deg << ") deg" << endl;
			cout << hd_msg << " Tranverse Boundaries:     (" << tlimits[0]/cm <<  ", " << tlimits[1]/cm  << ") cm"  << endl;
			cout << hd_msg << " Longitudinal Boundaries:  (" << llimits[0]/cm <<  ", " << llimits[1]/cm  << ") cm"  << endl;
			cout << hd_msg << " Phi segment span, number of segments:  " << segm_phi_span/deg <<  " deg, " << nsegments << endl;
			cout << hd_msg << " Map Displacement:  (" << mapOrigin[0]/cm << ", "
					<< mapOrigin[1]/cm << ", "
					<< mapOrigin[2]/cm << ") cm" << endl;
			cout << hd_msg << " Integration Method: " << integration_method << endl;
			cout << hd_msg << " Map Field Units: " << units[4] << endl;
			cout << hd_msg << " Map File: " << MapFile << endl;
		}
		mappedfield = new MappedField(gemcOpt, TNPOINTS, PNPOINTS, LNPOINTS, tlimits, plimits, llimits, MapFile, mapOrigin, units, scale_factor);
		mappedfield->segm_phi_span = segm_phi_span;
		mappedfield->nsegments     = nsegments;
	}




	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// Mapped y-symmetric Field in Cartesian coordinates 
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if(var == "mapped" && symmetry == "y-symmetric")
	{
		vars.clear();
		vars << magnitude;
		int XNPOINTS, YNPOINTS, ZNPOINTS;            	///< Number of cells in X, Y, Z dimensions
		double xlimits[2], ylimits[2], zlimits[2];   	///< Boundaries in  X, Y, Z dimensions
		double mapOrigin[3];                         	///< Displacemept of the mapped field
		string units[5];                             	///< Units for table dimensions and field

		vars >> var ;
		XNPOINTS  = (int) get_number(var);
		vars >> var1 >> var2 >> dim;
		xlimits[0]   =  get_number(var1 + "*" + dim);
		xlimits[1]   =  get_number(var2 + "*" + dim);
		units[0].assign(dim);

		vars >> var ;
		YNPOINTS  = (int) get_number(var);
		vars >> var1 >> var2 >> dim;
		ylimits[0]   =  get_number(var1 + "*" + dim);
		ylimits[1]   =  get_number(var2 + "*" + dim);
		units[1].assign(dim);

		vars >> var ;
		ZNPOINTS  = (int) get_number(var);
		vars >> var1 >> var2 >> dim;
		zlimits[0]   =  get_number(var1 + "*" + dim);
		zlimits[1]   =  get_number(var2 + "*" + dim);
		units[2].assign(dim);

   	// Origin and Units
		vars >> var1 >> var2 >> var3 >> dimSpc >> dimFld;
		mapOrigin[0] = get_number(var1 + "*" + dimSpc);
		mapOrigin[1] = get_number(var2 + "*" + dimSpc);
		mapOrigin[2] = get_number(var3 + "*" + dimSpc);
		units[3].assign( dimSpc );
		units[4].assign( dimFld);

		vars.clear();
		vars << swim_method;
		vars >> integration_method;
		vars.clear();
		vars << swim_method;
		vars >> integration_method;

		if(MGN_VERBOSITY>3)
		{
			cout << hd_msg << " <" << name << "> is a cartesian y-symmetric mapped field in cartesian coordinates" << endl;;
			cout << hd_msg << " <" << name << "> has (" << XNPOINTS << ", " << YNPOINTS << ", " << ZNPOINTS << ") points" << endl;;
			cout << hd_msg << " X Boundaries:     (" << xlimits[0]/cm << ", " << xlimits[1]/cm  << ") cm" << endl;
			cout << hd_msg << " Y Boundaries:     (" << ylimits[0]/cm << ", " << ylimits[1]/cm  << ") cm"  << endl;
			cout << hd_msg << " Z Boundaries:     (" << zlimits[0]/cm << ", " << zlimits[1]/cm  << ") cm"  << endl;
			cout << hd_msg << " Map Displacement:  (" 
			     << mapOrigin[0]/cm << ", "  << mapOrigin[1]/cm << ", "  << mapOrigin[2]/cm << ") cm" << endl;
			cout << hd_msg << " Integration Method: " << integration_method << endl;
			cout << hd_msg << " Map Field Units: `" << units[4] << "`" << endl;
			cout << hd_msg << " Map File: `" << MapFile << "`" << endl;
		}
		mappedfield = new MappedField(gemcOpt, YNPOINTS, XNPOINTS, ZNPOINTS, ylimits, xlimits, zlimits, 
					      MapFile, mapOrigin, units, scale_factor, true);
		mappedfield->nsegments     = 2;
	}


	if(integration_method == "RungeKutta")
	{
   	// specialized equations for mapped magnetic field

		G4Mag_UsualEqRhs*       iEquation    = new G4Mag_UsualEqRhs(mappedfield);
		G4MagIntegratorStepper* iStepper     = new G4HelixSimpleRunge(iEquation);
		G4ChordFinder*          iChordFinder = new G4ChordFinder(mappedfield, 1.0e-2*mm, iStepper);

		MFM = new G4FieldManager(mappedfield, iChordFinder);
		MFM->SetDeltaOneStep(1*mm);
		MFM->SetDeltaIntersection(1*mm);
	}
}

MappedField::MappedField(){;}
MappedField::~MappedField(){;}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Constructor for Dipole field in cartesian coordinate
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MappedField::MappedField(gemc_opts Opt, int TNPOINTS, int LNPOINTS, double tlimits[2], double llimits[2],
                         string filename, double origin[3], string units[5], double scale_factor, string symmetry)
{
	gemcOpt           = Opt;
	Symmetry          = symmetry;
	string hd_msg     = gemcOpt.args["LOG_MSG"].args + " Magnetic Field Constructor: >> ";
	MGN_VERBOSITY     = (int) gemcOpt.args["MGN_VERBOSITY"].arg ;
	string field_dir  = gemcOpt.args["FIELD_DIR"].args ;
  if( getenv("JLAB_ROOT") == NULL){
    cout << hd_msg << " ERROR: Please set JLAB_ROOT to point to the directory containing noarch/data \n";
    exit(EXIT_FAILURE);
  }
	string field_file = (string) getenv("JLAB_ROOT") + "/noarch/data/" + filename;
		
	if(field_dir != "env")
		field_file = field_dir + "/" + filename;
	
	mapOrigin[0] = origin[0];
	mapOrigin[1] = origin[1];
	mapOrigin[2] = origin[2];
		
	table_start[0] = tlimits[0];
	table_start[1] = llimits[0];
	cell_size[0]   = (tlimits[1] - tlimits[0])/( TNPOINTS - 1);
	cell_size[1]   = (llimits[1] - llimits[0])/( LNPOINTS - 1);
	
	if(MGN_VERBOSITY>3)
	{
		cout << hd_msg << " The Transverse cell size is: "       << cell_size[0]/cm << " cm" << endl
		     << hd_msg << " and the Longitudinal cell size is: " << cell_size[1]/cm << " cm" << endl;
		
	}
	
	ifstream IN(field_file.c_str());
	if(!IN)
	{
		cout << hd_msg << " File " << field_file << " could not be opened. Exiting." << endl;
		exit(0);
	}
	cout << hd_msg << " Reading map file: " << field_file << "... ";
	
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// Setting up storage space for tables
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	BDipole.resize( LNPOINTS );
	for(int il=0; il<LNPOINTS; il++)
	{
		BDipole[il].resize(TNPOINTS);
	}
	
	// %%%%%%%%%%%%%
	// Filling table
	// %%%%%%%%%%%%%
	double TC, LC;        	// coordinates as read from the map
	double B;           	  // magnetic field as read from the map
	unsigned int IT, IL;  	// indexes of the vector map
	
	for(int il=0; il<LNPOINTS; il++)
	{
		for(int it=0; it<TNPOINTS; it++)
		{
			IN >> LC >> TC  >>  B;
			     if(units[0] == "cm") LC *= cm;
			else if(units[0] == "m")  LC *= m;
			else if(units[0] == "mm") LC *= mm;
			else  cout << hd_msg << " Dimension Unit " << units[1] << " not implemented yet." << endl;
					 if(units[1] == "cm") TC *= cm;
			else if(units[1] == "m")  TC *= m;
			else if(units[1] == "mm") TC *= mm;
			else  cout << hd_msg << " Dimension Unit " << units[0] << " not implemented yet." << endl;
			
			// checking map consistency for transverse coordinate
			if( (tlimits[0]  + it*cell_size[0] - TC)/TC > 0.001)
			{
				cout << hd_msg << it << " transverse index wrong. Map point should be " <<  tlimits[0] + it*cell_size[0]
				<< " but it's  " << TC << " instead." << endl;
			}
			
			IT = (unsigned int) floor( ( TC/mm - table_start[0]/mm + cell_size[0]/mm/2 ) / ( cell_size[0]/mm ) ) ;
			IL = (unsigned int) floor( ( LC/mm - table_start[1]/mm + cell_size[1]/mm/2 ) / ( cell_size[1]/mm ) ) ;
			
			B *= scale_factor;
			
			if(units[4] == "gauss")
			{
				BDipole[IL][IT] = B*gauss;
			}
			else if(units[4] == "kilogauss")
			{
				BDipole[IL][IT] = B*kilogauss;
			}
			else if(units[4] == "T")
			{
				BDipole[IL][IT] = B*tesla;
			}
			else
			{
				cout << hd_msg << " Field Unit " << units[4] << " not implemented yet." << endl;
			}
		}
		// checking map consistency for longitudinal coordinate
		if( (llimits[0] + il*cell_size[1] - LC)/LC > 0.001)
		{
			cout << hd_msg << il << " longitudinal index wrong. Map point should be " <<  llimits[0] + il*cell_size[1]
			<< " but it's  " << LC << " instead." << endl;
		}
	}
	
	IN.close();
	cout << " done!" << endl;
	
}


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Constructor for phi-symmetric field in cylindrical coordinates
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MappedField::MappedField(gemc_opts Opt, int TNPOINTS, int LNPOINTS, double tlimits[2], double llimits[2],
                         string filename, double origin[3], string units[5], double scale_factor, string symmetry, int dummy)
{
	gemcOpt           = Opt;
	string hd_msg     = gemcOpt.args["LOG_MSG"].args + " Magnetic Field Constructor: >> ";
	MGN_VERBOSITY     = (int) gemcOpt.args["MGN_VERBOSITY"].arg ;
	string field_dir  = gemcOpt.args["FIELD_DIR"].args ;
  if( getenv("JLAB_ROOT") == NULL){
    cout << hd_msg << " ERROR: Please set JLAB_ROOT to point to the directory containing noarch/data \n";
    exit(EXIT_FAILURE);
  }
	string field_file = (string) getenv("JLAB_ROOT") + "/noarch/data/" + filename;
	Symmetry          = symmetry;
	
	if(field_dir != "env")
		field_file = field_dir + "/" + filename;
	

	mapOrigin[0] = origin[0];
	mapOrigin[1] = origin[1];
	mapOrigin[2] = origin[2];
	
	table_start[0] = tlimits[0];
	table_start[1] = llimits[0];
	cell_size[0]   = (tlimits[1] - tlimits[0])/( TNPOINTS - 1);
	cell_size[1]   = (llimits[1] - llimits[0])/( LNPOINTS - 1);

	if(MGN_VERBOSITY>3)
	{
		cout << hd_msg << " The transverse cell size is: "       << cell_size[0]/cm << " cm" << endl
         << hd_msg << " and the longitudinal cell size is: " << cell_size[1]/cm << " cm" << endl;

	}

	ifstream IN(field_file.c_str());
	if(!IN)
	{
		cout << hd_msg << " File " << field_file << " could not be opened. Exiting." << endl;
		exit(0);
	}
	cout << hd_msg << " Reading map file: " << field_file << "... ";

	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// Setting up storage space for tables
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	B2DCylT.resize( TNPOINTS );
	B2DCylL.resize( TNPOINTS );
	for(int it=0; it<TNPOINTS; it++)
	{
		B2DCylT[it].resize(LNPOINTS);
		B2DCylL[it].resize(LNPOINTS);
	}

	// %%%%%%%%%%%%%
	// Filling table
	// %%%%%%%%%%%%%
	double TC, LC;        	// coordinates as read from the map
	double BT, BL;        	// transverse and longitudinal magnetic field as read from the map
	unsigned int IT, IL;  	// indexes of the vector map

	for(int it=0; it<TNPOINTS; it++)
	{
		for(int il=0; il<LNPOINTS; il++)
		{
			IN >> TC >> LC >> BT >>  BL;
			     if(units[0] == "cm") TC *= cm;
			else if(units[0] == "m")  TC *= m;
			else if(units[0] == "mm") TC *= mm;
			else  cout << hd_msg << " Dimension Unit " << units[0] << " not implemented yet." << endl;
			     if(units[1] == "cm") LC *= cm;
			else if(units[1] == "m")  LC *= m;
			else if(units[1] == "mm") LC *= mm;
			else  cout << hd_msg << " Dimension Unit " << units[1] << " not implemented yet." << endl;

      	// checking map consistency for longitudinal coordinate
			if( (llimits[0] + il*cell_size[1] - LC)/LC > 0.001)
			{
				cout << hd_msg << il << " longitudinal index wrong. Map point should be " <<  llimits[0] + il*cell_size[1]
						<< " but it's  " << LC << " instead." << endl;
			}

			IT = (unsigned int) floor( ( TC/mm - table_start[0]/mm + cell_size[0]/mm/2 ) / ( cell_size[0]/mm ) ) ;
			IL = (unsigned int) floor( ( LC/mm - table_start[1]/mm + cell_size[1]/mm/2 ) / ( cell_size[1]/mm ) ) ;

			BT *= scale_factor;
			BL *= scale_factor;

			if(units[4] == "gauss")
			{
				B2DCylT[IT][IL] = BT*gauss;
				B2DCylL[IT][IL] = BL*gauss;
			}
			else if(units[4] == "kilogauss")
			{
				B2DCylT[IT][IL] = BT*kilogauss;
				B2DCylL[IT][IL] = BL*kilogauss;
			}
			else if(units[4] == "T")
			{
				B2DCylT[IT][IL] = BT*tesla;
				B2DCylL[IT][IL] = BL*tesla;
			}
			else
			{
				cout << hd_msg << " Field Unit " << units[4] << " not implemented yet." << endl;
			}
		}
   	// checking map consistency for transverse coordinate
		if( (tlimits[0]  + it*cell_size[0] - TC)/TC > 0.001)
		{
			cout << hd_msg << it << " transverse index wrong. Map point should be " <<  tlimits[0] + it*cell_size[0]
					<< " but it's  " << TC << " instead." << endl;
		}
	}

	IN.close();
	cout << " done!" << endl;

}


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Constructor for phi-segmented field in cylindrical coordinates. Field is in cartesian coordinates
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MappedField::MappedField(gemc_opts Opt, int rNPOINTS, int pNPOINTS, int zNPOINTS, double tlimits[2], double plimits[2], double llimits[2],
												 string filename, double origin[3], string units[5], double scale_factor)
{
	gemcOpt           = Opt;
	string hd_msg     = gemcOpt.args["LOG_MSG"].args + " Magnetic Field Constructor: >> ";
	MGN_VERBOSITY     = (int) gemcOpt.args["MGN_VERBOSITY"].arg ;
	string field_dir  = gemcOpt.args["FIELD_DIR"].args ;
  if( getenv("JLAB_ROOT") == NULL){
    cout << hd_msg << " ERROR: Please set JLAB_ROOT to point to the directory containing noarch/data \n";
    exit(EXIT_FAILURE);
  }
	string field_file = (string) getenv("JLAB_ROOT") + "/noarch/data/" + filename;
	
	if(field_dir != "env")
		field_file = field_dir + "/" + filename;
	
	mapOrigin[0] = origin[0];
	mapOrigin[1] = origin[1];
	mapOrigin[2] = origin[2];
	
	table_start[0] = plimits[0];
	table_start[1] = tlimits[0];
	table_start[2] = llimits[0];
	cell_size[0]   = (plimits[1] - plimits[0])/( pNPOINTS - 1);
	cell_size[1]   = (tlimits[1] - tlimits[0])/( rNPOINTS - 1);
	cell_size[2]   = (llimits[1] - llimits[0])/( zNPOINTS - 1);

	if(MGN_VERBOSITY>3)
	{
		cout << hd_msg << " the phi cell size is: "    << cell_size[0]/deg << " degrees" << endl
				<< hd_msg << " The radius cell size is: " << cell_size[1]/cm  << " cm" << endl
				<< hd_msg << " and the z cell size is: "  << cell_size[2]/cm  << " cm" << endl;
	}

	ifstream IN(field_file.c_str());
	if(!IN)
	{
		cout << hd_msg << " File " << field_file << " could not be opened. Exiting." << endl;
		exit(0);
	}
	cout << hd_msg << " Reading map file: " << field_file << "... ";


	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// Setting up storage space for tables
	// Field[phi][r][z]
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	B3DCylX.resize( pNPOINTS );
	B3DCylY.resize( pNPOINTS );
	B3DCylZ.resize( pNPOINTS );
	for(int ip=0; ip<pNPOINTS; ip++)
	{
		B3DCylX[ip].resize( rNPOINTS );
		B3DCylY[ip].resize( rNPOINTS );
		B3DCylZ[ip].resize( rNPOINTS );
		for(int ir=0; ir<rNPOINTS; ir++)
		{
			B3DCylX[ip][ir].resize( zNPOINTS );
			B3DCylY[ip][ir].resize( zNPOINTS );
			B3DCylZ[ip][ir].resize( zNPOINTS );
		}
	}

	// %%%%%%%%%%%%%
	// Filling table
	// %%%%%%%%%%%%%
	double pC, tC, lC;        	// coordinates as read from the map
	double Bx, By, Bz;        	// magnetic field components as read from the map
	unsigned int It, Ip, Il;  	// indexes of the vector map
	for(int ip=0; ip<pNPOINTS; ip++)
	{
		for(int it=0; it<rNPOINTS; it++)
		{
			for(int il=0; il<zNPOINTS; il++)
			{
				IN >> pC >> tC >> lC >> Bx >> By >> Bz;

				if(units[0] == "deg") pC = pC*deg;
				else                  cout << hd_msg << " Dimension Unit " << units[0] << " not implemented yet." << endl;
				if(units[1] == "cm")  tC *= cm;
				else                  cout << hd_msg << " Dimension Unit " << units[1] << " not implemented yet." << endl;
				if(units[2] == "cm")  lC *= cm;
				else                  cout << hd_msg << " Dimension Unit " << units[2] << " not implemented yet." << endl;

         	// checking map consistency for longitudinal coordinate
				if( (llimits[0] + il*cell_size[2] - lC)/lC > 0.001)
				{
					cout << hd_msg << il << " longitudinal index wrong. Map point should be " <<  llimits[0] + il*cell_size[2]
							<< " but it's  " << lC << " instead." << endl;
				}

				Ip = (unsigned int) floor( ( pC/deg - table_start[0]/deg + cell_size[0]/deg/2 )  / ( cell_size[0]/deg ) ) ;
				It = (unsigned int) floor( ( tC/mm  - table_start[1]/mm  + cell_size[1]/mm/2  )  / ( cell_size[1]/mm  ) ) ;
				Il = (unsigned int) floor( ( lC/mm  - table_start[2]/mm  + cell_size[2]/mm/2  )  / ( cell_size[2]/mm  ) ) ;

				Bx *= scale_factor;
				By *= scale_factor;
				Bz *= scale_factor;

				if(units[4] == "gauss") 
				{
					B3DCylX[Ip][It][Il] = Bx*gauss;
					B3DCylY[Ip][It][Il] = By*gauss;
					B3DCylZ[Ip][It][Il] = Bz*gauss;
				}
				else if(units[4] == "kilogauss")
				{
					B3DCylX[Ip][It][Il] = Bx*kilogauss;
					B3DCylY[Ip][It][Il] = By*kilogauss;
					B3DCylZ[Ip][It][Il] = Bz*kilogauss;
				}
				else if(units[4] == "T")
				{
					B3DCylX[Ip][It][Il] = Bx*tesla;
					B3DCylY[Ip][It][Il] = By*tesla;
					B3DCylZ[Ip][It][Il] = Bz*tesla;
				}

				else
				{
					cout << hd_msg << " Field Unit " << units[4] << " not implemented yet." << endl;
				}

				if(MGN_VERBOSITY>10 && MGN_VERBOSITY < 50)
				{
					cout << " phi=" << pC/deg << ", ip=" << Ip << "   "
							<< " r="   << tC/cm  << ", it=" << It << "   "
							<< " z="   << lC/cm  << ", iz=" << Il << "   "
							<< " Bx=" << B3DCylX[Ip][It][Il]/kilogauss  << " "
							<< " By=" << B3DCylY[Ip][It][Il]/kilogauss  << " "
							<< " Bz=" << B3DCylZ[Ip][It][Il]/kilogauss  << " kilogauss.   Map Values: "
							<< " rBx=" << Bx  << " "
							<< " rBy=" << By  << " "
							<< " rBz=" << Bz  << endl;

				}

			}

      	// checking map consistency for transverse coordinate
			if( (tlimits[0]  + it*cell_size[1] - tC)/tC > 0.001)
			{
				cout << hd_msg << it << " transverse index wrong. Map point should be " <<  tlimits[0] + it*cell_size[0]
						<< " but it's  " << tC << " instead." << endl;
			}

		}

   	// checking map consistency for azimuthal coordinate
		if( (plimits[0] + ip*cell_size[0] - pC)/pC > 0.001)
		{
			cout << hd_msg << ip << " azimuthal index wrong. Map point should be " <<  plimits[0] + ip*cell_size[1]
					<< " but it's  " << pC << " instead." << endl;
		}

	}

	IN.close();
	cout << " done!" << endl;

}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// Constructor for y-symmetric field in cartesian coordinates. Field is in cartesian coordinates
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MappedField::MappedField(gemc_opts Opt, int yNPOINTS, int xNPOINTS, int zNPOINTS, 
			 double ylimits[2], double xlimits[2], double zlimits[2],
			 string filename, double origin[3], string units[5], double scale_factor, bool ySymmetry)
{
	gemcOpt           = Opt;
	string hd_msg     = gemcOpt.args["LOG_MSG"].args + " Magnetic Field Constructor: >> ";
	MGN_VERBOSITY     = (int) gemcOpt.args["MGN_VERBOSITY"].arg ;
	string field_dir  = gemcOpt.args["FIELD_DIR"].args ;
  if( getenv("JLAB_ROOT") == NULL){
    cout << hd_msg << " ERROR: Please set JLAB_ROOT to point to the directory containing noarch/data \n";
    exit(EXIT_FAILURE);
  }
 	string field_file = (string) getenv("JLAB_ROOT") + "/noarch/data/" + filename;
	
	if(field_dir != "env")
		field_file = field_dir + "/" + filename;
	
	double table_end[3];

	if( ySymmetry ) nsegments = 2;
	
	mapOrigin[0] = origin[0];
	mapOrigin[1] = origin[1];
	mapOrigin[2] = origin[2];
	
	table_start[0] = xlimits[0];
	table_start[1] = ylimits[0];
	table_start[2] = zlimits[0];

	table_end[0] = xlimits[1];
	table_end[1] = ylimits[1];
	table_end[2] = zlimits[1];

	if( ySymmetry ) 
	{ 
	  table_start[1] = fabs( table_start[1] );
	  table_end[1]   = fabs( table_end[1] );
	}

	cell_size[0]   = (table_end[0] - table_start[0])/( xNPOINTS - 1);
	cell_size[1]   = (table_end[1] - table_start[1])/( yNPOINTS - 1);
	cell_size[2]   = (table_end[2] - table_start[2])/( zNPOINTS - 1);


	if(MGN_VERBOSITY>3)
	{
	  cout << hd_msg << " the X cell size is:     "  << cell_size[0]/cm <<  " cm" << endl
	       << hd_msg << " The Y cell size is:     "  << cell_size[1]/cm <<  " cm" << endl
	       << hd_msg << " and the Z cell size is: "  << cell_size[2]/cm <<  " cm" << endl;
	}

	ifstream IN(field_file.c_str());
	if(!IN)
	{
	  cout << hd_msg << " File " << field_file << " could not be opened. Exiting." << endl;
	  exit(0);
	}
	cout << hd_msg << " Reading map file: " << field_file << "... ";


	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// Setting up storage space for tables
	// Field[x][y][z]
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	B3DCartX.resize( xNPOINTS );
	B3DCartY.resize( xNPOINTS );
	B3DCartZ.resize( xNPOINTS );
	for(int ix=0; ix<xNPOINTS; ix++)
	{
	  B3DCartX[ix].resize( yNPOINTS );
	  B3DCartY[ix].resize( yNPOINTS );
	  B3DCartZ[ix].resize( yNPOINTS );
	  for(int iy=0; iy<yNPOINTS; iy++)
	    {
	      B3DCartX[ix][iy].resize( zNPOINTS );
	      B3DCartY[ix][iy].resize( zNPOINTS );
	      B3DCartZ[ix][iy].resize( zNPOINTS );
	    }
	}

	// %%%%%%%%%%%%%
	// Filling table
	// %%%%%%%%%%%%%
	double xC, yC, zC;        	// coordinates as read from the map
	double Bx, By, Bz;        	// magnetic field components as read from the map
	unsigned int Ix, Iy, Iz;  	// indexes of the vector map
	for(int ix=0; ix<xNPOINTS; ix++)
	{
		for(int iz=0; iz<zNPOINTS; iz++)
		{
			for(int iy=0; iy<yNPOINTS; iy++)
			{
			  IN >> xC >> yC >> zC >> Bx >> By >> Bz;
			  if( ySymmetry ) yC = fabs( yC );
			  
			       if(units[0] == "cm")  xC *= cm;
				else if(units[0] == "m")   xC *=  m;
				else if(units[0] == "mm")  xC *= mm;
			  else                  cout << hd_msg << " Dimension Unit " << units[0] << " not implemented yet." << endl;
			       if(units[1] == "cm")  yC *= cm;
				else if(units[1] == "m")   yC *=  m;
				else if(units[1] == "mm")  yC *= mm;
			  else                  cout << hd_msg << " Dimension Unit " << units[1] << " not implemented yet." << endl;
			       if(units[2] == "cm")  zC *= cm;
				else if(units[2] == "m")   zC *=  m;
				else if(units[2] == "mm")  zC *= mm;
			  else                  cout << hd_msg << " Dimension Unit " << units[2] << " not implemented yet." << endl;
			  
			  // checking map consistency for Y coordinate
			  if( (table_start[1] + iy*cell_size[1] - yC)/yC > 0.001)
			    {
			      cout << hd_msg << iy << " Y index wrong. Map point should be " <<  table_start[1] + iy*cell_size[1]
				   << " but it's  " << yC << " instead." << endl;
			    }
			  
			  Ix = (unsigned int) floor( ( xC/mm  - table_start[0]/mm  + cell_size[0]/mm/2  )  / ( cell_size[0]/mm  ) ) ;
			  Iy = (unsigned int) floor( ( yC/mm  - table_start[1]/mm  + cell_size[1]/mm/2  )  / ( cell_size[1]/mm  ) ) ;
			  Iz = (unsigned int) floor( ( zC/mm  - table_start[2]/mm  + cell_size[2]/mm/2  )  / ( cell_size[2]/mm  ) ) ;
			  Bx *= scale_factor;
			  By *= scale_factor;
			  Bz *= scale_factor;

			  if(units[4] == "gauss")
			    {
			      B3DCartX[Ix][Iy][Iz] = Bx*gauss;
			      B3DCartY[Ix][Iy][Iz] = By*gauss;
			      B3DCartZ[Ix][Iy][Iz] = Bz*gauss;
			    } else if(units[4] == "kilogauss")
			    {
			      B3DCartX[Ix][Iy][Iz] = Bx*kilogauss;
			      B3DCartY[Ix][Iy][Iz] = By*kilogauss;
			      B3DCartZ[Ix][Iy][Iz] = Bz*kilogauss;
			    } else if(units[4] == "T")
			    {
			      B3DCartX[Ix][Iy][Iz] = Bx*tesla;
			      B3DCartY[Ix][Iy][Iz] = By*tesla;
			      B3DCartZ[Ix][Iy][Iz] = Bz*tesla;
			    }
			  else 
			    {
			      cout << hd_msg << " Field Unit " << units[4] << " not implemented yet." << endl;
			    }
			  
			  if(MGN_VERBOSITY>10 && MGN_VERBOSITY < 50)
			    {
			      cout << " x=" << xC/cm  << ", ix=" << Ix << "   "
				         << " y=" << yC/cm  << ", iy=" << Iy << "   "
				         << " z=" << zC/cm  << ", iz=" << Iz << "   "
								 << " Bx=" << B3DCartX[Ix][Iy][Iz]/kilogauss  << " "
				         << " By=" << B3DCartY[Ix][Iy][Iz]/kilogauss  << " "
				         << " Bz=" << B3DCartZ[Ix][Iy][Iz]/kilogauss  << " kilogauss.   Map Values: "
				         << " rBx=" << Bx  << " "
				         << " rBy=" << By  << " "
				         << " rBz=" << Bz  << endl;
			    }
			}

      	// checking map consistency for Z coordinate
			if( (table_start[2]  + iz*cell_size[2] - zC)/zC > 0.001)
			{
			  cout << hd_msg << iz << " Z index wrong. Map point should be " << table_start[2]  + iz*cell_size[2]
			       << " but it's  " << zC << " instead." << endl;
			}

		}

   	// checking map consistency for X coordinate
		if( (table_start[0] + ix*cell_size[0] - xC)/xC > 0.001)
		{
		  cout << hd_msg << ix << " X index wrong. Map point should be " << table_start[0] + ix*cell_size[0]
		       << " but it's  " << xC << " instead." << endl;
		}
	}

	IN.close();
	cout << " done!" << endl;

}




// %%%%%%%%%%%%%
// GetFieldValue
// %%%%%%%%%%%%%
void MappedField::GetFieldValue(const double point[3], double *Bfield) const
{

	double Point[3];	// global coordinates, in mm, after shifting the origin
	vector<double> Field[3];
	static int FIRST_ONLY;

	Point[0] = point[0] - mapOrigin[0]/mm;
	Point[1] = point[1] - mapOrigin[1]/mm;
	Point[2] = point[2] - mapOrigin[2]/mm;

	Bfield[0] = Bfield[1] = Bfield[2] = 0*gauss;

	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// Dipole field in cartesian coordinates
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if(BDipole.size())
	{
		double psfield[3] = {0,0,0};
		unsigned int IT, IL;
		
		double LC;     	// longitudinal coordinate of the track in the global coordinate system
		double TC;     	// transverse and phy polar 2D coordinates: the map is phi-symmetric. phi is angle in respect to x
		if(Symmetry == "Dipole-x")
		{
			TC  = Point[1];
			LC  = Point[2];
		}
		if(Symmetry == "Dipole-y")
		{
			TC  = Point[0];
			LC  = Point[2];
		}
		if(Symmetry == "Dipole-z")
		{
			TC  = Point[0];
			LC  = Point[1];
		}
		
		
		IT = (unsigned int) floor( ( TC - table_start[0]/mm ) / (cell_size[0]/mm) ) ;
		IL = (unsigned int) floor( ( LC - table_start[1]/mm ) / (cell_size[1]/mm) ) ;
		
		if( fabs( table_start[0]/mm + IT*cell_size[0]/mm - TC) > fabs( table_start[0]/mm + (IT+1)*cell_size[0]/mm - TC)  ) IT++;
		if( fabs( table_start[1]/mm + IL*cell_size[1]/mm - LC) > fabs( table_start[1]/mm + (IL+1)*cell_size[1]/mm - LC)  ) IL++;
		// vector sizes are checked on both T and L components
		// (even if only one is enough)
		if(IL < BDipole.size())
			if(IT < BDipole[IL].size())
			{
				if(Symmetry == "Dipole-x") psfield[0] = BDipole[IL][IT];
				if(Symmetry == "Dipole-y") psfield[1] = BDipole[IL][IT];
				if(Symmetry == "Dipole-z") psfield[2] = BDipole[IL][IT];
				if(MGN_VERBOSITY>5 && FIRST_ONLY != 99)
				{
					cout << hd_msg << " Dipole Field: Cart. coordinates (cm), table indexes, magnetic field values (gauss):" << endl;
					cout << " x="    << point[0]/cm << "   " ;
					cout << "y="     << point[1]/cm << "   ";
					cout << "z="     << point[2]/cm << "   ";
					cout << "IT="    << IT << "   ";
					cout << "IL="    << IL << "  ";
					cout << "Bx="    << psfield[0]/gauss << "  ";
					cout << "By="    << psfield[1]/gauss << "  ";
					cout << "Bz="    << psfield[2]/gauss << endl;
				}
			}
		for(int i=0; i<3; i++) Field[i].push_back(psfield[i]);
	}
	

	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// phi symmetric field in cylindrical coordinates
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if(B2DCylT.size() && B2DCylL.size())
	{
		double psfield[3] = {0,0,0};
		unsigned int IT, IL;

		double LC;           	// longitudinal coordinate of the track in the global coordinate system
		double TC, phi;      	// transverse and phy polar 2D coordinates: the map is phi-symmetric. phi is angle in respect to x
		TC              = sqrt(Point[0]*Point[0] + Point[1]*Point[1]);
		G4ThreeVector vpos(Point[0], Point[1], Point[2]);
		phi = vpos.phi();
		LC  = Point[2];

		IT = (unsigned int) floor( ( TC - table_start[0]/mm ) / (cell_size[0]/mm) ) ;
		IL = (unsigned int) floor( ( LC - table_start[1]/mm ) / (cell_size[1]/mm) ) ;

		if( fabs( table_start[0]/mm + IT*cell_size[0]/mm - TC) > fabs( table_start[0]/mm + (IT+1)*cell_size[0]/mm - TC)  ) IT++;
		if( fabs( table_start[1]/mm + IL*cell_size[1]/mm - LC) > fabs( table_start[1]/mm + (IL+1)*cell_size[1]/mm - LC)  ) IL++;


		// vector sizes are checked on both T and L components
		// (even if only one is enough)
		if(IT < B2DCylT.size() && IT < B2DCylL.size())
			if(IL < B2DCylT[IT].size() && IL < B2DCylL[IT].size()  )
			{
				
        
        psfield[0] = B2DCylT[IT][IL] * cos(phi);
				psfield[1] = B2DCylT[IT][IL] * sin(phi);
				psfield[2] = B2DCylL[IT][IL];
        
        
        if(Symmetry == "cylindrical-x")
        {
          psfield[2] = B2DCylT[IT][IL] * cos(phi);
          psfield[1] = B2DCylT[IT][IL] * sin(phi);
          psfield[0] = B2DCylL[IT][IL];
        }
        
        if(Symmetry == "cylindrical-y")
        {
          psfield[0] = B2DCylT[IT][IL] * cos(phi);
          psfield[2] = B2DCylT[IT][IL] * sin(phi);
          psfield[1] = B2DCylL[IT][IL];
        }
        
				if(MGN_VERBOSITY>5 && FIRST_ONLY != 99)
				{
					cout << hd_msg << " Phi-Simmetric Field: Cart. and Cyl. coordinates (cm), table indexes, magnetic field values (gauss):" << endl;
					cout << " x="    << point[0]/cm << "   " ;
					cout << "y="     << point[1]/cm << "   ";
					cout << "z="     << point[2]/cm << "   ";
					cout << "r="     << TC/cm << "   ";
					cout << "z="     << LC/cm << "  ";
					cout << "phi="   << phi/deg << "   ";
					cout << "IT="    << IT << "   ";
					cout << "IL="    << IL << "  ";
					cout << "Bx="    << psfield[0]/gauss << "  ";
					cout << "By="    << psfield[1]/gauss << "  ";
					cout << "Bz="    << psfield[2]/gauss << endl;
				}
		}
		for(int i=0; i<3; i++) Field[i].push_back(psfield[i]);
	}


	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// phi-segmented field in cylindrical coordinates
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if(B3DCylX.size() && B3DCylY.size() && B3DCylZ.size())
	{
		double mfield[3]      = {0,0,0};
		double rotpsfield[3]  = {0,0,0};

		double tC, pC, lC;        	///< coordinates of the track in the global coordinate system. Transverse (r), Phi, Longitudinal
		double pLC;               	///< phi local  to the first segment
		unsigned int Ip, It, Il;  	///< indexes of the vector map

		pC = atan2( Point[1], Point[0] )*rad;
		if( pC < 0 ) pC += 360*deg;

		tC = sqrt(Point[0]*Point[0] + Point[1]*Point[1]); 	///< R
		lC = Point[2];                                    	///< Z

   	// Rotating the point to within the map limit
		int segment = 0;
		pLC = pC;
		while (pLC/deg > 30)
		{
			pLC -= 60*deg;
			segment++;
		}

		double dphi = pC - pLC;
		int    sign = (pLC >= 0 ? 1 : -1);
		double apLC = fabs(pLC);

		Ip = (unsigned int) floor( ( apLC/deg - table_start[0]/deg ) / (cell_size[0]/deg ) ) ;
		It = (unsigned int) floor( ( tC/mm    - table_start[1]/mm  ) / (cell_size[1]/mm  ) ) ;
		Il = (unsigned int) floor( ( lC/mm    - table_start[2]/mm  ) / (cell_size[2]/mm  ) ) ;

		if( fabs( table_start[0]/mm + Ip*cell_size[0]/deg - apLC) > fabs( table_start[0]/mm + (Ip+1)*cell_size[0]/mm - apLC) ) Ip++;
		if( fabs( table_start[1]/mm + It*cell_size[1]/mm  - tC)   > fabs( table_start[1]/mm + (It+1)*cell_size[1]/mm - tC)   ) It++;
		if( fabs( table_start[2]/mm + Il*cell_size[2]/mm  - lC)   > fabs( table_start[2]/mm + (Il+1)*cell_size[2]/mm - lC)   ) Il++;

   	// Getting Field at the rotated point
   	// vector sizes are checked on all components
   	// (even if only one is enough)
		if(     Ip < B3DCylX.size()         && Ip < B3DCylY.size()         && Ip < B3DCylZ.size())
			if(   It < B3DCylX[Ip].size()     && It < B3DCylY[Ip].size()     && It < B3DCylZ[Ip].size())
				if( Il < B3DCylX[Ip][It].size() && Il < B3DCylY[Ip][It].size() && Il < B3DCylZ[Ip][It].size())
				{
					// Field at local point
					mfield[0] = B3DCylX[Ip][It][Il];
					mfield[1] = B3DCylY[Ip][It][Il];
					mfield[2] = B3DCylZ[Ip][It][Il];


					// Rotating the field back to original point
					rotpsfield[0] =  sign*mfield[0] * cos(dphi/rad) - mfield[1] * sin(dphi/rad);
					rotpsfield[1] = +sign*mfield[0] * sin(dphi/rad) + mfield[1] * cos(dphi/rad);
					rotpsfield[2] =  sign*mfield[2];
					
					if(MGN_VERBOSITY>6 && FIRST_ONLY != 99)
					{
						cout << hd_msg << " Phi-Segmented Field: Cart. and Cyl. coord. (cm), indexes, local and rotated field values (gauss):" << endl;
						cout << " x="       << point[0]/cm << "   " ;
						cout << "y="        << point[1]/cm << "   ";
						cout << "z="        << point[2]/cm << "   ";
						cout << "phi="      << pC/deg << "   ";
						cout << "r="        << tC/cm << "   ";
						cout << "z="        << lC/cm << "  ";
						cout << "dphi="     << dphi/deg << "   ";
						cout << "dphir="    << dphi/rad << "   ";
						cout << "lphi="     << (sign == 1 ? "+ " : "- ") << pLC/deg << "   ";
						cout << "segment="  << segment << "   ";
						cout << "Ip="       << Ip << "  ";
						cout << "It="       << It << "   ";
						cout << "Il="       << Il << "  ";
						cout << "lBx="      << mfield[0]/gauss << "  ";
						cout << "lBy="      << mfield[1]/gauss << "  ";
						cout << "lBz="      << mfield[2]/gauss << " " ;
						cout << "rBx="      << rotpsfield[0]/gauss << "  ";
						cout << "rBy="      << rotpsfield[1]/gauss << "  ";
						cout << "rBz="      << rotpsfield[2]/gauss << endl;
					}
				}
				for(int i=0; i<3; i++) Field[i].push_back(-rotpsfield[i]);
	}

	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// y-symmtric field in Cartesian coordinates
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if(B3DCartX.size() && B3DCartY.size() && B3DCartZ.size())
	{
		double mfield[3]      = {0,0,0};
		double xC, yC, zC;        	///< coordinates of the track in the global coordinate system. Transverse (r), Phi, Longitudinal
		unsigned int Ix, Iy, Iz;  	///< indexes of the vector map

		xC = Point[0]; 
		yC = Point[1]; 
		zC = Point[2]; 

		// Use positive y-values for y-symmtric field
		if( nsegments == 2 ) yC = fabs( yC );

		Ix = (unsigned int) floor( ( xC/mm  - table_start[0]/mm  ) / (cell_size[0]/mm  ) ) ;
		Iy = (unsigned int) floor( ( yC/mm  - table_start[1]/mm  ) / (cell_size[1]/mm  ) ) ;
		Iz = (unsigned int) floor( ( zC/mm  - table_start[2]/mm  ) / (cell_size[2]/mm  ) ) ;

		if( fabs( table_start[0]/mm + Ix*cell_size[0]/mm  - xC) > fabs( table_start[0]/mm + (Ix+1)*cell_size[0]/mm - xC) ) Ix++;
		if( fabs( table_start[1]/mm + Iy*cell_size[1]/mm  - yC) > fabs( table_start[1]/mm + (Iy+1)*cell_size[1]/mm - yC) ) Iy++;
		if( fabs( table_start[2]/mm + Iz*cell_size[2]/mm  - zC) > fabs( table_start[2]/mm + (Iz+1)*cell_size[2]/mm - zC) ) Iz++;

   	// Getting Field at the  point in space 
   	// vector sizes are checked on all components
   	// (even if only one is enough)
		if(     Ix < B3DCartX.size()         && Ix < B3DCartY.size()         && Ix < B3DCartZ.size())
		  if(   Iy < B3DCartX[Ix].size()     && Iy < B3DCartY[Ix].size()     && Iy < B3DCartZ[Ix].size())
		    if( Iz < B3DCartX[Ix][Iy].size() && Iz < B3DCartY[Ix][Iy].size() && Iz < B3DCartZ[Ix][Iy].size())
		      {
						// Field at local point
						mfield[0] = B3DCartX[Ix][Iy][Iz];
						mfield[1] = B3DCartY[Ix][Iy][Iz];
						mfield[2] = B3DCartZ[Ix][Iy][Iz];
			
						if(MGN_VERBOSITY>6 && FIRST_ONLY != 99)
						{
							cout << hd_msg << " Segmented Field: Cart. coord. (cm), indexes and field values (gauss):" << endl;
							cout << " x="        << point[0]/cm << "   " ;
							cout << "y="        << point[1]/cm << "   ";
							cout << "z="        << point[2]/cm << "   ";
							cout << "Ix="       << Ix << "  ";
							cout << "Iy="       << Iy << "   ";
							cout << "Iz="       << Iz << "  ";
							cout << "lBx="      << mfield[0]/gauss << "  ";
							cout << "lBy="      << mfield[1]/gauss << "  ";
							cout << "lBz="      << mfield[2]/gauss << endl ;
						}
		      }
		for(int i=0; i<3; i++) Field[i].push_back(mfield[i]);
	}


	// %%%%%%%%%%%%%%%%%%
	// Summing the Fields
	// %%%%%%%%%%%%%%%%%%
	for(unsigned int i=0; i<Field[0].size(); i++)
		for(int j=0; j<3; j++)
			Bfield[j] +=  Field[j][i];

	if(MGN_VERBOSITY>5  && FIRST_ONLY != 99)
	{
		cout << hd_msg << " Total Field: coordinates (cm), magnetic field values (gauss):" << endl ;
		cout << " x="    << point[0]/cm << "   " ;
		cout << "y="     << point[1]/cm << "   ";
		cout << "z="     << point[2]/cm << "   ";
		cout << "Bx="    << Bfield[0]/gauss << "  ";
		cout << "By="    << Bfield[1]/gauss << "  ";
		cout << "Bz="    << Bfield[2]/gauss << endl << endl;
	}
	
	if(MGN_VERBOSITY == 99)
		FIRST_ONLY = 99;

}













