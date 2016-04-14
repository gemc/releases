// G4 headers
#include "G4Poisson.hh"
#include "Randomize.hh"

// gemc headers
#include "ecs_hitprocess.h"


// Process the ID and hit for the EC using individual EC scintillator strips.
map<string, double> ecs_HitProcess :: integrateDgt(MHit* aHit, int hitn)
{
	map<string, double> dgtz;
	vector<identifier> identity = aHit->GetId();
	
	// get sector, stack (inner or outer), view (U, V, W), and strip.
	int sector = identity[0].id;
	int stack  = identity[1].id;
	int view   = identity[2].id;
	int strip  = identity[3].id;
	trueInfos tInfos(aHit);

	// initialize ADC and TDC
	int ADC = 0;
	int TDC = TDC_MAX;
	
	// simulate the adc value.
	if (tInfos.eTot > 0)
	{
		// number of photoelectrons.
		double EC_npe = G4Poisson(tInfos.eTot*ECfactor);
		//  Fluctuations in PMT gain distributed using Gaussian with
		//  sigma SNR = sqrt(ngamma)/sqrt(del/del-1) del = dynode gain = 3 (From RCA PMT Handbook) p. 169)
		//  algorithm, values, and comment above taken from gsim.
		double sigma = sqrt(EC_npe)*1.15;
		double EC_charge = G4RandGauss::shoot(EC_npe,sigma)*ec_MeV_to_channel/ECfactor;
		if (EC_charge <= 0) EC_charge=0.0; // guard against weird, rare events.
		ADC = (int) EC_charge;
	}
	
	// simulate the tdc.
	TDC = (int) (tInfos.time*TDC_time_to_channel);
	if (TDC > TDC_MAX) TDC = TDC_MAX;
	
	dgtz["hitn"]   = hitn;
	dgtz["sector"] = sector;
	dgtz["stack"]  = stack;
	dgtz["view"]   = view;
	dgtz["strip"]  = strip;
	dgtz["ADC"]    = ADC;
	dgtz["TDC"]    = TDC;
		
	return dgtz;
}

vector<identifier>  ecs_HitProcess :: processID(vector<identifier> id, G4Step* aStep, detector Detector)
{
	id[id.size()-1].id_sharing = 1;
	return id;
}


map< string, vector <int> >  ecs_HitProcess :: multiDgt(MHit* aHit, int hitn)
{
	map< string, vector <int> > MH;
	
	return MH;
}














