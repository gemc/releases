// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"
#include "string_utilities.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <cstdio>
#include <set>
#include <cstdlib>

gemc_opts::gemc_opts()
{
	// Initialize all the options in the map<string, "args"
	//
	// The "string" of the pair in the map is the argument name: -"name"=
	// args = the string type argument
	// arg  = the numeric type argument
	// help = Long explanation.
	// name = Short description.
	// type = 1 for argumenst that are strings, 0 for numbers.
    
	// #########
	// Generator
	// #########

	args["BEAM_P"].args  = "e-, 11*GeV, 0*deg, 0*deg";
	args["BEAM_P"].help  = "Beam particle, momentum, angles (in respect of z-axis). \n";
	args["BEAM_P"].help += "      Example: -BEAM_P=\"e-, 6*GeV, 15*deg, 20*deg\" sets 6 GeV electrons 15 degrees in theta, 20 degrees in phi. \n";
	args["BEAM_P"].help += "      Use -BEAM_P=\"show_all\" to print the list of G4 supported particles.\n";
	args["BEAM_P"].name  = "Beam particle, Energy, Theta, Phi";
	args["BEAM_P"].type  = 1;
	args["BEAM_P"].ctgr  = "generator";

	args["SPREAD_P"].args  = "0*GeV, 0*deg, 0*deg";
	args["SPREAD_P"].help  = "Spread beam energy and angles (in respect of z-axis). \n";
	args["SPREAD_P"].help += "      Example: -SPREAD_P=\"0*GeV, 10*deg, 20*deg\" spreads 10 degrees in theta, 20 degrees in phi. \n";
	args["SPREAD_P"].name  = "delta_Energy, delta_Theta, delta_phi";
	args["SPREAD_P"].type  = 1;
	args["SPREAD_P"].ctgr  = "generator";

	args["ALIGN_ZAXIS"].args  = "no";
	args["ALIGN_ZAXIS"].help  = "Align z axis to a custom direction. Options:\n";
	args["ALIGN_ZAXIS"].help += "      - \"beamp\"  aligns z axis to the beam directions specified by BEAM_P.\n";
	args["ALIGN_ZAXIS"].help += "      - \"custom, theta*unit, phi*unit\" aligns z axis to a custom direction, changes BEAM_P reference frame.";
	args["ALIGN_ZAXIS"].name  = "Align z axis to a custom direction.";
	args["ALIGN_ZAXIS"].type  = 1;
	args["ALIGN_ZAXIS"].ctgr  = "generator";
	
	args["BEAM_V"].args = "(0, 0, 0) cm";
	args["BEAM_V"].help = "Beam Vertex. Example: -BEAM_V=\"(0, 0, -20)cm\". ";
	args["BEAM_V"].name = "Beam Vertex";
	args["BEAM_V"].type = 1;
	args["BEAM_V"].ctgr = "generator";

	args["SPREAD_V"].args = "(0, 0) cm";
	args["SPREAD_V"].help = "Spread Beam Radius, Z position. Example: -SPREAD_V=\"(0.1, 10)cm\". ";
	args["SPREAD_V"].name = "Vertex Spread";
	args["SPREAD_V"].type = 1;
	args["SPREAD_V"].ctgr = "generator";

	args["POLAR"].args  = "0, 0*deg, 0*deg";
	args["POLAR"].help  = "Beam particle, polarization percentage and angles  (in respect of z-axis). \n";
	args["POLAR"].help += "      Example: -POLAR=\"90, 90*deg, 270*deg\" sets 90% polarization 90 degrees in theta, 270 degrees in phi. \n";
	args["POLAR"].help += "      Use -POLAR=\"show_all\" to print the list of G4 supported particles.\n";
	args["POLAR"].name  = "Beam polarization in %, Theta, Phi";
	args["POLAR"].type  = 1;
	args["POLAR"].ctgr  = "generator";

	args["N"].arg  = 0;
	args["N"].help = "Number of events to be simulated.";
	args["N"].name = "Number of events to be simulated";
	args["N"].type = 0;
	args["N"].ctgr = "generator";

	args["INPUT_GEN_FILE"].args = "gemc_internal";
	args["INPUT_GEN_FILE"].help = "Generator Input. Current availables file formats:\n";
	args["INPUT_GEN_FILE"].help += "      LUND. \n";
	args["INPUT_GEN_FILE"].help += "      xample: -INPUT_GEN_FILE=\"LUND, input.dat\"\n";
	args["INPUT_GEN_FILE"].name = "Generator Input File";
	args["INPUT_GEN_FILE"].type = 1;
	args["INPUT_GEN_FILE"].ctgr = "generator";

	args["NGENP"].arg  = 10;
	args["NGENP"].help = "Max Number of Generated Particles to save in the Output.";
	args["NGENP"].name = "Max Number of Generated Particles to save in the Output";
	args["NGENP"].type = 0;
	args["NGENP"].ctgr = "generator";






	// ###############
	// Luminosity Beam
	// ###############

	args["LUMI_P"].args  = "e-, 11*GeV, 0*deg, 0*deg";
	args["LUMI_P"].help  = "Luminosity Beam particle, momentum, angles (in respect of z-axis). \n";
	args["LUMI_P"].help += "            Example: -LUMI_P=\"proton, 1*GeV, 25*deg, 2*deg\" sets 1 GeV protons, 25 degrees in theta, 2 degrees in phi. \n";
	args["LUMI_P"].help += "            Use -LUMI_P=\"show_all\" to print the list of G4 supported particles.\n";
	args["LUMI_P"].name  = "Luminosity Beam particle, Energy, Theta, Phi";
	args["LUMI_P"].type  = 1;
	args["LUMI_P"].ctgr = "luminosity";

	args["LUMI_V"].args = "(0, 0, -20) cm";
	args["LUMI_V"].help = "Luminosity Beam Vertex. Example: -LUMI_V=\"(0, 0, -20)cm\". ";
	args["LUMI_V"].name = "Luminosity Beam Vertex";
	args["LUMI_V"].type = 1;
	args["LUMI_V"].ctgr = "luminosity";

	args["LUMI_SPREAD_V"].args = "(0, 0) cm";
	args["LUMI_SPREAD_V"].help = "Spread Luminosity Beam Radius, Z position. Example: -SPREAD_V=\"(0.1, 10)cm\". ";
	args["LUMI_SPREAD_V"].name = "Luminosity Beam Vertex Spread";
	args["LUMI_SPREAD_V"].type = 1;
	args["LUMI_SPREAD_V"].ctgr = "luminosity";
	
	args["LUMI_EVENT"].args = "0, 0*ns, 2*ns";
	args["LUMI_EVENT"].help = "Luminosity Beam Parameters: number of Particles/Event, Time Window, Time Between Bunches\n";
	args["LUMI_EVENT"].help += "            Example: -LUMI_EVENT=\"10000, 120*ns, 2*ns\" simulate 10K particles per event distributed over 120 ns, at 2ns intervals. \n";
	args["LUMI_EVENT"].name = "Luminosity Beam Parameters";
	args["LUMI_EVENT"].type = 1;
	args["LUMI_EVENT"].ctgr = "luminosity";

	args["LUMI2_P"].args  = "proton, 50*GeV, 175*deg, 180*deg";
	args["LUMI2_P"].help  = "Luminosity Beam Particle 2, momentum, angles (in respect of z-axis). \n";
	args["LUMI2_P"].help += "            Example: -LUMI2_P=\"proton, 1*GeV, 25*deg, 2*deg\" sets 1 GeV protons, 25 degrees in theta, 2 degrees in phi. \n";
	args["LUMI2_P"].help += "            Use -LUMI2_P=\"show_all\" to print the list of G4 supported particles.\n";
	args["LUMI2_P"].name  = "Luminosity Beam particle 2, Energy, Theta, Phi";
	args["LUMI2_P"].type  = 1;
	args["LUMI2_P"].ctgr = "luminosity";
	
	args["LUMI2_V"].args = "(4, 0, 50) cm";
	args["LUMI2_V"].help = "Luminosity Beam Particle 2 Vertex. Example: -LUMI2_V=\"(0, 0, -20)cm\". ";
	args["LUMI2_V"].name = "Luminosity Beam Particle 2 Vertex";
	args["LUMI2_V"].type = 1;
	args["LUMI2_V"].ctgr = "luminosity";
	
	args["LUMI2_SPREAD_V"].args = "(0, 0) cm";
	args["LUMI2_SPREAD_V"].help = "Spread Luminosity Beam 2 Radius, Z position. Example: -SPREAD_V=\"(0.1, 10)cm\". ";
	args["LUMI2_SPREAD_V"].name = "Luminosity Beam Vertex 2 Spread";
	args["LUMI2_SPREAD_V"].type = 1;
	args["LUMI2_SPREAD_V"].ctgr = "luminosity";
	
	args["LUMI2_EVENT"].args = "0, 2*ns";
	args["LUMI2_EVENT"].help = "Luminosity Beam 2 Parameters: number of Particles/Event, Time Between Bunches. The Time Window is specified with the LUMI_EVENT flag\n";
	args["LUMI2_EVENT"].help += "            Example: -LUMI2_EVENT=\"10000, 2*ns\" simulate 10K particles per event at 2ns intervals. \n";
	args["LUMI2_EVENT"].name = "Luminosity Beam 2 Parameters";
	args["LUMI2_EVENT"].type = 1;
	args["LUMI2_EVENT"].ctgr = "luminosity";
	
	




	// ##############
	// MySQL Database
	// ##############

	args["DBHOST"].args = "clasdb.jlab.org";
	args["DBHOST"].help = "Select mysql server host name.";
	args["DBHOST"].name = "Select mysql server host name";
	args["DBHOST"].type = 1;
	args["DBHOST"].ctgr = "mysql";

	args["DATABASE"].args = "clas12_geometry";
	args["DATABASE"].help = "Select mysql Database.";
	args["DATABASE"].name = "Select mysql Database";
	args["DATABASE"].type = 1;
	args["DATABASE"].ctgr = "mysql";

	args["BANK_DATABASE"].args = "clas12_banks";
	args["BANK_DATABASE"].help = "Select mysql Bank Database.";
	args["BANK_DATABASE"].name = "Select mysql Bank Database";
	args["BANK_DATABASE"].type = 1;
	args["BANK_DATABASE"].ctgr = "mysql";

	args["DBUSER"].args = "clasuser";
	args["DBUSER"].help = "Select mysql user name";
	args["DBUSER"].name = "Select mysql user name";
	args["DBUSER"].type = 1;
	args["DBUSER"].ctgr = "mysql";

	args["DBPSWD"].args = "";
	args["DBPSWD"].help = "Select mysql password";
	args["DBPSWD"].name = "Select mysql password";
	args["DBPSWD"].type = 1;
	args["DBPSWD"].ctgr = "mysql";

	args["GT"].args = "no";
	args["GT"].help = "Selects Geometry table. This option is overwritten with the gemc read card.";
	args["GT"].name = "Geometry table";
	args["GT"].type = 1;
	args["GT"].ctgr = "mysql";






	// #########
	// Verbosity
	// #########

	args["G4P_VERBOSITY"].arg  = 1;
	args["G4P_VERBOSITY"].help = "Controls Physical Volumes Construction Log Output.";
	args["G4P_VERBOSITY"].name = "Logical Volume Verbosity";
	args["G4P_VERBOSITY"].type = 0;
	args["G4P_VERBOSITY"].ctgr = "verbosity";

	args["GEO_VERBOSITY"].arg  = 1;
	args["GEO_VERBOSITY"].help = "Controls Geometry Construction Log Output.";
	args["GEO_VERBOSITY"].name = "Geometry Verbosity";
	args["GEO_VERBOSITY"].type = 0;
	args["GEO_VERBOSITY"].ctgr = "verbosity";

	args["GUI_VERBOSITY"].arg  = 1;
	args["GUI_VERBOSITY"].help = "Controls GUI Construction Log Output.";
	args["GUI_VERBOSITY"].name = "GUI Verbosity";
	args["GUI_VERBOSITY"].type = 0;
	args["GUI_VERBOSITY"].ctgr = "verbosity";

	args["HIT_VERBOSITY"].arg  = 1;
	args["HIT_VERBOSITY"].help = "Controls Hits Log Output. ";
	args["HIT_VERBOSITY"].name = "Hit Verbosity";
	args["HIT_VERBOSITY"].type = 0;
	args["HIT_VERBOSITY"].ctgr = "verbosity";

	args["LOG_MSG"].args = "  >>> gemc";
	args["LOG_MSG"].help = "Log Messages Header.";
	args["LOG_MSG"].name = "Log Messages Header";
	args["LOG_MSG"].type = 1;
	args["LOG_MSG"].ctgr = "verbosity";

	args["CATCH"].args = "Maurizio";
	args["CATCH"].help = "Catch volumes matching the given string.";
	args["CATCH"].name = "Volume catcher";
	args["CATCH"].type = 1;
	args["CATCH"].ctgr = "verbosity";

	args["MGN_VERBOSITY"].arg  = 1;
	args["MGN_VERBOSITY"].help = "Controls Magnetic Fields Log Output.";
	args["MGN_VERBOSITY"].name = "Magnetic Fields Verbosity";
	args["MGN_VERBOSITY"].type = 0;
	args["MGN_VERBOSITY"].ctgr = "verbosity";

	args["PRINT_EVENT"].arg  = 1000;
	args["PRINT_EVENT"].help = "-PRINT_EVENT=N: Print Event Number every N events.";
	args["PRINT_EVENT"].name = "Print Event Modulus";
	args["PRINT_EVENT"].type = 0;
	args["PRINT_EVENT"].ctgr = "verbosity";

	args["OUT_VERBOSITY"].arg  = 1;
	args["OUT_VERBOSITY"].help = "Controls Bank Log Output.";
	args["OUT_VERBOSITY"].name = "Bank Output Verbosity";
	args["OUT_VERBOSITY"].type = 0;
	args["OUT_VERBOSITY"].ctgr = "verbosity";

	args["PHY_VERBOSITY"].arg  = 1;
	args["PHY_VERBOSITY"].help = "Controls Physics List Log Output.";
	args["PHY_VERBOSITY"].name = "Physics List Verbosity";
	args["PHY_VERBOSITY"].type = 0;
	args["PHY_VERBOSITY"].ctgr = "verbosity";

	args["GEN_VERBOSITY"].arg  = 0;
	args["GEN_VERBOSITY"].help = "Controls Geant4 Generator Verbosity.";
	args["GEN_VERBOSITY"].name = "Geant4 Generator Verbosity";
	args["GEN_VERBOSITY"].type = 0;
	args["GEN_VERBOSITY"].ctgr = "verbosity";

	args["G4TRACK_VERBOSITY"].arg  = 0;
	args["G4TRACK_VERBOSITY"].help = "Controls Geant4 Track Verbosity.";
	args["G4TRACK_VERBOSITY"].name = "Geant4 Track Verbosity";
	args["G4TRACK_VERBOSITY"].type = 0;
	args["G4TRACK_VERBOSITY"].ctgr = "verbosity";
  
	args["MATERIAL_VERBOSITY"].arg  = 0;
	args["MATERIAL_VERBOSITY"].help = "Controls Geant4 Material Verbosity.";
	args["MATERIAL_VERBOSITY"].name = "Geant4 Material Verbosity";
	args["MATERIAL_VERBOSITY"].type = 0;
	args["MATERIAL_VERBOSITY"].ctgr = "verbosity";
  
	args["PARAMETER_VERBOSITY"].arg  = 0;
	args["PARAMETER_VERBOSITY"].help = "Controls Parameters Verbosity.";
	args["PARAMETER_VERBOSITY"].name = "Parameters Verbosity";
	args["PARAMETER_VERBOSITY"].type = 0;
	args["PARAMETER_VERBOSITY"].ctgr = "verbosity";
  





	// ###########
	// Run Control
	// ###########

	args["EXEC_MACRO"].args = "no";
	args["EXEC_MACRO"].help = "Executes commands in macro file.";
	args["EXEC_MACRO"].name = "Executes commands in macro file";
	args["EXEC_MACRO"].type = 1;
	args["EXEC_MACRO"].ctgr = "control";

	args["CHECK_OVERLAPS"].arg  = 0;
	args["CHECK_OVERLAPS"].help  = "Checks Overlapping Volumes:\n";
	args["CHECK_OVERLAPS"].help += "      1.  Check Overlaps at Construction Time\n";
	args["CHECK_OVERLAPS"].help += "      2.  Check Overlaps based on standard lines grid setup\n";
	args["CHECK_OVERLAPS"].help += "      3.  Check Overlaps by shooting lines according to a cylindrical pattern\n";
	args["CHECK_OVERLAPS"].name = "Checks Overlapping Volumes";
	args["CHECK_OVERLAPS"].type = 0;
	args["CHECK_OVERLAPS"].ctgr = "control";

	args["USE_QT"].arg   = 1;
	args["USE_QT"].help  = "QT GUI switch\n";
	args["USE_QT"].help += "      0.  Don't use the graphical interface\n";
	args["USE_QT"].help += "      1.  QT OpenGL Immediate mode (can interact with picture; sliders works well; slower than Stored mode)\n";
	args["USE_QT"].help += "      2.  OpenGL Stored mode (can't interact with picture; sliders works well)\n";
	args["USE_QT"].help += "      3.  OpenGL Immediate mode (can't interact with picture; sliders works well; slower than Stored mode)\n";
	args["USE_QT"].help += "      4.  QT OpenGL Stored mode (can interact with picture; sliders works but picture needs to be updated by clicking on it)\n";
	args["USE_QT"].name  = "QT Gui";
	args["USE_QT"].type  = 0;
	args["USE_QT"].ctgr  = "control";
	
	args["geometry"].args="600x600";
	args["geometry"].help = "Specify the size of the QT display window. Default '600x600' ";
	args["geometry"].name="geometry";
	args["geometry"].type=1;
	args["geometry"].ctgr = "control";

	args["QTSTYLE"].args  = "no";
	args["QTSTYLE"].name  = "Sets the GUI Style";
	args["QTSTYLE"].help  = "Sets the GUI Style. Available options: \n";
	args["QTSTYLE"].help += "      - QCleanlooksStyle \n";
	args["QTSTYLE"].help += "      - QMacStyle \n";
	args["QTSTYLE"].help += "      - QPlastiqueStyle \n";
	args["QTSTYLE"].help += "      - QWindowsStyle \n";
	args["QTSTYLE"].help += "      - QMotifStyle";
	args["QTSTYLE"].type  = 1;
	args["QTSTYLE"].ctgr  = "control";
  
	args["RANDOM"].args = "TIME";
	args["RANDOM"].help = "Random Engine Initialization. The argument (seed) can be an integer or the string TIME.";
	args["RANDOM"].name = "Random Engine Initialization";
	args["RANDOM"].type = 1;
	args["RANDOM"].ctgr = "control";

	args["gcard"].args = "no";
	args["gcard"].help = "gemc card file.";
	args["gcard"].name = "gemc card file";
	args["gcard"].type = 1;
	args["gcard"].ctgr = "control";

	args["EVN"].arg  = 1;
	args["EVN"].help = "Initial Event Number.";
	args["EVN"].name = "Initial Event Number";
	args["EVN"].type = 0;
	args["EVN"].ctgr = "control";

	args["ENERGY_CUT"].arg  = -1.;
	args["ENERGY_CUT"].help = "Set an energy cut in MeV below which no particle will be tracked further. -1. turns this off.";
	args["ENERGY_CUT"].name = "Tracking Energy cut (in MeV)";
	args["ENERGY_CUT"].type = 0;
	args["ENERGY_CUT"].ctgr = "control";
	
	args["MAX_X_POS"].arg  = 30000.;
	args["MAX_X_POS"].help = "Max X Position in millimeters. Beyond this the track will be killed";
	args["MAX_X_POS"].name = "Max X Position in millimeters. Beyond this the track will be killed";
	args["MAX_X_POS"].type = 0;
	args["MAX_X_POS"].ctgr = "control";
	
	args["MAX_Y_POS"].arg  = 30000.;
	args["MAX_Y_POS"].help = "Max Y Position in millimeters. Beyond this the track will be killed";
	args["MAX_Y_POS"].name = "Max Y Position in millimeters. Beyond this the track will be killed";
	args["MAX_Y_POS"].type = 0;
	args["MAX_Y_POS"].ctgr = "control";
	
	args["MAX_Z_POS"].arg  = 30000.;
	args["MAX_Z_POS"].help = "Max Z Position in millimeters. Beyond this the track will be killed";
	args["MAX_Z_POS"].name = "Max Z Position in millimeters. Beyond this the track will be killed";
	args["MAX_Z_POS"].type = 0;
	args["MAX_Z_POS"].ctgr = "control";
	
	args["DAWN_N"].arg = 0;
	args["DAWN_N"].help = "Number of events to be displayed with the DAWN driver (also activate the DAWN driver).";
	args["DAWN_N"].name = "Number of events to be displayed with the DAWN driver (also activate the DAWN driver)";
	args["DAWN_N"].type = 0;
	args["DAWN_N"].ctgr = "control";
	
	args["HIT_PROCESS_LIST"].args = "clas12";
	args["HIT_PROCESS_LIST"].name = "Registers Hit Process Routines.";
	args["HIT_PROCESS_LIST"].help = "Registers Hit Process Routines. Can register multiple experiments, separated by space, e.v. \"clas12 aprime\"\n";
	args["HIT_PROCESS_LIST"].help += "      clas12.  CLAS12 hit process routines (default)\n";
	args["HIT_PROCESS_LIST"].help += "      aprime.  aprime hit process routines\n";
	args["HIT_PROCESS_LIST"].help += "      gluex.   GlueX  hit process routines\n";
	args["HIT_PROCESS_LIST"].type = 1;
	args["HIT_PROCESS_LIST"].ctgr = "control";
	
	args["SAVE_ALL_MOTHERS"].arg = 0;
	args["SAVE_ALL_MOTHERS"].name = "Set to 1 to save mother vertex and pid infos in output. High Memory Usage. Default is 0";
	args["SAVE_ALL_MOTHERS"].help = "Set to 1 to save mother vertex and pid infos in output. High Memory Usage. Default is 0.\n";
	args["SAVE_ALL_MOTHERS"].type = 0;
	args["SAVE_ALL_MOTHERS"].ctgr = "control";
	
	args["HIGH_RES"].arg = 1;
	args["HIGH_RES"].name = "Use High Resolution Graphics";
	args["HIGH_RES"].help = "Use High Resolution Graphics\n";
	args["HIGH_RES"].type = 0;
	args["HIGH_RES"].ctgr = "control";
	
	args["RECORD_PASSBY"].arg = 0;
	args["RECORD_PASSBY"].name = "Set to one if you want to save zero energy hits in the output. Default is 0.";
	args["RECORD_PASSBY"].help = "Set to one if you want to save zero energy hits in the output. Default is 0.\n";
	args["RECORD_PASSBY"].type = 0;
	args["RECORD_PASSBY"].ctgr = "control";
  
	args["RECORD_MIRRORS"].arg = 0;
	args["RECORD_MIRRORS"].name = "Set to one if you want to save mirror hits in the output. Default is 0.";
	args["RECORD_MIRRORS"].help = "Set to one if you want to save mirror hits in the output. Default is 0.\n";
	args["RECORD_MIRRORS"].type = 0;
	args["RECORD_MIRRORS"].ctgr = "control";
  
	args["RUNNO"].arg  = 1;
	args["RUNNO"].name = "Run Number. Controls the geometry and calibration parameters.";
	args["RUNNO"].help = "Run Number. Controls the geometry and calibration parameters.\n";
	args["RUNNO"].type = 0;
	args["RUNNO"].ctgr = "control";
  
	args["MERGE_FILE"].args  = "no";
	args["MERGE_FILE"].name  = "Merge banks from filename.";
	args["MERGE_FILE"].help  = "Merge banks from filename. Format supported: \n";
	args["MERGE_FILE"].help += "      - EVIO";
	args["MERGE_FILE"].type  = 1;
	args["MERGE_FILE"].ctgr  = "control";
  
	
	



	// ######
	// Output
	// ######

	args["OUTPUT"].args = "no, output";
	args["OUTPUT"].help = "Type of output, output filename. Supported output: evio, txt. Example: -OUTPUT=\"evio, out.ev\"";
	args["OUTPUT"].name = "Type of output, output filename. ";
	args["OUTPUT"].type = 1;
	args["OUTPUT"].ctgr = "output";






	// #######
	// Physics
	// #######
    
	args["OPT_PH"].arg  = 0;
	args["OPT_PH"].help = "Activate Optical Physics Processes in gemc Physics List.";
	args["OPT_PH"].name = "Optical Physics";
	args["OPT_PH"].type = 0;
	args["OPT_PH"].ctgr = "physics";

	args["USE_PHYSICSL"].args = "QGSC_BERT";
	args["USE_PHYSICSL"].help =  "Physics List. Avaliable choices: \n\n";
	args["USE_PHYSICSL"].help += "            * gemc: comprehensive physics list. Optical Physics may be activated with OPT_PH=1 \n\n";
	args["USE_PHYSICSL"].help += "            The following is a list of other physics lists. More infos can be found here:\n\n";
	args["USE_PHYSICSL"].help += "            http://geant4.cern.ch/support/proc_mod_catalog/physics_lists/referencePL.shtml\n\n";
	args["USE_PHYSICSL"].help += "            * LHEP: This is the main LHEP based physics list, using exclusively parameterised modeling. \n";
	args["USE_PHYSICSL"].help += "            * LHEP_BERT: Like LHEP, but using Geant4 Bertini cascade for primary protons, neutrons, \n";
	args["USE_PHYSICSL"].help += "               pions and Kaons below ~10GeV.  \n";
	args["USE_PHYSICSL"].help += "            * LHEP_BERT_HP: Like LHEP_BERT with the addition to use the data driven high precision.\n";
	args["USE_PHYSICSL"].help += "               neutron package (NeutronHP) to transport neutrons below 20 MeV down to thermal energies.\n";
	args["USE_PHYSICSL"].help += "            * QGSP:  Quark-Gluon String model based physics list. \n";
	args["USE_PHYSICSL"].help += "            * QGSP_BERT: Like QGSP, but using Geant4 Bertini cascade for primary protons, neutrons, \n";
	args["USE_PHYSICSL"].help += "               pions and Kaons below ~10GeV.  \n";
	args["USE_PHYSICSL"].help += "            * QGSP_BERT_HP: Like QGSP_BERT with the addition to use the data driven high precision.\n";
	args["USE_PHYSICSL"].help += "               neutron package (NeutronHP) to transport neutrons below 20 MeV down to thermal energies.\n";
	args["USE_PHYSICSL"].help += "            * QGSP_BIC: Like QGSP, but using Geant4 Binary cascade for primary protons and neutrons \n";
	args["USE_PHYSICSL"].help += "               with energies below ~10GeV.  \n";
	args["USE_PHYSICSL"].help += "            * QGSP_BIC_HP: Like QGSP_BIC with the addition to use the data driven high precision.\n";
	args["USE_PHYSICSL"].help += "               neutron package (NeutronHP) to transport neutrons below 20 MeV down to thermal energies.\n";
	args["USE_PHYSICSL"].help += "            * QGSC_BERT: The quark-gluon string (QGS) part handles the formation of strings in the initial\n";
	args["USE_PHYSICSL"].help += "              collision of a hadron with a nucleon in the nucleus. String fragmentation into hadrons is\n";
	args["USE_PHYSICSL"].help += "              handled by the Quark-Gluon String fragmentation model. The Chiral Invariant Phase Space (CHIPS)\n";
	args["USE_PHYSICSL"].help += "              part handles the de-excitation of the remnant nucleus. Uses Geant4 Bertini cascade for primary\n";
	args["USE_PHYSICSL"].help += "              protons, neutrons, pions and Kaons below ~10GeV. \n";
	args["USE_PHYSICSL"].name = "Choice of Physics List";
	args["USE_PHYSICSL"].type = 1;
	args["USE_PHYSICSL"].ctgr = "physics";

	args["LOW_EM_PHYS"].arg  = 0;
  args["LOW_EM_PHYS"].help = "Turn on the low energy Electro-Magnetic physics, down to the X-rat scale.\n";
	args["LOW_EM_PHYS"].help+= "     Currently only implemented for gemc physics list. \n";
  args["LOW_EM_PHYS"].help+= "         0  Turn off [default]  \n";
  args["LOW_EM_PHYS"].help+= "         1  Standard E&M down to X-rays ( ~1 kEV cutoff) \n";
  args["LOW_EM_PHYS"].name = "Low Energy Physics";
  args["LOW_EM_PHYS"].type = 0;
  args["LOW_EM_PHYS"].ctgr = "physics";
  
	args["HALL_MATERIAL"].args = "Air";
	args["HALL_MATERIAL"].help = "Composition of the Experimental Hall. \n";
	args["HALL_MATERIAL"].help += "            Air normal simulation\n";
	args["HALL_MATERIAL"].help += "            Air_Opt Simulation with Optical Physics (default)\n";
	args["HALL_MATERIAL"].help += "            Vacuum\n";
	args["HALL_MATERIAL"].name = "Composition of the Experimental Hall";
	args["HALL_MATERIAL"].type = 1;
	args["HALL_MATERIAL"].ctgr = "physics";
	
	args["DEFAULT_MATERIAL"].args = "none";
	args["DEFAULT_MATERIAL"].help = "Default material for missing material field.\n";
	args["DEFAULT_MATERIAL"].name = "Default material for missing material field";
	args["DEFAULT_MATERIAL"].type = 1;
	args["DEFAULT_MATERIAL"].ctgr = "physics";
	
	args["HALL_FIELD"].args = "no";
	args["HALL_FIELD"].help = "Magnetic Field of the Hall. \n";
	args["HALL_FIELD"].name = "Magnetic Field of the Hall";
	args["HALL_FIELD"].type = 1;
	args["HALL_FIELD"].ctgr = "physics";
	
	args["FIELD_DIR"].args = "env";
	args["FIELD_DIR"].help = "Magnetic Field Maps Location. \n";
	args["FIELD_DIR"].name = "Magnetic Field Maps Location";
	args["FIELD_DIR"].type = 1;
	args["FIELD_DIR"].ctgr = "physics";
	
	args["NO_FIELD"].args = "none";
	args["NO_FIELD"].help = "Sets Magnetic Field of a volume to zero. \"all\" means no magnetic field at all. \n";
	args["NO_FIELD"].name = "Sets Magnetic Field of a volume to zero. \"all\" means no magnetic field at all ";
	args["NO_FIELD"].type = 1;
	args["NO_FIELD"].ctgr = "physics";
	
	args["MAX_FIELD_STEP"].arg =  0;
	args["MAX_FIELD_STEP"].help = "Sets Maximum Acceptable Step in Magnetic Field (in mm).\n";
	args["MAX_FIELD_STEP"].name = "Sets Maximum Acceptable Step in Magnetic Field (in mm) ";
	args["MAX_FIELD_STEP"].type = 0;
	args["MAX_FIELD_STEP"].ctgr = "physics";
	
	args["SCALE_FIELD"].args  = "no, 1";
	args["SCALE_FIELD"].help  = "Scales Magnetic Field by a factor.\n";
	args["SCALE_FIELD"].help += "      Usage:\n";
	args["SCALE_FIELD"].help += "      -SCALE_FIELD=\"fieldname, scalefactor\"\n";
	args["SCALE_FIELD"].help += "      Example: -SCALE_FIELD=\"srr-solenoid, 0.5\"\n";
	args["SCALE_FIELD"].name  = "Scales Magnetic Field by a factor ";
	args["SCALE_FIELD"].type  = 1;
	args["SCALE_FIELD"].ctgr  = "physics";
	
	args["MATERIALSDB"].args  = "CPP";
	args["MATERIALSDB"].help  = "Select Materials DB. \n";
	args["MATERIALSDB"].help += "  Available Databases: \n";
	args["MATERIALSDB"].help += "  * CPP: use the normal geant4 c++ constructor.\n";
	args["MATERIALSDB"].help += "  * MYSQL: use the mysql DB.\n";
	args["MATERIALSDB"].name  = "Select Materials DB. ";
	args["MATERIALSDB"].type  = 1;
	args["MATERIALSDB"].ctgr  = "physics";
	
	
	
	
	
	
	// #######
	// General
	// #######
	
	args["PARAMETERSDB"].args  = "MYSQL";
	args["PARAMETERSDB"].help = "Select Parameters DB. \n";
	args["PARAMETERSDB"].help += "  Available Databases: \n";
	args["PARAMETERSDB"].help += "  * MYSQL: use the mysql DB.\n";
	args["PARAMETERSDB"].name = "Select Parameters DB";
	args["PARAMETERSDB"].type = 1;
	args["PARAMETERSDB"].ctgr = "general";

	args["DC_MSTAG_R3"].arg  = 0.0;
	args["DC_MSTAG_R3"].help = "Mini Stagger for Region 3. Each layer will alternate +- |this value|";
	args["DC_MSTAG_R3"].name = "Mini Stagger for Region 3. Each layer will alternate +- |this value|";
	args["DC_MSTAG_R3"].type = 0;
	args["DC_MSTAG_R3"].ctgr = "general";

	args["DC_MSTAG_R2"].arg  = 0.0;
	args["DC_MSTAG_R2"].help = "Mini Stagger for Region 2. Each layer will alternate +- |this value|";
	args["DC_MSTAG_R2"].name = "Mini Stagger for Region 2. Each layer will alternate +- |this value|";
	args["DC_MSTAG_R2"].type = 0;
	args["DC_MSTAG_R2"].ctgr = "general";

}

