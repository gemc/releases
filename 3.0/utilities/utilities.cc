// gemc utilities
#include "utilities.h"
#include "gActionInitialization.h"

// Qt
#include <QtWidgets>

// geant4 headers
#include "G4UImanager.hh"
#include "G4MTRunManager.hh"
#include "gRun.h"

// PRAGMA TODO: needs gphysics so remove this one
#include "QGS_BIC.hh"

// distinguishing between graphical and batch mode
QCoreApplication* createQtApplication(int &argc, char *argv[], bool gui)
{
	if(!gui)
		return new QCoreApplication(argc, argv);
	return new QApplication(argc, argv);
}


// loads a qt resource (images)
int loadQResource(char* argv[], string resourceName)
{
	QFileInfo qrcFileInfoExecutable(argv[0]);
	QString rccPath = qrcFileInfoExecutable.absolutePath() + "/" + QString(resourceName.c_str());
	QResource::registerResource(rccPath);

	return 1;
}



// retrieve and define batch commands
vector<string> batchCommands(GOptions* gopt)
{
	vector<string> commands;



	return commands;
}

// retrieve and define gui commands
vector<string> startingCommands(GOptions* gopt)
{
	vector<string> commands = batchCommands(gopt);


	commands.push_back("/vis/scene/add/trajectories rich smooth");


	// not in gui mode, return natch only
	if( gopt->getBool("gui") == false) return commands;



	return commands;
}

// apply initial UIM commands coming from, in order:
// - batch
// - gui (if needed)
// - goptions
void applyInitialUIManagerCommands(GOptions* gopt)
{
	G4UImanager *g4uim = G4UImanager::GetUIpointer();

	int verbosity = gopt->getInt("gemcv");
	vector<string> commands = startingCommands(gopt);

	vector<string> optionCommands = gopt->getStrings("g4command");
	if(optionCommands[0] != "no") {
		for(auto &c: optionCommands) {
			commands.push_back(c);
		}
	}

	for(auto &c : commands) {
		if(verbosity > GVERBOSITY_SUMMARY) {
			cout << " % Executing UIManager command \"" << c << "\"" << endl;
		}
		g4uim->ApplyCommand(c);
	}

}




// run beamOn requested n. events for each run
void gBeamOn(GOptions *gopts)
{
	G4UImanager *g4uim   = G4UImanager::GetUIpointer();
	//G4RunManager *g4rm = G4RunManager::GetRunManager();

//	GRuns *gruns = new GRuns(gopts);

//	for(auto &run : gruns->getRunEvents()) {
//		int runno = run.first;
//		int nevents = run.second;
//		
		GRun* thisGrun = static_cast<GRun*>( G4RunManager::GetRunManager()->GetNonConstCurrentRun() );
//
		cout << " ASD " << thisGrun << endl;
//		if(thisGrun)
//		thisGrun->SetRunID(runno);
//
////		g4rm->SetRunIDCounter(runno);
//		g4uim->ApplyCommand("/run/beamOn " + to_string(nevents));
//	}
	
	
	g4uim->ApplyCommand("/run/beamOn 10");
	g4uim->ApplyCommand("/run/beamOn 10");
}


// instantiate run manager and assign number of cores
// this is done in main() gemc.cc
// this routine should be part of utilities
G4MTRunManager* gRunManager(int nthreads, GOptions* gopt, GDetectorConstruction *gDetC)
{
	int useThreads = nthreads;
	int allThreads = G4Threading::G4GetNumberOfCores();
	
	if(useThreads == 0) useThreads = allThreads;
	
	G4MTRunManager *runManager = new G4MTRunManager;
	runManager->SetNumberOfThreads(useThreads);
	
	// sequential log screen
	cout << " % G4MTRunManager: using " << useThreads << " threads out of "  << allThreads << " available." << endl;
	
	// GEMC Action
	// shared classes
	runManager->SetUserInitialization(gDetC);
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

// load plugins into digitization
int loadPlugins(map<string, shared_ptr<GDynamic>> *gDigi, GDetectorConstruction *gDetC)
{
	
	
	return 0;
}



