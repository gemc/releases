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

// gemc
#include "utilities.h"
#include "gui.h"
#include "gActionInitialization.h"
#include "gLog.h"

// geant4
#include "G4UImanager.hh"
#include "G4VisExecutive.hh"
#include "G4UIQt.hh"


int main(int argc, char* argv[])
{
	// init option map
	// the option are loaded in utilities/defineOptions.cc
	// they include the gemc core options and any frameworks options
	GOptions *gopts = new GOptions(argc, argv, defineOptions(), 1);

	// init qt app
	// createQtApplication defined in utilities
	// it returns a QCore application either in interactive or batch mode
	bool gui = gopts->getBool("gui");
	createQtApplication(argc, argv, gui);

	// init splash screen
	// message is streamed always
	// if interactive session message is also streamd on splash screen
	GSplash gsplash(gopts, gui);
	gsplash.message(" % Initializing GEMC " + string(GEMC_VERSION));

	G4UImanager* UIM = G4UImanager::GetUIpointer();
	UIM->SetCoutDestination(new GSession);

	// geant4 run manager with number of threads coming from options
	// this also register the GActionInitialization and initialize the geant4 kernel
	int nthreads = gopts->getOption("nthreads").getIntValue();
	G4MTRunManager *runManager = gRunManager(nthreads, gopts);

	// initialize gemc gui
	if(gui) {
		gsplash.message("Starting GUI");
		qApp->processEvents();

		// passing executable to retrieve full path
		GemcGUI gemcGui(argv[0], gopts);

		// PRAGMA TODO: use option g4view to set the position
		gemcGui.move(10, 10);
		gemcGui.show();

		gsplash.finish(&gemcGui);


		// initializing vis manager and qt session
		G4VisManager *visManager = new G4VisExecutive();
		visManager->Initialize();

		// intializing G4UIQt session
		G4UIsession *session = new G4UIQt(1, argv);

		// now opening the g4 display
		G4Display *g4Display = new G4Display(gopts);

		// PRAGMA TODO: these two calls (and maybe others?) should be in a separate function?
		applyInitialUIManagerCommands(gopts);
		gBeamOn(gopts);

		qApp->exec();
		delete visManager;
		delete session;
		delete g4Display;
	} else {
		applyInitialUIManagerCommands(gopts);
		gBeamOn(gopts);
	}
	
	// alla prossima!
	cout << " % Simulation completed, arrivederci! " << endl;
	delete runManager;
	delete gopts;
	return 1;
}


