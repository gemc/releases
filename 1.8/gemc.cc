/// \mainpage
/// \htmlonly <center><img src="gemc_logo.gif" width="130"></center>\endhtmlonly
/// \section overview Overview
/// gemc (<b>GE</b>ant4 <b>M</b>onte<b>C</b>arlo) is a simulation
/// software based on <a href="http://geant4.web.cern.ch/geant4/"> Geant4 </a>.\n\n
/// The simulation parameters are external to the software:\n
/// Geometry, Materials, Fields, Banks definitions are stored in an external database.\n
/// The Factory Method is used for the Hit Processes/Digitization Routines and for the Input/Output formats.\n
/// \section database The Database
/// gemc supports <i> mysql </i> as the external database. \n
/// The informations stored in the database determine:
/// - The Geometry.
/// - Sensitive Detectors definitions (including Thresholds, Time Window, Production Cut).
/// - The Hit Process Factories.
/// - The Bank Output Format.
/// - The Magnetic Fields definitions.
/// \section software Software Requirement:
/// - geant4 (simulation libraries)
/// - clhep  (random generators, physics vectors, geometry and linear algebra libraries)
/// - qt4 (graphic libraries)
/// - mysql
/// - scons (build system)
/// \section platforms Platforms Supported:
/// - Windows Vista (32, 64)
/// - Linux (32, 64)
/// - Mac OS X
/// \section docs Documentation:
/// - <a href="http://clasweb.jlab.org/wiki/index.php/CLAS12_Software"> Clas12 Software Wiki </a>
/// - <a href="http://www.jlab.org/ccc/mail_archives/SOFTWARE/gemc_software"> gemc list archives </a>
/// - <a href="https://clas12svn.jlab.org/repos/trunk/clas12/gemc/production/"> gemc repository </a>
/// \image html gemc_logo.gif
/// \n\n
/// \author \n &copy; Maurizio Ungaro
/// \author e-mail: ungaro@jlab.org\n\n\n
/// \file gemc.cc
/// Defines the gemc main( int argc, char **argv )
/// \author \n &copy; Maurizio Ungaro
/// \author e-mail: ungaro@jlab.org\n\n\n

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4RunManager.hh"
#include "G4UImanager.hh"
#include "G4UIterminal.hh"
#include "G4VisExecutive.hh"
#include "G4PhysListFactory.hh"
#include "G4VModularPhysicsList.hh"
#include "G4PropagatorInField.hh"
#include "G4TransportationManager.hh"
#include "G4UIQt.hh"
#include "G4Qt.hh"

// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QApplication>
#include <QSplashScreen>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "HitProcess_MapRegister.h"
#include "detector.h"
#include "gemc_MainGui.h"
#include "images/CLAS12_cad.h"
#include "MagneticField.h"
#include "MBankdefs.h"
#include "MDetectorConstruction.h"
#include "MEventAction.h"
#include "MOutputBaseClass.h"
#include "MPHBaseClass.h"
#include "MPhysicsList.h"
#include "MPrimaryGeneratorAction.h"
#include "MSteppingAction.h"
#include "Output_Register.h"
#include "usage.h"
#include "run_conditions.h"
#include "material_factory.h"
#include "parameter_factory.h"
#include "string_utilities.h"

// c++ headers
#include <unistd.h>  // needed for get_pid



/////////////////////////
/// <b> Main Program </b>
/////////////////////////
///  -# Sets the gemc_opts\n
///  -# Starts QT application if USE_QT=1
///  -# Starts the CLHEP random engine
///  -# Instantiates the Geant4 Run Manager
///  -# Builds detector map object from database
///  -# Builds Processes Routines Map
///  -# Builds Materials Map
///  -# Builds G4 Physical Volumes
///  -# Initialize Physics List
///  -# Initialize Generator
///  -# Initialize Event Action
///  -# Initialize G4Qt User Interface if USE_QT>0
///  -# Initialize Visualization Manager if USE_QT>0


// get_pid is useful only on the farm
// don't need it in Windows environment
// (but, why _getpid is not found?)
#ifdef _MSC_VER
#include <stdio.h>	
#include <process.h>
	//int get_pid(){return __get_pid();}
	int get_pid(){return 0;}
#endif



