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
		G4cout << "Registering " << name << " touchable in " << GetName() << " with value: " << gt->getGTouchableDescriptionString() << G4endl;
	}
	gTouchableMap[name] = gt;
}

// thread local
void GSensitiveDetector::Initialize(G4HCofThisEvent* g4hc)
{
	flowMessage("Initializing GSensitiveDetector " + GetName());

	// picking the digitization from the global map
	if(gDigitizationGlobal->find(GetName()) != gDigitizationGlobal->end()) {
		gDigiLocal = (*gDigitizationGlobal)[GetName()];
	}
	
	// clearing touchableSet at the start of the event
	touchableSet.clear();
	
	// protecting against pluging loading failures
	if(!gDigiLocal) {
		G4cout << GWARNING << " Plugin " << GetName() << " not loaded." << G4endl;
	}
}


G4bool GSensitiveDetector::ProcessHits(G4Step* thisStep, G4TouchableHistory* g4th)
{
	// skip event if gDigiLocal not present?
	if(!gDigiLocal) {
		return false;
	}

	double depe = thisStep->GetTotalEnergyDeposit();
		
	// decide if to proceed or skip.
	if(skipProcessHit(depe)) {
		return false;
	}
	

	// PRAGMA TODO: do this only in debug mode
	flowMessage("Processing Hits in GSensitiveDetector " + GetName());
	
	G4StepPoint   *preStepPoint = thisStep->GetPreStepPoint();
	G4StepPoint   *pstStepPoint = thisStep->GetPostStepPoint();

	// process touchable. if not defined by plugin, base class will return vector
	vector<GTouchable*> thisStepProcessedTouchables = gDigiLocal->processTouchable(getGTouchable(preStepPoint->GetTouchable()), thisStep);
	
	for(auto thisGTouchable: thisStepProcessedTouchables) {
		
	}
	
//	G4cout << " ASD " << gDigiLocal << G4endl;

	G4cout << " identifier before " << getGTouchable(preStepPoint->GetTouchable())->getGTouchableDescriptionString() << G4endl;
	
	for(auto gt: thisStepProcessedTouchables) {
		G4cout << " identifier after " << gt->getGTouchableDescriptionString() << G4endl ;
	}

	// PRAGMA TODO: do this only in debug mode
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




