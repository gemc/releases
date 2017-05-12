// gemc
#include "GDetectorConstruction.h"

// geant4
#include "G4NistManager.hh"
#include "G4Material.hh"
#include "G4Box.hh"
#include "G4LogicalVolume.hh"
#include "G4PVPlacement.hh"
#include "G4SystemOfUnits.hh"


GDetectorConstruction::GDetectorConstruction() : G4VUserDetectorConstruction()
{
	
}

GDetectorConstruction::~GDetectorConstruction() {}


G4VPhysicalVolume* GDetectorConstruction::Construct()
{

	G4cout << " Constructing world volume " << G4endl;

	G4ThreeVector worldSize = G4ThreeVector(200*cm, 200*cm, 200*cm);
	G4NistManager* NISTman = G4NistManager::Instance();
	G4Material* air  = NISTman->FindOrBuildMaterial("G4_AIR");
 
	// temp world to test MT
	G4Box * solidWorld = new G4Box("world", worldSize.x()/2., worldSize.y()/2., worldSize.z()/2.);
	G4LogicalVolume * logicWorld = new G4LogicalVolume(solidWorld, air, "World", 0, 0, 0);
	
	//
	//  Must place the World Physical volume unrotated at (0,0,0).
	G4VPhysicalVolume * physiWorld
	= new G4PVPlacement(0,               // no rotation
						G4ThreeVector(), // at (0,0,0)
						logicWorld,      // its logical volume
						"World",         // its name
						0,               // its mother  volume
						false,           // no boolean operations
						0);              // copy number
	

	return physiWorld;
}



void GDetectorConstruction::ConstructSDandField()
{
	G4cout << " Inside SDandField" << G4endl;
}
