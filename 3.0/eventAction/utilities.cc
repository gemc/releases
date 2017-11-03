// gemc
#include "gEventAction.h"

/*! \fn map<string, GOption> G4Setup::defineOptions()
 
 \return defines G4Setup specific options
 
 */
map<string, GOption> GEventAction::defineOptions()
{
    map<string, GOption> optionsMap;
    
    optionsMap["eventv"] = GOption("Sensitivity Verbosity", GVERBOSITY_SILENT, "verbosity");
    optionsMap["eventv"].addHelp("Possible values:\n");
    optionsMap["eventv"].addHelp(GVERBOSITY_SILENT_D);
    optionsMap["eventv"].addHelp(GVERBOSITY_SUMMARY_D);
    optionsMap["eventv"].addHelp(GVERBOSITY_DETAILS_D);
    optionsMap["eventv"].addHelp(GVERBOSITY_ALL_D);
   
    optionsMap["logEveryNEvents"] = GOption("Print Event Statistics every N events", 100, "verbosity");

    return optionsMap;
}
