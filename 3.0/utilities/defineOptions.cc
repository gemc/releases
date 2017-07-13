// gemc utilities
#include "utilities.h"

// mlibrary options constructors
#include "gsplash.h"
#include "gsystem.h"
#include "g4display.h"
#include "g4volume.h"
#include "gSensitiveDetector.h"

// define all gemc options
map<string, GOption> defineOptions()
{
	map<string, GOption> optionsMap;

	// GUI options
	optionsMap["geometry"] = GOption("Window Geometry", "1400x1200", "gui");

	optionsMap["gui"] = GOption("Use the QT interface", 1, "gui");
	optionsMap["gui"].addHelp("Possible choices are:\n");
	optionsMap["gui"].addHelp("0: run the program in batch mode\n");
	optionsMap["gui"].addHelp("1. run the program in interactive qt mode\n");

	optionsMap["nthreads"] = GOption("Number of threads to use", 0, "control");
	optionsMap["nthreads"].addHelp("0: use all available threads (default)\n");

	optionsMap["g4command"] = GOption("Execute G4 command.", "no", "geant4", "true");
	optionsMap["g4command"].addHelp("Examples:\n");
	optionsMap["g4command"].addHelp("/vis/scene/add/axes 0 0 0 20 cm\n");
	optionsMap["g4command"].addHelp("This option can be repeated.\n");

	optionsMap["gemcv"] = GOption("Gemc general Verbosity", 0, "verbosity");
	optionsMap["gemcv"].addHelp("Possible values:\n");
	optionsMap["gemcv"].addHelp(GVERBOSITY_SILENT_D);
	optionsMap["gemcv"].addHelp(GVERBOSITY_SUMMARY_D);
	optionsMap["gemcv"].addHelp(GVERBOSITY_DETAILS_D);
	optionsMap["gemcv"].addHelp(GVERBOSITY_ALL_D);

	// mlibrary GSplash default option
	optionsMap += GSplash::defineOptions();
	optionsMap += GSetup::defineOptions();
	optionsMap += G4Setup::defineOptions();
	optionsMap += G4Display::defineOptions();
	optionsMap += GSensitiveDetector::defineOptions();

	return optionsMap;
}

