// gemc
#include "GLog.h"

// c++
#include <iostream>

GSession::GSession()
{
	cout << " Opening for G4Cout " << endl;
	logFile.open(".geant4Log");
}

G4int GSession::ReceiveG4cout(const G4String& coutString)
{
	logFile << coutString << flush;
	return 0;
}

G4int GSession::ReceiveG4cerr(const G4String& coutString)
{
	return 0;
}
