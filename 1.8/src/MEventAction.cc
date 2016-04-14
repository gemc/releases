// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4Event.hh"
#include "G4RunManager.hh"
#include "G4Trajectory.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MEventAction.h"
#include "MHit.h"

#include <iostream>
using namespace std;
// the following functions return the pid, mpid and charges vector<int> from a map<int, TInfos>

vector<int> vector_zint(int size)
{
	vector<int> zints;
	for(int t=0; t<size; t++)
		zints.push_back(0);
  
  return zints;
}

vector<G4ThreeVector> vector_zthre(int size)
{
	vector<G4ThreeVector> zthre;
	for(int t=0; t<size; t++)
		zthre.push_back(G4ThreeVector(0,0,0));
	
	return zthre;
}

vector<int> vector_mtids(map<int, TInfos> tinfos, vector<int> tids)
{
	vector<int> mtids;
	for(unsigned int t=0; t<tids.size(); t++)
		mtids.push_back(tinfos[tids[t]].mtid);
	
	return mtids;
}

vector<int> vector_mpids(map<int, TInfos> tinfos, vector<int> tids)
{
	vector<int> mpids;
	for(unsigned int t=0; t<tids.size(); t++)
		mpids.push_back(tinfos[tids[t]].mpid);
	
	return mpids;
}

vector<G4ThreeVector> vector_mvert(map<int, TInfos> tinfos, vector<int> tids)
{
	vector<G4ThreeVector> mvert;
	for(unsigned int t=0; t<tids.size(); t++)
		mvert.push_back(tinfos[tids[t]].mv);
	
	return mvert;
}

MEventAction::MEventAction(gemc_opts opts, map<string, double> gpars)
{
	gemcOpt          = opts;
	hd_msg           = gemcOpt.args["LOG_MSG"].args + " Event Action: >> ";
	Modulo           = (int) gemcOpt.args["PRINT_EVENT"].arg ;
	VERB             = gemcOpt.args["OUT_VERBOSITY"].arg ;
	catch_v          = gemcOpt.args["CATCH"].args;
	SAVE_ALL_MOTHERS = (int) gemcOpt.args["SAVE_ALL_MOTHERS"].arg ;
	gPars            = gpars;
  MAXP             = (int) gemcOpt.args["NGENP"].arg;
}

MEventAction::~MEventAction()
{
	;
}

void MEventAction::BeginOfEventAction(const G4Event* evt)
{
	if(evtN%Modulo == 0 )
	{
		cout << hd_msg << " Begin of event " << evtN << endl;
		cout << hd_msg << " Random Number: " << G4UniformRand() << endl;
		// CLHEP::HepRandom::showEngineStatus();
	}
}

