// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UnitsTable.hh"
#include "G4Poisson.hh"
#include "Randomize.hh"
#include <math.h>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "PCAL_hitprocess.h"

PH_output PCAL_HitProcess :: ProcessHit(MHit* aHit, gemc_opts)
{
	PH_output out;
	out.identity = aHit->GetId();
	
	// get sector, stack (inner or outer), view (U, V, W), and strip.
	int sector = out.identity[0].id; 
	int module = out.identity[1].id;
	int view   = out.identity[2].id;
	int strip  = out.identity[3].id;  

	HCname = "PCAL Hit Process";	

    // Attenuation Length (mm)
    double attlen=3760.;
    
    // Get scintillator volume x dimension (mm)
	double pDx2 = aHit->GetDetector().dimensions[5];  ///< G4Trap Semilength.
	
    //cout<<"pDx2="<<pDx2<<" pDy1="<<pDy1<<endl;
    
	// %%%%%%%%%%%%%%%%%%%
	// Raw hit information
	// %%%%%%%%%%%%%%%%%%%
	int nsteps = aHit->GetPos().size();
	
	// average global, local positions of the hit
	double x, y, z;
	double lx, ly, lz;
    double xlocal,ylocal;
	x = y = z = lx = ly = lz = 0;
	vector<G4ThreeVector> pos  = aHit->GetPos();
	vector<G4ThreeVector> Lpos = aHit->GetLPos();
	
	// Get Total Energy deposited
	double Etot = 0;
    double Etota = 0;
    double latt = 0;
	vector<G4double> Edep = aHit->GetEdep();
    
	for(int s=0; s<nsteps; s++) 
    {
        if(attlen>0) 
        {
            xlocal = Lpos[s].x();
            ylocal = Lpos[s].y();
            if(view==1) latt=pDx2+xlocal;
            if(view==2) latt=pDx2+xlocal;
            if(view==3) latt=pDx2+xlocal;
            Etot  = Etot  + Edep[s];
            //cout<<"xlocal="<<xlocal<<" ylocal="<<ylocal<<" view="<<view<<" strip="<<strip<<" latt="<<latt<<endl;
            Etota = Etota + Edep[s]*exp(-latt/attlen);
        }
        else 
        {
            Etot  = Etot  + Edep[s];
            Etota = Etota + Edep[s];
        }
	}
	
	if(Etot>0)
		for(int s=0; s<nsteps; s++)
		{
			x  = x  +  pos[s].x()*Edep[s]/Etot;
			y  = y  +  pos[s].y()*Edep[s]/Etot;
			z  = z  +  pos[s].z()*Edep[s]/Etot;
			lx = lx + Lpos[s].x()*Edep[s]/Etot;
			ly = ly + Lpos[s].y()*Edep[s]/Etot;
			lz = lz + Lpos[s].z()*Edep[s]/Etot;
		}
		else
		{
			x  = pos[0].x();
			y  = pos[0].y();
			z  = pos[0].z();
			lx = Lpos[0].x();
			ly = Lpos[0].y();
			lz = Lpos[0].z();
		}

		// average time
		double time = 0;
		vector<G4double> times = aHit->GetTime();
		for(int s=0; s<nsteps; s++) time = time + times[s]/nsteps;
		
		// Energy of the track
		double Ene = aHit->GetE();
		
		out.raws.push_back(Etot);
		out.raws.push_back(x);
		out.raws.push_back(y);
		out.raws.push_back(z);
		out.raws.push_back(lx);
		out.raws.push_back(ly);
		out.raws.push_back(lz);
		out.raws.push_back(time);
		out.raws.push_back((double) aHit->GetPID());
		out.raws.push_back(aHit->GetVert().getX());
		out.raws.push_back(aHit->GetVert().getY());
		out.raws.push_back(aHit->GetVert().getZ());
		out.raws.push_back(Ene);
		out.raws.push_back((double) aHit->GetmPID());
		out.raws.push_back(aHit->GetmVert().getX());
		out.raws.push_back(aHit->GetmVert().getY());
		out.raws.push_back(aHit->GetmVert().getZ());
		
		
		// %%%%%%%%%%%%
		// Digitization
		// %%%%%%%%%%%%
		// adapted by Alex Piaseczny, Canisius College Medium Energy Nuclear Physics (CMENP), through
		// Dr. Michael Wood from Gilfoyle EC code
		// Jerry Gilfoyle, Feb, 2010
		
		// parameters: factor  - conversion for adc (MeV/channel).
		//             pcal_tdc_to_channel - conversion factor for tdc (ns/channel).
		
    // int pcal_tdc_time_to_channel = (int) gpars["PCAL/pcal_tdc_time_to_channel"];     // conversion from time (ns) to TDC channels. name has to match parameters
	
        double pc_tdc_time_to_channel = 20 ;
        double PCfactor = 11.5;               // number of p.e. divided by the energy deposited in MeV; measured from PCAL cosmic tests
        int PC_TDC_MAX = 4095;                // max value for PC tdc.
        double pc_MeV_to_channel = 10.;       // conversion from energy (MeV) to ADC channels
    
        // initialize ADC and TDC
        int PC_ADC = 0;
        int PC_TDC = PC_TDC_MAX;
    
        // simulate the adc value.
        if (Etot > 0) {
        double PC_npe = G4Poisson(Etota*PCfactor); //number of photoelectrons
        //  Fluctuations in PMT gain distributed using Gaussian with 
        //  sigma SNR = sqrt(ngamma)/sqrt(del/del-1) del = dynode gain = 3 (From RCA PMT Handbook) p. 169)
        //  algorithm, values, and comment above taken from gsim.
        double sigma = sqrt(PC_npe)/1.22;
        double PC_MeV = G4RandGauss::shoot(PC_npe,sigma)*pc_MeV_to_channel/PCfactor;
        if (PC_MeV <= 0) PC_MeV=0.0; // guard against weird, rare events.
        PC_ADC = (int) PC_MeV;
        }
    
        // simulate the tdc.
        PC_TDC = (int) (time*pc_tdc_time_to_channel);
        if (PC_TDC > PC_TDC_MAX) PC_TDC = PC_TDC_MAX;

        out.dgtz.push_back(sector);
		out.dgtz.push_back(module);
		out.dgtz.push_back(view);
		out.dgtz.push_back(strip);
		out.dgtz.push_back(PC_ADC);
		out.dgtz.push_back(PC_TDC);
		
 		//cout << "sector = " << sector << " layer = " << module << " view = " << view << " strip = " << strip << " PL_ADC = " << PC_ADC << " PC_TDC = " << PC_TDC << " Edep = " << Etot << endl;
		
		return out;		
}


vector<identifier>  PCAL_HitProcess :: ProcessID(vector<identifier> id, G4Step* aStep, detector Detector, gemc_opts Opt)
{
	//int sector             = yid[0].id;
	//int layer              = yid[1].id;
	//int view               = yid[2].id; // get the view: U->1, V->2, W->3
	//int strip	       = yid[3].id;
	//return yid;
	id[id.size()-1].id_sharing = 1;
	return id;
}
// have to change end










