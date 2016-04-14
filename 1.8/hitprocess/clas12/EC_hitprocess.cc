// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UnitsTable.hh"
#include "G4Poisson.hh"
#include "Randomize.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "EC_hitprocess.h"

// Process the ID and hit for the EC using EC scintillator slab geometry instead of individual strips.

PH_output EC_HitProcess :: ProcessHit(MHit* aHit, gemc_opts)
{
  PH_output out;
	out.identity = aHit->GetId();
    
	// get sector, stack (inner or outer), view (U, V, W), and strip.
	int sector = out.identity[0].id;
	int stack  = out.identity[1].id;
	int view   = out.identity[2].id;
	int strip  = out.identity[3].id;
    
	HCname = "EC Hit Process";
    
    //Attenuation Length (mm)
    double attlen=3760.;
    
    // Get scintillator mother volume dimensions (mm)
	double pDy1 = aHit->GetDetector().dimensions[3];  ///< G4Trap Semilength.
	double pDx2 = aHit->GetDetector().dimensions[5];  ///< G4Trap Semilength.
    double BA = sqrt(4*pow(pDy1,2) + pow(pDx2,2)) ;
    
    //cout<<"pDx2="<<pDx2<<" pDy1="<<pDy1<<" BA="<<BA<<endl;
    
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
            if(view==1) latt=xlocal+(pDx2/(2.*pDy1))*(ylocal+pDy1);
            if(view==2) latt=BA*(pDy1-ylocal)/2./pDy1;
            if(view==3) latt=BA*(ylocal+pDy1-xlocal*2*pDy1/pDx2)/4/pDy1;
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

		// Jerry Gilfoyle, Feb, 2010
		// parameters: changed from hardwiring (see below) to gpars array - gilfoyle 8/31/12
		//int ec_tdc_time_to_channel = (int) gpars["EC/ec_tdc_time_to_channel"];     // conversion from time (ns) to TDC channels.
		//double ECfactor = (double) gpars["EC/ECfactor"];                    // number of photons divided by the energy deposited in MeV; value taken from gsim. see EC NIM paper table 1.
		//int EC_TDC_MAX = (int) gpars["EC/EC_TDC_MAX"];                      // max value for EC tdc.
		//int ec_charge_to_channel = (int) gpars["EC/ec_charge_to_channel"];  // conversion from charge (pC) to ADC channels; taken from IC code.
		//double ec_npe_to_charge = (double) gpars["EC/ec_npe_to_charge"];    // unjustified (!!) conversion from number of photoelectrons to charge in pC.

		// parameters were initially hardwired into the code with the values shown below. 
		// Moved into trunk/database_io/clas/geo/ec/parameters.txt - gilfoyle 8/31/12

        double ec_tdc_time_to_channel = 20.; // conversion from time (ns) to TDC channels.
        double ECfactor = 3.5;               // number of p.e. divided by the energy deposited in MeV; value taken from gsim. see EC NIM paper table 1.
        int EC_TDC_MAX = 4095;               // max value for EC tdc.
        double ec_MeV_to_channel = 10.;      // conversion from energy (MeV) to ADC channels 

		// initialize ADC and TDC
		int EC_ADC = 0;
		int EC_TDC = EC_TDC_MAX;

		// simulate the adc value.
		if (Etota > 0) {
        double EC_npe = G4Poisson(Etota*ECfactor); //number of photoelectrons
        //  Fluctuations in PMT gain distributed using Gaussian with 
        //  sigma SNR = sqrt(ngamma)/sqrt(del/del-1) del = dynode gain = 3 (From RCA PMT Handbook) p. 169)
        //  algorithm, values, and comment above taken from gsim.
        double sigma = sqrt(EC_npe)/1.22;
        double EC_MeV = G4RandGauss::shoot(EC_npe,sigma)*ec_MeV_to_channel/ECfactor;
        if (EC_MeV <= 0) EC_MeV=0.0; // guard against weird, rare events.
        EC_ADC = (int) EC_MeV;
		}

		// simulate the tdc.
		EC_TDC = (int) (time*ec_tdc_time_to_channel);
		if (EC_TDC > EC_TDC_MAX) EC_TDC = EC_TDC_MAX;

		out.dgtz.push_back(sector);
		out.dgtz.push_back(stack);
		out.dgtz.push_back(view);
		out.dgtz.push_back(strip);
		out.dgtz.push_back(EC_ADC);
		out.dgtz.push_back(EC_TDC);

		//cout << "sector = " << sector << " stack = " << stack << " view = " << view << " strip = " << strip << " EC_ADC = " << EC_ADC << " EC_TDC = " << EC_TDC << " Edep = " << Etot << endl;

		return out;
}

