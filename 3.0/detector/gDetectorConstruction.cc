// gemc
#include "gDetectorConstruction.h"

// mlibrary
#include "gsystem.h"
#include "g4volume.h"

GDetectorConstruction::GDetectorConstruction(GOptions* opt) : G4VUserDetectorConstruction(), gopt(opt)
{
	G4cout << " V Constructing world volume " << G4endl;
	

}

GDetectorConstruction::~GDetectorConstruction() {}


G4VPhysicalVolume* GDetectorConstruction::Construct()
{


	G4cout << " Constructing gemc world " << G4endl;

	// PRAGMA: TODO
	// is this needed at this level,
	// or it could be inside g4setup
	// or it has to be in gemc main then assigned later?
	// well seee
	GSetup *gsetup = new GSetup(gopt);

	G4cout << " Constructing geant4 world " << G4endl;

	// PRAGMA: TODO
	// is this needed at this level,
	// or it has to be in gemc main then assigned later?
	// can this be deleted
	// well seee
	G4Setup *g4setup = new G4Setup(gsetup, gopt);



	return g4setup->getPhysical("world");
}



void GDetectorConstruction::ConstructSDandField()
{
	G4cout << " Inside SDandField" << G4endl;
}
