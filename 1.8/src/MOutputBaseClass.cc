// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MOutputBaseClass.h"
#include "usage.h"

#include <fstream>
using namespace std;

MOutputBaseClass *GetMOutputClass (map<string, MOutput_Factory> *MProcessOutput_Map, string outputType)
{
	
	if(MProcessOutput_Map->find(outputType) == MProcessOutput_Map->end())
	{
		cout << endl << endl << "  >>> WARNING: Output type <" << outputType << "> NOT FOUND IN  Output Map." << endl;
		return NULL;
	}
	
	return (*MProcessOutput_Map)[outputType]();
}

MOutputs::MOutputs(gemc_opts Opts)
{
 // EVIO Buffer size set to 30M words
 int evio_buffer = 30000000;

 gemcOpt = Opts;
 string hd_msg  = gemcOpt.args["LOG_MSG"].args + " Output File: >> ";

 string optf = gemcOpt.args["OUTPUT"].args;
 outType.assign(optf, 0, optf.find(",")) ;
 outFile.assign(optf,    optf.find(",") + 1, optf.size()) ;

 if(outType != "no") cout << hd_msg << " Opening output file \"" << TrimSpaces(outFile) << "\"." << endl; 
 if(outType == "txt")  txtoutput = new ofstream(TrimSpaces(outFile).c_str());
 if(outType == "evio")
 {
    pchan = new evioFileChannel(TrimSpaces(outFile).c_str(), "w", evio_buffer);
    pchan->open();
 }
}

MOutputs::~MOutputs()
{
 string hd_msg  = gemcOpt.args["LOG_MSG"].args + " Output File: >> ";

 if(outType != "no")   cout << " Closing " << outFile << "." << endl;
 if(outType == "txt")  txtoutput->close();
 if(outType == "evio")
 {
    pchan->close();
    delete pchan;
 }
}
