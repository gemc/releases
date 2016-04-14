#ifndef ECwithG4strips_HITPROCESS_H
#define ECwithG4strips_HITPROCESS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class ECwithG4strips_HitProcess : public MPHBaseClass
{
	public:
		~ECwithG4strips_HitProcess(){}
		PH_output ProcessHit(MHit*, gemc_opts);                                           ///< Method to process the hit
		vector<identifier> ProcessID(vector<identifier>, G4Step*, detector, gemc_opts) ;  ///< Method to calculate new identifier
		static MPHBaseClass *createHitClass() {return new ECwithG4strips_HitProcess;}
};

#endif
