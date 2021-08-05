
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

	

	

	// loading plugins must be done after GDetectorConstruction::Construct
	// - this includes digitization routines, constants
	// - global
	// - used thread-locally by digitization
	loadGPlugins(gopts, gDetectorGlobal->getSensitiveVolumes(), globalDigitization);
	
	// init gruns. Default run number if no configuration file specified
	// this is the weighted runs, not g4run
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


