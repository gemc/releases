#include "gEventAction.h"

// geant4
#include "G4EventManager.hh"


GEventAction::GEventAction(GOptions* gopt) : G4UserEventAction()
{
	verbosity = gopt->getInt("eventv");
}

GEventAction::~GEventAction()
{}

void GEventAction::BeginOfEventAction(const G4Event* event)
{
    printEventStatsBegin(event);
}

void GEventAction::EndOfEventAction(const G4Event* event)
{
    
    printEventStatsEnd(event);

}

