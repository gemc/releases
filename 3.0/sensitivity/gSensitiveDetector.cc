// gemc
#include "gSensitiveDetector.h"


// this is thread-local
GSensitiveDetector::GSensitiveDetector(string name, GOptions* gopt, GVolume *thisGV) : G4VSensitiveDetector(name), GFlowMessage(gopt, "GSensitiveDetector " + name)
{
	verbosity = gopt->getInt("gsensitivityv");
	
	flowMessage("Instantiating GSensitiveDetector " + name);

	
	

	// PRAGMA TODO: need to load the sensitive infos like timwindow and thresholds
}

void GSensitiveDetector::Initialize(G4HCofThisEvent* g4hc)
{
	flowMessage("Initialize GSensitiveDetector " + GetName());

	
	// PRAGMA TODO: if a plugin function is not defined, then this should revert to the base class?
	// instead of crashing
//	if(digitization)
//		digitization->loadConstants(2, "original");


}

G4bool GSensitiveDetector::ProcessHits(G4Step* thisStep, G4TouchableHistory* g4th)
{
	flowMessage("Processing Hits in GSensitiveDetector " + GetName());
	
	double depe = thisStep->GetTotalEnergyDeposit();
	if(verbosity == GVERBOSITY_ALL) {
		G4cout << " Energy deposited this step: " << depe << G4endl;
	}
	
	
	return true;
}

void GSensitiveDetector::EndOfEvent(G4HCofThisEvent* g4hc)
{
	flowMessage("EndOfEvent of GSensitiveDetector " + GetName());
}





