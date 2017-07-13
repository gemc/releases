#ifndef  GSENSITIVEDETECTOR_H
#define  GSENSITIVEDETECTOR_H 1

// geant4
#include "G4VSensitiveDetector.hh"

// mlibrary
#include "goptions.h"

// gemc
#include "gTouchable.h"

// c++
#include <vector>
using namespace std;

class GSensitiveDetector : public G4VSensitiveDetector
{
public:
	GSensitiveDetector(string name, GOptions* gopt);

	// geant4 methods
	virtual void Initialize(G4HCofThisEvent* g4hc);                            ///< Beginning of sensitive Hit
	virtual G4bool ProcessHits(G4Step* thisStep, G4TouchableHistory* g4th);    ///< Process Step
	virtual void EndOfEvent(G4HCofThisEvent* g4hc);                            ///< End of sensitive Hit

private:
	int verbosity;

	// map of touchable associated with each volume registered with the sensitive detector
	// it is stored here so it can be retrieved

	// a touchable has been hit if it's present in the set
	// the set is reset each event
	set<GTouchable*> touchableSet;

private:
	// by default the touchable is not changed
	// this function is loaded by plugin methods
	virtual vector<GTouchable*> processTouchable(GTouchable *gTouchID, G4Step* thisStep) {return { gTouchID } ;}

	// skip ProcessHit
	bool skipProcessHit(double energy);

public:
	// GSensitiveDetector options - defined in utilities.cc
	static map<string, GOption> defineOptions();

};

#endif
