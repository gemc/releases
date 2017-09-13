// gemc
#include "gRun.h"

// geant4
#include "G4Event.hh"


// Constructor
// PRAGMA: why  SetRunID here is not reflected in runAction?
GRun::GRun(int runno) :  G4Run()
{
	G4cout << " Constructor GRun with run number " << runno << G4endl;
	
	
	SetRunID(runno);
}


// Destructor
GRun::~GRun()
{
	G4cout << " Destructor GRun  " << G4endl;
}


//  RecordEvent is called at end of event.
//  For scoring purpose, the resultant quantity in a event,
//  is accumulated during a Run.
void GRun::RecordEvent(const G4Event *aEvent)
{
	numberOfEvent++;  // This is an original line.

	// HitsCollection of This Event
	G4HCofThisEvent* pHCE = aEvent->GetHCofThisEvent();
	if (!pHCE) return;

	G4cout << " RecordEvent run  " << G4endl;

}


void GRun::Merge(const G4Run *aRun) {

//	const GRun *localRun = static_cast<const GRun *> (aRun);

	G4cout << " Merge run  " << G4endl;

	G4Run::Merge(aRun);
}
