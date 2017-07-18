#ifndef GACTIONINITIALIZATION_H
#define GACTIONINITIALIZATION_H 1

// geant4
#include "G4VUserActionInitialization.hh"

// mlibrary
#include "goptions.h"

// G4VUserActionInitialization is a newly introduced class for the user to instantiate
// user action classes (both mandatory and optional).
// All the user action classes are thread-local and instantiated only for worker treads,
// with the only exception of UserRunAction, which could be instantiated also for the master thread.
// G4VUserActionInitialization has two virtual method to be implemented, one is Build() and the other is BuildForMaster().
// Build() should be used for defining user action classes for worker threads as well as for the sequential mode.
// BuildForMaster() should be used for defining only the UserRunAction for the master thread.
// All user actions must be registered through SetUserAction() protected method defined in the G4VUserActionInitialization base class.

class GActionInitialization : public G4VUserActionInitialization
{
public:
	GActionInitialization(GOptions* gopt);
	virtual ~GActionInitialization();

	virtual void Build() const;
	virtual void BuildForMaster() const;

private:
	GOptions* gopt;

};

// geant4
#include "G4MTRunManager.hh"

// instantiates the geant4 MT run manager singleton
G4MTRunManager* gRunManager(int cores, GOptions* gopt);

#endif
