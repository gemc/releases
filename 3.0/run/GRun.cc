// geant4
#include "GRun.h"
#include "G4Event.hh"


// Constructor
GRun::GRun() {}

// Destructor
GRun::~GRun() {}


//  RecordEvent is called at end of event.
//  For scoring purpose, the resultant quantity in a event,
//  is accumulated during a Run.
void GRun::RecordEvent(const G4Event *aEvent)
{
	numberOfEvent++;  // This is an original line.

	// HitsCollection of This Event
	G4HCofThisEvent* pHCE = aEvent->GetHCofThisEvent();
	if (!pHCE) return;

}


void GRun::Merge(const G4Run *aRun) {

	const GRun *localRun = static_cast<const GRun *> (aRun);

	G4Run::Merge(aRun);
}
