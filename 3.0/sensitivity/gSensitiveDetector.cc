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
	string fpath    = getPathFromFilename(name);
	
	if(verbosity > GVERBOSITY_SUMMARY) {
		G4cout << " Instantiating GSensitive Detector " << filename << " " << name << " " << fpath << G4endl;
	}
	
	
	
	// need to use w/o verbosity because of multithreading
	GManager manager(0);
//	manager.registerDL(name);
	manager.registerDL("ctof");
//	digitization = shared_ptr<GDynamic>(manager.LoadObjectFromLibrary<GDynamic>("ctof"));
	digitization = manager.LoadObjectFromLibrary<GDynamic>("ctof");
	

	
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





