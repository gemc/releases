// gemc
#include "gRun.h"

// geant4
#include "G4Event.hh"


// Constructor
GRun::GRun(GOptions* gopt) : G4Run(), GFlowMessage(gopt, "GRun")
{
}

// Destructor
GRun::~GRun()
{
}


// RecordEvent is called at end of event
// Method to be overwritten by the user for recording events in this (thread-local) run.
// The observables defined in each run should be filled here with the information from the hits
void GRun::RecordEvent(const G4Event *aEvent)
{
	flowMessage("GRun:Local RecordEvent");

	// HitsCollections of This Event
	G4HCofThisEvent* HCsThisEvent = aEvent->GetHCofThisEvent();
	if (!HCsThisEvent) return;

    G4cout << " Number of collections: " << HCsThisEvent->GetNumberOfCollections() << G4endl ;
    
    G4Run::RecordEvent(aEvent);


}

// This is global
// Method to be overwritten by the user for merging local
// Run objects to the global Run object.
void GRun::Merge(const G4Run *aRun)
{
	flowMessage("GRun:Global Merge");

	const GRun *localRun = static_cast<const GRun *> (aRun);


	G4Run::Merge(localRun);
}
