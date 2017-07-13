// gemc
#include "gSensitiveDetector.h"



/*! \fn map<string, GOption> G4Setup::defineOptions()

 \return defines G4Setup specific options

 */
map<string, GOption> GSensitiveDetector::defineOptions()
{
	map<string, GOption> optionsMap;

	optionsMap["gsensitivityv"] = GOption("Sensitivity Verbosity", GVERBOSITY_SILENT, "verbosity");
	optionsMap["gsensitivityv"].addHelp("Possible values:\n");
	optionsMap["gsensitivityv"].addHelp(GVERBOSITY_SILENT_D);
	optionsMap["gsensitivityv"].addHelp(GVERBOSITY_SUMMARY_D);
	optionsMap["gsensitivityv"].addHelp(GVERBOSITY_DETAILS_D);
	optionsMap["gsensitivityv"].addHelp(GVERBOSITY_ALL_D);

	return optionsMap;
}