vector<identifier>  EC_HitProcess :: ProcessID(vector<identifier> id, G4Step* aStep, detector Detector, gemc_opts Opt)
{
	vector<identifier> yid = id;

	double NSTRIPS         = 36;
	//int sector             = yid[0].id;
	//int stack              = yid[1].id;
	int view               = yid[2].id; // get the view: U->1, V->2, W->3

	G4StepPoint   *prestep   = aStep->GetPreStepPoint();
	G4StepPoint   *poststep  = aStep->GetPostStepPoint();
	G4VTouchable* TH = (G4VTouchable*) aStep->GetPreStepPoint()->GetTouchable();
	
	string         name    = TH->GetVolume(0)->GetName();                                    ///< Volume name
	G4ThreeVector   xyz    = poststep->GetPosition();                                        ///< Global Coordinates of interaction
	G4ThreeVector  Lxyz    = prestep->GetTouchableHandle()->GetHistory()                     ///< Local Coordinates of interaction
	->GetTopTransform().TransformPoint(xyz);

	double xlocal = Lxyz.x();
	double ylocal = Lxyz.y();

	double pDy1 = Detector.dimensions[3];  ///< G4Trap Semilength. these points are needed to get the strip number.
	double pDx2 = Detector.dimensions[5];  ///< G4Trap Semilength.

	string detName = Detector.name;

	//
	// Some EC geometry:
	//
	//    B ---------------------- C
	//       \                  /
	//        \                /
	//         \              /
	//          \            /            face of EC sector looking from the target; z-axis is out
	//           \     x    /
	//            \        /                      | y
	//             \      /                       |       coordinates: origin is at the 
	//              \    /                 _______|       geometric center of the triangle.
	//               \  /                  x
	//                \/
	//                 A
	//
	//   U - strips parallel to BC, start numbering at A
	//   V - strips parallel to AB, start numbering at C
	//   W - strips parallel tp CA, start numbering at B
	//
	// other points: D - point where line from C crosses AB at right angle.
	//               F - CF is the component of the hit along CD.
	//               G - point where line from B crosses AC at right angle.
	//               H - BH is the component of the hit position along BG.
	//

	// get the strip.
    
    double BA = sqrt(4*pow(pDy1,2) + pow(pDx2,2)) ;
    //double lu=xlocal+(pDx2/(2.*pDy1))*(ylocal+pDy1);
    //double lv=BA*(pDy1-ylocal)/2./pDy1;
    //double lw=BA*(ylocal+pDy1-xlocal*2*pDy1/pDx2)/4/pDy1;	
    //cout<<"pDx2="<<pDx2<<" pDy1="<<pDy1<<endl;
    
    int strip = 0;
	if (view == 1) {
	  strip = (int) floor((ylocal + pDy1)*NSTRIPS/(2*pDy1)) + 1;  // U view strip.
      //cout<<"view="<<view<<" strip="<<strip<<" xloc="<<xlocal<<" yloc="<<ylocal<<" lu="<<lu<<endl;
	}
	else if (view == 3) {
	  double CFtop = (xlocal - pDx2)*2*pDy1 + (ylocal - pDy1)*pDx2;
	  double CF = abs(CFtop/BA);  // component of vector from the apex of the V view to the hit along a line perpendicular to the strips.

	  double CDtop =  -4*pDx2*pDy1;
	  double CD = abs(CDtop/BA);  // maximum length of V view along a line perpendicular to the strips (height of the V view triangle).

      strip = (int) floor(CF*NSTRIPS/CD)+1 ; // V view strip.
        //cout<<"view="<<view<<" strip="<<strip<<" xloc="<<xlocal<<" yloc="<<ylocal<<" lv="<<lv<<endl;
	}
	else if (view == 2) {
	  double BHtop = (xlocal + pDx2)*(-2*pDy1) + (ylocal - pDy1)*(pDx2);
	  double BH = abs(BHtop/BA); // component of vector from the apex of the W view to the hit along a line perpendicular to the strips.

	  double BGtop =  4*pDx2*pDy1;
	  double BG = abs(BGtop/BA); // maximum length of W view along a line perpendicular to the strips (height of the W view triangle).

	  strip = (int) floor(BH*NSTRIPS/BG)+1 ; // W view strip.
      //cout<<"view="<<view<<" strip="<<strip<<" xloc="<<xlocal<<" yloc="<<ylocal<<" lw="<<lw<<endl;
	} else {
	  cout << "WARNING: No view found." << endl;
	}
    

	if (strip <=0 ) strip=1;
	if (strip >=36) strip=36;

	yid[3].id = strip;
	yid[3].id_sharing = 1;

	return yid;
}











