// gemc
#include "gSensitiveDetector.h"


// this is thread-local
GSensitiveDetector::GSensitiveDetector(string name, GOptions* gopt, map<string, GDynamic*> *gDigiGlobal) : G4VSensitiveDetector(name),
GFlowMessage(gopt, "GSensitiveDetector " + name),
gDigitizationGlobal(gDigiGlobal)
{
	verbosity = gopt->getInt("gsensitivityv");

	flowMessage("Instantiating GSensitiveDetector " + name);
}

void GSensitiveDetector::registerGVolumeTouchable(string name, GTouchable* gt)
{
	if(verbosity >= GVERBOSITY_DETAILS) {
		G4cout << "Registering " << name << " touchable in " << GetName() << " with value: " << gt->getGTouchableId() << G4endl;
	}
	gTouchableMap[name] = gt;
}


void GSensitiveDetector::Initialize(G4HCofThisEvent* g4hc)
{
	flowMessage("Initializing GSensitiveDetector " + GetName());

	// picking the digitization from the global map
	if(gDigitizationGlobal->find(GetName()) != gDigitizationGlobal->end()) {
		gDigiLocal = (*gDigitizationGlobal)[GetName()];
	}
	
	// protecting against pluging loading failures
	if(!gDigiLocal) {
		flowMessage("Plugin " + GetName() + " not loaded.");
	}
}


G4bool GSensitiveDetector::ProcessHits(G4Step* thisStep, G4TouchableHistory* g4th)
{
	double depe = thisStep->GetTotalEnergyDeposit();
	
	// decide if to proceed or skip.
	if(skipProcessHit(depe)) {
		return false;
	}

	flowMessage("Processing Hits in GSensitiveDetector " + GetName());
	G4StepPoint   *preStepPoint = thisStep->GetPreStepPoint();

	
	G4cout << " identifier " << getGTouchable(preStepPoint->GetTouchable());
	
	if(verbosity == GVERBOSITY_ALL) {
		G4cout << " Energy deposited this step: " << depe << G4endl;
	}
	
	
	return true;
}

void GSensitiveDetector::EndOfEvent(G4HCofThisEvent* g4hc)
{
	flowMessage("EndOfEvent of GSensitiveDetector " + GetName());
}


// retrieve touchable in ProcessHit
GTouchable* GSensitiveDetector::getGTouchable(const G4VTouchable *geant4Touchable)
{
	// PRAGMA TODO: throw exception here if not found?
	// this assumes the name exists in the map
	return gTouchableMap[geant4Touchable->GetVolume()->GetName()];
}




