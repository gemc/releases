// %%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%
#include "STR_hitprocess.h"
#include "str_strip.h"


PH_output STR_HitProcess :: ProcessHit(MHit* aHit, gemc_opts Opt)
{
  string hd_msg        = Opt.args["LOG_MSG"].args + " STR Hit Process " ;
  double HIT_VERBOSITY = Opt.args["HIT_VERBOSITY"].arg;
  
  PH_output out;
  out.identity = aHit->GetId();
  
  HCname = "STR Hit Process";
  
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
  
  
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Digitization
  // STR ID:
  // layer, type, sector, module, strip
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // class str_strip strs;
  // strs.fill_infos();
  
  // double checking dimensions
  //  double CardLength = 2.0*aHit->GetDetector().dimensions[2]/mm;  // length of 1 card
  // double CardWidth  = 2.0*aHit->GetDetector().dimensions[0]/mm;  // width 1 card
  //if(CardLength != strs.CardLength || CardWidth != strs.CardWidth)
  //cout << hd_msg << "  Warning: dimensions mismatch between card reconstruction dimensions and gemc card dimensions." << endl << endl;
  
  int slayer  = out.identity[0].id;		
  int stype   = out.identity[1].id;	
  int segment = out.identity[2].id;
  int module  = out.identity[3].id;
  int strip   = out.identity[4].id;
  //
  if(HIT_VERBOSITY>4)
    cout <<  hd_msg << " layer: " << slayer << "  type: " << stype << "  segment: " << segment << "  module: "<< module
    << "  Strip: " << strip << " x=" << x << " y=" << y << " z=" << z << endl;
  
  out.dgtz.push_back(slayer);
  out.dgtz.push_back(stype);
  out.dgtz.push_back(segment);
  out.dgtz.push_back(module);
  out.dgtz.push_back(strip);
  
  return out;
}

#define ABS_(x) (x < 0 ? -x : x)

vector<identifier> STR_HitProcess :: ProcessID(vector<identifier> id, G4Step* aStep, detector Detector, gemc_opts Opt)
{
  vector<identifier> yid = id;
  
  enum STR_identifiers {layer=0,type=1,segment=2,module=3,strip=4};
  
  //int slayer  = yid[0].id;		
  //int stype   = yid[1].id;	
  //int segment = yid[2].id;
  //int module  = yid[3].id;
  //int strip   = yid[4].id;
  
  
  
  double active_width  = 38.34; // mm  X-direction
  double active_height = 98.33; // mm  Y-direction
  double readout_pitch = 0.06; // mm, = 60 micron 
  
  G4ThreeVector   xyz    = aStep->GetPostStepPoint()->GetPosition();
  G4ThreeVector  Lxyz    = aStep->GetPreStepPoint()->GetTouchableHandle()->GetHistory()->GetTopTransform().TransformPoint(xyz); // Local coordinates
  
  double x = Lxyz.x();
  double y = Lxyz.y();
  
  if( x < -active_width/2)      yid[strip].id = -10;
  else if ( x > active_width/2) yid[strip].id = -9;
  else if( y < -active_height/2)yid[strip].id = -8;
  else if( y > active_height/2) yid[strip].id = -7;
  else
  {
    int nstrip = (int)((x + active_width/2 )/readout_pitch);
    yid[strip].id = nstrip;
  }
  yid[id.size()-1].id_sharing = 1;
  return yid;
}











