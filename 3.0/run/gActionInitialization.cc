// gemc
#include "gPrimaryGeneratorAction.h"
#include "gActionInitialization.h"
#include "gRunAction.h"
#include "gEventAction.h"

// mlibrary
#include "gfactory.h"
#include "gstring.h"
using namespace gstring;

// c++
#include <iostream>
using namespace std;

GActionInitialization::GActionInitialization(GOptions* opt, map<string, GDynamic*> *gDigitization) :
GFlowMessage(opt, "GActionInitialization"),
gopt(opt),
gDigitizationGlobal(gDigitization)
{
	flowMessage("GActionInitialization Constructor");
	gmediaFactory = new map<string, GMedia*>;
	
	int verbosity = gopt->getInt("gemcv");
	vector<string> requestedMedias = getStringVectorFromStringWithDelimiter(gopt->getString("output"), ",");
	
	if(requestedMedias.size() > 1) {
		
		GManager gOutputManager(verbosity);
		
		// first string is filename
		// the available plugins names are formatted as "xxxGMedia".
		for(unsigned f=1; f<requestedMedias.size(); f++) {
			string pluginName = requestedMedias[f] + "GMedia";
			// need path here
			gOutputManager.registerDL(pluginName);
			
			(*gmediaFactory)[requestedMedias[f]] = gOutputManager.LoadObjectFromLibrary<GMedia>(pluginName);
						
			// set file name, open the connection
			(*gmediaFactory)[requestedMedias[f]]->setOutputName(requestedMedias[0]);
		}
	}
}

GActionInitialization::~GActionInitialization()
{
	// close output connections
	for(auto gmf: (*gmediaFactory)) {
		gmf.second->closeConnection();
	}
}

void GActionInitialization::Build() const
{
	flowMessage("Thread Build");
	
	SetUserAction(new GRunAction(gopt, gDigitizationGlobal, gmediaFactory));
	SetUserAction(new GPrimaryGeneratorAction);
	SetUserAction(new GEventAction(gopt));
}

void GActionInitialization::BuildForMaster() const
{
	flowMessage("Master Build");
	SetUserAction(new GRunAction(gopt, gDigitizationGlobal, gmediaFactory));
}


