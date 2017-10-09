// gemc
#include "gDetectorConstruction.h"

// mlibrary
#include "g4volume.h"

GDetectorConstruction::GDetectorConstruction(GOptions* opt, map<string, GDynamic*> *gDigiGlobal) :
G4VUserDetectorConstruction(), GFlowMessage(opt, "GDetectorConstruction"), gopt(opt), gDigitizationGlobal(gDigiGlobal)
{
	// making this explicit in case of access before Construct()
	// (should never happen anyway)
	gsetup  = nullptr;
	g4setup = nullptr;
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
	// no need to do anything if we're in the main thread
	if (G4Threading::IsMasterThread() ) return;

	flowMessage("Inside SDandField");

	// building the sensitive detectors
	// this is thread local
	for(auto &s : gsetup->getSetup()) {
		for(auto &gv : s.second->getSytems()) {
			string sensitivity = gv.second->getSensitivity();
			// making sure the logical volume exists
			G4LogicalVolume *thisLV = g4setup->getLogical(gv.first);
			if(thisLV == nullptr) {
				G4cerr << " !!! Error: " << gv.first << " logical volume not build? This should never happen." << G4endl;
				exit(99);
			} else if(sensitivity != "no") {
				SetSensitiveDetector(gv.first, new GSensitiveDetector(sensitivity, gopt, gv.second, gDigitizationGlobal));
			}
		}
	}
}
