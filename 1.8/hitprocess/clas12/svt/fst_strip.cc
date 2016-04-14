// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "fst_strip.h"

#include <iostream>
#include <cmath>

void fst_strip::fill_infos()
{
 // all dimensions are in mm

 Pi  = 3.14159265358;
 interlayer      = 2.75;      // distance between 2 layers of a superlayer
 intersuperlayer = 20.0;      // distance between 2 superlayers
 Nsector=15;                  // number of sectors for each layer

 alpha      = (360.0/Nsector/2.0)*Pi/180.0;  // angle of the strips
 pitch      = 0.150;                         // pitch of the strips

 DZ = 0.934;                    // size of the band of dead zones 
 Rmin = 17.0;                 // inner radius of disks
 Rint = Rmin + 42.949;          // intermediate radius of disks
 Rmax = (Rmin+45.419+159.581);  // outer radius of disks
 Z_1stlayer = 190.1;          // z position of the 1st layer

 // z of the upstream part of the layer
 Z0.push_back(Z_1stlayer);
 Z0.push_back(Z0[0]+interlayer);
 Z0.push_back(Z_1stlayer+intersuperlayer);
 Z0.push_back(Z0[2]+interlayer);
 Z0.push_back(Z_1stlayer+2.*intersuperlayer);
 Z0.push_back(Z0[4]+interlayer);


 // mid angle of the sector
 MidTile.push_back((360.0/Nsector/2.0)*Pi/180.0);
 MidTile.push_back((360.0/Nsector/2.0)*Pi/180.0);
 MidTile.push_back((360.0/Nsector/2.0)*Pi/180.0);
 MidTile.push_back((360.0/Nsector/2.0)*Pi/180.0);
 MidTile.push_back((360.0/Nsector/2.0)*Pi/180.0);
 MidTile.push_back((360.0/Nsector/2.0)*Pi/180.0);

 // Number of strips
 Nstrips = (int) floor((2.*Rmax*tan(alpha)-2.*DZ)/pitch);

}





int fst_strip::FindStrip(int layer, int sector, double x, double y, double z)
{
  // 1st define phi of the hit point
  double phi;
  if(x>0 && y>=0) phi = atan(y/x);
  else if(x>0 && y<0) phi = 2.*Pi+atan(y/x);
  else if(x<0) phi = Pi+atan(y/x);
  else if(x==0 && y>0) phi = Pi/2.;
  else if(x==0 && y<0) phi = 3.*Pi/2.;
  else phi = 0; // x = y = 0, phi not defined

  // now find the tile number
  int ti=0;
  double theta_tmp=0;
  for(int t=0; t<Nsector; t++) 
  {
     theta_tmp = MidTile[layer]+2.*t*Pi/Nsector;
     if(theta_tmp>2.*Pi) theta_tmp = theta_tmp - 2.*Pi;
     if(theta_tmp<0) theta_tmp = theta_tmp + 2.*Pi;
     if(fabs(phi-theta_tmp)<Pi/Nsector || fabs(2.*Pi-fabs(phi-theta_tmp))<Pi/Nsector) ti=t; // gives tile #
  }

  double thetaij = MidTile[layer]+2.*ti*Pi/Nsector;
  int ClosestStrip=0;
  if(layer%2==0)
    ClosestStrip = (int) (floor( (-DZ+x*(cos(thetaij)*tan(alpha)+sin(thetaij))+y*(sin(thetaij)*tan(alpha)-cos(thetaij)))/pitch) +
                          floor(2.0*((-DZ+x*(cos(thetaij)*tan(alpha)+sin(thetaij)) + y*(sin(thetaij)*tan(alpha)-cos(thetaij)))/pitch -
                               floor((-DZ+x*(cos(thetaij)*tan(alpha)+sin(thetaij)) + y*(sin(thetaij)*tan(alpha)-cos(thetaij)))/pitch))));

  if(layer%2==1)
    ClosestStrip = (int) (floor( (-DZ+x*(cos(thetaij)*tan(alpha)-sin(thetaij))+y*(sin(thetaij)*tan(alpha)+cos(thetaij)))/pitch) +
                          floor(2.0*((-DZ+x*(cos(thetaij)*tan(alpha)-sin(thetaij))+y*(sin(thetaij)*tan(alpha)+cos(thetaij)))/pitch -
                               floor((-DZ+x*(cos(thetaij)*tan(alpha)-sin(thetaij))+y*(sin(thetaij)*tan(alpha)+cos(thetaij)))/pitch))));

  int IsOK=1;

  // now check if the position is in the acceptance of the detector:
  if(ClosestStrip<0 || ClosestStrip>Nstrips) IsOK = 0;
  if(x*cos(thetaij)+y*sin(thetaij)< Rmin || x*cos(thetaij)+y*sin(thetaij)>Rmax)
  {
    // cout << " Outside Acceptance " << endl;
     IsOK = 0;
  }
  if(x*cos(thetaij)+y*sin(thetaij)<(Rint+DZ) && x*cos(thetaij)+y*sin(thetaij)>(Rint-DZ)) IsOK = 0; // new ("inner" dead zones)
  if(IsOK) return ClosestStrip;
  else return -1;

}











