// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%

#include "G4PhysicsListHelper.hh"

#include "G4BaryonConstructor.hh"
#include "G4LeptonConstructor.hh"
#include "G4MesonConstructor.hh"
#include "G4IonConstructor.hh"



// gamma
#include "G4PhotoElectricEffect.hh"
#include "G4LivermorePhotoElectricModel.hh"
#include "G4ComptonScattering.hh"
#include "G4LivermoreComptonModel.hh"
#include "G4GammaConversion.hh"
#include "G4LivermoreGammaConversionModel.hh"
#include "G4RayleighScattering.hh" 
#include "G4LivermoreRayleighModel.hh"

// e-, e+
#include "G4eMultipleScattering.hh"
#include "G4UniversalFluctuation.hh"
#include "G4eIonisation.hh"
#include "G4LivermoreIonisationModel.hh"
#include "G4eBremsstrahlung.hh"
#include "G4LivermoreBremsstrahlungModel.hh"
#include "G4eplusAnnihilation.hh"

// mu
#include "G4MuMultipleScattering.hh"
#include "G4MuIonisation.hh"
#include "G4MuBremsstrahlung.hh"
#include "G4MuPairProduction.hh"
#include "G4MuonMinusCaptureAtRest.hh"

// hadrons
#include "G4hMultipleScattering.hh"
#include "G4hIonisation.hh"
#include "G4hBremsstrahlung.hh"
#include "G4hPairProduction.hh"


// other
#include "G4ionIonisation.hh"
#include "G4SynchrotronRadiation.hh"
#include "G4ProcessManager.hh"
#include "G4StepLimiter.hh"

// %%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%
#include "EMPhysics.h"


EMPhysics::EMPhysics(gemc_opts Opt) : G4VPhysicsConstructor("EM Physics")
{
	gemcOpt = Opt;
}

EMPhysics::~EMPhysics(){}

void EMPhysics::ConstructParticle()
{
	G4Gamma::GammaDefinition();
	
  //  Construct all mesons
  G4MesonConstructor pMesonConstructor;
  pMesonConstructor.ConstructParticle();
	
  //  Construct all leptons
  G4LeptonConstructor pLeptonConstructor;
  pLeptonConstructor.ConstructParticle();
	
  //  Construct all baryons
  G4BaryonConstructor pBaryonConstructor;
  pBaryonConstructor.ConstructParticle();
	
  // Construct light ions (d, t, 3He, alpha, and generic ion)
  G4IonConstructor ionConstruct;
  ionConstruct.ConstructParticle();
}


// see  cosmicray_charging/src/LISAPhysicsList.cc for possible switch to low energy EM.

