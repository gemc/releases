// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4SDManager.hh"
#include "G4UnitsTable.hh"
#include "G4ParticleTypes.hh"


// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "identifier.h"
#include "MSensitiveDetector.h"


MSensitiveDetector::MSensitiveDetector(G4String name, gemc_opts opt):G4VSensitiveDetector(name), gemcOpt(opt), HCID(-1)
{
	HCname = name;
	collectionName.insert(HCname);
  hitCollection = NULL;
	SDID = get_SDId(HCname, gemcOpt);
	minEnergy = SDID.minEnergy;

	hd_msg1 = gemcOpt.args["LOG_MSG"].args + " New Hit: <<< ";
	hd_msg2 = gemcOpt.args["LOG_MSG"].args + " > ";
	hd_msg3 = gemcOpt.args["LOG_MSG"].args + " End of Hit Collections >> ";
	catch_v = gemcOpt.args["CATCH"].args;
	HIT_VERBOSITY = gemcOpt.args["HIT_VERBOSITY"].arg;
	RECORD_PASSBY = gemcOpt.args["RECORD_PASSBY"].arg;
	RECORD_MIRROR = gemcOpt.args["RECORD_MIRRORS"].arg;
}

MSensitiveDetector::~MSensitiveDetector(){}


void MSensitiveDetector::Initialize(G4HCofThisEvent* HCE)
{
	Id_Set.clear();
	hitCollection = new MHitCollection(HCname, collectionName[0]);
	if(HCID < 0)  HCID = G4SDManager::GetSDMpointer()->GetCollectionID(collectionName[0]);
	HCE->AddHitsCollection( HCID, hitCollection );
	ProcessHitRoutine = NULL;
}



