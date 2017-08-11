// gemc
#include "gSensitiveDetector.h"

// mlibrary
#include "gstring.h"
using namespace gstring;

// this is thread-local
GSensitiveDetector::GSensitiveDetector(string name, GOptions* gopt, GVolume *thisGV) : G4VSensitiveDetector(name)
{
	verbosity = gopt->getInt("gsensitivityv");
	string filename = getFilenameFromFilename(name);
	string fpath    = getPathFromFilename(name) + "/plugin/";
	string plugin   = fpath + filename;

	if(verbosity > GVERBOSITY_SUMMARY) {
		G4cout << " Instantiating GSensitive Detector " << filename << " from plugin: " << plugin << G4endl;
	}
	
	
	
	// need to use w/o verbosity because of multithreading
	// PRAGMA TODO: fix this when it is fixed in the loader
	GManager manager(0);
	//GManager manager(verbosity);
	manager.registerDL(plugin);
	digitization = manager.LoadObjectFromLibrary<GDynamic>(plugin);

	// PRAGMA TODO: need to load the sensitive infos like timwindow and thresholds
}

void GSensitiveDetector::Initialize(G4HCofThisEvent* g4hc)
{
	// PRAGMA TODO: if a plugin function is not defined, then this should revert to the base class?
	// instead of crashing
	if(digitization)
	digitization->loadConstants(1, "original");

}

G4bool GSensitiveDetector::ProcessHits(G4Step* thisStep, G4TouchableHistory* g4th)
{
	double depe = thisStep->GetTotalEnergyDeposit();
	if(verbosity == GVERBOSITY_ALL) {
		G4cout << " Energy deposited this step: " << depe << G4endl;
	}
	
	
	return true;
}

void GSensitiveDetector::EndOfEvent(G4HCofThisEvent* g4hc)
{

}





