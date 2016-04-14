#ifndef OpticalPhysics_H
#define OpticalPhysics_H 1


// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4VPhysicsConstructor.hh"
#include "G4Scintillation.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"

class OpticalPhysics : public G4VPhysicsConstructor
{
 public: 
   OpticalPhysics(gemc_opts);
   virtual ~OpticalPhysics();
   gemc_opts gemcOpt;  

 public: 
   virtual void ConstructParticle(); 
   virtual void ConstructProcess();

   void SetScintYieldFactor(G4double yf);  
  
 protected:
   G4Scintillation* theScintProcess;
       
};

#endif





