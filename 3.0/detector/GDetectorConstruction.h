#ifndef GDETECTORCONSTRUCTION_H
#define GDETECTORCONSTRUCTION_H 1

// options
#include "goptions.h"

// geant4
#include "G4VUserDetectorConstruction.hh"

class GDetectorConstruction : public G4VUserDetectorConstruction
{
public:
	// constructor and destructor.
	GDetectorConstruction();
	virtual ~GDetectorConstruction();
	
public:
	// virtual method from G4VUserDetectorConstruction.
	virtual G4VPhysicalVolume* Construct();
	virtual void ConstructSDandField();
};


#endif
