#ifndef GDETECTORCONSTRUCTION_H
#define GDETECTORCONSTRUCTION_H 1

// gemc
#include "gSensitiveDetector.h"
#include "gLog.h"

// mlibrary
#include "gsystem.h"
#include "goptions.h"
#include "g4volume.h"

// geant4
#include "G4VUserDetectorConstruction.hh"

class GDetectorConstruction : public G4VUserDetectorConstruction, public GFlowMessage
{
public:
	// constructor and destructor.
	GDetectorConstruction(GOptions* opt);
	virtual ~GDetectorConstruction();
	
public:
	// virtual method from G4VUserDetectorConstruction.
	virtual G4VPhysicalVolume* Construct();
	virtual void ConstructSDandField();

	map<string, GSensitiveDetector*> getSensitiveDetectorMap() {return allSensitiveDetectors;}
	
private:
	GOptions* gopt;
	GSetup *gsetup;
	G4Setup *g4setup;
	map<string, GSensitiveDetector*> allSensitiveDetectors;

};


#endif
