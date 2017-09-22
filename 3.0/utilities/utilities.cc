// gemc
#include "utilities.h"
#include "gActionInitialization.h"

// Qt
#include <QtWidgets>

// geant4 headers
#include "G4UImanager.hh"
#include "gRun.h"

// mlibrary
#include "gruns.h"

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
// these include possible options/gcard commands
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

	GRuns *gruns = new GRuns(gopts);

	for(auto &run : gruns->getRunEvents()) {
//		int runno = run.first;
		int nevents = run.second;
		g4uim->ApplyCommand("/run/beamOn " + to_string(nevents));
		
	}
}

int getNumberOfThreads(GOptions* gopt)
{
	int useThreads = gopt->getOption("nthreads").getIntValue();
	int allThreads = G4Threading::G4GetNumberOfCores();
	if(useThreads == 0) useThreads = allThreads;
	
	// global log screen
	cout << " % G4MTRunManager: using " << useThreads << " threads out of "  << allThreads << " available." << endl;

	return useThreads;
}

	
void initGemcG4RunManager(G4MTRunManager *grm)
{
	G4UImanager *g4uim   = G4UImanager::GetUIpointer();
	g4uim->ApplyCommand("/control/cout/setCoutFile thread.log");
	grm->Initialize();
}