G4bool MSensitiveDetector::ProcessHits(G4Step* aStep, G4TouchableHistory*)
{
	// First check on energy deposited
	double depe = aStep->GetTotalEnergyDeposit();
	// don't enter if RECORD_PASSBY is not set and it's not an optical photon
	// Notice: a gamma will not directly release energy on a scintillator
	// but will convert, and the pair will release energy
	// so by default right now gammas are not recorded 
	// change this ?
	if(depe == 0 && RECORD_PASSBY == 0 && aStep->GetTrack()->GetDefinition() != G4OpticalPhoton::OpticalPhotonDefinition()) return false;

	// do not record Mirrors unless specified
  if(HCname == "Mirrors" && RECORD_MIRROR == 0) return false;

	G4Track *trk = aStep->GetTrack();
	if(trk->GetDefinition()->GetParticleName().find("unknown") != string::npos) return false;
	
	G4StepPoint   *prestep   = aStep->GetPreStepPoint();
	G4StepPoint   *poststep  = aStep->GetPostStepPoint();
	
	G4VTouchable* TH = (G4VTouchable*) aStep->GetPreStepPoint()->GetTouchable();

	///< Hit informations
	///< The hit position is taken from PostStepPoint (inside the sensitive volume)
	///< Transformation to local coordinates has to be done with prestep
	double         Dx      = aStep->GetStepLength();
	string         name    = TH->GetVolume(0)->GetName();                                     ///< Volume name
	G4ThreeVector   xyz    = poststep->GetPosition();                                         ///< Global Coordinates of interaction
	G4ThreeVector  Lxyz    = prestep->GetTouchableHandle()->GetHistory()                      ///< Local Coordinates of interaction
														  ->GetTopTransform().TransformPoint(xyz);
	G4ThreeVector  vert    = trk->GetVertexPosition();   
	double         ctime   = poststep->GetGlobalTime();                                       ///< Time of step
	G4ThreeVector  pxyz    = prestep->GetMomentum();                                          ///< Track Momentum (before entering the volume)
	double         ene     = prestep->GetTotalEnergy();                                       ///< Track Energy (before entering the volume)
	int            tid     = trk->GetTrackID();                                               ///< Track ID
	int            pid     = trk->GetDefinition()->GetPDGEncoding();                          ///< Track PID
	int            q       = (int) trk->GetDefinition()->GetPDGCharge();                      ///< Track Charge
	vector<identifier> VID = SetId(GetDetectorIdentifier(name), TH,
																 ctime, SDID.TimeWindow, tid);                              ///< Identifier at the geant4 level
		
	///< Check on the ProcessHitRoutine to calculate the new vector<identifier>
	if(ProcessHitRoutine == NULL)
  {
    ProcessHitRoutine = GetMPHClass(MProcessHit_Map, GetDetectorHitType(name));
  }
  
	if(!ProcessHitRoutine)
	{
		cout << endl << hd_msg2 << " Hit Process Routine <" << GetDetectorHitType(name) << "> not found. Exiting. " << endl;
		exit(0);
	}

	///< Process VID: getting Identifier at the ProcessHitRoutine level
	vector<identifier> PID = ProcessHitRoutine->ProcessID(VID, aStep, (*Hall_Map)[name], gemcOpt);
	int singl_hit_size = VID.size();
	int multi_hit_size = PID.size()/singl_hit_size;

	// splitting PIDs into an array
	for(int mh = 0; mh<multi_hit_size; mh++)
	{
		vector<identifier> mhPID;

		for(int this_id = 0; this_id<singl_hit_size; this_id++)
		{
			identifier this_shit; // adding this single hit
			this_shit.name       = PID[this_id + mh*singl_hit_size].name;
			this_shit.rule       = PID[this_id + mh*singl_hit_size].rule;
			this_shit.id         = PID[this_id + mh*singl_hit_size].id;
			this_shit.time       = PID[this_id + mh*singl_hit_size].time;
			this_shit.TimeWindow = PID[this_id + mh*singl_hit_size].TimeWindow;
			this_shit.TrackId    = PID[this_id + mh*singl_hit_size].TrackId;
			this_shit.id_sharing = PID[this_id + mh*singl_hit_size].id_sharing;
			mhPID.push_back(this_shit);
		}
		
		if(HIT_VERBOSITY > 9 || name.find(catch_v) != string::npos)
			cout << endl << hd_msg2 << " Before hit Process Identification:"  << endl << VID
			<< hd_msg2 << " After:  hit Process Identification:" << endl << mhPID << endl;
	
		///< Checking if it's new hit or existing hit. Use the overloaded "=="
		if(HIT_VERBOSITY > 9) cout << endl << endl << " BEGIN SEARCH for same hit in Identifier Set..." << endl;
		
		set<vector<identifier> > :: iterator itid;
		int hit_found = 0;
		
		for(itid = Id_Set.begin(); itid!= Id_Set.end() && !hit_found; itid++)
		{
			if(*itid == mhPID)  hit_found=1;
			if(HIT_VERBOSITY > 9 )
				cout << "   >> Current Step:  " << mhPID
				<< "   >> Set Hit Index: " << *itid
				<< (hit_found ? "   >> FOUND at this Set Entry. " : "   >> Not found yet. ") << endl;
		}
		if(HIT_VERBOSITY > 10) cout << " SEARCH ENDED." << (hit_found ? " 1 " : " No ") << "hit found in the Set." << endl << endl;
	
		
		
		// New Hit
		if(!hit_found)
		{
			MHit *thisHit = new MHit();
			thisHit->SetPos(xyz);
			thisHit->SetLPos(Lxyz);
			thisHit->SetVert(vert);
			thisHit->SetTime(ctime);
			thisHit->SetEdep(depe*mhPID[singl_hit_size-1].id_sharing);
			thisHit->SetDx(Dx);
			thisHit->SetMom(pxyz);
			thisHit->SetE(ene);
			thisHit->SetTrackId(tid);
			thisHit->SetDetector((*Hall_Map)[name]);
			thisHit->SetThreshold(SDID.minEnergy);
			thisHit->SetId(mhPID);
			thisHit->SetPID(pid);
			thisHit->SetCharge(q); 
			hitCollection->insert(thisHit);
			Id_Set.insert(mhPID);
						
			if(HIT_VERBOSITY > 6 || name.find(catch_v) != string::npos)
			{
				string pid    = aStep->GetTrack()->GetDefinition()->GetParticleName();
				cout << endl << hd_msg1 << endl
				<< "  > This element was not hit yet in this event. Identity:" << endl << thisHit->GetId()
				<< "  > Creating new hit by a E=" <<  ene/MeV << ", p=" <<  pxyz.mag()/MeV << " MeV "  << pid
				<< ", track ID = " << tid << ", inside Hit Collection <" << HCname << ">." << endl
				<< "  > Energy Deposited this step: " << depe/MeV << " MeV" << endl
				<< "  > Time of this step: " << G4BestUnit(ctime, "Time") << endl
				<< "  > Position of this step:   " << xyz/cm  << " cm"  << endl
				<< "  > Local Position in volume: " << Lxyz/cm  << " cm" << endl;
			}
		}
		else
		{
			// Adding hit info only if the poststeppint remains in the volume?
			// if( aStep->GetPreStepPoint()->GetTouchable()->GetVolume(0) == aStep->GetPostStepPoint()->GetTouchable()->GetVolume(0))
			{
				MHit *thisHit = find_existing_hit(mhPID);
				if(!thisHit)
				{
					cout << " Hit not found in collection but found in PID. This should never happen. Exiting." << endl; 
					exit(0);
				}
				else
				{				
					thisHit->SetPos(xyz);
					thisHit->SetLPos(Lxyz);
					thisHit->SetVert(vert);
					thisHit->SetTime(ctime);
					thisHit->SetEdep(depe*mhPID[singl_hit_size-1].id_sharing);
					thisHit->SetDx(Dx);
					thisHit->SetMom(pxyz);
					thisHit->SetE(ene);
					thisHit->SetTrackId(tid);
					thisHit->SetPID(pid);
					thisHit->SetCharge(q); 
					thisHit->SetDetector((*Hall_Map)[name]);
					
					if(HIT_VERBOSITY > 6 || name.find(catch_v) != string::npos)
					{
						string pid    = aStep->GetTrack()->GetDefinition()->GetParticleName();
						cout << hd_msg2 << " Step Number " << thisHit->GetPos().size()
						<< " inside Identity: "  << endl << thisHit->GetId()
						<< "            >  Adding hit inside Hit Collection <" << HCname << ">."
						<< " by a E=" <<  ene/MeV << ", p=" <<  pxyz.mag()/MeV << " MeV "
						<< pid << ", track ID = " << tid << endl
						<< "            >  Energy Deposited this step: " << depe/MeV << " MeV" << endl
						<< "            >  Time of this step: " << G4BestUnit(ctime, "Time")
						<< " is within this element Time Window of " << SDID.TimeWindow/ns << " ns. " << endl
						<< "            >  Position of this step:   " << xyz/cm << " cm" << endl
						<< "            >  Local Position in volume: " << Lxyz/cm  << " cm" << endl;
					}
				}
			}
		}
	
	}	
	
		
		



	return true;
}


