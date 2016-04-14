#ifndef flux_HITPROCESS_H
#define flux_HITPROCESS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class flux_HitProcess : public MPHBaseClass
{
	public:
		~flux_HitProcess(){}
		PH_output ProcessHit(MHit*, gemc_opts);                                            ///< Method to process the hit
		vector<identifier> ProcessID(vector<identifier>, G4Step*, detector, gemc_opts) ;   ///< Method to calculate new identifier
		static MPHBaseClass *createHitClass() {return new flux_HitProcess;}
};

#endif
