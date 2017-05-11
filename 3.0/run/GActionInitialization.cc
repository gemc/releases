// geant4
#include "GActionInitialization.h"
#include "GRunAction.h"

// c++
#include <iostream>
using namespace std;

GActionInitialization::GActionInitialization()
{;}

GActionInitialization::~GActionInitialization()
{;}

void GActionInitialization::Build() const
{
//	SetUserAction(new GRunAction);
}

void GActionInitialization::BuildForMaster() const
{
//	G4UserRunAction* run_action = new GRunAction;
//	SetUserAction(run_action);
}

// instantiate run manager and assign number of cores
G4MTRunManager* gRunManager(int nthreads)
{
	int useThreads = nthreads;
	int allThreads = G4Threading::G4GetNumberOfCores();

	if(useThreads == 0) useThreads = allThreads;

	G4MTRunManager *runManager = new G4MTRunManager;
	runManager->SetNumberOfThreads(useThreads);

	cout << " > gRunManager: using " << useThreads << " threads out of "  << allThreads << " available." << endl;

	// GEMC Action
	runManager->SetUserInitialization(new GActionInitialization);
	
	//Initialize G4 kernel
	runManager->Initialize();

	
	return runManager;
}
