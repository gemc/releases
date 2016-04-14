#ifndef CND_HITPROCESS_H
#define CND_HITPROCESS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class CND_HitProcess : public MPHBaseClass
{
	public:
		~CND_HitProcess(){}
		PH_output ProcessHit(MHit*, gemc_opts);                                           ///< Method to process the hit
		vector<identifier> ProcessID(vector<identifier>, G4Step*, detector, gemc_opts) ;  ///< Method to calculate new identifier
		static MPHBaseClass *createHitClass() {return new CND_HitProcess;}
		double BirksAttenuation(double,double,int,double);
};

#endif
