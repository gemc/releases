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


// RecordEvent is called at end of event.
// For scoring purpose, the resultant quantity in a event,
// is accumulated during a Run.
// Method to be overwritten by the user for recording events in this (thread-local) run.
// This should be what EndOfEvent hit collections was doing?
void GRun::RecordEvent(const G4Event *aEvent)
{
	flowMessage("GRun:Local RecordEvent");

	
	numberOfEvent++;  // This is an original line.

	// HitsCollection of This Event
	G4HCofThisEvent* pHCE = aEvent->GetHCofThisEvent();
	if (!pHCE) return;


}

// This is global
// Method to be overwritten by the user for merging local Run object to the global Run object.
void GRun::Merge(const G4Run *aRun)
{
	flowMessage("GRun:Global Merge");

//	const GRun *localRun = static_cast<const GRun *> (aRun);


	G4Run::Merge(aRun);
}
