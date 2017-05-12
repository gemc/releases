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

// this gemc version
const string GEMC_VERSION = "gemc 3.0";

// mlibrary
#include "gsplash.h"

// gemc
#include "utilities.h"
#include "Gui.h"
#include "GActionInitialization.h"
#include "GLog.h"

// geant4
#include "G4UImanager.hh"


int main(int argc, char* argv[])
{
	// init option map
	// the option are loaded in utilities/defineOptions.cc
	// they include the gemc core options and any frameworks options
	GOptions *gopts = new GOptions(argc, argv, defineOptions(), 1);
	bool gui = gopts->getOption("gui").getBoolValue();

	// init qt app
	// function defined in utilities, returns a QCore application either in interactive or batch mode
	createQtApplication(argc, argv, gui);

	// init splash screen
	GSplash gsplash(gopts, gui);
	gsplash.message("Initializing GEant4 MonteCarlo version " + string(GEMC_VERSION));

	G4UImanager* UI = G4UImanager::GetUIpointer();
	GSession *gSession = new GSession;
	UI->SetCoutDestination(gSession);

	// geant4 run manager with number of threads coming from options
	// this also register the GActionInitialization and initialize the geant4 kernel
	G4MTRunManager *runManager = gRunManager(gopts->getOption("nthreads").getIntValue());
	
	

	// temp, for batch mode
	// get the pointer to the User Interface manager
	G4UImanager * pUI = G4UImanager::GetUIpointer();

//	pUI->ApplyCommand("/process/verbose 0");
//	pUI->ApplyCommand("/tracking/verbose 0");
//	pUI->ApplyCommand("/run/verbose 0");
//	pUI->ApplyCommand("/run/particle/verbose 0");
//	pUI->ApplyCommand("/process/setVerbose 0 all");
//	pUI->ApplyCommand("/material/verbose 0");

	pUI->ApplyCommand("/control/cout/prefixString  asd");
	pUI->ApplyCommand("/run/beamOn 10000");

	

	// initialize gemc gui
	if(gui) {
		gsplash.message("Starting GUI");
		qApp->processEvents();

		// passing executable to retrieve full path
		GemcGUI gemcGui(argv[0]);
		gemcGui.show();

		gsplash.finish(&gemcGui);
		
		return qApp->exec();
	}

	delete runManager;
	delete gSession;
	return 1;
}