gemc_opts::~gemc_opts(){}

void gemc_opts::Scan_gcard(string file)
{
	// If found, parse the <options> section of the file.
	QDomDocument domDocument;
    
	cout << "  >>> gemc Init: >>  Parsing " << file << " for options: \n";
    
	QFile gcard(file.c_str());
    
	if( !gcard.exists() )
	{
		cout << "  >>> gemc Init: >>  gcard: " << file <<" not found. Exiting." << endl;
		exit(0);
	}
    
	if (!domDocument.setContent(&gcard))
	{
		gcard.close();
		cout << "  >>> gemc Init: >>  gcard format is wrong - check XML syntax. Exiting." << endl;
		exit(0);
	}
	
	gcard.close();
    
	QDomElement docElem = domDocument.documentElement(); ///< reading gcard file
	QDomNode n;

	map<string, int> count;
	map<string,opts>::iterator itm;
	for(itm = args.begin();itm != args.end(); itm++)
		count[itm->first] = 0;

    
	n = docElem.firstChild(); ///< looping over options.
	while(!n.isNull())
	{
		QDomElement e = n.toElement();                ///< converts the node to an element.
		if(!e.isNull())                               ///< the node really is an element.
    if(e.tagName().toStdString() == "option")     ///< selecting "option" nodes
		{
      int found=0;
      for(itm = args.begin();itm != args.end(); itm++)
			{
				// looking for a valid option. If a two instances of the same option exist
				// the string __REPETITION__ will be appended
				if(e.attributeNode("name").value().toStdString() == itm->first )
				{
					if(count[itm->first] == 0)
					{

						itm->second.args =      e.attributeNode("value").value().toStdString();
						itm->second.arg  = atof(e.attributeNode("value").value().toStdString().c_str());
						cout << "  >>> gemc Init: >>  Options: " << itm->second.name << " set to: ";
						if(itm->second.type) cout << itm->second.args;
						else                 cout << itm->second.arg;
						cout << endl;
					}
					
					found = 1;
					count[itm->first] += 1;

					if(count[itm->first]>1)
					{
						string new_opt = itm->first + "__REPETITION__" + stringify(count[itm->first] - 1);
						args[new_opt].args = e.attributeNode("value").value().toStdString();
						args[new_opt].arg  = atof(e.attributeNode("value").value().toStdString().c_str());
						args[new_opt].name = itm->second.name;
						args[new_opt].help = itm->second.help;
						args[new_opt].type = itm->second.type;
						args[new_opt].ctgr = itm->second.ctgr;
						cout << "  >>> gemc Init: >>  Options: " << itm->second.name << " set to: ";
						if(itm->second.type) cout << itm->second.args;
						else                 cout << itm->second.arg;
						cout << endl;
					}
					break;
				}
			}
      if( found == 0 )
			{
				cout << "The option in the gcard file " << e.attributeNode("name").value().toStdString()
             << " is not known to this system. Please check your spelling. \n\n";
        exit(3);
			}
		}
 
		// now looking for child arguments
		QDomNode nn= e.firstChild();
		while( !nn.isNull() && e.tagName().toStdString() == "option")
		{
			QDomElement ee = nn.toElement();
      map<string,opts>::iterator itm;
      int found=0;
      for(itm = args.begin();itm != args.end(); itm++)
			{
				if(ee.tagName().toStdString() == itm->first )
				{
					itm->second.args= ee.attributeNode("value").value().toStdString();
          itm->second.arg = atof(ee.attributeNode("value").value().toStdString().c_str());
          cout << "  >>> gemc Init: >>  Options: " << itm->second.name << " set to:";
          if(itm->second.type) cout << itm->second.args;
          else                 cout << itm->second.arg;
          cout << endl;
          found = 1;
				}
			}
      if( found == 0 )
			{
				cout << "The option in the gcard file " << e.attributeNode("name").value().toStdString()
						 << " is not known to this system. Please check your spelling. \n\n";
				exit(3);
			}
			nn = nn.nextSibling();
            
		}
		n = n.nextSibling();
	}
	gcard.close();    
}



