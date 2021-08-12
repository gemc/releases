
// geant4
#include "G4MTRunManager.hh"
#include "G4Version.hh"
#include "G4StepLimiterPhysics.hh"

// PRAGMA TODO: needs gphysics so remove this one
#include "QGS_BIC.hh"


// PRAGMA TODO: gopts must be shared ptr so it can be used in the local threads

int main(int argc, char* argv[])
{

	

	

	// loading plugins must be done after GDetectorConstruction::Construct
	// - this includes digitization routines, constants
	// - global
	// - used thread-locally by digitization
	loadGPlugins(gopts, gDetectorGlobal->getSensitiveVolumes(), globalDigitization);
	

	

	
	// alla prossima!
	delete g4MTRunManager;
	delete gopts;
	return 1;
}


