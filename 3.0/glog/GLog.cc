// gemc
#include "GLog.h"

// c++
#include <iostream>


GSession::GSession()
{
	logFile.open("MasterGeant4.log");
	errFile.open("MasterGeant4.err");
}

G4int GSession::ReceiveG4cout(const G4String& coutString)
{
	logFile << coutString << flush;
	return 0;
}

G4int GSession::ReceiveG4cerr(const G4String& coutString)
{
	errFile << coutString << flush;
	return 0;
}
