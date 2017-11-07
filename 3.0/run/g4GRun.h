#ifndef G4GRUN_H
#define G4GRUN_H 1

// geant4
#include "G4Run.hh"

// gemc
#include "gLog.h"

// mlibrary
#include "goptions.h"
#include "gdynamic.h"
#include "gdata.h"
#include "gmedia.h"

// In Geant4 a run consists of a sequence of events.
// A run is represented by a G4Run class object. A run starts with BeamOn() method of G4RunManager.
// G4RunManager creates this class
class G4GRun : public G4Run, public GFlowMessage
{
public:
	G4GRun(GOptions* gopt, map<string, GDynamic*> *gDigitization);
	virtual ~G4GRun();
	virtual void RecordEvent(const G4Event*);
	virtual void Merge(const G4Run*);
	
	
private:
	map<string, GDynamic*> *gDigitizationGlobal;
	
	// vector of events data in the local run
	vector<GEventData*> *runData;
	
	// output factories
	map<string, GMedia*> gmediaFactory;

private:
	GDynamic *getDigitizationForHitCollection(string name);

};


#endif
