// gemc
#include "gSensitiveDetector.h"



/*! \fn map<string, GOption> G4Setup::defineOptions()

 \return defines G4Setup specific options

 */
map<string, GOption> GSensitiveDetector::defineOptions()
{
	map<string, GOption> optionsMap;

	optionsMap["gsensitivityv"] = GOption("Sensitivity Verbosity", 0, "verbosity");
	optionsMap["gsensitivityv"].addHelp("Possible values:\n");
	optionsMap["gsensitivityv"].addHelp(" - 0: silent\n");
	optionsMap["gsensitivityv"].addHelp(" - 1: summary information\n");
	optionsMap["gsensitivityv"].addHelp(" - 2: details\n");
	optionsMap["gsensitivityv"].addHelp(" - 3: verbose details\n");

	return optionsMap;
}