void MEventAction::EndOfEventAction(const G4Event* evt)
{
	if(evtN%Modulo == 0 )
		cout << hd_msg << "   End of Event " << evtN << " Routine..." << endl;

	MHitCollection* MHC;
	MHit* aHit;
	int nhits;

	// building the tracks database with all the tracks in all the hits
  // if SAVE_ALL_MOTHERS is set
	set<int> track_db;
  if(SAVE_ALL_MOTHERS)
    for(map<string, MSensitiveDetector*>::iterator it = SeDe_Map.begin(); it!= SeDe_Map.end(); it++)
    {
      string hitType;
      
      MHC = it->second->GetMHitCollection();
      nhits = MHC->GetSize();
      
      for(int h=0; h<nhits; h++)
      {
        vector<int> tids = (*MHC)[h]->GetTIds();
        for(unsigned int t=0; t<tids.size(); t++)
          track_db.insert(tids[t]);
      }
    }
	
	// now filling the map of tinfos with tracks infos from the track_db database
	// this won't get the mother particle infos except for their track ID
	map<int, TInfos> tinfos;
	set<int>::iterator it;
	
	// the container is full only if /tracking/storeTrajectory 2
	G4TrajectoryContainer *trajectoryContainer;
  
  if(SAVE_ALL_MOTHERS) 
  {
    trajectoryContainer = evt->GetTrajectoryContainer();
	
    while(trajectoryContainer && track_db.size())
    {
      // looping over all tracks
      for(unsigned int i=0; i< trajectoryContainer->size(); i++)
      {
        // cout << " index track " << i << endl;
        G4Trajectory* trj = (G4Trajectory*)(*(evt->GetTrajectoryContainer()))[i];
        int tid = trj->GetTrackID();
        
        // is this track involved in a hit?
        // if yes, add it to the map
        it = track_db.find(tid);
        if(it != track_db.end())
        {
          int           mtid = trj->GetParentID();
          tinfos[tid]        = TInfos(mtid);
          // 					cout << " At map level: " << tid << " " <<mtid << " " << pid << "   charge: " << q << endl;
          // remove the track from the database so we don't have to loop over it next time
          track_db.erase(it);
        }
      }
    }
	
	
    // now accessing the mother particle infos
    map<int, TInfos>::iterator itm;
    for(itm = tinfos.begin(); itm != tinfos.end(); itm++)
    {
      int mtid = (*itm).second.mtid;
      // looking for mtid infos in the trajectoryContainer
      for(unsigned int i=0; i< trajectoryContainer->size() && mtid != 0; i++)
      {
        G4Trajectory* trj = (G4Trajectory*)(*(evt->GetTrajectoryContainer()))[i];
        int tid = trj->GetTrackID();
        if(tid == mtid)
        {
          tinfos[(*itm).first].mpid   = trj->GetPDGEncoding();
          tinfos[(*itm).first].mv     = trj->GetPoint(0)->GetPosition();
        }
      }
    }
	}
	
	
	PH_output output;
	double Etot;

	// Making sure the output routine exists in the ProcessOutput map
	// If no output selected, or HitProcess not found, end current event
	map<string, MOutput_Factory>::iterator ito = Out->find(MOut->outType);
	if(ito == Out->end())
	{
		if(MOut->outType != "no")
			cout << hd_msg << " Warning: output type <" << MOut->outType << "> is not registered in the <MOutput_Factory>. " << endl
					<< "      This event will not be written out." << endl;
		evtN++;
		return;
	}
	MOutputBaseClass *ProcessOutput  = GetMOutputClass(Out, MOut->outType);
	

	// Header Bank contains event number
	// Need to change this to read DB header bank
  //
	header head;
  head.evn = evtN;
  head.type = -1;
  head.beamPol   = gen_action->getBeamPol();
  head.targetPol = gen_action->getTargetPol();
  
	ProcessOutput->SetOutpHeader(head, MOut);

	// Getting Generated Particles info
	vector<MGeneratedParticle> MPrimaries;
	for(int pv=0; pv<evt->GetNumberOfPrimaryVertex() && pv<MAXP; pv++)
	{
		MGeneratedParticle Mparticle;
		G4PrimaryVertex* MPV = evt->GetPrimaryVertex(pv);
		Mparticle.vertex = MPV->GetPosition();
		for(int pp = 0; pp<MPV->GetNumberOfParticle() && pv<MAXP; pp++)
		{

			G4PrimaryParticle *PP = MPV->GetPrimary(pp);
			Mparticle.momentum    = PP->GetMomentum();
			Mparticle.PID         = PP->GetPDGcode();
		}
		MPrimaries.push_back(Mparticle)  ;
	}
	ProcessOutput-> WriteGenerated(MOut, MPrimaries);

	for(map<string, MSensitiveDetector*>::iterator it = SeDe_Map.begin(); it!= SeDe_Map.end(); it++)
	{
		string hitType;

		MHC = it->second->GetMHitCollection();
		nhits = MHC->GetSize();

		
		// The same ProcessHit Routine must apply to all the hits  in this HitCollection. 
		// Instantiating the ProcessHitRoutine only once for the first hit.
		if(nhits)
		{
			ProcessOutput->SetBankHeader(it->second->SDID.id, it->first, MOut);

			aHit = (*MHC)[0];
			string vname = aHit->GetDetector().name;
			hitType = it->second->GetDetectorHitType(vname);

			// Making sure the Routine exists in the MProcessHit_Map
			map<string, MPHB_Factory>::iterator itp = MProcessHit_Map->find(hitType);
			if(itp == MProcessHit_Map->end())
			{
				cout << hd_msg << " Warning: hit Type <" << hitType << "> is not registered in the <MProcessHit_Map>. " << endl
						<< "      This hit collection will not be processed." << endl;
				return;
			}
			
			MPHBaseClass *ProcessHitRoutine = GetMPHClass(MProcessHit_Map, hitType);
			ProcessHitRoutine->gpars = gPars;

			for(int h=0; h<nhits; h++)
			{
				aHit = (*MHC)[h];
				
        if(SAVE_ALL_MOTHERS)
        {
          // setting track infos before processing the hit
          vector<int> tids = aHit->GetTIds();
          aHit->SetmTrackIds(vector_mtids(   tinfos, tids));
          aHit->SetmPIDs(    vector_mpids(   tinfos, tids));
          aHit->SetmVerts(   vector_mvert(   tinfos, tids)); 
        }
        else
        {
          int thisHitSize = aHit->GetId().size();
          vector<int>           zint  = vector_zint(thisHitSize);
          vector<G4ThreeVector> zthre = vector_zthre(thisHitSize);
          aHit->SetmTrackIds(zint);
          aHit->SetmPIDs(    zint);
          aHit->SetmVerts(   zthre); 

        }
				output = ProcessHitRoutine->ProcessHit(aHit, gemcOpt);
				ProcessOutput->ProcessOutput(output, MOut, (*MBank_Map)[hitType]);

				string vname = aHit->GetId()[aHit->GetId().size()-1].name;
				if(VERB > 4 || vname.find(catch_v) != string::npos)
				{
					cout << hd_msg << " Hit " << h + 1 << " --  total number of steps this hit: " << aHit->GetPos().size() << endl;
					cout << aHit->GetId();
					Etot = 0;
					for(unsigned int e=0; e<aHit->GetPos().size(); e++) Etot = Etot + aHit->GetEdep()[e];
					cout << "   Total energy deposited: " << Etot/MeV << " MeV" << endl;
				}
			}
			delete ProcessHitRoutine;

			//       cout << it->second->HCname << " " << evtN << " " << nhits << endl;
		}
		ProcessOutput->RecordAndClear(MOut, (*MBank_Map)[hitType]);

	}
	ProcessOutput->WriteEvent(MOut);

	// merging information from another file
  


	delete ProcessOutput;

	if(evtN%Modulo == 0 )
		cout << "      done." << endl << endl;;

	evtN++;    ///< Increase event number. Notice: this is different than evt->GetEventID()
	return;
}











