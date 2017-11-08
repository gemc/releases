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
	G4GRun(GOptions* gopt, map<string, GDynamic*> *gDigitization, map<string, GMedia*> *gmedia);
	virtual ~G4GRun();
	virtual void RecordEvent(const G4Event*);
	virtual void Merge(const G4Run*);
	
	
private:
	// digitization map, loaded in main(), passed here
	map<string, GDynamic*> *gDigitizationGlobal;
	
	// output factories map, loaded in GActionInitialization constructor and passed here
	map<string, GMedia*> *gmediaFactory;

	// vector of events data in the local run
	vector<GEventData*> *runData;
	
private:
	GDynamic *getDigitizationForHitCollection(string name);

};


#endif
