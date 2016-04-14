#ifndef STR_HITPROCESS_H
#define STR_HITPROCESS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class STR_HitProcess : public MPHBaseClass
{
	public:
		~STR_HitProcess(){}
		PH_output ProcessHit(MHit*, gemc_opts);                                          ///< Method to process the hit
		vector<identifier> ProcessID(vector<identifier>, G4Step*, detector, gemc_opts) ; ///< Method to calculate new identifier
		static MPHBaseClass *createHitClass() {return new STR_HitProcess;}
};

#endif
