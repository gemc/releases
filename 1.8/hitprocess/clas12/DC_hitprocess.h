#ifndef DC_HITPROCESS_H
#define DC_HITPROCESS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class DC_HitProcess : public MPHBaseClass
{
	public:
	~DC_HitProcess(){}
	
		PH_output ProcessHit(MHit*, gemc_opts);                                           ///< Method to process the hit
		vector<identifier> ProcessID(vector<identifier>, G4Step*, detector, gemc_opts) ;  ///< Method to calculate new identifier
		static MPHBaseClass *createHitClass() {return new DC_HitProcess;}

};

#endif
