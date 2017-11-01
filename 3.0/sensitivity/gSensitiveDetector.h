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
#include "ghit.h"

// c++
#include <vector>
using namespace std;


class GSensitiveDetector : public G4VSensitiveDetector, public GFlowMessage
{
public:
	GSensitiveDetector(string name, GOptions* gopt, map<string, GDynamic*> *gDigiGlobal);

	// geant4 methods
	virtual void Initialize(G4HCofThisEvent* g4hc);                            ///< Beginning of sensitive Hit
	virtual G4bool ProcessHits(G4Step* thisStep, G4TouchableHistory* g4th);    ///< Process Step
	virtual void EndOfEvent(G4HCofThisEvent* g4hc);                            ///< End of sensitive Hit

	// register GTouchable in GDetectorConstruction::ConstructSDandField()
	void registerGVolumeTouchable(string name, GTouchable* gt);
	
private:
	int verbosity;

	// the GSensitiveDetector is built before the digitization, so we need
	// a pointer to global digitization map so we can pick gDigiLocal at initialization
	// it will be loaded later with the plugins
	map<string, GDynamic*> *gDigitizationGlobal;
	// gDigiLocal is thread local, picked form gDigitizationGlobal
	GDynamic *gDigiLocal;

	// map of touchable associated with each volume registered with the sensitive detector
	// this map is used to retrieve the touchable from the volume during processHit.
	map<string, GTouchable*> gTouchableMap;

	// a touchable has been hit if it's present in the set
	// the set is reset each event
	set<GTouchable*> touchableSet;
	
	// GHit collection
	GHitsCollection *ghitCollection;
	
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
	
public:
	// GSensitiveDetector options - defined in utilities.cc
	static map<string, GOption> defineOptions();
};

#endif
