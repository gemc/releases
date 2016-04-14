#ifndef FST_HITPROCESS_H
#define FST_HITPROCESS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class FST_HitProcess : public MPHBaseClass
{
	public:
		~FST_HitProcess(){}
		PH_output ProcessHit(MHit*, gemc_opts);                                          ///< Method to process the hit
		vector<identifier> ProcessID(vector<identifier>, G4Step*, detector, gemc_opts) ; ///< Method to calculate new identifier
		static MPHBaseClass *createHitClass() {return new FST_HitProcess;}
};

#endif
