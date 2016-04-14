// %%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%
#include "FMT_hitprocess.h"
#include "fmt_strip.h"

PH_output FMT_HitProcess :: ProcessHit(MHit* aHit, gemc_opts Opt)
{
 string hd_msg   = Opt.args["LOG_MSG"].args + " FMT Hit Process " ;
 double VERB     = Opt.args["HIT_VERBOSITY"].arg;

 PH_output out;
 out.identity = aHit->GetId();

 HCname = "FMT Hit Process";

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
 

 // %%%%%%%%%%%%%%%%%%%%%%%%%%
 // Digitization
 // FMT ID:
 // layer, type, sector, strip
 // %%%%%%%%%%%%%%%%%%%%%%%%%% 
 int layer  = 2*out.identity[0].id + out.identity[1].id - 2 ;
 int sector = out.identity[2].id;
 int strip  = out.identity[3].id;
 
 if(VERB>4)
 cout <<  hd_msg << " layer: " << layer << "  sector: " << sector 
      << "  Strip: " << strip << " x=" << x << " y=" << y << " z=" << z << endl; 

 out.dgtz.push_back(layer);
 out.dgtz.push_back(sector);
 out.dgtz.push_back(strip); 

 return out;
}



vector<identifier>  FMT_HitProcess :: ProcessID(vector<identifier> id, G4Step* aStep, detector Detector, gemc_opts Opt)
{
 double x, y, z;
 G4ThreeVector   xyz    = aStep->GetPostStepPoint()->GetPosition();
 x = xyz.x()/mm;
 y = xyz.y()/mm;
 z = xyz.z()/mm;

 vector<identifier> yid = id;
 class fmt_strip fmts;
 fmts.fill_infos();

 int layer  = 2*yid[0].id + yid[1].id - 2 ;
 int sector = yid[2].id;

 //yid[3].id = fmts.FindStrip(layer-1, sector-1, x, y, z);
double depe = aStep->GetTotalEnergyDeposit();
 //cout << "resolMM " << layer << " " << x << " " << y << " " << z << " " << depe << " " << aStep->GetTrack()->GetTrackID() << endl;
 vector<double> multi_hit = fmts.FindStrip(layer-1, sector-1, x, y, z, depe);
 
 int n_multi_hits = multi_hit.size()/2;
 
 // closest strip
 //yid[4].id = (int) multi_hit[0];
 yid[3].id = (int) multi_hit[0];
 
 yid[0].id_sharing = multi_hit[1];
 yid[1].id_sharing = multi_hit[1];
 yid[2].id_sharing = multi_hit[1];
 yid[3].id_sharing = multi_hit[1];
 // yid[4].id_sharing = multi_hit[1];
 
 // additional strip			
 for(int h=1; h<n_multi_hits; h++)
   {
     for(int j=0; j<3; j++)
       {
	 identifier this_id;
	 this_id.name       = yid[j].name;
	 this_id.rule       = yid[j].rule;
	 this_id.id         = yid[j].id;
	 this_id.time       = yid[j].time;
	 this_id.TimeWindow = yid[j].TimeWindow;
	 this_id.TrackId    = yid[j].TrackId;
	 this_id.id_sharing = multi_hit[3];
	 yid.push_back(this_id);
       }
     // last id is strip
     identifier this_id;
     this_id.name       = yid[3].name;
     this_id.rule       = yid[3].rule;
     this_id.id         = (int) multi_hit[2];
     this_id.time       = yid[3].time;
     this_id.TimeWindow = yid[3].TimeWindow;
     this_id.TrackId    = yid[3].TrackId;
     this_id.id_sharing = multi_hit[3];
     yid.push_back(this_id);  
   }
 
 return yid;
}










