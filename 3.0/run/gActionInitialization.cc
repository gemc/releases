// gemc
#include "gPrimaryGeneratorAction.h"
#include "gActionInitialization.h"
#include "gRunAction.h"
#include "gEventAction.h"


// c++
#include <iostream>
using namespace std;

GActionInitialization::GActionInitialization(GOptions* opt, map<string, GDynamic*> *gDigitization) :
GFlowMessage(opt, "GActionInitialization"),
gopt(opt),
gDigitizationGlobal(gDigitization)
{
	flowMessage("GActionInitialization Constructor");
}

GActionInitialization::~GActionInitialization()
{
}

void GActionInitialization::Build() const
{
	flowMessage("Thread Build");

	SetUserAction(new GRunAction(gopt, gDigitizationGlobal));
	SetUserAction(new GPrimaryGeneratorAction);
	SetUserAction(new GEventAction(gopt));
}

void GActionInitialization::BuildForMaster() const
{
	flowMessage("Master Build");
	SetUserAction(new GRunAction(gopt, gDigitizationGlobal));
}


