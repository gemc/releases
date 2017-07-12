// gemc
#include "gSensitiveDetector.h"

// this is thread-local
GSensitiveDetector::GSensitiveDetector(string name, GOptions* gopt) : G4VSensitiveDetector(name)
{
	verbosity = gopt->getInt("gsensitivityv");

	if(verbosity > 1) {
		G4cout << " Instantiating GSensitive Detector " << name << G4endl;
	}

	// loading processTouchable plugin if it can be found

}

void GSensitiveDetector::Initialize(G4HCofThisEvent* g4hc)
{

}

G4bool GSensitiveDetector::ProcessHits(G4Step* thisStep, G4TouchableHistory* g4th)
{
	double depe = thisStep->GetTotalEnergyDeposit();
	if(verbosity > 2) {
		G4cout << " Energy deposited this step: " << depe << G4endl;
	}

	return true;
}

void GSensitiveDetector::EndOfEvent(G4HCofThisEvent* g4hc)
{

}





