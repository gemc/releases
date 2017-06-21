// gemc
#include "GDetectorConstruction.h"

//// geant4
//#include "G4NistManager.hh"
//#include "G4Material.hh"
//#include "G4Box.hh"
//#include "G4LogicalVolume.hh"
//#include "G4PVPlacement.hh"
//#include "G4SystemOfUnits.hh"

// mlibrary
#include "gSystem.h"
#include "g4volume.h"

GDetectorConstruction::GDetectorConstruction(GOptions* opt) : G4VUserDetectorConstruction(), gopt(opt)
{
	G4cout << " V Constructing world volume " << G4endl;
	
	GSetup *setup = new GSetup(gopt);

	delete setup;

}

GDetectorConstruction::~GDetectorConstruction() {}


G4VPhysicalVolume* GDetectorConstruction::Construct()
{


	G4cout << " Constructing gemc world " << G4endl;

	GSetup *gsetup = new GSetup(gopt);

	G4cout << " Constructing geant4 world " << G4endl;

	G4Setup *g4setup = new G4Setup(gsetup, gopt);

	return g4setup->getG4Volume("world")->getPhysical();
}



void GDetectorConstruction::ConstructSDandField()
{
	G4cout << " Inside SDandField" << G4endl;
}
