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
	GDetectorConstruction(GOptions* opt, map<string, GDynamic*> *gDigiGlobal);
	virtual ~GDetectorConstruction();
	
public:
	// virtual method from G4VUserDetectorConstruction.
	virtual G4VPhysicalVolume* Construct();
	virtual void ConstructSDandField();
	
	map<string, string> getSensitiveVolumes() {
		if(gsetup != nullptr)
			return gsetup->getSensitiveVolumes();
		else
			return {};
	}
	
private:
	GOptions* gopt;
	GSetup *gsetup;
	G4Setup *g4setup;
	
	// the GSensitiveDetector is built before the digitization, so we need
	// a pointer to global digitization map, filled later, to pass to the local GSensitiveDetector
	map<string, GDynamic*> *gDigitizationGlobal;

};


#endif
