// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UnitsTable.hh"
#include "G4MaterialPropertyVector.hh"
#include "Randomize.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "HTCC_hitprocess.h"
#include "detector.h"
#include <set>

PH_output HTCC_HitProcess :: ProcessHit(MHit* aHit, gemc_opts Opt)
{
  string hd_msg        = Opt.args["LOG_MSG"].args + " HTCC Hit Process " ;
  double HIT_VERBOSITY = Opt.args["HIT_VERBOSITY"].arg;
  PH_output out;
  out.identity = aHit->GetId();
  HCname = "HTCC Hit Process";
  
  // if the particle is not an opticalphoton?
  if(aHit->GetPID() != 0) return out;
  
  // Since the HTCC hit involves a PMT which detects photons with a certain quantum efficiency (QE)
  // we want to implement QE here in a flexible way: 
  // That means we want to find out if the material of the photocathode has been defined, 
  // and if so, find out if it has a material properties table which defines an efficiency. 
  // if we find both of these properties, then we accept this event with probability QE:
  
  // %%%%%%%%%%%%%%%%%%%
  // Raw hit information
  // %%%%%%%%%%%%%%%%%%%
  int nsteps = aHit->GetPos().size();
  
  
  
  vector<int> tids = aHit->GetTIds(); //track ID at EACH STEP!
  vector<int> pids = aHit->GetPIDs(); //particle ID at EACH STEP!
  set<int> TIDS; //an array containing all UNIQUE tracks in this hit!
  vector<double> photon_energies;
  
  // average global, local positions of the hit
  double x, y, z;
  double lx, ly, lz;
  x = y = z = lx = ly = lz = 0;
  vector<G4ThreeVector> pos  = aHit->GetPos();
  vector<G4ThreeVector> Lpos = aHit->GetLPos();
  
  for(int s=0; s<nsteps; s++)
    {
      if(pids[s] == 0) { //the particle in the hit at this step is an optical photon
	pair< set<int> ::iterator, bool> newtrack = TIDS.insert(tids[s]); //insert this step into the set of track ids (set can only have unique values).
	if( newtrack.second ) photon_energies.push_back( (aHit->GetEs())[s] ); //if we found a new track, then add the initial photon energy of this track to the list of photon energies, for when we calculate quantum efficiency later!
      }
      
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
  
  //int pmt = out.identity[0].id;
  //we no longer use pmt. Now we use sector, ring, half:

  int idsector=-1, idring=-1, idhalf=-1;
  if( out.identity.size() >= 3 ){
    for(unsigned int id=0; id<out.identity.size(); id++){
      if( TrimSpaces(out.identity[id].name) == "sector" ) idsector = id;
      if( TrimSpaces(out.identity[id].name) == "ring" ) idring = id;
      if( TrimSpaces(out.identity[id].name) == "half" ) idhalf = id;
    }
  } else return out; //no valid ID
 
  
  // if identifiers for theta and phi indices have been defined, use them. 
  // otherwise, calculate itheta and iphi from the (mandatory) pmt index 
  // assuming the default configuration:
  int isector=-1, iring=-1, ihalf=-1;
  
  if( idsector >= 0 && idring >= 0 && idhalf >= 0 ){
    isector = out.identity[idsector].id;
    iring   = out.identity[idring].id;
    ihalf  = out.identity[idhalf].id;
  } else return out; //no valid ID

  //here is the fun part: figure out the number of photons we detect based on the quantum efficiency of the photocathode material, if defined:
  
  int ndetected = 0;
  
  // If the detector corresponding to this hit has a material properties table with "Efficiency" defined:
  G4MaterialPropertiesTable* MPT = aHit->GetDetector().GetLogical()->GetMaterial()->GetMaterialPropertiesTable();
  G4MaterialPropertyVector* efficiency;
  
  bool gotefficiency = false;
  if( MPT != NULL ){
    efficiency = (G4MaterialPropertyVector*) MPT->GetProperty("EFFICIENCY");
    if( efficiency != NULL ) gotefficiency = true;
  }

  for( unsigned int iphoton = 0; iphoton<TIDS.size(); iphoton++ ){ //loop over all unique photons contributing to the hit:
    if( gotefficiency ){ //If the material of this detector has a material properties table with "EFFICIENCY" defined, then "detect" this photon with probability = efficiency
      bool outofrange = false;
      if( G4UniformRand() <= efficiency->GetValue( photon_energies[iphoton], outofrange ) ) 
	ndetected++;
      
      if( HIT_VERBOSITY > 4 ){
	cout << "Found efficiency definition for material " << aHit->GetDetector().GetLogical()->GetMaterial()->GetName() 
	     << ": (Ephoton, efficiency)=(" << photon_energies[iphoton] << ", " 
	     << ( (G4MaterialPropertyVector*) efficiency )->GetValue( photon_energies[iphoton], outofrange )
	     << ")" << endl;
      }  
    } else { //No efficiency definition, "detect" all photons
      ndetected++;
    }
  }
  
  if(HIT_VERBOSITY>4)
    cout <<  hd_msg << " (sector, ring, half)=(" << isector << ", " << iring << ", " << ihalf << ")"
	 << " x=" << x/cm << " y=" << y/cm << " z=" << z/cm << endl;
  
  out.dgtz.push_back(isector);
  out.dgtz.push_back(iring);
  out.dgtz.push_back(ihalf);
  //out.dgtz.push_back(TIDS.size());
  out.dgtz.push_back( ndetected );
  
  return out;
}


vector<identifier>  HTCC_HitProcess :: ProcessID(vector<identifier> id, G4Step *step, detector Detector, gemc_opts Opt)
{
  id[id.size()-1].id_sharing = 1;
  return id;
}






