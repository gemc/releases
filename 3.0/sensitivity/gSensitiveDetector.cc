// gemc
#include "gSensitiveDetector.h"

// geant4
#include "G4SDManager.hh"




// thread local
void GSensitiveDetector::Initialize(G4HCofThisEvent* g4hc)
{

	
	// clearing touchableSet at the start of the event
	touchableSet.clear();
	
	// setting bitset
	gHitBitSet = gDigiLocal->gSensitiveParameters->getHitBitSet();
	
    // initializing hit collection
    // in geant4 this comes with two arguments
    // in gemc the two are the same
    gHitsCollection = new GHitsCollection(GetName(), collectionName[0]);
    
    // adding gHitsCollection to the G4HCofThisEvent
    // hcID is incrememnted by 1 every time we instantiate it with the above command
    // it can then be retrieved at the end of the event
    auto hcID = G4SDManager::GetSDMpointer()->GetCollectionID(collectionName[0]);
    g4hc->AddHitsCollection(hcID, gHitsCollection);
	
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
		// new hit
		if(isThisANewTouchable(thisGTouchable)) {
			gHitsCollection->insert(new GHit(thisGTouchable, thisStep, gHitBitSet));
        } else {
            // retrieve hit from hit collection
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


