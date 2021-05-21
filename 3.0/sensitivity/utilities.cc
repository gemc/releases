// gemc
#include "gSensitiveDetector.h"

/*! \fn map<string, GOption> GSensitiveDetector::defineOptions()

 \return defines GSensitiveDetector specific options

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

//
//// check if a touchable already exists in the event
//// by checking if it is present in the set. If not, add it.
//bool GSensitiveDetector::isThisANewTouchable(GTouchable* thisTouchable)
//{
//	// not found. Insert it and return false
//	if(touchableSet.find(thisTouchable) == touchableSet.end()) {
//		touchableSet.insert(thisTouchable);
//		return true;
//	}
//	
//	return false;
//}
