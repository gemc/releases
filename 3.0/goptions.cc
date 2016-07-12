/// \file options.cc
/// Defines the gemc options

// options
#include "options.h"


map<string, GOption> defineOptions()
{
	map<string, GOption> optionsMap;


	// GUI options
	optionsMap["geometry"]      = GOption("Window Geometry", "1400x1200", "gui");

	optionsMap["splashPic"] = GOption("Splash Screen Picture", "GEMC gemcArchitecture.png", "gui");
	optionsMap["splashPic"].addHelp("The arguments are:\n");
	optionsMap["splashPic"].addHelp("1. env. variable location of the picture file\n");
	optionsMap["splashPic"].addHelp("2. picture file\n");

	optionsMap["gui"] = GOption("Use the QT interface", 1, "gui");
	optionsMap["gui"].addHelp("Possible choices are:\n");
	optionsMap["gui"].addHelp("0: run the program in batch mode\n");
	optionsMap["gui"].addHelp("1. run the program in interactive mode\n");






	// Log options
	optionsMap["header"] = GOption("Message to display on (splash)screen", " > ", "log");



	return optionsMap;
}
