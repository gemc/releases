// gemc
#include "gRunAction.h"
#include "gRun.h"

// geant4
#include "globals.hh"
#include "G4Threading.hh"


// c++
using namespace std;

// Constructor
GRunAction::GRunAction(GOptions* opt) : G4UserRunAction(), gopt(opt)
{
	G4cout << " Constructor GRunAction" << G4endl;
}


// Destructor
GRunAction::~GRunAction()
{
	G4cout << " Destructor GRunAction" << G4endl;
}


G4Run* GRunAction::GenerateRun()
{
	G4cout << " GRunAction GenerateRun" << G4endl;
	return new GRun;
}


void GRunAction::BeginOfRunAction(const G4Run* aRun)
{
	G4cout << "### GRunAction " << aRun->GetRunID() << " BeginOfRunAction in thread " << G4Threading::G4GetThreadId()  << G4endl;
}

void GRunAction::EndOfRunAction(const G4Run* aRun)
{
	G4cout << "### GRunAction " << aRun->GetRunID() << " EndOfRunAction in thread " << G4Threading::G4GetThreadId()  << G4endl;
	
	const GRun* theRun = static_cast<const GRun*> (aRun);
	if(IsMaster())
	{
		G4cout << "Global result with " << theRun->GetNumberOfEvent() << G4endl;
	} else {
		G4cout << "Local thread result with " << theRun->GetNumberOfEvent() << G4endl;
	}
}
