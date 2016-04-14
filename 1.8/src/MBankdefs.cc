/// \file MBankdefs.cc
/// Contains:
/// - read_banks: reads the Hit Process Map and
/// builds the gemc bank class map.\n\n
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n

// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QtSql>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "detector.h"
#include "MBankdefs.h"
#include "string_utilities.h"


map<string, MBank> read_banks(gemc_opts gemcOpt, map<string, MPHB_Factory> Map)
{
	string hd_msg         = gemcOpt.args["LOG_MSG"].args + " Bank Map >> " ;
	double OUT_VERBOSITY  = gemcOpt.args["OUT_VERBOSITY"].arg;
	string database = gemcOpt.args["BANK_DATABASE"].args;
	string dbhost         = gemcOpt.args["DBHOST"].args;

	string dbUser         =  gemcOpt.args["DBUSER"].args;
	string dbPswd         =  gemcOpt.args["DBPSWD"].args;


	map<string, MBank> banks;

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
		for(map<string, MPHB_Factory>::iterator it=Map.begin(); it!=Map.end(); it++)
	{
		MBank mbank;
		string dbtable  = it->first;
		QSqlQuery q;
		string dbexecute = "select name,id, type, activated, description from " + dbtable ;
		q.exec(dbexecute.c_str());

		while (q.next())
		{
			mbank.name.push_back(TrimSpaces(gemc_tostring(q.value(0).toString())));
			mbank.id.push_back(q.value(1).toInt());
			mbank.type.push_back(q.value(2).toInt());
			mbank.activated.push_back(q.value(3).toInt());
			mbank.description.push_back(gemc_tostring(q.value(4).toString()));
		}
		banks[dbtable] = mbank;
	}

	if(OUT_VERBOSITY>2)
	{
		for(map<string, MBank>::iterator it=banks.begin(); it!=banks.end(); it++)
		{
			cout << hd_msg << " bank: <" << it->first << ">" << endl;
			for(unsigned int i=0; i<it->second.name.size(); i++)
			{
				cout << "      variable: " ;
				cout.width(12);
				cout << it->second.name[i];
				cout << " | id: " ;
				cout.width(2);
				cout << it->second.id[i] ;
				cout << " | " ;
				cout.width(8);
				cout << (it->second.type[i] ? "double |" : "int |");
				cout.width(13);
				cout << (it->second.activated[i] ? "present |" : "not present |");
				cout << it->second.description[i] << endl ;
			}
			cout << endl;
		}
	}
	db = QSqlDatabase(); 
	db.removeDatabase("qt_sql_default_connection");

	return banks;
}





