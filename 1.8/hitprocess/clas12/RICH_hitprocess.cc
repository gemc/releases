// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UnitsTable.hh"
#include "G4Poisson.hh"
#include "Randomize.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "RICH_hitprocess.h"

PH_output RICH_HitProcess :: ProcessHit(MHit* aHit, gemc_opts)
{
 PH_output out;
 out.identity = aHit->GetId();
 int sector = out.identity[0].id;
 int pad = out.identity[1].id;
 HCname = "RICH Hit Process";

 // %%%%%%%%%%%%%%%%%%%
 // Raw hit information
 // %%%%%%%%%%%%%%%%%%%
 int nsteps = aHit->GetPos().size();

 // Get Total Energy deposited
 double Etot = 0;
 vector<G4double> Edep = aHit->GetEdep();
 for(int s=0; s<nsteps; s++) Etot = Etot + Edep[s];
 if(nsteps>1)cout << "ATT nsteps " << nsteps << endl;

 // average global, local positions of the hit
 double x, y, z;
 double lx, ly, lz;
 x = y = z = lx = ly = lz = 0;
 vector<G4ThreeVector> pos  = aHit->GetPos();
 vector<G4ThreeVector> Lpos = aHit->GetLPos();

 if(Etot>0)
 {
   for(int s=0; s<nsteps; s++)
   {
     x  = x  +  pos[s].x()*Edep[s]/Etot;
     y  = y  +  pos[s].y()*Edep[s]/Etot;
     z  = z  +  pos[s].z()*Edep[s]/Etot;
     lx = lx + Lpos[s].x()*Edep[s]/Etot;
     ly = ly + Lpos[s].y()*Edep[s]/Etot;
     lz = lz + Lpos[s].z()*Edep[s]/Etot;
   }
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

 cout << " RICHhit: " << aHit->GetPID() 
      << " " << Ene << " " << sector << " " << pad << " " << x << "  " << y << " " << z 
      << " " << lx << "  " << ly << " " << lz <<  endl;

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

 // Ahmed El Alaoui, May, 2010
 out.dgtz.push_back(sector);
 out.dgtz.push_back(pad);

 return out;
}


#include "G4VVisManager.hh"
#include "G4Circle.hh"
#include "G4VisAttributes.hh"
#include "G4ParticleTable.hh"

vector<identifier> RICH_HitProcess :: ProcessID(vector<identifier> id, G4Step* aStep, detector Detector, gemc_opts Opt)
{
  vector<identifier> id2 = id;

  G4StepPoint *prestep = aStep->GetPreStepPoint();
  G4ThreeVector  xyz   = aStep->GetPostStepPoint()->GetPosition();
  G4ThreeVector Lxyz = prestep->GetTouchableHandle()->GetHistory()->GetTopTransform().TransformPoint(xyz);
  const double xpos = Lxyz.x();
  const double ypos = Lxyz.y();
  const double Energy = aStep->GetTrack()->GetTotalEnergy()/eV;

  // H8500 specs:
  static const int nbins=15;
  static const double p[nbins]={1.86,   1.96,  2.03,  2.13, 2.28, 2.37, 2.48, 2.59, 2.71, 3.11, 3.37, 3.73, 4.13, 4.39, 4.64};
  static const double q[nbins]={0.0002, 0.002, 0.007, 0.02, 0.04, 0.08, 0.13, 0.17, 0.20, 0.26, 0.27, 0.28, 0.22, 0.18, 0.10};
  static const int NIPXL = 8;
  static const int NJPXL = 8;
  static const double PhCsize_x(49);
  static const double PhCsize_y(49);
  static const double PXLDeadSpace_x(0.15);
  static const double PXLDeadSpace_y(0.15);
  static const double PXLsize_x((PhCsize_x-7*PXLDeadSpace_x)/8);
  static const double PXLsize_y((PhCsize_y-7*PXLDeadSpace_y)/8);
  
  //shift the local reference center to down left corner
  const double new_xpos = xpos+PhCsize_x/2.;
  const double new_ypos = ypos+PhCsize_y/2.;

  //find the pixel row
  const int    iPMT = (int) floor(new_xpos/(PXLDeadSpace_x+PXLsize_x))+1;
  const double lx = new_xpos -(iPMT-1)*(PXLDeadSpace_x+PXLsize_x);

  //find the pixel column
  const int    jPMT = (int) floor(new_ypos/(PXLDeadSpace_y+PXLsize_y))+1;
  const double ly = new_ypos -(jPMT-1)*(PXLDeadSpace_y+PXLsize_y);

  // find the pixel number
  int ijPMT = NIPXL*(NJPXL-jPMT) + iPMT;

  // photon hit the dead space:
  if(lx>PXLsize_x || ly>PXLsize_y)
  {
    ijPMT = 0;
  }
  else
  {
    // pixel# += 100 if fails quauntum efficiency:
    double QE = -1;
    if(Energy > p[0] || Energy <= p[nbins-1])
    {
      for(int ie=0; ie<nbins-1; ie++)
      {
        if(Energy > p[ie] && Energy <= p[ie+1])
        {
          QE = q[ie] + (Energy-p[ie])*(q[ie+1]-q[ie])/(p[ie+1]-p[ie]);
          if(G4UniformRand()>QE)
          {
            ijPMT += 100;
          }
          break;
        }
      }
    }
  }
  
  G4VVisManager* pVVisManager = G4VVisManager::GetConcreteInstance();
  if(pVVisManager)
  {
    if (ijPMT<100)
    {
      // All hits are already colored green by MHit.cc.  Here,
      // draw white circle for photons that hit dead area, and
      // red circle for photons that pass QE.
      G4Circle circle(xyz);
      circle.SetFillStyle(G4Circle::filled);
      circle.SetScreenSize(8);
      if (ijPMT>0)
      {
        G4Colour colour_touch (1.0, 0.0, 0.0);
        circle.SetVisAttributes(G4VisAttributes(colour_touch));
      }
      pVVisManager->Draw(circle);
    }
  }

  id2[2].id = ijPMT;
	id2[2].id_sharing = 1;
  return id2;
}
