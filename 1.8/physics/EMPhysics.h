#ifndef EMPhysics_H
#define EMPhysics_H 1

#include "G4VPhysicsConstructor.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"

class EMPhysics : public G4VPhysicsConstructor
{
 public:
   EMPhysics(gemc_opts);
   virtual ~EMPhysics();
   gemc_opts gemcOpt;

  public: 
    virtual void ConstructParticle();
    virtual void ConstructProcess();
};


#endif





