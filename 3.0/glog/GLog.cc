// gemc
#include "GLog.h"

// c++
#include <iostream>


GSession::GSession()
{
	logFile.open("MasterGeant4.log");
}

G4int GSession::ReceiveG4cout(const G4String& coutString)
{
	logFile << coutString << flush;
	return 0;
}

G4int GSession::ReceiveG4cerr(const G4String& coutString)
{
	cout << coutString << flush;
	return 0;
}
