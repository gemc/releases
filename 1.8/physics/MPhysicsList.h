#ifndef MPhysicsList_H
#define MPhysicsList_H 1

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4VModularPhysicsList.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"

class MPhysicsList: public G4VModularPhysicsList
{
 public:
   MPhysicsList(gemc_opts);
   virtual ~MPhysicsList();
   gemc_opts gemcOpt;  
  
 public:
   virtual void SetCuts();

};


#endif

