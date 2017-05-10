#ifndef GRUNACTION_H
#define GRUNACTION_H 1

#include "G4UserRunAction.hh"

class GRunAction : public G4UserRunAction
{
	public:
	// constructor and destructor
	GRunAction();
	virtual ~GRunAction();

	public:
	// virtual method from G4UserRunAction.
	virtual G4Run* GenerateRun();
	virtual void BeginOfRunAction(const G4Run*);
	virtual void EndOfRunAction(const G4Run*);

};




#endif
