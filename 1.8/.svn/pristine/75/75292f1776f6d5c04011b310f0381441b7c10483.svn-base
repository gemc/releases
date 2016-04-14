// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UnitsTable.hh"
#include "G4Poisson.hh"
#include "Randomize.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "IC_hitprocess.h"

PH_output IC_HitProcess :: ProcessHit(MHit* aHit, gemc_opts)
{
 PH_output out;
 out.identity = aHit->GetId();
 HCname = "IC Hit Process";

 // %%%%%%%%%%%%%%%%%%%
 // Raw hit information
 // %%%%%%%%%%%%%%%%%%%
 int nsteps = aHit->GetPos().size();

 // Get Total Energy deposited
 double Etot = 0;
 vector<G4double> Edep = aHit->GetEdep();
 for(int s=0; s<nsteps; s++) Etot = Etot + Edep[s];

 // average global, local positions of the hit
 double x, y, z;
 double lx, ly, lz;
 x = y = z = lx = ly = lz = 0;
 vector<G4ThreeVector> pos  = aHit->GetPos();
 vector<G4ThreeVector> Lpos = aHit->GetLPos();

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

 // R.De Vita (April 2009)

 // relevant parameter for digitization (in the future should be read from database)
 double tdc_time_to_channel=20;     // conversion factor from time(ns) to TDC channels)
 double tdc_max=4095;               // TDC range
 double adc_charge_tochannel=20;    // conversion factor from charge(pC) to ADC channels
 double PbWO4_light_yield =120/MeV; // Lead Tungsten Light Yield (PAD have similar QE for 
                                    // fast component, lambda=420nm-ly=120ph/MeV, and slow component, 
                                    // lambda=560nm-ly=20ph/MeV, taking fast component only)
 double APD_qe    = 0.75;           // APD Quantum Efficiency (Hamamatsu S8664-55)
 double APD_size  = 25*mm*mm;       // APD size ( 5 mm x 5 mm)
 double APD_gain  = 250;            // based on IC note
 double APD_noise = 0.006;          // relative noise based on a Voltage and Temperature stability of 30 mV (10%/V) and 0.1 C (-5%/C)
 double AMP_input_noise = 4500;     // preamplifier input noise in number of electrons
 double AMP_gain        = 2500;    // preamplifier gain = 5V/pC x 25 ns (tipical signal duration)
 double light_speed =15;

 // Get the crystal length: in the IC crystal are trapezoid (TRD) and the half-length is the 5th element
 double length = 2 * aHit->GetDetector().dimensions[4];
 // Get the crystal width (rear face): in the IC crystal are trapezoid (TRD) and the half-length is the 2th element
 double width  = 2 * aHit->GetDetector().dimensions[1];

 // use Crystal ID to define IDX and IDY
 int IDX = out.identity[0].id;
 int IDY = out.identity[1].id;

 // initialize ADC and TDC
 int ADC = 0;
 int TDC = 8192; 


 double Tmin = 99999.;
 if(Etot>0)
 {
   for(int s=0; s<nsteps; s++)
   {
     double dRight = length/2 - Lpos[s].z();              // distance along z between the hit position and the end of the crystal
     double timeR  = times[s] + dRight/cm/light_speed;    // arrival time of the signal at the end of the crystal (speed of light in the crystal=15 cm/ns)
     if(Edep[s]>1*MeV) Tmin=min(Tmin,timeR);              // signal time is set to first hit time with energy above 1 MeV
   }
   TDC=int(Tmin*tdc_time_to_channel);
   if(TDC>tdc_max) TDC=(int)tdc_max;
   // calculate number of photoelectrons detected by the APD considering the light yield, the q.e., and the size of the sensor
   double npe=G4Poisson(Etot*PbWO4_light_yield/2*APD_qe*APD_size/width/width);
   // calculating APD output charge (in number of electrons) and adding noise
   double nel=npe*APD_gain;
   nel=nel*G4RandGauss::shoot(1.,APD_noise);
   if(nel<0) nel=0;
   // adding preamplifier input noise
   nel=nel+AMP_input_noise*G4RandGauss::shoot(0.,1.);
   if(nel<0) nel=0;
   // converting to charge (in picoCoulomb)
   double crg=nel*AMP_gain*1.6e-7;      
   // converting to ADC channels
   ADC= (int) (crg*adc_charge_tochannel);
   	
 }
 out.dgtz.push_back(IDX);
 out.dgtz.push_back(IDY);
 out.dgtz.push_back(ADC);
 out.dgtz.push_back(TDC);


 return out;
}

vector<identifier>  IC_HitProcess :: ProcessID(vector<identifier> id, G4Step* aStep, detector Detector, gemc_opts Opt)
{
	id[id.size()-1].id_sharing = 1;
 return id;
}











