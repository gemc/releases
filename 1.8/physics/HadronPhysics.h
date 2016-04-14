#ifndef HadronPhysics_h
#define HadronPhysics_h 1


// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4VPhysicsConstructor.hh"


// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"

class HadronPhysics : public G4VPhysicsConstructor
{
 public: 
   HadronPhysics(gemc_opts);
   virtual ~HadronPhysics();
   gemc_opts gemcOpt;  

   virtual void ConstructParticle(); 
   virtual void ConstructProcess();

};

#endif





