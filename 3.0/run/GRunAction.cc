// gemc
#include "GRunAction.h"
#include "GRun.h"

// geant4
#include "globals.hh"
#include "G4Threading.hh"


// c++
using namespace std;

// Constructor
GRunAction::GRunAction()
: G4UserRunAction()
{
}


// Destructor.
GRunAction::~GRunAction()
{
}


G4Run* GRunAction::GenerateRun()
{
	return new GRun;
}


void GRunAction::BeginOfRunAction(const G4Run* aRun)
{
	G4cout << "### Run " << aRun->GetRunID() << " start inside " << G4Threading::G4GetThreadId()  << G4endl;
}

void GRunAction::EndOfRunAction(const G4Run* aRun)
{
	const GRun* theRun = static_cast<const GRun*> (aRun);
	if(IsMaster())
	{
		G4cout << "Global result with " << theRun->GetNumberOfEvent() << G4endl;
	} else {
		G4cout << "Local thread result with " << theRun->GetNumberOfEvent() << G4endl;
	}
}
