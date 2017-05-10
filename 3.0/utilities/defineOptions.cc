// gemc utilities
#include "utilities.h"

// mlibrary options constructors
#include "gsplash.h"

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


	// mlibrary GSplash default option
	optionsMap += GSplash::defineOptions();

	return optionsMap;
}

