#ifndef  GSENSITIVEDETECTOR_H
#define  GSENSITIVEDETECTOR_H 1

// gemc
#include "gLog.h"

// geant4
#include "G4VSensitiveDetector.hh"

// mlibrary
#include "goptions.h"
#include "gvolume.h"
#include "gtouchable.h"
#include "gdynamic.h"

// c++
#include <vector>
using namespace std;

// PRAGMA TODO:
// should we have a shared_pointer of all the GSensitiveDetector inside eventAction
// so we can call loadConstants for each run if necessary?
// Or inside RunAction?
// How do I pass run# from grun to runAction or eventAction

class GSensitiveDetector : public G4VSensitiveDetector, public GFlowMessage
{
public:
	GSensitiveDetector(string name, GOptions* gopt, GVolume *thisVolume);

	// geant4 methods
	virtual void Initialize(G4HCofThisEvent* g4hc);                            ///< Beginning of sensitive Hit
	virtual G4bool ProcessHits(G4Step* thisStep, G4TouchableHistory* g4th);    ///< Process Step
	virtual void EndOfEvent(G4HCofThisEvent* g4hc);                            ///< End of sensitive Hit

private:
	int verbosity;

	// defines the timewindow of the touchable if it's a readout
	double timeWindow;

	// map of touchable associated with each volume registered with the sensitive detector
	// it is stored here so it can be retrieved

	// a touchable has been hit if it's present in the set
	// the set is reset each event
	set<GTouchable*> touchableSet;


	// the digitization routines and constants
	// are thread local
	GDynamic *gDigiLocal;

private:
	// skip ProcessHit
	// decides if the hit should be processed or not
	bool skipProcessHit(double energy);
	bool loadDigitizationPlugin();
	
public:
	// GSensitiveDetector options - defined in utilities.cc
	static map<string, GOption> defineOptions();

};

#endif
