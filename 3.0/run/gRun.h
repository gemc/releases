#ifndef GRUN_H
#define GRUN_H 1

// geant4
#include "G4Run.hh"


class GRun : public G4Run
{
	public:
	GRun();
	virtual ~GRun();
	virtual void RecordEvent(const G4Event*);
	virtual void Merge(const G4Run*);
};


#endif
