// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
//#include "G4ParticleDefinition.hh"
#include "G4ProcessManager.hh"
#include "G4Decay.hh"

// %%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%
#include "GeneralPhysics.h"


GeneralPhysics::GeneralPhysics(gemc_opts Opt) : G4VPhysicsConstructor("General Physics")
{
 gemcOpt = Opt;
}

GeneralPhysics::~GeneralPhysics(){}

void GeneralPhysics::ConstructParticle()
{
 // Decay will apply to all particles built so far
}

void GeneralPhysics::ConstructProcess()
{
 string hd_msg = gemcOpt.args["LOG_MSG"].args + " General Physics List: <<< ";
 double   VERB = gemcOpt.args["PHY_VERBOSITY"].arg ;
 cout << hd_msg << " Building Decay processes " << endl;

 G4Decay*fDecayProcess = new G4Decay();

 // Add Decay Process
 theParticleIterator->reset();
 while( (*theParticleIterator)() )
 {
    G4ParticleDefinition* particle = theParticleIterator->value();
    G4ProcessManager*     pmanager = particle->GetProcessManager();
    string                pname    = particle->GetParticleName();
    if (fDecayProcess->IsApplicable(*particle))
    { 
       if(VERB > 2) cout << hd_msg << " Adding Decay Process for " << pname << endl;
       pmanager ->AddProcess(fDecayProcess);
       // set ordering for PostStepDoIt and AtRestDoIt
       pmanager ->SetProcessOrdering(fDecayProcess, idxPostStep);
       pmanager ->SetProcessOrdering(fDecayProcess, idxAtRest);
    }
 }
}


