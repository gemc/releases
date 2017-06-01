// gemc
#include "GDetectorConstruction.h"
#include "GPrimaryGeneratorAction.h"

// geant4
#include "GActionInitialization.h"
#include "GRunAction.h"

// to be removed
#include "QGS_BIC.hh"
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
	SetUserAction(new GRunAction(gopt));
}

// instantiate run manager and assign number of cores
G4MTRunManager* gRunManager(int nthreads, GOptions* gopt)
{
	int useThreads = nthreads;
	int allThreads = G4Threading::G4GetNumberOfCores();

	if(useThreads == 0) useThreads = allThreads;

	G4MTRunManager *runManager = new G4MTRunManager;
	runManager->SetNumberOfThreads(useThreads);

	// sequential log screen
	cout << " % gRunManager: using " << useThreads << " threads out of "  << allThreads << " available." << endl;

	// GEMC Action
	// shared classes
	runManager->SetUserInitialization(new GDetectorConstruction(gopt));
	runManager->SetUserInitialization(new QGS_BIC());
	runManager->SetUserInitialization(new GActionInitialization(gopt));


	// setting WTs G4cout destination to files
	G4UImanager* UI = G4UImanager::GetUIpointer();
	// using 100 as "for sure it's bigger than any number of cores?"
	// to ignore output from all threads until initialisation
	UI->ApplyCommand("/control/cout/ignoreThreadsExcept 100");
	UI->ApplyCommand("/control/cout/ignoreInitializationCout");
	UI->ApplyCommand("/control/cout/setCoutFile thread.log");
	//Initialize G4 kernel
	runManager->Initialize();
	UI->ApplyCommand("/control/cout/ignoreThreadsExcept -1");

	return runManager;
}