int main( int argc, char **argv )
{
	
	gemc_opts gemcOpt;
	gemcOpt.Set(argc, argv);
	string hd_msg    = gemcOpt.args["LOG_MSG"].args + " Init: >> " ;
	
	cout << endl << hd_msg  << " Geant4 MonteCarlo" << endl;
	double use_qt = gemcOpt.args["USE_QT"].arg;
	
	///< Initializing QT application
	QApplication gemc_gui( argc, argv, (bool) use_qt );
	// setting style if different than defulat "no"
	string guistyle = gemcOpt.args["QTSTYLE"].args;
	if(guistyle == "QPlastiqueStyle")	 gemc_gui.setStyle(new  QPlastiqueStyle);
	if(guistyle == "QCleanlooksStyle") gemc_gui.setStyle(new  QCleanlooksStyle);
	if(guistyle == "QWindowsStyle")	   gemc_gui.setStyle(new  QWindowsStyle);
	if(guistyle == "QMotifStyle")	     gemc_gui.setStyle(new  QMotifStyle);

	QPixmap *splash_i = NULL;
	QSplashScreen *splash = NULL;
	

#ifdef Q_OS_MAC
//
// If you are on a Mac, add the gemc.app/Contents/plugins directory to the list of paths
// that are searched for dynamic plugins.
//
	QDir dir(QApplication::applicationDirPath());
	dir.cdUp();
	dir.cd("PlugIns");
	QStringList dir_list(QLibraryInfo::location(QLibraryInfo::PluginsPath));
	dir_list.append(dir.absolutePath());
	QApplication::setLibraryPaths(dir_list);	

//  To print the path that is searched for plugins, uncomment:
//
//	foreach (QString path, gemc_gui.libraryPaths())
//      qDebug() << "Path: " << path << endl;	
#endif

	
	///< Initializing Splash Screen
	if(use_qt)
	{
		splash_i = new QPixmap(CLAS12_cad);
		splash   = new QSplashScreen(*splash_i);
		splash->show();
		gemc_gui.processEvents();
	}
	
	string msg;
	
	///< Initializing the CLHEP Random engine
	msg = " Setting CLHEP Random Engine...";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	// CLHEP::HepRandom::setTheEngine(new CLHEP::RanecuEngine);
	CLHEP::HepRandom::setTheEngine(new CLHEP::MTwistEngine);
	string RAND = gemcOpt.args["RANDOM"].args;
	G4int seed;
	
	if(RAND=="TIME")
	{
		msg = " Initializing CLHEP Random Engine from time, cpu clock and process id...";
		seed = time(NULL)-clock()-getpid() ;
	}
	else
	{
		seed = atoi(RAND.c_str());
		msg = " Initializing CLHEP Random Engine from user seed...";
	}
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	char seeds[100];
	sprintf(seeds, "%d", seed);
	msg = " Random Seed Initialized to: " ;
	msg.append(seeds);

	CLHEP::HepRandom::setTheSeed(seed);
	
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	
	///< Reading the gcard file
	if(gemcOpt.args["gcard"].args != "no")
	{
		msg = " Opening GCARD file " + gemcOpt.args["gcard"].args + "...";
		if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	}
	run_conditions RunConditions(gemcOpt);
	
  
  ///< Creating the sim_condition map to save to the output
  map<string, string> sim_condition;
  // filling gcard option content
  for(map<string, opts>::iterator it = gemcOpt.args.begin(); it != gemcOpt.args.end(); it++)
  {
  	string key = "option: " + it->first;
  	if(it->second.type == 0) sim_condition[key] = stringify(it->second.arg);
    else                     sim_condition[key] = it->second.args;
  }
  // filling detectors from gcard
  for(unsigned int i=0; i<RunConditions.gTab_Vec.size(); i++)
  {
  	string key = "detector: " + RunConditions.gTab_Vec[i];
    sim_condition[key] = "is present";
  }
  // filling rotation, position modifications from gcard 
  for(map<string, gcard_detector>::iterator it = RunConditions.gDet_Map.begin(); it != RunConditions.gDet_Map.end(); it++)
  {
  	if(it->second.get_position().mag2() != 0)
  	{
    	string key = "local shift for " + it->first;
    	sim_condition[key] = "(" + stringify(it->second.get_position().x()/mm) + ", " 
                             	 + stringify(it->second.get_position().y()/mm) + ", " 
                             	 + stringify(it->second.get_position().z()/mm) + ")mm"; 
  	}
    
  	if(it->second.get_vrotation().mag2() != 0)
  	{
    	string key = "local rotation for " + it->first;
    	sim_condition[key] = "(" + stringify(it->second.get_vrotation().x()/degree) + ", " 
                               + stringify(it->second.get_vrotation().y()/degree) + ", " 
                               + stringify(it->second.get_vrotation().z()/degree) + ")deg"; 
  	}
  }
  
	///< Construct the default G4 run manager
	msg = " Instantiating Run Manager...";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	G4RunManager *runManager = new G4RunManager;
	
	
  ///< Detector Map
	msg = " Retrieving gemc Detector Map...";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	map<string, detector> Hall_Map = read_detector(gemcOpt, RunConditions);
  
	///< Materials Map
	msg = " Material factory selected: " + gemcOpt.args["MATERIALSDB"].args;
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
  map<string, materialFactory> materialFactoriesMap = registerMaterialFactories();
  materials *materialSelectedFactory = getMaterialFactory(&materialFactoriesMap, gemcOpt.args["MATERIALSDB"].args);
	map<string, G4Material*> mats = materialSelectedFactory->initMaterials(RunConditions, gemcOpt);

  ///< Parameters Map
	msg = " Parameter factory selected: " + gemcOpt.args["PARAMETERSDB"].args;
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
  map<string, parameterFactory> parameterFactoriesMap = registerParameterFactories();
  parameters *parameterSelectedFactory = getParameterFactory(&parameterFactoriesMap, gemcOpt.args["PARAMETERSDB"].args);
	map<string, double> gParameters = parameterSelectedFactory->initParameters(RunConditions, gemcOpt);
  // filling parameters map in sim. condition map 
 	for(map<string, double>::iterator it = gParameters.begin(); it != gParameters.end(); it++)
  {
    string key = "parameter: " + it->first;
		sim_condition[key] = stringify(it->second);
  }	
  
  ///< Process Hit Map
	msg = " Building gemc Process Hit Factory...";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	map<string, MPHB_Factory> MProcessHit_Map = HitProcess_Map(gemcOpt.args["HIT_PROCESS_LIST"].args);
	
	///< Bank Map
	msg = " Retrieving gemc Banks Map...";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	map<string, MBank> MBank_Map = read_banks(gemcOpt, MProcessHit_Map);
		
	///< magnetic Field Map
	msg = " Retrieving gemc Magnetic Fields Map...";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	map<string, MagneticField> FieldMap = get_magnetic_Fields(gemcOpt);
	
  
  
	///< Build G4 Physical Volumes: MDetectorConstruction
	MDetectorConstruction* ExpHall = new MDetectorConstruction(gemcOpt);
	ExpHall->Hall_Map = &Hall_Map;
	ExpHall->mats    = &mats;
	ExpHall->FieldMap = &FieldMap;
	runManager->SetUserInitialization(ExpHall);
	
  
	///< Physics List
	string phys_list = gemcOpt.args["USE_PHYSICSL"].args  ;
	msg = " Initializing Physics List " + phys_list + "...";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;

	G4VUserPhysicsList* physics = NULL;
	G4VModularPhysicsList* phys = NULL;
	G4PhysListFactory factory;
	
	if(phys_list == "gemc")
	{
		physics = new MPhysicsList(gemcOpt);
		runManager->SetUserInitialization(physics);
	}
	else
	{
		if(factory.IsReferencePhysList(phys_list))
				phys = factory.GetReferencePhysList(phys_list);

		if(!phys) phys = factory.ReferencePhysList();
			
		runManager->SetUserInitialization(phys);
	}

	// need to use flags for both these here
	//  	physics->SetDefaultCutValue(0.1*mm);
	
	// Setting Max step for all the simulation. This is historically needed to limit 
	// the step in magnetic field in vacuum
	double max_step = gemcOpt.args["MAX_FIELD_STEP"].arg;
	if(max_step != 0)
		G4TransportationManager::GetTransportationManager()->GetPropagatorInField()->SetLargestAcceptableStep(max_step);
	
	///< Generator
	msg = " Initializing Primary Generator Action...";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	MPrimaryGeneratorAction* gen_action = new MPrimaryGeneratorAction(&gemcOpt);
	runManager->SetUserAction(gen_action);
	
  
	///< Event Action
	msg = " Initializing Event Action...";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	MEventAction* event_action = new MEventAction(gemcOpt, gParameters);
	event_action->SetEvtNumber((int) gemcOpt.args["EVN"].arg);     ///< Sets event number from OPTION
	runManager->SetUserAction(event_action);
	
  
	///< Stepping Action
	msg = " Initializing Stepping Action...";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	MSteppingAction* SteppingAction = new MSteppingAction(gemcOpt);
	runManager->SetUserAction(SteppingAction);
	
	///< User Interface manager
	// need UIQt to see Qt Open GL - have to comment line 136 of visualization/OpenGL/src/G4OpenGLQtViewer.cc
	msg = " Initializing User Interface...";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
  G4UIsession *session = NULL;
	if(use_qt) 
    session = new G4UIQt(argc,argv);
		
	///< Vis Manager
  G4VisManager *visManager = NULL;
  if(use_qt)
  {
    visManager = new G4VisExecutive;
    visManager->Initialize();
	}
  
	///< Initialize G4 kernel
	msg = " Initializing Run Manager...\n";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	runManager->Initialize();

  // Getting UI manager, restoring G4Out to cout
  G4UImanager* UImanager = G4UImanager::GetUIpointer();
  UImanager->SetCoutDestination(NULL);

	///< Output File: registering output type, output process factory,
	///< sensitive detectors into Event Action
	msg = " Initializing Output Action...";
	MOutputs MOutput(gemcOpt);
	map<string, MOutput_Factory> MProcessOutput_Map = Output_Map();

	// saving simulation condition in the output file
  if(MOutput.outType != "no")
  {
		MOutputBaseClass *ProcessOutput  = GetMOutputClass(&MProcessOutput_Map, MOutput.outType);
		ProcessOutput->SaveSimConditions(&MOutput, sim_condition);
		delete ProcessOutput;
	}
  
	event_action->MOut            = &MOutput;
	event_action->Out             = &MProcessOutput_Map;
	event_action->MProcessHit_Map = &MProcessHit_Map;
	event_action->SeDe_Map        = ExpHall->SeDe_Map;
	event_action->MBank_Map       = &MBank_Map;
	event_action->gen_action      = gen_action;
	
	///< passing output process factory to sensitive detectors
	map<string, MSensitiveDetector*>::iterator it;
	for(it = ExpHall->SeDe_Map.begin(); it != ExpHall->SeDe_Map.end(); it++)
		it->second->MProcessHit_Map = &MProcessHit_Map;
	

	msg = " Executing initial directives...\n";
	if(use_qt) splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
	vector<string> init_commands = init_dmesg(gemcOpt);
	for(unsigned int i=0; i<init_commands.size(); i++)
		UImanager->ApplyCommand(init_commands[i].c_str());

	string exec_macro = "/control/execute " + gemcOpt.args["EXEC_MACRO"].args;

	
	if(use_qt)
	{
    splash->showMessage("Starting GUI...");
		gemc_gui.processEvents();
		
		gemcMainWidget gemcW(runManager, visManager, &gemcOpt, ExpHall->SeDe_Map);
		gemcW.Hall_Map = &Hall_Map;
    gemcW.SeDe_Map = ExpHall->SeDe_Map;
		gemcW.mats    = &mats;
		
		gemcW.setWindowTitle( " gemc" );
		
		gemcW.show();
		splash->finish(&gemcW);

		msg = " Executing initial visual directives...\n";
		splash->showMessage(msg.c_str()); gemc_gui.processEvents(); cout << hd_msg << msg << endl;
		vector<string> init_vcommands = init_dvmesg(gemcOpt, visManager);
		for(unsigned int i=0; i<init_vcommands.size(); i++)
		{
			cout << " >> Now executing: " << init_vcommands[i].c_str() << endl;
			UImanager->ApplyCommand(init_vcommands[i].c_str());
		}
		
		if(exec_macro != "/control/execute no") UImanager->ApplyCommand(exec_macro.c_str());
		if(gemcOpt.args["N"].arg>0)
		{
			char command[100];
			sprintf(command, "/run/beamOn %d", (int) gemcOpt.args["N"].arg);
			UImanager->ApplyCommand(command);
		}

		return gemc_gui.exec();
		// deleting the visManager and runManager is now taken care 
		// in the gemc_quit slot
		// since qApp->quit() also calls an exit 
		cout << " >> Exiting gemc qApp." << endl;
		delete visManager;
    if(session != NULL) delete session;
	}
	else
	{
		if(gemcOpt.args["N"].arg>0)
		{
			char command[100];
			sprintf(command, "/run/beamOn %d", (int) gemcOpt.args["N"].arg);
			UImanager->ApplyCommand(command);
		}
		if(exec_macro != "/control/execute no") UImanager->ApplyCommand(exec_macro.c_str());
	}
	
	delete runManager;	
  return 1;
}








