// gemc
#include "gSensitiveDetector.h"

// this is thread-local
bool GSensitiveDetector::skipProcessHit(double energy)
{

	// flowMessage("Processing Hits in GSensitiveDetector " + GetName());

	// PRAGMA TODO: call digi skipProcess?
	// in that case, need more argument, like trk
	
	return false;
}
