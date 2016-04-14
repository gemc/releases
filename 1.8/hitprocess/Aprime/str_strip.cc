// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "str_strip.h"

#include <iostream>
#include <cmath>
#include <cstdlib>

void str_strip::fill_infos()
{
 // all dimensions are in mm

 Pi  = 3.14159265358;
 interlayer = 2.75;            // distance between 2 layers of a superlayer

 alpha      = 3.0*Pi/180.0;    // max angle of the strips
 pitch      = 0.150;           // pitch of the strips

 // number of sectors for each layer
 Nsector.push_back(1);  Nsector.push_back(1);
 Nsector.push_back(1); Nsector.push_back(1);
 Nsector.push_back(1); Nsector.push_back(1);
//  Nsector.push_back(24); Nsector.push_back(24);

 // number of cards by sector for each layer
 Ncards.push_back(2);   Ncards.push_back(2);
 Ncards.push_back(2);   Ncards.push_back(2);
 Ncards.push_back(2);   Ncards.push_back(2);
//  Ncards.push_back(3);   Ncards.push_back(3);

 // z of the upstream part of the layer (start of the silicon)
 Z0.push_back(-131.854); Z0.push_back(-131.854);
 Z0.push_back(-92.329);  Z0.push_back(-92.329);
 Z0.push_back(-165.11);  Z0.push_back(-165.11);
//  Z0.push_back(-164.775); Z0.push_back(-164.775);

 // radii of layers
 R.push_back(50.699);   R.push_back(R[0]+interlayer);
 R.push_back(78.375);   R.push_back(R[2]+interlayer);
 R.push_back(105.574);  R.push_back(R[4]+interlayer);
//  R.push_back(161.25); R.push_back(R[6]+interlayer);

 // mid angle of the sector
 MidTile.push_back(0);     MidTile.push_back(0);
 MidTile.push_back(0);     MidTile.push_back(0);
 MidTile.push_back(Pi/16); MidTile.push_back(Pi/16);
//  MidTile.push_back(0);     MidTile.push_back(0);

 DZ_inLength = 0.934;   // size of the band of dead zones all around in the length of the card
 DZ_inWidth  = 0.934;   // size of the band of dead zones all around in the width of the card
 CardLength  = 111.625; // length of 1 card
 CardWidth   = 41.7;    // width 1 card

 // Number of strips
 NstripsZ = (int) floor((CardWidth-2.0*DZ_inLength-(CardLength-2*DZ_inWidth)*tan(alpha))*cos(alpha)/pitch);
 Nstrips = (int) floor((CardWidth-2.0*DZ_inLength)/pitch);

}


void str_strip::FindCard(int layer, double Z)
{
 if(Z>Z0[layer] && Z<Z0[layer]+Ncards[layer]*CardLength) 
 {
    // get the card index
    nCard = (int) floor((Z-Z0[layer])/CardLength);

    // redefine z to the global coordinate on the first card.
    // If it's the middle card z becomes the distance to the right edge.
    if((nCard%2)==0) z = Z - nCard*CardLength;
    if((nCard%2)==1) z = Z0[layer] + (nCard+1)*CardLength - Z + Z0[layer];

    // now hit is in the 1st card of the tile! let's check it
    if(z<Z0[layer] || z>Z0[layer]+CardLength)
    {
       cout << " Warning: z not within first card. This should never happen! z = " << z << ", card = " << nCard << endl;
       exit(0);
    }
 }
}


