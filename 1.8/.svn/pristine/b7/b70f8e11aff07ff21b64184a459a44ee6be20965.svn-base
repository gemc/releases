#ifndef OTOF_HITPROCESS_H
#define OTOF_HITPROCESS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%

/// \class OTOF_HitProcess
/// <b> Forward Time of Flight Hit Process Routine</b>\n\n
/// The Calibration Constants are:\n
/// - VEF is the effective velocity of propogation in the scintillator

class OTOF_HitProcess : public MPHBaseClass
{
	public:
		~OTOF_HitProcess(){}
		PH_output ProcessHit(MHit*, gemc_opts);                                           ///< Method to process the hit
		vector<identifier> ProcessID(vector<identifier>, G4Step*, detector, gemc_opts) ;  ///< Method to calculate new identifier
		static MPHBaseClass *createHitClass() {return new OTOF_HitProcess;}
};

#endif
