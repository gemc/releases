#ifndef  GSENSITIVEDETECTOR_H
#define  GSENSITIVEDETECTOR_H 1

// mlibrary
#include "goptions.h"
#include "gvolume.h"
#include "gtouchable.h"
#include "gdynamic.h"
#include "ghit.h"

// c++
#include <vector>
using namespace std;


class GSensitiveDetector : public G4VSensitiveDetector, public GFlowMessage
{

	
private:



	// a touchable has been hit if it's present in the set
	// the set is reset each event
	set<GTouchable*> touchableSet;
	
	// GHit collection
	GHitsCollection *gHitsCollection;
	
private:
	// skip ProcessHit decides if the hit should be processed or not
	bool skipProcessHit(double energy);
	
	// retrieve volume touchable from map in ProcessHit
	// needs geant4Touchable to get the volume name
	GTouchable* getGTouchable(const G4Step* thisStep);
	
	// check if touchable exist in the set
	// defined in utilities.cc
	bool isThisANewTouchable(GTouchable* thisTouchable);
	
	// private var here set at Initialize
	bitset<NHITBITS> gHitBitSet;
    
    // retrieve hit that matches an identifier
	
public:
	// GSensitiveDetector options - defined in utilities.cc
	static map<string, GOption> defineOptions();
};

#endif
