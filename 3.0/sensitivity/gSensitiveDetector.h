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

	virtual void Initialize(G4HCofThisEvent* g4hc);                            ///< Beginning of sensitive Hit
	virtual G4bool ProcessHits(G4Step* thisStep, G4TouchableHistory* g4th);    ///< Process Step
	virtual void EndOfEvent(G4HCofThisEvent* g4hc);                            ///< End of sensitive Hit

private:
	int verbosity;
	set<GTouchable> touchableSet;

	// by default the touchable is not changed
	// this function is loaded by plugin methods
	virtual vector<GTouchable*> processTouchable(GTouchable *gTouchID, G4Step* thisStep) {return { gTouchID } ;}


public:
	// GSensitiveDetector options - defined in utilities.cc
	static map<string, GOption> defineOptions();

};

#endif
