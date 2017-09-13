// gemc
#include "gPrimaryGeneratorAction.h"
#include "gActionInitialization.h"
#include "gRunAction.h"

// PRAGMA TODO: to be removed
#include "G4UImanager.hh"


// c++
#include <iostream>
using namespace std;

GActionInitialization::GActionInitialization(GOptions* opt) : gopt(opt)
{
	G4cout << " GActionInitialization constructor  " << G4endl;
}

GActionInitialization::~GActionInitialization()
{
	G4cout << " GActionInitialization destructor  " << G4endl;
}

void GActionInitialization::Build() const
{
	G4cout << " GActionInitialization Thread Build  " << G4endl;

	SetUserAction(new GRunAction(gopt));
	SetUserAction(new GPrimaryGeneratorAction);
	// SetUserAction(new GEventAction);
}

void GActionInitialization::BuildForMaster() const
{
	G4cout << " GActionInitialization Master  " << G4endl;
	SetUserAction(new GRunAction(gopt, new GRuns(gopt) ) );
}