int str_strip::FindStripZ(int layer, int sector, double X, double Y)
{
 x = X;
 y = Y;

 double mindist   = 999.; // min distance between the points and strips
 double dist      = 999.; // distance to current strip
 int ClosestStrip = -1;   // number of the closest strip

 int IsOK = 0;
 const int MAXNSTRIP = 1024;
 if(NstripsZ > MAXNSTRIP)
 {
   cout << " Warning: number of strips > 1024. Exiting. " << endl;
   exit(0);
 }

 double Px[MAXNSTRIP], Py[MAXNSTRIP], Pz[MAXNSTRIP];
 double Pxp[MAXNSTRIP], Pyp[MAXNSTRIP], Pzp[MAXNSTRIP];


 for(int k=0; k<NstripsZ; k++)
 {
    Px[k]  = (R[layer]/cos(0.5*(CardWidth/R[layer])))*cos(MidTile[layer] +
              2.0*sector*Pi/Nsector[layer]  + 0.5*CardWidth/R[layer]) + DZ_inLength*sin(MidTile[layer] +
              2.0*sector*Pi/Nsector[layer]) + (pitch*k/cos(alpha))*sin(MidTile[layer] +
              2.0*sector*Pi/Nsector[layer]);
    Py[k]  = (R[layer]/cos(0.5*(CardWidth/R[layer])))*sin(MidTile[layer] +
              2.0*sector*Pi/Nsector[layer]  + 0.5*CardWidth/R[layer]) - DZ_inLength*cos(MidTile[layer] +
              2.0*sector*Pi/Nsector[layer]) - (pitch*k/cos(alpha))*cos(MidTile[layer] +
              2.0*sector*Pi/Nsector[layer]);
    Pz[k]  = Z0[layer]+DZ_inWidth;


    Pxp[k] = (R[layer]/cos(0.5*(CardWidth/R[layer])))*cos(MidTile[layer]
            + 2.0*sector*Pi/Nsector[layer]  - 0.5*CardWidth/R[layer])-DZ_inLength*sin(MidTile[layer]
            + 2.0*sector*Pi/Nsector[layer]) - (pitch*k/cos(alpha))*sin(MidTile[layer]
            + 2.0*sector*Pi/Nsector[layer]);
    Pyp[k] = (R[layer]/cos(0.5*(CardWidth/R[layer])))*sin(MidTile[layer]
            + 2.0*sector*Pi/Nsector[layer]  - 0.5*CardWidth/R[layer])+DZ_inLength*cos(MidTile[layer]
            + 2.0*sector*Pi/Nsector[layer]) + (pitch*k/cos(alpha))*cos(MidTile[layer]
            + 2.0*sector*Pi/Nsector[layer]);
    Pzp[k] = Z0[layer]+DZ_inWidth;

    // W layer
    if((layer%2)==0)
    {
       dist = fabs( - sin(MidTile[layer] + sector*2.0*Pi/Nsector[layer])*cos(alpha)*x
                    + cos(MidTile[layer] + sector*2.0*Pi/Nsector[layer])*cos(alpha)*y
                    + sin(alpha)*z
                    + sin(MidTile[layer] + sector*2.0*Pi/Nsector[layer])*cos(alpha)*Px[k]
                    - cos(MidTile[layer] + sector*2.0*Pi/Nsector[layer])*cos(alpha)*Py[k]
                    - sin(alpha)*Pz[k]);

       if(dist<mindist)
       {
          mindist      = dist;
          ClosestStrip = k;
       }
    }

    // V layer
    if((layer%2)==1)
    {
        dist = fabs( - sin(MidTile[layer] + sector*2.0*Pi/Nsector[layer])*cos(-alpha)*x
                     + cos(MidTile[layer] + sector*2.0*Pi/Nsector[layer])*cos(-alpha)*y
                     + sin(-alpha)*z
                     + sin(MidTile[layer] + sector*2.0*Pi/Nsector[layer])*cos(-alpha)*Pxp[k]
                     - cos(MidTile[layer] + sector*2.0*Pi/Nsector[layer])*cos(-alpha)*Pyp[k]
                     - sin(-alpha)*Pzp[k]);

        if(dist<mindist)
        {
           mindist = dist;
           ClosestStrip = k;
        }
    }
 }
 if(mindist<pitch/2. && z>Z0[layer]+DZ_inWidth && z<Z0[layer]+CardLength-DZ_inWidth) IsOK = 1;
 else IsOK = 0;

 if(IsOK) return ClosestStrip;
 else return -1;
}


