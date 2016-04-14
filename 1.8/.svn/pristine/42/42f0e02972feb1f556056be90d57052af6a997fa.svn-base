/// \file MSensitiveDetector.h
/// Defines the gemc Sensitive Detector class
/// and the SDId class.\n
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n
#ifndef MSensitiveDetector_H
#define MSensitiveDetector_H 1

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4VSensitiveDetector.hh"
#include "G4Step.hh"
#include "G4HCofThisEvent.hh"
#include "G4TouchableHistory.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "detector.h"
#include "MHit.h"
#include "MPHBaseClass.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <iostream>
#include <string>
#include <set>
using namespace std;


/// \class SDId
/// <b> SDId</b>\n\n
/// This class contains the maximum number of elements
/// for each identifier class.\n
/// At construction time the IDshifts are defined by
/// the first 2^IDshifts that is greater than IDmaxs.\n
/// The result is used for bit-packing the volume identity.
class SDId
{
 public:
   int id;                        ///< Sensitive Detector identifier. This is also the bank ID.
   vector<string> IDnames;        ///< Identifier names as they should be in identifier
   double         minEnergy;      ///< Minimum energy of the hit to be recorded in the output stream
   double         TimeWindow;     ///< If two steps happens withing the same TimeWindow, they belong to the same Hit.
   double         ProdThreshold;  ///< Production Threshold in the detector
   double         MaxStep;        ///< Maximum Acceptable Step in the detector
};


/// \class MSensitiveDetector
/// <b> MSensitiveDetector </b>\n\n
/// This is the gemc Sensitive Detector.\n
/// When a track enters a volume associated with this SD, the 
/// ProcessHits routine is called. ProcessHits builds the MHit and
/// adds it in the MHitCollection.\n
/// At the end of event, each MHitCollection instantiate the
/// MPHB_Factory relative to the Hit Process and calls its method ProcessHit.\n
class MSensitiveDetector : public G4VSensitiveDetector
{
	public:
		MSensitiveDetector(G4String, gemc_opts);                     ///< Constructor
		virtual ~MSensitiveDetector();
	
		virtual void Initialize(G4HCofThisEvent*);                   ///< Virtual Method called at the beginning of each hit event
		virtual G4bool ProcessHits(G4Step*, G4TouchableHistory*);    ///< Virtual Method called for each step of each hit
		virtual void EndOfEvent(G4HCofThisEvent*);                   ///< Virtual Method called at the end of each hit event
	
		G4String HCname;                                             ///< Sensitive Detector/Hit Collection Name
		map<string, detector>          *Hall_Map;                    ///< detector map
		map<string, MPHB_Factory>      *MProcessHit_Map;             ///< Hit Process Routine Factory Map
		set<vector<identifier> >        Id_Set;                      ///< Identifier Set. Used to determine if a step is inside a new/existing element.
	
		gemc_opts gemcOpt;                                           ///< gemc option class
		SDId      SDID;                                              ///< SDId used for identification
	
	private:
		MHitCollection *hitCollection;                               ///< G4THitsCollection<MHit>
		MPHBaseClass   *ProcessHitRoutine;                           ///< To call PID
		int             HCID;                                        ///< HCID increases every new hit collection.
		double          minEnergy;
	
		string hd_msg1;        ///< New Hit message
		string hd_msg2;        ///< Normal Message
		string hd_msg3;        ///< End of hit Collection message
		string catch_v;        ///< Volume Name for Verbosity
		double HIT_VERBOSITY;  ///< Hit Verbosity
		double RECORD_PASSBY;  ///< If set to one, records particles even if they do not leave any energy
		double RECORD_MIRROR;  ///< If set to one, records particles in the mirror detectors
	
	 
 public:
    vector<identifier> GetDetectorIdentifier(string name) {return (*Hall_Map)[name].identity;} ///< returns detector identity
    string GetDetectorHitType(string name)                {return (*Hall_Map)[name].hitType;}  ///< returns detector hitType
    MHitCollection* GetMHitCollection()                   {if(hitCollection) return hitCollection; else return NULL;}              ///< returns hit collection
    MHit* find_existing_hit(vector<identifier>);                                               ///< returns hit collection hit inside identifer
};

SDId get_SDId(string, gemc_opts);   ///< Connects to DB and retrieve SDId

#endif