int gemc_opts::Set(int argc, char **argv)
{
	string arg;
	string com;
	string opt;
	cout << endl;
	string comp;

	map<string, opts>::iterator itm;

	set<string> category;

	// Check the command line for the -gcard=file option.
	// Then call the parser for the gcard file that reads all the options.
	// This must be done BEFORE the commandline is parsed, so that command line
	// options override the options in the file.

	size_t pos;
	string file;
    
	// Look for -gcard :
	for(int i=1;i<argc;i++)
	{
		arg = argv[i]; 
		if( (pos=arg.find("gcard="))!= string::npos)
		{
			file = arg.substr(pos+6);
			Scan_gcard(file);
		}
	}
    
    
	// Filling Categories
	for(itm = args.begin(); itm != args.end(); itm++)
		if(category.find(itm->second.ctgr) == category.end()) category.insert(itm->second.ctgr);


	// -help-all
	for(int i=1; i<argc; i++)
	{
		arg = argv[i];
		com = "-help-all";
		if(arg == com)
		{
			cout <<  "    Usage: -Option=<option>" << endl << endl;
			cout <<  "    Options:" <<  endl << endl ;

			for(itm = args.begin(); itm != args.end(); itm++)
				cout <<  "   > Option " <<  itm->first << ": " << itm->second.help << endl;

			cout << endl << endl;
			exit(0);
		}
	}


	// -help
	set<string> :: iterator itcat;
	for(int i=1; i<argc; i++)
	{
		arg = argv[i];
		com = "-help";
		if(arg == com)
		{
			cout <<  endl << endl;
			cout <<  "    Help Options:" <<  endl << endl ;
			cout <<  "   >  -help-all:  all available options. " <<  endl << endl;
			for(itcat = category.begin(); itcat != category.end(); itcat++)
			{

				cout <<  "   >  -help-" << *itcat << "     ";
				cout.width(15);
				cout << *itcat << " options." << endl;
			}
			cout << endl << endl;
			exit(0);
		}
	}


	// -help-option
	for(int i=1; i<argc; i++)
	{
		arg = argv[i];
		for(itcat = category.begin(); itcat != category.end(); itcat++)
		{
			com = "-help-" + *itcat;
			if(arg == com)
			{
				cout << endl << endl <<  "   ## " << *itcat << " ## " << endl << endl;
				cout << "    Usage: -Option=<option>" << endl << endl;
				for(itm = args.begin(); itm != args.end(); itm++)
					if(itm->second.ctgr == *itcat) cout <<  "   > " <<  itm->first << ": " << itm->second.help << endl;
				cout << endl << endl;
				exit(0);
			}
		}
	}


	// -help-html
	for(int i=1; i<argc; i++)
	{
		arg = argv[i];
		for(itcat = category.begin(); itcat != category.end(); itcat++)
		{
			com = "-help-html";
			if(arg == com)
			{
				ofstream hf;
				hf.open("gemc_help.html");
				hf << "<html>" << endl;
				hf << "	<STYLE TYPE=\"text/css\">" << endl;
				hf << "<!--" << endl;
				hf << ".pretty-table" << endl;
				hf << "{" << endl;
				hf << "	padding: 0;" << endl;
				hf << "	margin: 0;" << endl;
				hf << "	border-collapse: collapse;" << endl;
				hf << "	border: 1px solid #333;" << endl;
				hf << "	font-family: \"Trebuchet MS\", Verdana, Arial, Helvetica, sans-serif;" << endl;
				hf << "	font-size: 0.8em;" << endl;
				hf << "	color: #000;" << endl;
				hf << "	background: #bcd0e4;" << endl;
				hf << "}" << endl;
				hf << ".pretty-table caption" << endl;
				hf << "{" << endl;
				hf << "	caption-side: bottom;" << endl;
				hf << "	font-size: 0.9em;" << endl;
				hf << "	font-style: italic;" << endl;
				hf << "	text-align: right;" << endl;
				hf << "	padding: 0.5em 0;" << endl;
				hf << "}" << endl;
				hf << ".pretty-table th, .pretty-table td" << endl;
				hf << "{" << endl;
				hf << "	border: 1px dotted #666;" << endl;
				hf << "	padding: 0.5em;" << endl;
				hf << "	text-align: left;" << endl;
				hf << "	color: #632a39;" << endl;
				hf << "}" << endl;
				hf << ".pretty-table th[scope=col]" << endl;
				hf << "{" << endl;
				hf << "	color: #000;" << endl;
				hf << "	background-color: #8fadcc;" << endl;
				hf << "	text-transform: uppercase;" << endl;
				hf << "	font-size: 0.9em;" << endl;
				hf << "	border-bottom: 2px solid #333;" << endl;
				hf << "	border-right: 2px solid #333;" << endl;
				hf << "}" << endl;
				hf << ".pretty-table th+th[scope=col]" << endl;
				hf << "{" << endl;
				hf << "	color: #009;" << endl;
				hf << "	background-color: #7d98b3;" << endl;
				hf << "	border-right: 1px dotted #666;" << endl;
				hf << "}" << endl;
				hf << ".pretty-table th[scope=row]" << endl;
				hf << "{" << endl;
				hf << "	background-color: #b8cfe5;" << endl;
				hf << "	border-right: 2px solid #333;" << endl;
				hf << "}" << endl;
				hf << "pre{font-family:Helvetica;font-size:12pt}" << endl;

				hf << "--->" << endl;
				hf << "</STYLE>" << endl;
				hf << "</head>" << endl;
				hf << "<body>" << endl;
				hf << "<br><br>" << endl;
				hf << "<center>" << endl;
				hf << "<h1> GEMC options</h1>" << endl;
				hf << "</center>" << endl;
				hf << "<br><br><br>" << endl;
				hf << "<table cellsize=20>" << endl;
				hf << "<tr><td>" << endl;
				hf << "<table class=\"pretty-table\">" << endl;
				hf << "<caption>gemc options. This table is produced with the gemc option: gemc -help-html </caption>" << endl;
				hf << "<tr><th scope=\"col\" >Category</th>" << endl;
				hf << "    <th scope=\"col\" >Option</th>" << endl;
				hf << "    <th scope=\"col\" >Help</th></tr>" << endl;
				for(itcat = category.begin(); itcat != category.end(); itcat++)
					for(itm = args.begin(); itm != args.end(); itm++)
						if(itm->second.ctgr == *itcat) 
						{
							hf << "<tr><th scope=\"row\">";
							hf << *itcat ;
					
							hf << "</th> <td>";
							hf << itm->first;
							hf << "</td><td><pre>" << endl;
							hf << itm->second.help;
							hf << "</pre></td></tr>" << endl;
						}

				
				hf << "</table>" << endl;
				hf << "</td>" << endl;
				hf << "<td>" << endl;
				hf << "</table>" << endl;
				hf << " </body></html>";
				
				hf.close();
				exit(0);
			}
		}
	}
	
	map<string, int> count;
	for(itm = args.begin();itm != args.end(); itm++)
		count[itm->first] = 0;

	for(int i=1; i<argc; i++)
	{
		arg = argv[i];
		int found=0;
		for(itm = args.begin(); itm != args.end(); itm++)
		{
			com = "-" + itm->first + "=";
			comp.assign(arg, 0, arg.find("=") + 1);
			if(comp == com)
			{
				opt.assign(arg, com.size(), arg.size()-com.size());
				if(count[itm->first] == 0)
				{
					itm->second.args = opt;
					itm->second.arg  = atof(opt.c_str());
					cout <<  " >>> Options: " << itm->second.name << " set to: " ;
					if(itm->second.type) cout << itm->second.args;
					else cout << itm->second.arg  ;
					cout << endl;
				}
				found=1;
				count[itm->first] += 1;
				if(count[itm->first]>1)
				{
					string new_opt = itm->first + "__REPETITION__" + stringify(count[itm->first]-1);
					args[new_opt].args  = opt;
					args[new_opt].arg   = atof(opt.c_str());
					args[new_opt].name  = itm->second.name;
					args[new_opt].help  = itm->second.help;
					args[new_opt].type  = itm->second.type;
					args[new_opt].ctgr  = itm->second.ctgr;
					
					cout <<  " >>> Options: " << itm->second.name << " set to: " ;
					if(itm->second.type) cout << args[new_opt].args;
					else cout << args[new_opt].arg  ;
					cout << endl;
				}            
				break;
			}
		}
		//
		// For MAC OS X, we want to ignore the -psn_# type argument. This argument is added by
		// the system when launching an application as an "app", and # contains the process id.
		//
		if( found == 0 && strncmp(argv[i],"-psn_",4) !=0 )
		{
			cout << "The argument " << argv[i] << " is not known to this system. \n\n";
			exit(2);
		}        
	}

	cout << endl;

	return 1;
}
 
vector<opts> gemc_opts::get_args(string opt)
{
	map<string, opts>::iterator itm;
	vector<opts> options;
	map<string, int> count;
	for(itm = args.begin();itm != args.end(); itm++)
	{
		if(itm->first.find(opt) != string::npos)
		{
			options.push_back(itm->second);
		} 
	}

	return options;
}















