#include "HadronPhysics.h"
#include "G4MesonConstructor.hh"
#include "G4LeptonConstructor.hh"
#include "G4BaryonConstructor.hh"
#include "G4ShortLivedConstructor.hh"
#include "G4IonConstructor.hh"

// processes
#include "G4ProcessManager.hh"
#include "G4HadronElasticProcess.hh"
#include "G4PionPlusInelasticProcess.hh"
#include "G4PionMinusInelasticProcess.hh"
#include "G4KaonPlusInelasticProcess.hh"
#include "G4KaonMinusInelasticProcess.hh"
#include "G4KaonZeroLInelasticProcess.hh"
#include "G4KaonZeroSInelasticProcess.hh"
#include "G4ProtonInelasticProcess.hh"
#include "G4NeutronInelasticProcess.hh"
#include "G4HadronFissionProcess.hh"
#include "G4HadronCaptureProcess.hh"
#include "G4AntiProtonInelasticProcess.hh"
#include "G4AntiNeutronInelasticProcess.hh"
#include "G4LambdaInelasticProcess.hh"
#include "G4AntiLambdaInelasticProcess.hh"
#include "G4SigmaPlusInelasticProcess.hh"
#include "G4SigmaMinusInelasticProcess.hh"
#include "G4AntiSigmaPlusInelasticProcess.hh"
#include "G4AntiSigmaMinusInelasticProcess.hh"
#include "G4PionMinusAbsorptionAtRest.hh"
#include "G4KaonMinusAbsorption.hh"
#include "G4AntiProtonAnnihilationAtRest.hh"
#include "G4AntiNeutronAnnihilationAtRest.hh"

// Lepton nuclear interations
#include "G4PhotoNuclearProcess.hh"
#include "G4GammaNuclearReaction.hh"
#include "G4ElectroNuclearReaction.hh"
#include "G4ElectronNuclearProcess.hh"


// cross sections
#include "G4PiNuclearCrossSection.hh"
#include "G4ProtonInelasticCrossSection.hh"
#include "G4NeutronInelasticCrossSection.hh"

// models
#include "G4LElastic.hh"
#include "G4CascadeInterface.hh"
#include "G4LEPionPlusInelastic.hh"
#include "G4LEPionMinusInelastic.hh"
#include "G4LEKaonPlusInelastic.hh"
#include "G4LEKaonMinusInelastic.hh"
#include "G4LEKaonZeroLInelastic.hh"
#include "G4LEKaonZeroSInelastic.hh"
#include "G4LEProtonInelastic.hh"
#include "G4LENeutronInelastic.hh"
#include "G4LFission.hh"
#include "G4LCapture.hh"
#include "G4LEAntiProtonInelastic.hh"
#include "G4LEAntiNeutronInelastic.hh"
#include "G4LELambdaInelastic.hh"
#include "G4LEAntiLambdaInelastic.hh"
#include "G4LESigmaPlusInelastic.hh"
#include "G4LESigmaMinusInelastic.hh"
#include "G4LEAntiSigmaPlusInelastic.hh"
#include "G4LEAntiSigmaMinusInelastic.hh"


HadronPhysics::HadronPhysics(gemc_opts Opt):G4VPhysicsConstructor("Hadron Physics")
{
 gemcOpt = Opt;
}
HadronPhysics::~HadronPhysics(){;}

void HadronPhysics::ConstructParticle()
{
  //  Construct all mesons
  G4MesonConstructor pMesonConstructor;
  pMesonConstructor.ConstructParticle();

  //  Construct all leptons
  G4LeptonConstructor pLeptonConstructor;
  pLeptonConstructor.ConstructParticle();

  //  Construct all baryons
  G4BaryonConstructor pBaryonConstructor;
  pBaryonConstructor.ConstructParticle();

  //  Construct  resonaces and quarks
  G4ShortLivedConstructor pShortLivedConstructor;
  pShortLivedConstructor.ConstructParticle();

  // Construct light ions (d, t, 3He, alpha, and generic ion)
  G4IonConstructor ionConstruct;
  ionConstruct.ConstructParticle();
}


