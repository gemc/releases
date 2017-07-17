// gemc
#include "gDetectorConstruction.h"
#include "gSensitiveDetector.h"

// mlibrary
#include "g4volume.h"

GDetectorConstruction::GDetectorConstruction(GOptions* opt) : G4VUserDetectorConstruction(), gopt(opt)
{
	G4cout << " V Constructing world volume " << G4endl;
	

}

GDetectorConstruction::~GDetectorConstruction() {}


G4VPhysicalVolume* GDetectorConstruction::Construct()
{
	G4cout << " Constructing gemc world " << G4endl;

	// loading gvolumes, material, system parameters
	gsetup = new GSetup(gopt);

	G4cout << " Constructing geant4 world " << G4endl;

	// builiding geant4 volumes
	g4setup = new G4Setup(gsetup, gopt);


	return g4setup->getPhysical("world");
}



void GDetectorConstruction::ConstructSDandField()
{
	G4cout << " Inside SDandField" << G4endl;

	map<string, GSensitiveDetector*> allSensitiveDetectors;
	
	// building the sensitive detectors
	for(auto &s : gsetup->getSetup()) {
		for(auto &gv : s.second->getSytems()) {
			string sensitivity = gv.second->getSensitivity();
			G4LogicalVolume *thisLV = g4setup->getLogical(gv.first);
			if(thisLV == nullptr) {
				cerr << " !!! Error: " << gv.first << " logical volume not build? This should never happen." << endl;
				exit(99);
			} else if(sensitivity != "no") {
				if(allSensitiveDetectors.find(sensitivity) == allSensitiveDetectors.end()) {
					allSensitiveDetectors[sensitivity] = new GSensitiveDetector(sensitivity, gopt, gv.second);
				}
				SetSensitiveDetector(gv.first, allSensitiveDetectors[sensitivity]);
			}
		}
		
	}
	
}
