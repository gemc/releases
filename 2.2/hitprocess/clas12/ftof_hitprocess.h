#ifndef FTOF_HITPROCESS_H
#define FTOF_HITPROCESS_H 1

// gemc headers
#include "HitProcess.h"

// Class definition
/// \class ftof_HitProcess
/// <b> Forward Time of Flight Hit Process Routine</b>\n\n
/// The Calibration Constants are:\n
/// - VEF is the effective velocity of propogation in the scintillator

class ftof_HitProcess : public HitProcess
{
	public:
	
		~ftof_HitProcess(){;}
	
		// - integrateDgt: returns digitized information integrated over the hit
		map<string, double> integrateDgt(MHit*, int);

		// - multiDgt: returns multiple digitized information / hit
		map< string, vector <int> > multiDgt(MHit*, int);
		
		// The pure virtual method processID returns a (new) identifier
		// containing hit sharing information
		vector<identifier> processID(vector<identifier>, G4Step*, detector);
	
		// creates the HitProcess
		static HitProcess *createHitClass() {return new ftof_HitProcess;}
};

#endif