void HadronPhysics::ConstructProcess()
{
 string hd_msg = gemcOpt.args["LOG_MSG"].args + " Hadron Physics List: <<< ";
 double   PHY_VERBOSITY = gemcOpt.args["PHY_VERBOSITY"].arg ;
 cout << hd_msg << " Building Hadron Physics Processes " << endl;

 // Hadronic Elastic Process and Model (the same for all hadrons)
 G4HadronElasticProcess* elasticProcess = new G4HadronElasticProcess();
 G4LElastic* elasticModel = new G4LElastic();
 elasticProcess->RegisterMe(elasticModel);

 // %%%%%%%%%%%%%%%%%%%%%%%%%
 // Hadronic inelastic models
 // %%%%%%%%%%%%%%%%%%%%%%%%%

 // Bertini cascade model: use for p,n,pi+,pi- between 0 and 9.9 GeV
 G4CascadeInterface* bertiniModel = new G4CascadeInterface();
 bertiniModel->SetMaxEnergy(9.9*GeV);

 // Low energy parameterized models : use between 9.5 and 25 GeV
 G4double LEPUpperLimit = 25*GeV;
 G4double LEPpnpiLimit = 9.5*GeV;

 G4LEKaonZeroLInelastic* LEPk0LModel = new G4LEKaonZeroLInelastic();
 LEPk0LModel->SetMaxEnergy(LEPUpperLimit);

 G4LEKaonZeroSInelastic* LEPk0SModel = new G4LEKaonZeroSInelastic();
 LEPk0SModel->SetMaxEnergy(LEPUpperLimit);


 G4ProcessManager * pmanager = 0;


 // Add Hadron Elastic Processes to all hadrons
 theParticleIterator->reset();
 while( (*theParticleIterator)() )
 {
    G4ParticleDefinition* particle = theParticleIterator->value();
    pmanager = particle->GetProcessManager();
    string                pname    = particle->GetParticleName();
    if (elasticProcess->IsApplicable(*particle))
    {
       if(PHY_VERBOSITY > 2) cout << hd_msg << " Adding Hadron Elastic Process for " << pname << endl;
       pmanager->AddDiscreteProcess(elasticProcess);
    }
 }


 // Adding inelastic nuclear scattering to leptons
 G4PhotoNuclearProcess*  thePhotoNuclearProcess    = new G4PhotoNuclearProcess;
 G4GammaNuclearReaction* theGammaReaction          = new G4GammaNuclearReaction;
 theGammaReaction->SetMaxEnergy(20*GeV);
 thePhotoNuclearProcess->RegisterMe(theGammaReaction);

 G4ElectronNuclearProcess* theElectronNuclearProcess = new G4ElectronNuclearProcess;
 G4ElectroNuclearReaction* theElectroReaction        = new G4ElectroNuclearReaction;
 theElectroReaction->SetMaxEnergy(20*GeV);
 theElectronNuclearProcess->RegisterMe(theElectroReaction);

 theParticleIterator->reset();
 while( (*theParticleIterator)() )
 {
    G4ParticleDefinition* particle = theParticleIterator->value();
    pmanager = particle->GetProcessManager();
    string                pname    = particle->GetParticleName();
    if (pname == "gamma")
    {
       if(PHY_VERBOSITY > 2) cout << hd_msg << " Gamma: inelastic nuclear scattering" << endl;
       pmanager->AddDiscreteProcess(thePhotoNuclearProcess);
    }
    else if (pname == "e-")
    {
       if(PHY_VERBOSITY > 2) cout << hd_msg << " Electron: inelastic nuclear scattering" << endl;
       pmanager->AddDiscreteProcess(thePhotoNuclearProcess);

    }
    else if (pname == "e+")
    {
       if(PHY_VERBOSITY > 2) cout << hd_msg << " Positron: inelastic nuclear scattering" << endl;
       pmanager->AddDiscreteProcess(thePhotoNuclearProcess);

    }

 }







 ///////////////////
 //  pi+ physics  //
 ///////////////////
 pmanager = G4PionPlus::PionPlus()->GetProcessManager();

 G4PionPlusInelasticProcess* pipinelProc = new G4PionPlusInelasticProcess();
 G4PiNuclearCrossSection* pion_XC = new G4PiNuclearCrossSection();
 pipinelProc->AddDataSet(pion_XC);
 pipinelProc->RegisterMe(bertiniModel);

 G4LEPionPlusInelastic* LEPpipModel = new G4LEPionPlusInelastic();
 LEPpipModel->SetMinEnergy(LEPpnpiLimit);
 LEPpipModel->SetMaxEnergy(LEPUpperLimit);
 pipinelProc->RegisterMe(LEPpipModel);

 pmanager->AddDiscreteProcess(pipinelProc);

 ///////////////////
 //  pi- physics  //
 ///////////////////
 pmanager = G4PionMinus::PionMinus()->GetProcessManager();

 G4PionMinusInelasticProcess* piminelProc = new G4PionMinusInelasticProcess();
 piminelProc->AddDataSet(pion_XC);
 piminelProc->RegisterMe(bertiniModel);

 G4LEPionMinusInelastic* LEPpimModel = new G4LEPionMinusInelastic();
 LEPpimModel->SetMinEnergy(LEPpnpiLimit);
 LEPpimModel->SetMaxEnergy(LEPUpperLimit);
 piminelProc->RegisterMe(LEPpimModel);

  pmanager->AddDiscreteProcess(piminelProc);

 // pi- absorption at rest
 G4PionMinusAbsorptionAtRest* pimAbsorb = new G4PionMinusAbsorptionAtRest();
 pmanager->AddRestProcess(pimAbsorb);

 ///////////////////
 //  K+ physics   //
 ///////////////////
 pmanager = G4KaonPlus::KaonPlus()->GetProcessManager();

 G4KaonPlusInelasticProcess* kpinelProc = new G4KaonPlusInelasticProcess();
 G4LEKaonPlusInelastic* LEPkpModel = new G4LEKaonPlusInelastic();
 LEPkpModel->SetMaxEnergy(LEPUpperLimit);
 kpinelProc->RegisterMe(LEPkpModel);
 pmanager->AddDiscreteProcess(kpinelProc);

 ///////////////////
 //  K- physics   //
 ///////////////////
 pmanager = G4KaonMinus::KaonMinus()->GetProcessManager();

 G4KaonMinusInelasticProcess* kminelProc = new G4KaonMinusInelasticProcess();
 G4LEKaonMinusInelastic* LEPkmModel = new G4LEKaonMinusInelastic();
 LEPkmModel->SetMaxEnergy(LEPUpperLimit);
 kminelProc->RegisterMe(LEPkmModel);
 pmanager->AddDiscreteProcess(kminelProc);

 // K- absorption at rest
 G4KaonMinusAbsorption* kmAbsorb = new G4KaonMinusAbsorption();
 pmanager->AddRestProcess(kmAbsorb);

 ///////////////////
 //  K0L physics  //
 ///////////////////
 pmanager = G4KaonZeroLong::KaonZeroLong()->GetProcessManager();

 G4KaonZeroLInelasticProcess* k0LinelProc = new G4KaonZeroLInelasticProcess();
 k0LinelProc->RegisterMe(LEPk0LModel);
 pmanager->AddDiscreteProcess(k0LinelProc);

 ///////////////////
 //  K0S physics  //
 ///////////////////
 pmanager = G4KaonZeroShort::KaonZeroShort()->GetProcessManager();

 G4KaonZeroSInelasticProcess* k0SinelProc = new G4KaonZeroSInelasticProcess();
 k0SinelProc->RegisterMe(LEPk0SModel);
 pmanager->AddDiscreteProcess(k0SinelProc);

 ///////////////////
 //    Proton     //
 ///////////////////
 pmanager = G4Proton::Proton()->GetProcessManager();

 G4ProtonInelasticProcess* pinelProc = new G4ProtonInelasticProcess();
 G4ProtonInelasticCrossSection* proton_XC = new G4ProtonInelasticCrossSection();
 pinelProc->AddDataSet(proton_XC);
 pinelProc->RegisterMe(bertiniModel);

 G4LEProtonInelastic* LEPpModel = new G4LEProtonInelastic();
 LEPpModel->SetMinEnergy(LEPpnpiLimit);
 LEPpModel->SetMaxEnergy(LEPUpperLimit);
 pinelProc->RegisterMe(LEPpModel);

 pmanager->AddDiscreteProcess(pinelProc);

 ///////////////////
 //  Anti-Proton  //
 ///////////////////
 pmanager = G4AntiProton::AntiProton()->GetProcessManager();

 G4AntiProtonInelasticProcess* apinelProc = new G4AntiProtonInelasticProcess();
 G4LEAntiProtonInelastic* LEPapModel = new G4LEAntiProtonInelastic();
 apinelProc->RegisterMe(LEPapModel);
 pmanager->AddDiscreteProcess(apinelProc);

 // anti-proton annihilation at rest
 G4AntiProtonAnnihilationAtRest* apAnnihil = new G4AntiProtonAnnihilationAtRest();
 pmanager->AddRestProcess(apAnnihil);

 ///////////////////
 //    Neutron    //
 ///////////////////
 pmanager = G4Neutron::Neutron()->GetProcessManager();

 // hadron elastic
 pmanager->AddDiscreteProcess(elasticProcess);

 // hadron inelastic
 G4NeutronInelasticProcess* ninelProc = new G4NeutronInelasticProcess();
 G4NeutronInelasticCrossSection* neutron_XC = 
                                   new G4NeutronInelasticCrossSection();
 ninelProc->AddDataSet(neutron_XC);
 ninelProc->RegisterMe(bertiniModel);

 G4LENeutronInelastic* LEPnModel = new G4LENeutronInelastic();
 LEPnModel->SetMinEnergy(LEPpnpiLimit);
 LEPnModel->SetMaxEnergy(LEPUpperLimit);
 ninelProc->RegisterMe(LEPnModel);

 pmanager->AddDiscreteProcess(ninelProc);

 // neutron-induced fission
 G4HadronFissionProcess* neutronFission = new G4HadronFissionProcess();
 G4LFission* neutronFissionModel = new G4LFission();
 neutronFissionModel->SetMinEnergy(0.);
 neutronFissionModel->SetMaxEnergy(20*TeV);
 neutronFission->RegisterMe(neutronFissionModel);
 pmanager->AddDiscreteProcess(neutronFission);

 // neutron capture
 G4HadronCaptureProcess* neutronCapture = new G4HadronCaptureProcess();
 G4LCapture* neutronCaptureModel = new G4LCapture();
 neutronCaptureModel->SetMinEnergy(0.);
 neutronCaptureModel->SetMaxEnergy(20*TeV);
 neutronCapture->RegisterMe(neutronCaptureModel);
 pmanager->AddDiscreteProcess(neutronCapture);

 ///////////////////
 // Anti-Neutron  //
 ///////////////////
 pmanager = G4AntiNeutron::AntiNeutron()->GetProcessManager();

 G4AntiNeutronInelasticProcess* aninelProc = new G4AntiNeutronInelasticProcess();
 G4LEAntiNeutronInelastic* LEPanModel = new G4LEAntiNeutronInelastic(); 
 aninelProc->RegisterMe(LEPanModel);
 pmanager->AddDiscreteProcess(aninelProc);

 // anti-neutron annihilation at rest
 G4AntiNeutronAnnihilationAtRest* anAnnihil = new G4AntiNeutronAnnihilationAtRest();
 pmanager->AddRestProcess(anAnnihil);

 ///////////////////
 //    Lambda     //
 ///////////////////
 pmanager = G4Lambda::Lambda()->GetProcessManager();

 G4LambdaInelasticProcess* linelProc = new G4LambdaInelasticProcess();
 G4LELambdaInelastic* LEPlModel = new G4LELambdaInelastic(); 
 linelProc->RegisterMe(LEPlModel);
 pmanager->AddDiscreteProcess(linelProc);

 ///////////////////
 //  Anti-Lambda  //
 ///////////////////
 pmanager = G4AntiLambda::AntiLambda()->GetProcessManager();

 G4AntiLambdaInelasticProcess* alinelProc = new G4AntiLambdaInelasticProcess();
 G4LEAntiLambdaInelastic* LEPalModel = new G4LEAntiLambdaInelastic(); 
 alinelProc->RegisterMe(LEPalModel);
 pmanager->AddDiscreteProcess(alinelProc);

 ///////////////////
 //    Sigma-     //
 ///////////////////
 pmanager = G4SigmaMinus::SigmaMinus()->GetProcessManager();

 G4SigmaMinusInelasticProcess* sminelProc = new G4SigmaMinusInelasticProcess();
 G4LESigmaMinusInelastic* LEPsmModel = new G4LESigmaMinusInelastic(); 
 sminelProc->RegisterMe(LEPsmModel);
 pmanager->AddDiscreteProcess(sminelProc);

 ///////////////////
 //  Anti-Sigma-  //
 ///////////////////
 pmanager = G4AntiSigmaMinus::AntiSigmaMinus()->GetProcessManager();

 G4AntiSigmaMinusInelasticProcess* asminelProc = new G4AntiSigmaMinusInelasticProcess();
 G4LEAntiSigmaMinusInelastic* LEPasmModel = new G4LEAntiSigmaMinusInelastic(); 
 asminelProc->RegisterMe(LEPasmModel);
 pmanager->AddDiscreteProcess(asminelProc);

 ///////////////////
 //    Sigma+     //
 ///////////////////
 pmanager = G4SigmaPlus::SigmaPlus()->GetProcessManager();


 G4SigmaPlusInelasticProcess* spinelProc = new G4SigmaPlusInelasticProcess();
 G4LESigmaPlusInelastic* LEPspModel = new G4LESigmaPlusInelastic(); 
 spinelProc->RegisterMe(LEPspModel);
 pmanager->AddDiscreteProcess(spinelProc);

 ///////////////////
 //  Anti-Sigma+  //
 ///////////////////
 pmanager = G4AntiSigmaPlus::AntiSigmaPlus()->GetProcessManager();

 G4AntiSigmaPlusInelasticProcess* aspinelProc = new G4AntiSigmaPlusInelasticProcess();
 G4LEAntiSigmaPlusInelastic* LEPaspModel = new G4LEAntiSigmaPlusInelastic();
 aspinelProc->RegisterMe(LEPaspModel);
 pmanager->AddDiscreteProcess(aspinelProc);


}
