// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QtSql>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "parameter_factory.h"
#include "mysql_parameters.h"
#include "detector.h"   // just for TrimSpaces
#include "string_utilities.h"



map<string, double> mysql_parameters::initParameters(run_conditions runConditions, gemc_opts opts)
{
	// DB settings
  string database = opts.args["DATABASE"].args;
	string dbhost   = opts.args["DBHOST"].args;
	string dbUser   = opts.args["DBUSER"].args;
	string dbPswd   = opts.args["DBPSWD"].args;
	string hd_msg   = opts.args["LOG_MSG"].args + " MYSQL Parameters: >> ";
	double verbos   = opts.args["PARAMETER_VERBOSITY"].arg;


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


	map<string, double> GParameters;   // parameters maps
	string dbtable  = opts.args["GT"].args;
	
  if(runConditions.gTab_Vec.size() == 0 && dbtable != "no")  
    runConditions.gTab_Vec.push_back(dbtable);



	// at this point RunConditions should have something inside
  for(unsigned int sql_t=0; sql_t< runConditions.gTab_Vec.size(); sql_t++)
  {
  	string parameter_table = runConditions.gTab_Vec[sql_t] + "__parameters";
    string dbexecute = "select name, value, units, description from " + parameter_table;

    // will exit if table cannot be accessed.
    QSqlQuery q;
    if(!q.exec(dbexecute.c_str()))
    {
      cout << hd_msg << "  WARNING! Failed to access DB for table: " << parameter_table <<  ". Maybe the table doesn't exist? " << endl;
    }
    
    while (q.next())
    {
      string pname   = runConditions.gTab_Vec[sql_t] + "/" + TrimSpaces(gemc_tostring(q.value(0).toString()));
      double pvalue  = q.value(1).toDouble();
      string punits  = TrimSpaces(gemc_tostring(q.value(2).toString()));
      string pdescr  = gemc_tostring(q.value(3).toString());
      
      if(       punits == "m")      pvalue *= m;
      else if(  punits == "inches") pvalue *= 2.54*cm;
      else if(  punits == "cm")     pvalue *= cm;
      else if(  punits == "mm")     pvalue *= mm;
      else if(  punits == "um")     pvalue *= 1E-6*m;
      else if(  punits == "fm")     pvalue *= 1E-15*m;
      else if(  punits == "deg")    pvalue *= deg;
      else if(  punits == "arcmin") pvalue = pvalue/60.0*deg;
      else if(  punits == "rad")    pvalue *= rad;
      else if(  punits == "mrad")   pvalue *= mrad;
      else if(  punits == "eV")     pvalue *= eV;
      else if(  punits == "MeV")    pvalue *= MeV;
      else if(  punits == "KeV")    pvalue *= 0.001*MeV;
      else if(  punits == "GeV")    pvalue *= GeV;
      else if(  punits == "T")      pvalue *= tesla;
      else if(  punits == "Tesla")  pvalue *= tesla;
      else if(  punits == "ns")     pvalue *= ns;
      else if(  punits == "na")     pvalue *= 1;
      else cout << punits << ": unit not recognized!!" << endl;
			
      GParameters[pname] = pvalue;
      
      if(verbos > 1)
      {
      	cout << hd_msg << " Parameter: " << pname << " with value " << pvalue << " "; 
        if(punits != "na") cout << punits ;
        cout << " : "  << pdescr << endl;
     } 
      
		}

	}  
  
  
  // closing DB connection
  db.close();
	// need to create empty db before removing the connection
	db = QSqlDatabase();
	db.removeDatabase("qt_sql_default_connection");
	cout << endl;

  
  
  return GParameters;
}
