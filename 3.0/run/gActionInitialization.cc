// gemc
#include "gPrimaryGeneratorAction.h"
#include "gActionInitialization.h"
#include "gRunAction.h"

// PRAGMA TODO: to be removed
#include "G4UImanager.hh"


// c++
#include <iostream>
using namespace std;

GActionInitialization::GActionInitialization(GOptions* opt) : GFlowMessage(opt, "GActionInitialization"), gopt(opt)
{
}

GActionInitialization::~GActionInitialization()
{
}

void GActionInitialization::Build() const
{
	flowMessage("Thread Build");

	SetUserAction(new GRunAction(gopt));
	SetUserAction(new GPrimaryGeneratorAction);
	// SetUserAction(new GEventAction);
}

void GActionInitialization::BuildForMaster() const
{
	flowMessage("Master Build");
	SetUserAction(new GRunAction(gopt));
}


