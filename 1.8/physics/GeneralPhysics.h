#ifndef GeneralPhysics_H
#define GeneralPhysics_H 1

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4VPhysicsConstructor.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"

class GeneralPhysics : public G4VPhysicsConstructor
{
 public: 
   GeneralPhysics(gemc_opts);
   virtual ~GeneralPhysics();
   gemc_opts gemcOpt;  

 public: 
   virtual void ConstructParticle();
   virtual void ConstructProcess();

};


#endif








