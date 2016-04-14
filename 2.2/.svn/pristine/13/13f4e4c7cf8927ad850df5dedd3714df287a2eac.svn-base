#ifndef EC_HITPROCESS_H
#define EC_HITPROCESS_H 1

// gemc headers
#include "HitProcess.h"

// Class definition
class ec_HitProcess : public HitProcess
{
	public:

		~ec_HitProcess(){;}

		void init_subclass()
		{
			attlen              = 3760.; // Attenuation Length (mm)
			TDC_time_to_channel = 20.;   // conversion from time (ns) to TDC channels.
			ECfactor            = 3.5;   // number of p.e. divided by the energy deposited in MeV; value taken from gsim. see EC NIM paper table 1.
			TDC_MAX             = 4095;  // max value for EC tdc.
			ec_MeV_to_channel   = 10.;   // conversion from energy (MeV) to ADC channels
		}

		// - integrateDgt: returns digitized information integrated over the hit
		map<string, double> integrateDgt(MHit*, int);
		
		// - multiDgt: returns multiple digitized information / hit
		map< string, vector <int> > multiDgt(MHit*, int);
		
		// The pure virtual method processID returns a (new) identifier
		// containing hit sharing information
		vector<identifier> processID(vector<identifier>, G4Step*, detector);
	
		// creates the HitProcess
		static HitProcess *createHitClass() {return new ec_HitProcess;}


	private:
		
		double NSTRIPS;              // Number of strips
		double attlen;               // Attenuation Length (mm)
		double TDC_time_to_channel;  // conversion from time (ns) to TDC channels.
		double ECfactor;             // number of p.e. divided by the energy deposited in MeV; value taken from gsim. see EC NIM paper table 1.
		int TDC_MAX;                 // max value for EC tdc.
		double ec_MeV_to_channel;    // conversion from energy (MeV) to ADC channels
	

};

#endif
