// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QtSql>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "material_factory.h"
#include "mysql_materials.h"
#include "detector.h"   // just for TrimSpaces
#include "string_utilities.h"

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4Element.hh"
#include "G4NistManager.hh"
#include "G4OpBoundaryProcess.hh"


map<string, G4Material*> mysql_materials::initMaterials(run_conditions runConditions, gemc_opts opts)
{
	// DB settings
  string database = opts.args["DATABASE"].args;
	string dbhost   = opts.args["DBHOST"].args;
	string dbUser   = opts.args["DBUSER"].args;
	string dbPswd   = opts.args["DBPSWD"].args;
	string hd_msg   = opts.args["LOG_MSG"].args + " MYSQL Materials: >> ";
	double verbos   = opts.args["MATERIAL_VERBOSITY"].arg;


	// connection to the DB
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


	map<string, G4Material*> mats;                        // material maps
	map<string, G4MaterialPropertiesTable*> optP;         // optical properties maps
  
  G4NistManager* matman = G4NistManager::Instance();    // material G4 Manager


	// loading elements material from table "materials__elements"
  map<string, G4Element*> elementsMap;
  QSqlQuery q, q2, q3;
  string dbexecute = "select name, symbol, atomic_number, molar_mass from materials__elements" ;

  // will exit if table cannot be accessed.
  if(!q.exec(dbexecute.c_str()))
  {
    cout << hd_msg << "  Failed to access DB for table: materials__elements. Maybe the table doesn't exist? Exiting." << endl;
    exit(0);
  }


  while (q.next())
  {
  	string ename         = TrimSpaces(gemc_tostring(q.value(0).toString()));
  	string esymbol       = TrimSpaces(gemc_tostring(q.value(1).toString()));
    int    atomic_number = q.value(2).toInt();
    double molar_mass    = q.value(3).toDouble();
    
    elementsMap[ename] = new G4Element(ename,  esymbol, atomic_number, molar_mass*g/mole);
    
	}

	
	string dbtable  = opts.args["GT"].args;
	
  if(runConditions.gTab_Vec.size() == 0 && dbtable != "no")  
    runConditions.gTab_Vec.push_back(dbtable);



	// at this point RunConditions should have something inside
  for(unsigned int sql_t=0; sql_t< runConditions.gTab_Vec.size(); sql_t++)
  {
  	string material_table = runConditions.gTab_Vec[sql_t] + "__materials";
    dbexecute = "select name, density, nelements, elements from " + material_table;

    // will exit if table cannot be accessed.
    if(!q.exec(dbexecute.c_str()))
    {
      cout << hd_msg << "  Failed to access DB for table: " << material_table <<  ". Maybe the table doesn't exist? Exiting." << endl;
      exit(0);
    }
    
    while (q.next())
    {
      string mname     = TrimSpaces(gemc_tostring(q.value(0).toString()));
      double density   = q.value(1).toDouble();
      int    nelements = q.value(2).toInt();
      mats[mname] = new G4Material(mname, density*mg/cm3, nelements);

                  
      stringstream elements(gemc_tostring(q.value(3).toString()));
      string *enamelist= new string[nelements];  // Have to use new, since string is a class (non-POD = not "plain old data") and clang complains. 
			                                           // Also, maybe cause the string operator "[]" ?
      double eperc[nelements];
    	for(int e=0; e<nelements; e++)
    	{
      	elements >> enamelist[e] >> eperc[e];
      }
      
      // checking that all components exists
      // if not, will build non-existing components first
      // TODO: adding elements by molecular components:
      // 
      // Example for Water:
      // H2O->AddElement(elH, natoms=2);
      // H2O->AddElement(elO, natoms=1);
      // should be done by modifying percentage so it's always < 1
      // so if it's > 1 it's molecular constructor
      
    	for(int e=0; e<nelements; e++)
			{
      	if(elementsMap.find(enamelist[e]) != elementsMap.end())
        {
        	mats[mname]->AddElement(elementsMap[enamelist[e]], eperc[e]*perCent);
        }
        // checking if geant4 provides this material. In case,
        // add it to the materials
        else if(matman->FindOrBuildMaterial(enamelist[e]) != 0)
            mats[mname]->AddMaterial(matman->FindOrBuildMaterial(enamelist[e]), eperc[e]*perCent);
        
        else 
        	cout << hd_msg << "  WARNING: Component " << enamelist[e] << "  NOT FOUND!!" << endl;
      }      
      
      // checking that percentages add to 100
    	double sum = 0;
      for(int e=0; e<nelements; e++)
				sum += eperc[e]*perCent;
        
      if(fabs(sum-1)>0.01) 
        cout << hd_msg << "  WARNING: Material " << mname << "  components percentages add to " << sum*100 << " instead of 100." << endl;
      	
      
      // Check if there are material properties associated with the material
      // First check if there's photon energy
      // If yes then load it, and proceed to the rest of the properties
      string opt_properties_table = runConditions.gTab_Vec[sql_t] + "__opt_properties";
      dbexecute = "select property, plist from " + opt_properties_table + " where mat_name='" + mname + "' and property='PhotonEnergy'";
      
      if(q2.exec(dbexecute.c_str()))
      {
      	int non_zero = 0; // switch to one for any properties so we can associate it to the material
        optP[mname]  = new G4MaterialPropertiesTable();
        vector<string> pvalues;
        
        while(q2.next())
        {
          string property = TrimSpaces(gemc_tostring(q2.value(0).toString()));
         	pvalues         = get_strings(gemc_tostring(q2.value(1).toString()));
					// last entry in pvalues is empty. Removing it
					pvalues.pop_back();
        } 
				
        unsigned int nentries = pvalues.size();
        double penergy[nentries];
        for(unsigned int i=0; i<nentries; i++)
          penergy[i] = get_number(pvalues[i]);
      
      	// now can fill the other properties
      	dbexecute = "select property, plist from " + opt_properties_table + " where mat_name='" + mname + "' and property!='PhotonEnergy'";
        if(q3.exec(dbexecute.c_str()))
        {          
          while(q3.next())
          {
          	string property        = TrimSpaces( gemc_tostring(q3.value(0).toString()));
            vector<string> dvalues = get_strings(gemc_tostring(q3.value(1).toString()));
						// last entry in dvalues is empty. Removing it
						dvalues.pop_back();
						
         		if(dvalues.size() != nentries)
            {
              cout << hd_msg << "  Number of entries for property " << property 
                   <<  " of material " << mname 
                   <<  " is " << dvalues.size() << " and does not match the photon energy entries of " << nentries << endl;
              exit(0);
            }
            else
            {
            	double this_values[nentries];
              for(unsigned int i=0; i<nentries; i++)
                this_values[i] = get_number(dvalues[i]);
             
              if(property == "IndexOfRefraction")
                optP[mname]->AddProperty("RINDEX",        penergy, this_values, nentries);
              
              if(property == "AbsorptionLength")
                optP[mname]->AddProperty("ABSLENGTH",     penergy, this_values, nentries);
              
              if(property == "Reflectivity")
                optP[mname]->AddProperty("REFLECTIVITY",  penergy, this_values, nentries);
              
              if(property == "Efficiency")
                optP[mname]->AddProperty("EFFICIENCY",    penergy, this_values, nentries);
       				
              non_zero = 1;      
            }   
          }
				}
      	
        if(non_zero)
        {
          mats[mname]->SetMaterialPropertiesTable(optP[mname]);
          if(verbos > 1)
          {
            cout << hd_msg << "  Optical Properties for " << mname << ":" << endl; 
         	 	optP[mname]->DumpTable();
          }
        }
      }
      
      if(verbos > 1)
      {
      	cout << hd_msg << " Material: " << mname << " with density " << density << " mg/cm3 loaded with " << nelements << " components: " << endl;
        for(int e=0; e<nelements; e++)
          cout << "                                (" << e+1 << ") " << enamelist[e] << " " << eperc[e] << "%" << endl;
			} 
     
			delete[] enamelist;
		}
	}  
  
  
  // closing DB connection
  db.close();
	// need to create empty db before removing the connection
	db = QSqlDatabase();
	db.removeDatabase("qt_sql_default_connection");
	cout << endl;

  
  
  return mats;
}
