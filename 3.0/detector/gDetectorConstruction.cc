// gemc
#include "gDetectorConstruction.h"

// mlibrary
#include "g4volume.h"

GDetectorConstruction::GDetectorConstruction(GOptions* opt) : G4VUserDetectorConstruction(), GFlowMessage(opt, "GDetectorConstruction"), gopt(opt)
{

}

GDetectorConstruction::~GDetectorConstruction() {}


G4VPhysicalVolume* GDetectorConstruction::Construct()
{
	flowMessage("Constructing gemc world");

	// loading gvolumes, material, system parameters
	gsetup = new GSetup(gopt);

	// builiding geant4 volumes
	g4setup = new G4Setup(gsetup, gopt);

	return g4setup->getPhysical("world");
}



void GDetectorConstruction::ConstructSDandField()
{
	flowMessage("Inside SDandField");

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
					// registering sensitive detector with its name, but passing the
					// path to the constructor so it can load the plugin
					// PRAGMA TODO: for windows it's "\" ?
					// PRAGMA TODO: no need to pass path since the plugin is loaded elsewhere
					string nameWithPath = s.second->getSystemPath()  + "/" + sensitivity;
					
					allSensitiveDetectors[sensitivity] = new GSensitiveDetector(nameWithPath, gopt, gv.second);
				}
				SetSensitiveDetector(gv.first, allSensitiveDetectors[sensitivity]);
			}
		}
	}
	
}
