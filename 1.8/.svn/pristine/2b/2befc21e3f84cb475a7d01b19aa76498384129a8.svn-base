// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4OpAbsorption.hh"
#include "G4OpBoundaryProcess.hh"
#include "G4OpRayleigh.hh"
#include "G4OpticalPhoton.hh"
#include "G4OpWLS.hh"
// #include "G4ParticleDefinition.hh"
// #include "G4ParticleTable.hh"
#include "G4ProcessManager.hh"

#include "G4Cerenkov.hh"

// %%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%
#include "OpticalPhysics.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <string>
using namespace std;

OpticalPhysics::OpticalPhysics(gemc_opts Opt) : G4VPhysicsConstructor("Optical Physics")
{
 gemcOpt = Opt;  
}

OpticalPhysics::~OpticalPhysics(){}

void OpticalPhysics::ConstructParticle()
{
 G4OpticalPhoton::OpticalPhotonDefinition();
}


void OpticalPhysics::ConstructProcess()
{
 string hd_msg = gemcOpt.args["LOG_MSG"].args + " Optical Physics List: <<< ";
 double   VERB = gemcOpt.args["PHY_VERBOSITY"].arg ;
 cout << hd_msg << " Building Optical Physics processes " << endl;
 
 theScintProcess       = new G4Scintillation("Scintillation");
 theScintProcess->SetScintillationYieldFactor(1.);
 theScintProcess->SetScintillationExcitationRatio(0.0);
 theScintProcess->SetTrackSecondariesFirst(true);

 G4Cerenkov* theCerenkovProcess    = new G4Cerenkov("Cerenkov");
 theCerenkovProcess->SetMaxNumPhotonsPerStep(200);
 theCerenkovProcess->SetTrackSecondariesFirst(true);

 G4OpAbsorption* theAbsorptionProcess  = new G4OpAbsorption();
 G4OpRayleigh* theRayleighScattering = new G4OpRayleigh();

 G4OpBoundaryProcess* theBoundaryProcess    = new G4OpBoundaryProcess();

 G4OpWLS* theWLSProcess         = new G4OpWLS();
 theWLSProcess->UseTimeProfile("delta");

 G4ProcessManager * pManager = 0;
 
 if(VERB > 2) cout << hd_msg << endl
                   << "  > Optical Photon: "       << endl
                   << "      Absorption "          << endl
                   << "      Rayleigh Scattering"  << endl
                   << "      Boundary Processes"   << endl
                   << "      WaveLength Shifting " << endl;
 pManager = G4OpticalPhoton::OpticalPhoton()->GetProcessManager();
 pManager->AddDiscreteProcess(theAbsorptionProcess);
 pManager->AddDiscreteProcess(theRayleighScattering);
 pManager->AddDiscreteProcess(theBoundaryProcess);
 pManager->AddDiscreteProcess(theWLSProcess);
  
 theParticleIterator->reset();
 while( (*theParticleIterator)() )
 {
    G4ParticleDefinition* particle = theParticleIterator->value();
    string particleName = particle->GetParticleName();

    pManager = particle->GetProcessManager();
    if(theCerenkovProcess->IsApplicable(*particle))
    { 
       if(VERB > 2) cout << hd_msg << " " << particleName << ": Cerenkov Process" << endl;
       pManager->AddProcess(theCerenkovProcess);    
       pManager->SetProcessOrdering(theCerenkovProcess, idxPostStep);
    }
    
    if(theScintProcess->IsApplicable(*particle))
     {
       if(VERB > 2) cout << hd_msg << " " << particleName << ": Scintillation Process" << endl;
       pManager->AddProcess(theScintProcess);
       pManager->SetProcessOrderingToLast(theScintProcess, idxAtRest);
       pManager->SetProcessOrderingToLast(theScintProcess, idxPostStep);
    }
 }
}


void OpticalPhysics::SetScintYieldFactor(G4double yf)
{
 string hd_msg = gemcOpt.args["LOG_MSG"].args + " Optical Physics List: <<< ";
 double   VERB = gemcOpt.args["PHY_VERBOSITY"].arg ;
  
 if(VERB > 2) cout << hd_msg << " Scintillation yield factor: " << yf << endl;
 if(theScintProcess)
    theScintProcess->SetScintillationYieldFactor(yf);
}


