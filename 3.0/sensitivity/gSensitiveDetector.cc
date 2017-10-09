// gemc
#include "gSensitiveDetector.h"


// this is thread-local
GSensitiveDetector::GSensitiveDetector(string name, GOptions* gopt, map<string, GDynamic*> *gDigiGlobal) :
G4VSensitiveDetector(name), GFlowMessage(gopt, "GSensitiveDetector " + name), gDigitizationGlobal(gDigiGlobal)
{
	verbosity = gopt->getInt("gsensitivityv");
	
	flowMessage("Instantiating GSensitiveDetector " + name);

	
	// PRAGMA TODO: need to load the sensitive infos like timwindow and thresholds?
}

void GSensitiveDetector::Initialize(G4HCofThisEvent* g4hc)
{
	flowMessage("Initializing GSensitiveDetector " + GetName());

	// picking the digitization from the global map
	if(gDigitizationGlobal->find(GetName()) != gDigitizationGlobal->end()) {
		gDigiLocal = (*gDigitizationGlobal)[GetName()];
	}
	
	flowMessage(gDigiLocal->showConstants());
	
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





