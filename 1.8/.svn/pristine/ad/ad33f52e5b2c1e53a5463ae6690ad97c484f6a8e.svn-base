#ifndef raw_HITPROCESS_H
#define raw_HITPROCESS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class raw_HitProcess : public MPHBaseClass
{
	public:
		~raw_HitProcess(){}
		PH_output ProcessHit(MHit*, gemc_opts);                                            ///< Method to process the hit
		vector<identifier> ProcessID(vector<identifier>, G4Step*, detector, gemc_opts) ;   ///< Method to calculate new identifier
		static MPHBaseClass *createHitClass() {return new raw_HitProcess;}
};

#endif
