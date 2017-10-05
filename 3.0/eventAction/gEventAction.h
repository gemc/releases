#ifndef GEventAction_H
#define GEventAction_H 1

// geant4
#include "G4UserEventAction.hh"

class GEventAction : public G4UserEventAction
{
public:
	GEventAction();
	virtual ~GEventAction();
	
	virtual void BeginOfEventAction(const G4Event*);
	virtual void EndOfEventAction(const G4Event*);

};


#endif
