#include "IonPhysics.h"

//#include "G4ParticleTable.hh"
#include "G4ProcessManager.hh"
#include "G4IonConstructor.hh"

// processes
#include "G4hMultipleScattering.hh"
#include "G4hIonisation.hh"
#include "G4ionIonisation.hh"
#include "G4HadronElasticProcess.hh"
#include "G4DeuteronInelasticProcess.hh"
#include "G4TritonInelasticProcess.hh"
#include "G4AlphaInelasticProcess.hh"

// models
#include "G4LEDeuteronInelastic.hh"
#include "G4LETritonInelastic.hh"
#include "G4LEAlphaInelastic.hh"

IonPhysics::IonPhysics(gemc_opts Opt) :  G4VPhysicsConstructor("Ion Physics")
{
	gemcOpt = Opt;
}


IonPhysics::~IonPhysics(){;}


void IonPhysics::ConstructParticle()
{
	// Construct light ions (d, t, 3He, alpha, and generic ion)
	G4IonConstructor ionConstruct;
	ionConstruct.ConstructParticle();
}


void IonPhysics::ConstructProcess()
{
	string hd_msg = gemcOpt.args["LOG_MSG"].args + " Ion Physics List: <<< ";
//	double   VERB = gemcOpt.args["PHY_VERBOSITY"].arg ;
	cout << hd_msg << " Building Ion Processes " << endl;

	G4ProcessManager * pManager = 0;
 
	///////////////////
	//   Deuteron    //
	///////////////////
	pManager = G4Deuteron::Deuteron()->GetProcessManager();

	G4DeuteronInelasticProcess* dinelProc = new G4DeuteronInelasticProcess();
	G4LEDeuteronInelastic* LEPdModel = new G4LEDeuteronInelastic();
	dinelProc->RegisterMe(LEPdModel);
	pManager->AddDiscreteProcess(dinelProc);

	///////////////////
	//    Triton     //
	///////////////////
	pManager = G4Triton::Triton()->GetProcessManager(); 

	G4TritonInelasticProcess* tinelProc = new G4TritonInelasticProcess();
	G4LETritonInelastic* LEPtModel = new G4LETritonInelastic();
	tinelProc->RegisterMe(LEPtModel);
	pManager->AddDiscreteProcess(tinelProc);

	///////////////////
	//     Alpha     //
	///////////////////
	pManager = G4Alpha::Alpha()->GetProcessManager(); 

	G4AlphaInelasticProcess* ainelProc = new G4AlphaInelasticProcess();
	G4LEAlphaInelastic* LEPaModel = new G4LEAlphaInelastic();
	ainelProc->RegisterMe(LEPaModel);
	pManager->AddDiscreteProcess(ainelProc);

 
}