void EMPhysics::ConstructProcess()
{
	string hd_msg = gemcOpt.args["LOG_MSG"].args + " EM / mu- Capture Physics List: <<< ";
	double  LOW_EM_PHYS = gemcOpt.args["LOW_EM_PHYS"].arg ;
	double   VERB = gemcOpt.args["PHY_VERBOSITY"].arg ;
	cout << hd_msg << " Building ElectroMagnetic and Capture Processes " << endl;
	
  
  G4PhysicsListHelper* ph = G4PhysicsListHelper::GetPhysicsListHelper();
	theParticleIterator->reset();
	
	while( (*theParticleIterator)() )
	{
    G4ParticleDefinition* particle = theParticleIterator->value();
    G4ProcessManager*     pmanager = particle->GetProcessManager();
    string                pname    = particle->GetParticleName();
		
    // Gammas 
    if (pname == "gamma")
    {
			if(LOW_EM_PHYS>0)
			{
				G4PhotoElectricEffect* thePhotoElectricEffect = new G4PhotoElectricEffect();
				thePhotoElectricEffect->SetModel(new G4LivermorePhotoElectricModel());
				ph->RegisterProcess(thePhotoElectricEffect, particle);
				
				G4ComptonScattering* theComptonScattering = new G4ComptonScattering();
				theComptonScattering->SetModel(new G4LivermoreComptonModel());
				ph->RegisterProcess(theComptonScattering, particle);
				
				G4GammaConversion* theGammaConversion = new G4GammaConversion();
				theGammaConversion->SetModel(new G4LivermoreGammaConversionModel());
				ph->RegisterProcess(theGammaConversion, particle);
				
				G4RayleighScattering* theRayleigh = new G4RayleighScattering();
				theRayleigh->SetModel(new G4LivermoreRayleighModel());
				ph->RegisterProcess(theRayleigh, particle);
			}
			else
			{
				ph->RegisterProcess(new G4PhotoElectricEffect, particle);
				ph->RegisterProcess(new G4ComptonScattering,   particle);
				ph->RegisterProcess(new G4GammaConversion,     particle);
				ph->RegisterProcess(new G4RayleighScattering,  particle);
			}
				
			if(VERB>2)
				cout << hd_msg << " Gamma: Photoelectric Effect, Compton Scattering, Gamma Conversion, Rayleigh Scattering" << endl;

    }
		
    // Electrons
    else if (pname == "e-")
    {
			
			if(LOW_EM_PHYS>0)
			{
				// Multiple Scattering
				G4eMultipleScattering* msc = new G4eMultipleScattering();
				ph->RegisterProcess(msc, particle);
				
				// Ionisation
				G4eIonisation* eIoni = new G4eIonisation();
				eIoni->SetEmModel(new G4LivermoreIonisationModel());
				eIoni->SetFluctModel(new G4UniversalFluctuation() );
				ph->RegisterProcess(eIoni, particle);
				
				// Bremsstrahlung
				G4eBremsstrahlung* eBrem = new G4eBremsstrahlung();
				eBrem->SetEmModel(new G4LivermoreBremsstrahlungModel());
				ph->RegisterProcess(eBrem, particle);
			}
			else
			{
				ph->RegisterProcess(new G4eMultipleScattering, particle);
				ph->RegisterProcess(new G4eIonisation,         particle);
				ph->RegisterProcess(new G4eBremsstrahlung,     particle);      
				
			}
			cout << hd_msg << " electrons: Multiple Scattering, Ionisation, Bremsstrahlung" << endl;
    }
		
		// Positrons
    else if (pname == "e+")
    {
			
			ph->RegisterProcess(new G4eMultipleScattering, particle);
      ph->RegisterProcess(new G4eIonisation,         particle);
      ph->RegisterProcess(new G4eBremsstrahlung,     particle);
      ph->RegisterProcess(new G4eplusAnnihilation,   particle);
			
			cout << hd_msg << " positrons: Multiple Scattering, Ionisation, Bremsstrahlung, Annihilation" << endl;
    }
		
    // Muonss
    else if(pname == "mu+" || pname == "mu-")
    {
			
			ph->RegisterProcess(new G4MuMultipleScattering, particle);
      ph->RegisterProcess(new G4MuIonisation,         particle);
      ph->RegisterProcess(new G4MuBremsstrahlung,     particle);
      ph->RegisterProcess(new G4MuPairProduction,     particle);
			
			cout << hd_msg << " muons: Multiple Scattering, Ionisation, Bremsstrahlung, Pair Production" << endl;
    }
		
		// proton, pions
		else if( pname == "proton" || 
						 pname == "pi-" ||
					 	 pname == "pi+"    ) 
		{
			ph->RegisterProcess(new G4hMultipleScattering, particle);
			ph->RegisterProcess(new G4hIonisation,         particle);
			ph->RegisterProcess(new G4hBremsstrahlung,     particle);
			ph->RegisterProcess(new G4hPairProduction,     particle);       
			
		}
		
		// alpha, helium3 
		else if( pname == "alpha" || 
						 pname == "He3" )     
		{
			ph->RegisterProcess(new G4hMultipleScattering, particle);
			ph->RegisterProcess(new G4ionIonisation,       particle);
			
		} 
		
		// ions
		else if( pname == "GenericIon" ) 
		{ 
			ph->RegisterProcess(new G4hMultipleScattering, particle);
			ph->RegisterProcess(new G4ionIonisation,       particle);     
			
		} 
		
		// everything else
		else if ((!particle->IsShortLived()) &&
							 (particle->GetPDGCharge() != 0.0) && 
							 (particle->GetParticleName() != "chargedgeantino")) 
		{
			ph->RegisterProcess(new G4hMultipleScattering, particle);
			ph->RegisterProcess(new G4hIonisation,         particle);        
		}     

		
    // Adding Step Limiter 
    if ((!particle->IsShortLived()) && (particle->GetPDGCharge() != 0.0) && (pname != "chargedgeantino"))
    {
			if(VERB > 2) cout << hd_msg << " Adding Step Limiter for " << pname << endl;
			pmanager->AddProcess(new G4StepLimiter,       -1,-1,3);
    }
		
		
  }
	
}



