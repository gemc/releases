/// \file MEventAction.h
/// Derived from G4UserEventAction.\n
/// The two functions:
/// - BeginOfEventAction
/// - EndOfEventAction
/// define the routines at the begin
/// and at the end of each event.\n
/// In EndOfEventAction the output is processed and
/// written out (if the output option is selected).\n
/// The event number is initialized and increased.
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n
#ifndef MEventAction_H
#define MEventAction_H 1

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UserEventAction.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MOutputBaseClass.h"
#include "MBankdefs.h"
#include "MPHBaseClass.h"
#include "MSensitiveDetector.h"
#include "usage.h"
#include "MPrimaryGeneratorAction.h"



/// \class TInfos
/// <b> TInfos </b>\n\n
/// Contains:
/// - particle ID (int from PDG encoding).
/// - mother particle ID.
/// - vertex
/// - mother particle vertex.\n
/// For ions:
/// Nuclear codes are given as 10-digit numbers +-100ZZZAAAI.\n
/// For a nucleus consisting of np protons and nn neutrons \n
/// A = np + nn and Z = np.\n
/// I gives the isomer level, with I = 0 corresponding \n
/// to the ground state and I >0 to excitations \n
class TInfos
{
	public:
		TInfos(){;}
		TInfos(int MTID)
		{
			mtid = MTID;
			mpid = 0;
			mv   = G4ThreeVector(0.,0.,0.);
		}
		~TInfos(){;}

	public:
		int mtid;
		int mpid;
		
		G4ThreeVector mv;
};

vector<int> vector_mtids(  map<int, TInfos> tinfos, vector<int> tids);
vector<int> vector_mpids(  map<int, TInfos> tinfos, vector<int> tids);
vector<G4ThreeVector> vector_mvert(  map<int, TInfos> tinfos, vector<int> tids);
vector<int>           vector_zint(  int size);  ///< provides a vector of 0
vector<G4ThreeVector> vector_zthre( int size);  ///< provides a vector of (0,0,0)


/// \class MEventAction
/// <b> MEventAction </b>\n\n
/// Derived from G4UserEventAction.\n
/// The two functions:
/// - BeginOfEventAction
/// - EndOfEventAction
/// define the routines at the begin
/// and at the end of each event.\n
/// In EndOfEventAction the output is written out
/// (if the output option is selected)
class MEventAction : public G4UserEventAction
{
	public:
		MEventAction(gemc_opts, map<string, double>);       ///< Constructor copies gemc options
		~MEventAction();                                    ///< Destructor
		
		gemc_opts gemcOpt;                                  ///< gemc options
		
		MOutputs                         *MOut;             ///< MOutputs class - contains the output format.
		map<string, MOutput_Factory>     *Out;              ///< MOutput_Factory map
		map<string, MSensitiveDetector*>  SeDe_Map;         ///< Sensitive detector Map
		map<string, MPHB_Factory>        *MProcessHit_Map;  ///< Hit Process Routine Factory Map
		map<string, MBank>               *MBank_Map;        ///< Bank Map
		map<string, double>               gPars;            ///< Parameters Map
    MPrimaryGeneratorAction           *gen_action;      ///< Generator Action
    
		int    evtN;            ///< Event Number
		string hd_msg;          ///< Event Action Message
		int    Modulo;          ///< Print Log Event every Modulo
		double VERB;            ///< Event Verbosity
		string catch_v;         ///< Print Log for volume
    int   SAVE_ALL_MOTHERS; ///< Loops over the stored trajectories to store mother vertex and pid in the output
		int   MAXP;             ///< Max number of generated particles to save on output stream
    
	public:
		void BeginOfEventAction(const G4Event*);            ///< Routine at the start of each event
		void EndOfEventAction(const G4Event*);              ///< Routine at the end of each event
		void SetEvtNumber(int N){evtN = N;}                 ///< Sets Event Number
		
};

#endif




