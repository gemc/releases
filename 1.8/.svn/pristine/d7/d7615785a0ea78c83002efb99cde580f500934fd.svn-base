// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UnitsTable.hh"


// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "LTCC_hitprocess.h"

#include <set>

PH_output LTCC_HitProcess :: ProcessHit(MHit* aHit, gemc_opts Opt)
{
	string hd_msg        = Opt.args["LOG_MSG"].args + " LTCC Hit Process " ;
	double HIT_VERBOSITY = Opt.args["HIT_VERBOSITY"].arg;
	PH_output out;
	out.identity = aHit->GetId();
	HCname = "LTCC Hit Process";

	// if the particle is not an opticalphoton
  // assuming it will create one photo-electron anyway
	// if(aHit->GetPID() != 0) return out;


	// removing all hits that do not correspond to optical 
  	
	// %%%%%%%%%%%%%%%%%%%
	// Raw hit information
	// %%%%%%%%%%%%%%%%%%%
	int nsteps = aHit->GetPos().size();
	
  vector<int> tids = aHit->GetTIds();
  vector<int> pids = aHit->GetPIDs();
	set<int> TIDS;
  
  
	// average global, local positions of the hit
	double x, y, z;
	double lx, ly, lz;
	x = y = z = lx = ly = lz = 0;
	vector<G4ThreeVector> pos  = aHit->GetPos();
	vector<G4ThreeVector> Lpos = aHit->GetLPos();
	  
  for(int s=0; s<nsteps; s++)
  {
  	// no conditions to count it as one photo-electron
    // a particle hitting on of the anodes directly 
    // may produce in average one photo-electron?
  	// if(pids[s] == 0) 
    TIDS.insert(tids[s]);
    x  = x  +  pos[s].x();
    y  = y  +  pos[s].y();
    z  = z  +  pos[s].z();
    lx = lx + Lpos[s].x();
    ly = ly + Lpos[s].y();
    lz = lz + Lpos[s].z();
  }
		
  x  = x  / nsteps;
  y  = y  / nsteps;
  z  = z  / nsteps;
  lx = lx / nsteps;
  ly = ly / nsteps;
  lz = lz / nsteps;
  
  
  
      
  // average time
  double time = 0;
  vector<G4double> times = aHit->GetTime();
  for(int s=0; s<nsteps; s++) time = time + times[s]/nsteps;
		
  // Energy of the track
  double Ene = aHit->GetE();
  
  out.raws.push_back(x);
  out.raws.push_back(y);
  out.raws.push_back(z);
  out.raws.push_back(lx);
  out.raws.push_back(ly);
  out.raws.push_back(lz);
  out.raws.push_back(time);
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
  
  int sector = out.identity[0].id;
  int side   = out.identity[1].id;
  int pmt    = out.identity[2].id;
  
  if(HIT_VERBOSITY>4)
    cout <<  hd_msg << " pmt: " << pmt << " x=" << x/cm << " y=" << y/cm << " z=" << z/cm << endl;
  
  out.dgtz.push_back(sector);
  out.dgtz.push_back(side);
  out.dgtz.push_back(pmt);
  out.dgtz.push_back(TIDS.size());
  
  return out;
}


vector<identifier>  LTCC_HitProcess :: ProcessID(vector<identifier> id, G4Step *step, detector Detector, gemc_opts Opt)
{
	id[id.size()-1].id_sharing = 1;
	return id;
}






