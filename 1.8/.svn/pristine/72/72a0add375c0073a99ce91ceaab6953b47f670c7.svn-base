// %%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%
#include "MPhysicsList.h"
#include "EMPhysics.h"
#include "HadronPhysics.h"
#include "IonPhysics.h"
#include "GeneralPhysics.h"
#include "OpticalPhysics.h"


MPhysicsList::MPhysicsList(gemc_opts Opt):  G4VModularPhysicsList()
{
	gemcOpt = Opt;
	string hd_msg  = gemcOpt.args["LOG_MSG"].args + " gemc Physics List: <<< ";
	double use_opt = gemcOpt.args["OPT_PH"].arg;
//	double   VERB  = gemcOpt.args["PHY_VERBOSITY"].arg ;
  
	// default cut value 
  if( gemcOpt.args["LOW_EM_PHYS"].arg )  defaultCutValue = 0.0001*mm;
  else                                   defaultCutValue = 1.0*mm;

	// EM Physics
	RegisterPhysics( new EMPhysics(gemcOpt));

	// Optical Physics
	if(use_opt)
		RegisterPhysics( new OpticalPhysics(gemcOpt));

	// Hadron Physics
	RegisterPhysics( new HadronPhysics(gemcOpt));

	// General Physics (decay processes)
	RegisterPhysics( new GeneralPhysics(gemcOpt) );
 
	// Ion Physics
	RegisterPhysics( new IonPhysics(gemcOpt));
 
 
}

MPhysicsList::~MPhysicsList(){}

void MPhysicsList::SetCuts()
{
	double   VERB  = gemcOpt.args["PHY_VERBOSITY"].arg ;
  SetCutsWithDefault();  
  
  if( gemcOpt.args["LOW_EM_PHYS"].arg ) cout << "LOW EM OPTION ON \n";
 
  if( gemcOpt.args["LOW_EM_PHYS"].arg ){
      G4ProductionCutsTable::GetProductionCutsTable()->SetEnergyRange(1e-3,1e5);
			DumpCutValuesTable();
  }
  
  if (VERB>2) DumpCutValuesTable();
}




