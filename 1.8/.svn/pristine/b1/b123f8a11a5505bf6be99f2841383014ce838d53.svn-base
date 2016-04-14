#ifndef IonPhysics_h
#define IonPhysics_h 1

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4VPhysicsConstructor.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"

class IonPhysics : public G4VPhysicsConstructor
{
  public: 
    IonPhysics(gemc_opts);
    virtual ~IonPhysics();
   gemc_opts gemcOpt;  

    virtual void ConstructParticle(); 
    virtual void ConstructProcess();

};

#endif





