#ifndef GRUNACTION_H
#define GRUNACTION_H 1

// geant4
#include "G4UserRunAction.hh"

// gemc
#include "gLog.h"

// mlibrary
#include "goptions.h"
#include "gruns.h"

class GRunAction : public G4UserRunAction, public GFlowMessage
{
public:
	// constructor and destructor
	GRunAction(GOptions* gopt);
	virtual ~GRunAction();


private:
	// virtual method from G4UserRunAction.
	virtual G4Run* GenerateRun();
	virtual void BeginOfRunAction(const G4Run*);
	virtual void EndOfRunAction(const G4Run*);
	
	GOptions* gopt;
	
};




#endif
