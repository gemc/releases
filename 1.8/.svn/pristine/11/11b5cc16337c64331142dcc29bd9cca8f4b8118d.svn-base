// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QtSql>


// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"
#include "detector.h"
#include "MSensitiveDetector.h"
#include "run_conditions.h"
#include "string_utilities.h"


// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <sstream>
using namespace std;



map<string, detector> read_detector(gemc_opts gemcOpt, run_conditions RunConditions)
{
	string database       = gemcOpt.args["DATABASE"].args;
	string dbtable        = gemcOpt.args["GT"].args;
	string dbhost         = gemcOpt.args["DBHOST"].args;

	string dbUser         = gemcOpt.args["DBUSER"].args;
	string dbPswd         = gemcOpt.args["DBPSWD"].args;

	string hd_msg         = gemcOpt.args["LOG_MSG"].args + " MySQL: >> ";
	double GEO_VERBOSITY  = gemcOpt.args["GEO_VERBOSITY"].arg;
	string catch_v        = gemcOpt.args["CATCH"].args;
	string hall_field     = gemcOpt.args["HALL_FIELD"].args;

	// StderrLog errlog;
	map<string, detector> CLAS;
	detector Detector;
	stringstream vars;
	string var;

	G4Colour thisCol;
	vector<identifier> identity;   // vector of identifiers
	identifier iden;


	cout << endl << hd_msg << " Connecting to database \"" << database << "\" as \"" 
       <<  dbUser <<  "\". " << endl;


	QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
	db.setHostName(dbhost.c_str());
	db.setDatabaseName(database.c_str());
	db.setUserName( dbUser.c_str() );
	db.setPassword( dbPswd.c_str() );
	bool ok = db.open();

	if(!ok)
	{
		cout << hd_msg << " Cannot connect to database " << database << ". Exiting." << endl;
		exit(-1);
	}

	else
	{
		// if no tables in the gcard or gcard is not specified, using standard full clas12 geometry instead
		if(RunConditions.gTab_Vec.size() == 0 && dbtable == "no")  
		{
			RunConditions.gTab_Vec.push_back("BST");
			RunConditions.gTab_Vec.push_back("CTOF");
			RunConditions.gTab_Vec.push_back("HTCC");
			RunConditions.gTab_Vec.push_back("SECTOR");
			RunConditions.gTab_Vec.push_back("FTOF");
      RunConditions.gTab_Vec.push_back("EC");
			RunConditions.gTab_Vec.push_back("DC12");
			RunConditions.gTab_Vec.push_back("solenoid");
			RunConditions.gTab_Vec.push_back("torus");
		}
		if(RunConditions.gTab_Vec.size() == 0 && dbtable != "no")  
			RunConditions.gTab_Vec.push_back(dbtable);
			
		for(unsigned int sql_t=0; sql_t< RunConditions.gTab_Vec.size(); sql_t++)
		{
			if(GEO_VERBOSITY > 3) cout <<  hd_msg << " Importing table: " <<  RunConditions.gTab_Vec[sql_t] << endl;;
			QSqlQuery q;
			string dbexecute = "select name, mother, description, pos, rot, col, type,";
			dbexecute += "dimensions, material, magfield, ncopy, pmany, exist, ";
			dbexecute += "visible, style, sensitivity, hitType, identity from " + RunConditions.gTab_Vec[sql_t];
			
			// will exit if table cannot be accessed.
			bool SUCCESS = q.exec(dbexecute.c_str());
			if(!SUCCESS)
			{
				cout << hd_msg << "  Failed to access DB for table: " << RunConditions.gTab_Vec[sql_t] << ". Maybe the table doesn't exist? Exiting." << endl;
				exit(0);
			}
			
			while (q.next())
			{
				// %%%%%%%%%%%%%%%%%
				// Reading variables
				// %%%%%%%%%%%%%%%%%

				// 0,1,2: Id, Mother, Description
				Detector.name        = TrimSpaces(gemc_tostring(q.value(0).toString()));
				Detector.mother      = TrimSpaces(gemc_tostring(q.value(1).toString()));
				Detector.description = gemc_tostring(q.value(2).toString());

				// 3: Position Vector
				Detector.pos = G4ThreeVector(0, 0, 0);

				G4ThreeVector nompos(0, 0, 0);
				G4ThreeVector shiftp(0, 0, 0);
				G4ThreeVector more_rot(0, 0, 0);

				vars << gemc_tostring(q.value(3).toString());
				vars >> var; nompos.setX(get_number(var));
				vars >> var; nompos.setY(get_number(var));
				vars >> var; nompos.setZ(get_number(var));
				vars.clear();
				// Adding gcard displacement for this detector if necessary
				if(RunConditions.gDet_Map.find(Detector.name) != RunConditions.gDet_Map.end())
				{
					shiftp = RunConditions.gDet_Map[Detector.name].get_position();
					if(GEO_VERBOSITY > 3 || Detector.name.find(catch_v))
						cout << hd_msg << " Detector " << Detector.name << " is displaced by: " << shiftp/cm << " cm" << endl;

				}
				Detector.pos = nompos + shiftp;


				// 4: Rotation Vector
				Detector.rot = G4RotationMatrix(G4ThreeVector(1, 0, 0),
                                        G4ThreeVector(0, 1, 0),
                                        G4ThreeVector(0, 0, 1));

				vars << gemc_tostring(q.value(4).toString());
				vars >> var;
				if(var != "ordered:")
				{
					             Detector.rot.rotateX(get_number(var));
					vars >> var; Detector.rot.rotateY(get_number(var));
					vars >> var; Detector.rot.rotateZ(get_number(var));
				}
				else
				{
					string order;
					vars >> order;
					if(order == "xzy")
					{
						vars >> var; Detector.rot.rotateX(get_number(var));
						vars >> var; Detector.rot.rotateZ(get_number(var));
						vars >> var; Detector.rot.rotateY(get_number(var));
					}
					else if(order == "yxz")
					{
						vars >> var; Detector.rot.rotateY(get_number(var));
						vars >> var; Detector.rot.rotateX(get_number(var));
						vars >> var; Detector.rot.rotateZ(get_number(var));
					}
					else if(order == "yzx")
					{
						vars >> var; Detector.rot.rotateY(get_number(var));
						vars >> var; Detector.rot.rotateZ(get_number(var));
						vars >> var; Detector.rot.rotateX(get_number(var));
					}
					else if(order == "zxy")
					{
						vars >> var; Detector.rot.rotateZ(get_number(var));
						vars >> var; Detector.rot.rotateX(get_number(var));
						vars >> var; Detector.rot.rotateY(get_number(var));
					}
					else if(order == "zyx")
					{
						vars >> var; Detector.rot.rotateZ(get_number(var));
						vars >> var; Detector.rot.rotateY(get_number(var));
						vars >> var; Detector.rot.rotateX(get_number(var));
					}
					else
					{
						cout << hd_msg << " Ordered rotation <" << order << "> for " << Detector.name << " is wrong, it's none of the following:"
								<< " xzy, yxz, yzx, zxy or zyx. Exiting." << endl;
						exit(0);
					}
				}
        // Adding gcard rotation for this detector if necessary
				if(RunConditions.gDet_Map.find(Detector.name) != RunConditions.gDet_Map.end())
				{
					more_rot = RunConditions.gDet_Map[Detector.name].get_vrotation();
					if(GEO_VERBOSITY > 3 || Detector.name.find(catch_v))
						cout << hd_msg << " Detector " << Detector.name << " is rotated by: " << more_rot/deg << " deg" << endl;
          
          Detector.rot.rotateX(more_rot.x());
          Detector.rot.rotateY(more_rot.y());
          Detector.rot.rotateZ(more_rot.z());
				}


				vars.clear();

				// 5: Color, opacity
				var  = TrimSpaces(gemc_tostring(q.value(5).toString()));
				if(var.size() != 6 && var.size() != 7)
				{
					cout << hd_msg << " Color for " << Detector.name << "<" << var << ">  has wrong size: " << var.size()
							         << ". It should be 6 or 7 hexadecimal numbers." << endl;
					exit(9);
				}
				thisCol = G4Colour(strtol(var.substr(0, 2).c_str(), NULL, 16)/255.0,
										 strtol(var.substr(2, 2).c_str(), NULL, 16)/255.0,
										 strtol(var.substr(4, 2).c_str(), NULL, 16)/255.0,
										 1.0 - atof(var.substr(6, 1).c_str())/5.0);   // Transparency 0 to 5 where 5=max transparency  (default is 0 if nothing is specified)


				// 6: Solid Type
				Detector.type = TrimSpaces(gemc_tostring(q.value(6).toString()));

				// 7: Dimensions
				vars << gemc_tostring(q.value(7).toString());
				while(!vars.eof())
				{
					vars >> var;
					Detector.dimensions.push_back(get_number(var));
				}
				vars.clear();

				// 8: Material
				Detector.material =  TrimSpaces(gemc_tostring(q.value(8).toString()));

				// 9: Magnetic Field
				Detector.magfield =  TrimSpaces(gemc_tostring(q.value(9).toString()));

				// 10: copy number
				Detector.ncopy   = q.value(10).toInt();

				// 11: pMany
				Detector.pMany   = q.value(11).toInt();

				// 12: Activation flag
				Detector.exist   = q.value(12).toInt();
				// Checking if existance is set in the gcard
				if(RunConditions.gDet_Map.find(Detector.name) != RunConditions.gDet_Map.end())
				{
					Detector.exist = RunConditions.gDet_Map[Detector.name].get_existance();
					if(GEO_VERBOSITY > 3 || Detector.name.find(catch_v))
						cout << hd_msg << " Detector " << Detector.name << " has existance set to: " << Detector.exist << endl;

				}


				// 13:  Visibility
				Detector.visible = q.value(13).toInt();

				// 14: Style
				Detector.style   = q.value(14).toInt();

				// 15: sensitivity
				Detector.sensitivity = gemc_tostring(q.value(15).toString());

				if(Detector.sensitivity != "no")
				{

					// 16: hitType
					Detector.hitType = gemc_tostring(q.value(16).toString());

					// 17: identity
					vars << gemc_tostring(q.value(17).toString());
					while(!vars.eof())
					{
						vars >> iden.name >> iden.rule >> iden.id;
						if(iden.rule.find("ncopy") != string::npos) iden.id = Detector.ncopy;
						identity.push_back(iden);
					}
					vars.clear();

					Detector.identity = identity;
					identity.clear();

				}

				// %%%%%%%%%%%%%%%%%
				// End of variables
				// %%%%%%%%%%%%%%%%%

				// Setting the Visual Atributes
				Detector.VAtts = G4VisAttributes(thisCol);
				if(Detector.visible) Detector.style ? Detector.VAtts.SetForceSolid(true) : Detector.VAtts.SetForceWireframe(true);
				Detector.visible ? Detector.VAtts.SetVisibility(true) : Detector.VAtts.SetVisibility(false);

				// need to check that it doesn't exists already before putting it in the map.

				CLAS[Detector.name] = Detector;
				Detector.dimensions.clear();
				Detector.identity.clear();
			}
		}
	}
	db.close();
	// need to create empty db before removing the connection
	db = QSqlDatabase();
	db.removeDatabase("qt_sql_default_connection");
	
	// adding mother volume here:
	string hall_mat   = gemcOpt.args["HALL_MATERIAL"].args;
	detector queen;
	queen.name        = "root";
	queen.mother      = "akasha";
	queen.description = "mother of us all";
	queen.pos         =  G4ThreeVector(0, 0, 0);
	queen.rot         =  G4RotationMatrix(G4ThreeVector(1, 0, 0),
                                        G4ThreeVector(0, 1, 0),
                                        G4ThreeVector(0, 0, 1));
	queen.type        =  "Box";
	queen.dimensions.push_back(120*m);
	queen.dimensions.push_back(120*m);
	queen.dimensions.push_back(120*m);
	queen.material    = hall_mat;
	queen.magfield    = hall_field;
	queen.exist       = 1;
	queen.visible     = 0;
	queen.ncopy       = 0;
	queen.scanned     = 1;
	CLAS["root"] = queen;

	
	
	
	
	cout << endl;

	string field   = gemcOpt.args["NO_FIELD"].args;
	// Transmitting the magnetic field properties to the whole genealogy if they are set to "no"
	for( map<string, detector>::iterator it =  CLAS.begin() ; it!=CLAS.end() && field != "all" ; it++)
	{
		// if this is tagged for no field, continue
		if(it->first  == field)
			continue;
		
		if(it->second.magfield == "no")
		{
			// looking up the whole genealogy, until the first field is found
			string mother = it->second.mother;
			string firstAncestorFieldFound = "no";
			while(mother != "akasha" && firstAncestorFieldFound == "no")
			{
				if(CLAS[mother].magfield != "no")
				{
					firstAncestorFieldFound = CLAS[mother].magfield;
					it->second.magfield = CLAS[mother].magfield;
				}
				// moving up in genealogy
				mother = CLAS[mother].mother;
			}
		}
		
		if(GEO_VERBOSITY > 3 || it->first.find(catch_v) != string::npos) cout << hd_msg << "    " << it->second ;
		
	}
	
	
	return CLAS;
}