void MSensitiveDetector::EndOfEvent(G4HCofThisEvent *HCE)
{
	int nhitC = hitCollection->GetSize();
	if(!nhitC) return;
	MHit *aHit;
	double Etot;
	if(HIT_VERBOSITY > 2 && nhitC)
	{
		cout << endl;
		cout << hd_msg3 << " Hit Collections <" << HCname << ">: " << nhitC << " hits." << endl; 

		for (int i=0; i<nhitC; i++)
		{
			aHit = (*hitCollection)[i];
			string vname = aHit->GetId()[aHit->GetId().size()-1].name;
			if(HIT_VERBOSITY > 5 || vname.find(catch_v) != string::npos)
			{
				cout << hd_msg3 << " Hit " << i + 1 << " --  total number of steps this hit: " << aHit->GetPos().size() << endl;
				cout << aHit->GetId();
				Etot = 0;
				for(unsigned int e=0; e<aHit->GetPos().size(); e++) Etot = Etot + aHit->GetEdep()[e];
				cout << "   Total energy deposited: " << Etot/MeV << " MeV" << endl;
			}
		}
	}
	delete ProcessHitRoutine; // not needed anymore

}


MHit*  MSensitiveDetector::find_existing_hit(vector<identifier> PID)  ///< returns hit collection hit inside identifer
{
	for(unsigned int i=0; i<hitCollection->GetSize(); i++)
		if((*hitCollection)[i]->GetId() == PID) return (*hitCollection)[i];

	return NULL;
}









