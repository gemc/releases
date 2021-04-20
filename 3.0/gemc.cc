/// \file gemc.cc
/// Defines the gemc main( int argc, char **argv )
/// \author \n &copy; Maurizio Ungaro
/// \author e-mail: ungaro@jlab.org\n\n\n
///
/// \mainpage
/// \htmlonly <center><img src="gemc_logo.gif" width="230"></center>\endhtmlonly
/// \section overview Overview
/// gemc (<b>GE</b>ant4 <b>M</b>onte<b>C</b>arlo) GEMC is a C++ framework
/// based on <a href="http://geant4.web.cern.ch/geant4/"> Geant4 </a>
/// Libraries to simulate the passage of particles through matter.\n
/// The simulation parameters are external to the software:
/// Geometry, Materials, Fields, Banks definitions are stored in
/// external databases in various format and are loaded at run
/// time using factory methods.\n
/// \n\n
/// \author \n &copy; Maurizio Ungaro
/// \author e-mail: ungaro@jlab.org\n\n\n

// c++
#include <string>
using namespace std;

// mlibrary
#include "gsplash.h"
#include "g4display.h"
#include "gdynamic.h"
#include "gruns.h"

// gemc
#include "utilities.h"
#include "gui.h"
#include "gActionInitialization.h"
#include "gLog.h"

// geant4
#include "G4UImanager.hh"
#include "G4VisExecutive.hh"
#include "G4UIQt.hh"
#include "G4MTRunManager.hh"
#include "G4Version.hh"
#include "G4StepLimiterPhysics.hh"

// PRAGMA TODO: needs gphysics so remove this one
#include "QGS_BIC.hh"


// PRAGMA TODO: gopts must be shared ptr so it can be used in the local threads

int main(int argc, char* argv[])
{

	// init splash screen
	// message is streamed always
	// if interactive session message is also streamd on splash screen
	GSplash gsplash(gopts, gui);
	gsplash.message(string(GEMCLOGMSGITEM) + " Initializing GEMC " + string(GEMC_VERSION) + ", Geant4 " + G4Version );

	G4UImanager* UIM = G4UImanager::GetUIpointer();
	UIM->SetCoutDestination(new GSession);

	// init geant4 run manager with number of threads coming from options
	G4MTRunManager *g4MTRunManager = new G4MTRunManager;
	g4MTRunManager->SetNumberOfThreads(getNumberOfThreads(gopts));

	// instantiating pointer to global digitization map
	map<string, GDynamic*> *globalDigitization = new map<string, GDynamic*>;

	// building detector
	// this is global, changed at main scope
	GDetectorConstruction *gDetectorGlobal = new GDetectorConstruction(gopts, globalDigitization);
	g4MTRunManager->SetUserInitialization(gDetectorGlobal);
	
	// g4MTRunManager->SetUserInitialization(new QGS_BIC());
	auto physicsList = new QGS_BIC;
	physicsList->RegisterPhysics(new G4StepLimiterPhysics());
	g4MTRunManager->SetUserInitialization(physicsList);
	
	// action
    // this also register the GActionInitialization and initialize the geant4 kernel
	g4MTRunManager->SetUserInitialization(new GActionInitialization(gopts, globalDigitization));

	
	// this calls Construct in GDetectorConstruction
	// which in turns builds gsetup, g4setup and, in each thread, the sensitive detectors
	initGemcG4RunManager(g4MTRunManager, gopts);

	// loading plugins must be done after GDetectorConstruction::Construct
	// - this includes digitization routines, constants
	// - global
	// - used thread-locally by digitization
	loadGPlugins(gopts, gDetectorGlobal->getSensitiveVolumes(), globalDigitization);
	
	// init gruns. Default run number if no configuration file specified
	GRuns *gruns = new GRuns(gopts, globalDigitization);

	
	// initialize gemc gui
	if(gui) {
		gsplash.message("Starting GUI");
		qApp->processEvents();

		// passing executable to retrieve full path
		GemcGUI gemcGui(argv[0], gopts, gruns);

		// PRAGMA TODO: use option g4view to set the position
		gemcGui.move(10, 10);
		gemcGui.show();

		gsplash.finish(&gemcGui);


		// initializing vis manager and qt session
		G4VisManager *visManager = new G4VisExecutive();
		visManager->Initialize();

		// intializing G4UIQt session
		G4UIsession *session = new G4UIQt(1, argv);

		// opening the g4Display GUI
		G4Display *g4Display = new G4Display(gopts);

		// PRAGMA TODO: these two calls (and maybe others?) should be in a separate function?
		applyInitialUIManagerCommands(gopts);
		
		qApp->exec();
		delete visManager;
		delete session;
		delete g4Display;
	} else {
		applyInitialUIManagerCommands(gopts);
		gruns->processEvents();
	}
	
	// alla prossima!
	delete g4MTRunManager;
	delete gopts;
	cout << GEMCLOGMSGITEM << " Simulation completed, arrivederci! " << endl << endl;
	return 1;
}


