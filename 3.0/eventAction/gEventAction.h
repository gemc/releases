#ifndef GEVENTACTION_H
#define GEVENTACTION_H 1

// geant4
#include "G4UserEventAction.hh"

// mlibrary
#include "goptions.h"

class GEventAction : public G4UserEventAction
{
public:
	GEventAction(GOptions* gopt);
	virtual ~GEventAction();
	
	virtual void BeginOfEventAction(const G4Event* event);
	virtual void EndOfEventAction(const G4Event* event);

private:
    int verbosity;
    
private:
    // logs event statistics
    void printEventStatsBegin(const G4Event* event);
    void printEventStatsEnd(const G4Event* event);

public:
    // GEventAction options - defined in utilities.cc
    static map<string, GOption> defineOptions();

};


#endif
