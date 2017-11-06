// gemc
#include "g4GRun.h"

// geant4
#include "G4Event.hh"

// mlibrary
#include "ghit.h"

// Constructor
G4GRun::G4GRun(GOptions* gopt) : G4Run(), GFlowMessage(gopt, "GRun")
{
}

// Destructor
G4GRun::~G4GRun()
{
}


// RecordEvent is called at end of event
// Method to be overwritten by the user for recording events in this (thread-local) run.
// The observables defined in each run should be filled here with the information from the hits
void G4GRun::RecordEvent(const G4Event *aEvent)
{
	flowMessage("GRun:Local RecordEvent");
	// HitsCollections of This Event
    G4HCofThisEvent* HCsThisEvent = aEvent->GetHCofThisEvent();
    if (!HCsThisEvent) return;

	
	// looping over all collections
	for(unsigned hci = 0; hci < HCsThisEvent->GetNumberOfCollections(); hci++) {
		GHitsCollection *thisGHC = (GHitsCollection*) HCsThisEvent->GetHC(hci);
		G4cout << " Collection number  " << hci + 1 << " " << thisGHC << " name " << thisGHC->GetSDname() <<  G4endl ;

		// looping over hits in this collection
		if(thisGHC) {
			for(size_t hitIndex = 0; hitIndex<thisGHC->GetSize(); hitIndex++) {
				GHit *thisHit = (GHit*) thisGHC->GetHit(hitIndex);
				
				// digitized hit if requested
				
				
				vector<double> edep = thisHit->getStepEdep();
				for(unsigned i=0; i<edep.size(); i++ )
					G4cout << " Hit number  " << hitIndex+1 << " step: " << i << "  edep: " << edep[i] <<  G4endl ;
			}
		}
		
	}
	
    G4Run::RecordEvent(aEvent);


}

// This is global
// Method to be overwritten by the user for merging local
// Run objects to the global Run object.
void G4GRun::Merge(const G4Run *aRun)
{
	flowMessage("GRun:Global Merge");

	const G4GRun *localRun = static_cast<const G4GRun *> (aRun);

	
	

	G4Run::Merge(aRun);
}
