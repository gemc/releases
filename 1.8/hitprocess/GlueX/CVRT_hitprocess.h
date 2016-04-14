#ifndef CVRT_HITPROCESS_H
#define CVRT_HITPROCESS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class CVRT_HitProcess : public MPHBaseClass
{
	public:
		~CVRT_HitProcess(){}
		PH_output ProcessHit(MHit*, gemc_opts);                                            ///< Method to process the hit
		vector<identifier> ProcessID(vector<identifier>, G4Step*, detector, gemc_opts) ;   ///< Method to calculate new identifier
		static MPHBaseClass *createHitClass() {return new CVRT_HitProcess;}
};

#endif
