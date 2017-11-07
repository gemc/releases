// gemc
#include "utilities.h"
#include "gActionInitialization.h"
#include "g4GRun.h"

// Qt
#include <QtWidgets>

// geant4 headers
#include "G4UImanager.hh"

// mlibrary
#include "gruns.h"
#include "gstring.h"
using namespace gstring;

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
			cout << GEMCLOGMSGITEM << " Executing UIManager command \"" << c << "\"" << endl;
		}
		g4uim->ApplyCommand(c);
	}
}


// return number of cores from options. If 0 or none given,
// returns max number of available cores
int getNumberOfThreads(GOptions* gopt)
{
	int useThreads = gopt->getOption("nthreads").getIntValue();
	int allThreads = G4Threading::G4GetNumberOfCores();
	if(useThreads == 0) useThreads = allThreads;
	
	// global log screen
	cout << GEMCLOGMSGITEM << " G4MTRunManager: using " << useThreads << " threads out of "  << allThreads << " available."  << endl;
	
	return useThreads;
}

// initialize run manager
void initGemcG4RunManager(G4MTRunManager *grm, GOptions* gopt)
{
	int threadLog = gopt->getOption("threadLog").getIntValue();
	
	G4UImanager *g4uim   = G4UImanager::GetUIpointer();
	g4uim->ApplyCommand("/control/cout/setCoutFile gthread.log");
	g4uim->ApplyCommand("/control/cout/ignoreThreadsExcept " + to_string(threadLog));
	
	grm->Initialize();
}

// loads plugins from sensitive map <names, paths>
// returns number of loaded plugins
int loadGPlugins(GOptions* gopt, map<string, string> sensD, map<string, GDynamic*> *gDigiGlobal)
{
	int goodPlugins = 0;
	
	int verbosity = gopt->getInt("gemcv");
	GManager manager(verbosity);
	
	for(auto &p: sensD) {
		string pluginPath = getPathFromFilename(p.second) + "/plugin";
		
		string pluginName = pluginPath + "/" + p.first;
		
		manager.registerDL(pluginName);
		
		(*gDigiGlobal)[p.first] = manager.LoadObjectFromLibrary<GDynamic>(pluginName);
		
		// checkPlugin shoud return true
		if((*gDigiGlobal)[p.first]) {
			if((*gDigiGlobal)[p.first]->checkPlugin() == false) {
				cout <<  GWARNING  << " Warning: Plugin " << pluginName << " checkPlugin() returned false. Load failure, or did you forget to implement it?" << endl;
			} else {
				goodPlugins++;
			}
		} else {
			cout <<  GWARNING  << " Warning: Plugin " << pluginName << " could not be loaded." << endl;
		}
	}
	
	if(verbosity > GVERBOSITY_SILENT) {
		cout << GEMCLOGMSGITEM << " Number of plugin loaded: " << gDigiGlobal->size() << ", numbero of good plugins: " << goodPlugins << endl;
	}
	
	return goodPlugins;
}





