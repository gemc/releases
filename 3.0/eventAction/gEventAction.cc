#include "gEventAction.h"

// geant4
#include "G4EventManager.hh"


GEventAction::GEventAction() : G4UserEventAction()
{
	
}

GEventAction::~GEventAction()
{}

void GEventAction::BeginOfEventAction(const G4Event*)
{
}

void GEventAction::EndOfEventAction(const G4Event* event)
{
//	G4EventManager::GetEventManager()->KeepTheCurrentEvent();
}