int str_strip::FindStrip(int layer, int sector, double X, double Y, double Z)
{
 x = X;
 y = Y;
 z = Z;

 double mindist   = 999.; // min distance between the points and strips
 double dist      = 999.; // distance to current strip
 int ClosestStrip = -1;   // number of the closest strip
 int IsOK = 0;
 const int MAXNSTRIP = 1024;

 if(Nstrips > MAXNSTRIP)
 {
   cout << " Warning: number of strips > 1024. Exiting. " << endl;
   exit(0);
 }

 double Px[MAXNSTRIP], Py[MAXNSTRIP], Pz[MAXNSTRIP];
 double Pxp[MAXNSTRIP], Pyp[MAXNSTRIP], Pzp[MAXNSTRIP];
 double alpha_k;

 // particle is in the z-acceptance
 if(z>Z0[layer]+DZ_inWidth && z<Z0[layer]+Ncards[layer]*CardLength-DZ_inWidth) 
 {

    for(int k=0; k<Nstrips; k++)
    {
       alpha_k = k/((float)(Nstrips-1))*alpha;
       Px[k] = (R[layer]/cos(atan(0.5*(CardWidth/R[layer]))))*cos(MidTile[layer] +
               2.0*sector*Pi/Nsector[layer]+atan(0.5*CardWidth/R[layer]))+DZ_inLength*sin(MidTile[layer] +
               2.0*sector*Pi/Nsector[layer])+(pitch*k)*sin(MidTile[layer]+sector*2.0*Pi/Nsector[layer]);
       Py[k] = (R[layer]/cos(atan(0.5*(CardWidth/R[layer]))))*sin(MidTile[layer] +
               2.0*sector*Pi/Nsector[layer]+atan(0.5*CardWidth/R[layer]))-DZ_inLength*cos(MidTile[layer] +
               2.0*sector*Pi/Nsector[layer])-(pitch*k)*cos(MidTile[layer]+sector*2.*Pi/Nsector[layer]);
       Pz[k] = Z0[layer]+DZ_inWidth;

       Pxp[k] = (R[layer]/cos(atan(0.5*(CardWidth/R[layer]))))*cos(MidTile[layer] +
                2.0*sector*Pi/Nsector[layer]-atan(0.5*CardWidth/R[layer]))-DZ_inLength*sin(MidTile[layer] +
                2.0*sector*Pi/Nsector[layer])-(pitch*k)*sin(MidTile[layer]+sector*2.*Pi/Nsector[layer]);
       Pyp[k] = (R[layer]/cos(atan(0.5*(CardWidth/R[layer]))))*sin(MidTile[layer] +
                2.0*sector*Pi/Nsector[layer]-atan(0.5*CardWidth/R[layer]))+DZ_inLength*cos(MidTile[layer] +
                2.0*sector*Pi/Nsector[layer])+(pitch*k)*cos(MidTile[layer]+sector*2.*Pi/Nsector[layer]);
       Pzp[k] = Z0[layer]+DZ_inWidth;

       if((layer%2)==0)
       {
          dist = fabs(-sin(MidTile[layer]+sector*2.0*Pi/Nsector[layer])*cos(alpha_k)*x +
                       cos(MidTile[layer]+sector*2.0*Pi/Nsector[layer])*cos(alpha_k)*y +
                       sin(alpha_k)*z +
                       sin(MidTile[layer]+sector*2.0*Pi/Nsector[layer])*cos(alpha_k)*Px[k] -
                       cos(MidTile[layer]+sector*2.0*Pi/Nsector[layer])*cos(alpha_k)*Py[k] -
                       sin(alpha_k)*Pz[k]);
          if(dist<mindist)
          {
             mindist = dist;
             ClosestStrip = k; // record strip number
          }
       }

       if((layer%2)==1)
       {
          dist = fabs(-sin(MidTile[layer]+sector*2.0*Pi/Nsector[layer])*cos(-alpha_k)*x +
                       cos(MidTile[layer]+sector*2.0*Pi/Nsector[layer])*cos(-alpha_k)*y +
                       sin(-alpha_k)*z +
                       sin(MidTile[layer]+sector*2.0*Pi/Nsector[layer])*cos(-alpha_k)*Pxp[k] -
                       cos(MidTile[layer]+sector*2.0*Pi/Nsector[layer])*cos(-alpha_k)*Pyp[k] -
                       sin(-alpha_k)*Pzp[k]);
          if(dist<mindist)
          {
             mindist = dist;
             ClosestStrip = k; // record strip number
          }
       }
    }
    if(mindist < (pitch+(Ncards[layer]*CardLength-2.*DZ_inWidth)*alpha/(Nstrips-1)*(1.+tan(alpha)*tan(alpha)))/2. &&
       z>Z0[layer]+DZ_inWidth &&
       z<Z0[layer]+Ncards[layer]*CardLength-DZ_inWidth &&
       sqrt(x*x+y*y)<R[layer]/cos(atan((0.5*CardWidth-DZ_inLength)/R[layer]))) IsOK = 1;
    else IsOK = 0;
 }
 else
 {
    // particle not in the z-acceptance
    IsOK = 0;
    ClosestStrip = -1;
 }

 if(IsOK) return ClosestStrip;
 else return -1;

}


