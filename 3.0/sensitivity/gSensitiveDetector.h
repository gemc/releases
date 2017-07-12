#ifndef  GSENSITIVEDETECTOR_H
#define  GSENSITIVEDETECTOR_H 1

// geant4
#include "G4VSensitiveDetector.hh"

// mlibrary
#include "goptions.h"

class GSensitiveDetector : public G4VSensitiveDetector
{
public:
	GSensitiveDetector(string name, GOptions* gopt);

	virtual void Initialize(G4HCofThisEvent* g4hc);                            ///< Beginning of sensitive Hit
	virtual G4bool ProcessHits(G4Step* thisStep, G4TouchableHistory* g4th);    ///< Process Step
	virtual void EndOfEvent(G4HCofThisEvent* g4hc);                            ///< End of sensitive Hit

private:

};

#endif