SDId get_SDId(string SD, gemc_opts gemcOpt)
{
	string hd_msg        = gemcOpt.args["LOG_MSG"].args + " MySQL: >> ";
	string database      = gemcOpt.args["BANK_DATABASE"].args;
	string dbhost        = gemcOpt.args["DBHOST"].args;

	string dbUser         =  gemcOpt.args["DBUSER"].args;
	string dbPswd         =  gemcOpt.args["DBPSWD"].args;

	double HIT_VERBOSITY = gemcOpt.args["HIT_VERBOSITY"].arg;

	stringstream vars;
	string var;

	SDId SDID;
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

	else
	{
		if(HIT_VERBOSITY>1) cout << hd_msg << " Loading definitions table for <" << SD << ">..." ;
		QSqlQuery q;
		string command = "select id, identifiers, minEnergy, TimeWindow, ProdThreshold, MaxStep from SDId where name = \"" + SD + "\"" ;
		q.exec(command.c_str());

		while (q.next())
		{
			// %%%%%%%%%%%%%%%%%
			// Reading variables
			// %%%%%%%%%%%%%%%%%
			// 0: Bank ID
			SDID.id = q.value(0).toInt();

			// 1: Identifier Maxs
			vars << gemc_tostring(q.value(1).toString());
			vars >> var;
			while(!vars.eof())
			{
				SDID.IDnames.push_back(var);
				vars >> var;
			}
			vars.clear();

			// 2: Minimum Energy Cut for processing the hit
			SDID.minEnergy = get_number(gemc_tostring(q.value(2).toString()));

			// 3: Minimum Energy Cut for processing the hit
			SDID.TimeWindow = get_number(gemc_tostring(q.value(3).toString()));

			// 4: Production Threshold in the detector
			SDID.ProdThreshold = get_number(gemc_tostring(q.value(4).toString()));

			// 5: Maximum Acceptable Step in the detector
			SDID.MaxStep = get_number(gemc_tostring(q.value(5).toString()));

			if(HIT_VERBOSITY>3)
			{
				cout << "found:  bank " << SD << ", id=" << SDID.id << "." << endl << endl ;
				for(unsigned int i=0; i<SDID.IDnames.size(); i++)
				{
					cout << "       element name:  " << SDID.IDnames[i] << endl;
				}
				cout << endl << hd_msg << " Minimum Energy Cut for processing the <" << SD << "> hit: " << SDID.minEnergy/MeV << " MeV." << endl ;
				cout << hd_msg << " Time Window for <" << SD << ">: " << SDID.TimeWindow/ns << " ns." << endl ;
				cout << hd_msg << " Production Threshold for <" << SD << ">: " << SDID.ProdThreshold/mm << " mm." << endl ;
				cout << hd_msg << " Maximum Acceptable Step for <" << SD << ">: " << SDID.MaxStep/mm << " mm." << endl ;
				cout << endl;
			}

		}
	}
	db.close();

	// need to create empty db before removing the connection
	db = QSqlDatabase();
	db.removeDatabase("qt_sql_default_connection");
	return SDID;
}










