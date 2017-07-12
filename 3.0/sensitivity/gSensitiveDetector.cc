// gemc
#include "gSensitiveDetector.h"


GSensitiveDetector::GSensitiveDetector(string name, GOptions* gopt) : G4VSensitiveDetector(name)
{
	
}

void GSensitiveDetector::Initialize(G4HCofThisEvent* g4hc)
{

}

G4bool GSensitiveDetector::ProcessHits(G4Step* thisStep, G4TouchableHistory* g4th)
{
	return true;
}

void GSensitiveDetector::EndOfEvent(G4HCofThisEvent* g4hc)
{

}
