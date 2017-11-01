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
	
	// setting
	gHitBitSet = gDigiLocal->gSensitiveParameters->getHitBitSet();
	
	
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
	

	// process touchable. if not defined by plugin, base class will return vector
	vector<GTouchable*> thisStepProcessedTouchables = gDigiLocal->processTouchable(getGTouchable(thisStep), thisStep);


	
	// PRAGMA TODO:
	// add verbosity for debug mode?
	for(auto thisGTouchable: thisStepProcessedTouchables) {
		//G4cout << " ASD " << gHitBitSet << G4endl;
		// new hit
		if(isThisANewTouchable(thisGTouchable)) {
			GHit *newGhit = new GHit(thisGTouchable, thisStep, gHitBitSet);
		}
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
GTouchable* GSensitiveDetector::getGTouchable(const G4Step* thisStep)
{
	// the touchable comes from the pre-step point
	
	// PRAGMA TODO: throw exception here if not found?
	// this assumes the name exists in the map
	return gTouchableMap[thisStep->GetPreStepPoint()->GetTouchable()->GetVolume()->GetName()];
}




