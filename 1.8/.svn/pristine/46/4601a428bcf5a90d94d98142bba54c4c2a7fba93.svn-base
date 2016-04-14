// %%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%
#include "MPHBaseClass.h"
#include "HitProcess_MapRegister.h"

// CLAS12
#include "BST_hitprocess.h"          ///< Barrel SVT
#include "FST_hitprocess.h"          ///< Forward SVT
#include "FMT_hitprocess.h"          ///< Forward MM Tracker
#include "FTM_hitprocess.h"          ///< Forward Tagger MM
#include "BMT_hitprocess.h"          ///< Barrel MM Tracker
#include "CTOF_hitprocess.h"         ///< Central TOF
#include "CND_hitprocess.h"          ///< Central Neutron Detector
#include "DC_hitprocess.h"           ///< Drift Chambers
#include "IC_hitprocess.h"           ///< Inner Calorimeter
#include "FT_hitprocess.h"           ///< Forward Tagger Calorimeter
#include "FTH_hitprocess.h"          ///< Forward Tagger Hodoscope
#include "OTOF_hitprocess.h"         ///< Outer TOF
#include "EC_hitprocess.h"           ///< EC
#include "ECwithG4strips_hitprocess.h"           ///< EC with scintillator strips instead of a single plane
#include "PCAL_hitprocess.h"         ///< PCAL
#include "raw_hitprocess.h"          ///< raw hit
#include "flux_hitprocess.h"         ///< FLUX hit
#include "RICH_hitprocess.h"         ///< RICH hit
#include "LTCC_hitprocess.h"         ///< LTCC hit
#include "HTCC_hitprocess.h"         ///< LTCC hit

// APrime
#include "HS_hitprocess.h"
#include "STR_hitprocess.h"

// GlueX 
#include "CVRT_hitprocess.h"       ///< Hit in Converter


map<string, MPHB_Factory> HitProcess_Map(string experiments)
{

	map<string, MPHB_Factory> hitMap;
	
	stringstream exps(experiments);	
	string EXP;
	
	cout << endl;
	while(!exps.eof())
	{
		exps >> EXP;
		cout << "  >> Registering experiment \"" << EXP << "\" hit processes " << endl;

		// CLAS12
		if(EXP == "clas12")
		{
			hitMap["BST"]     = &BST_HitProcess::createHitClass;
			hitMap["FST"]     = &FST_HitProcess::createHitClass;
			hitMap["FMT"]     = &FMT_HitProcess::createHitClass;
			hitMap["FTM"]     = &FTM_HitProcess::createHitClass;
			hitMap["BMT"]     = &BMT_HitProcess::createHitClass;
			hitMap["CTOF"]    = &CTOF_HitProcess::createHitClass;
			hitMap["CND"]     = &CND_HitProcess::createHitClass;
			hitMap["DC"]      = &DC_HitProcess::createHitClass;
			hitMap["FTOF_1a"] = &OTOF_HitProcess::createHitClass;
			hitMap["FTOF_1b"] = &OTOF_HitProcess::createHitClass;
			hitMap["FTOF_2b"] = &OTOF_HitProcess::createHitClass;
			hitMap["IC"]      = &IC_HitProcess::createHitClass;
			hitMap["FT"]      = &FT_HitProcess::createHitClass;
			hitMap["FTH"]     = &FTH_HitProcess::createHitClass;
			hitMap["Bonus"]   = &raw_HitProcess::createHitClass;
			hitMap["raw"]     = &raw_HitProcess::createHitClass;
			hitMap["EC"]      = &EC_HitProcess::createHitClass;
			hitMap["ECwithG4strips"] = &ECwithG4strips_HitProcess::createHitClass;
			hitMap["PCAL"]    = &PCAL_HitProcess::createHitClass;
			hitMap["FLUX"]    = &flux_HitProcess::createHitClass;
			hitMap["Mirrors"] = &flux_HitProcess::createHitClass; // mirrors will call FLUX
			hitMap["RICH"]    = &RICH_HitProcess::createHitClass;
			hitMap["LTCC"]    = &LTCC_HitProcess::createHitClass;
			hitMap["HTCC"]    = &HTCC_HitProcess::createHitClass;
		}
		// Aprime
		else if(EXP == "aprime")
		{
			hitMap["HS"]      = &HS_HitProcess::createHitClass;
			hitMap["STR"]     = &STR_HitProcess::createHitClass;
			hitMap["FLUX"]    = &flux_HitProcess::createHitClass;
			hitMap["raw"]     = &raw_HitProcess::createHitClass;
			hitMap["IC"]      = &IC_HitProcess::createHitClass;
		} 
		// GlueX
		else if( EXP == "gluex" ) {
		  hitMap["raw"]     = &raw_HitProcess::createHitClass;
		  hitMap["IC"]      = &IC_HitProcess::createHitClass;
		  hitMap["FLUX"]    = &flux_HitProcess::createHitClass;
		  hitMap["CVRT"]    = &CVRT_HitProcess::createHitClass;
		}
		// SoLID
		else if( EXP == "solid" ) {
		  hitMap["raw"]     = &raw_HitProcess::createHitClass;
		  hitMap["FLUX"]    = &flux_HitProcess::createHitClass;
		}		
	}
	cout << endl;
	return hitMap;

}
