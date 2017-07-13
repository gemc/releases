#ifndef  GHIT_H
#define  GHIT_H 1

// geant4
#include "G4VHit.hh"
#include "G4THitsCollection.hh"
#include "G4Types.hh"
#include "G4Colour.hh"
#include "G4Allocator.hh"

// gemc
#include "gTouchable.h"


enum gHitType {normal, noise, merged};

class GHit : public G4VHit
{

	GHit(GTouchable gt, gHitType ht, string cSchema);

	inline void* operator new(size_t);
	inline void  operator delete(void*);

	void Draw();


private:
	GTouchable touchableId;
	gHitType type;


	// only used if pVVisManager exist (interactive mode)
	string colorSchema;
	G4Colour aboveThreshold, belowThreshold, touching, noise, merged;

private:
	bool setColorSchema();

};


typedef G4THitsCollection<GHit> GHitCollection;


// MT definitions, as from:
// https://twiki.cern.ch/twiki/bin/view/Geant4/QuickMigrationGuideForGeant4V10
extern G4ThreadLocal G4Allocator<GHit>* GHitAllocator;

inline void* GHit::operator new(size_t)
{
	if(!GHitAllocator) GHitAllocator = new G4Allocator<GHit>;
	return (void *) GHitAllocator->MallocSingle();
}

inline void GHit::operator delete(void *hit)
{
	GHitAllocator->FreeSingle((GHit*) hit);
}
#endif

