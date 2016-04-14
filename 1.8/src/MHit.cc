// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4VVisManager.hh"
#include "G4Circle.hh"
#include "G4VisAttributes.hh"
#include "G4ParticleTable.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MHit.h"

MHit::MHit() : G4VHit() {;}
MHit::~MHit() {;}

void MHit::Draw()
{
 G4VVisManager* pVVisManager = G4VVisManager::GetConcreteInstance();
 if(pVVisManager)
 {
    G4Circle circle(pos[0]);
    circle.SetFillStyle(G4Circle::filled);
    G4Colour colour_touch (0.0, 0.0, 1.0);
    G4Colour colour_hit   (1.0, 0.0, 0.0);
    G4Colour colour_passby(0.0, 1.0, 0.0);

    // If the energy is above threshold, red circle.
    // If the energy is below threshold, blue smaller circle.
    // If no energy deposited, green smaller circle.
    if(edep[0] > minEdep)
    {
       circle.SetVisAttributes(G4VisAttributes(colour_hit));
       circle.SetScreenSize(5);
    }
    else if(edep[0] > 0 && edep[0] <= minEdep)
    {
      circle.SetVisAttributes(G4VisAttributes(colour_touch));
      circle.SetScreenSize(4);
    }
    else if(edep[0] == 0)
    {
      circle.SetVisAttributes(G4VisAttributes(colour_passby));
      circle.SetScreenSize(3);
    }

    pVVisManager->Draw(circle);
 }
}

