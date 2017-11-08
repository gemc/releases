// gemc
#include "g4GRun.h"

// geant4
#include "G4Event.hh"

// mlibrary
#include "ghit.h"

// Constructor
G4GRun::G4GRun(GOptions* gopt, map<string, GDynamic*> *gDigitization, map<string, GMedia*> *gmedia) :
G4Run(),
GFlowMessage(gopt, "GRun"),
gDigitizationGlobal(gDigitization),
gmediaFactory(gmedia)
{
	flowMessage("GRun:Constructor");
	runData = new vector<GEventData*>;
	
	// loading gmedia factories
	
}

// Destructor
G4GRun::~G4GRun()
{
	flowMessage("GRun:Destructor");
	
	// PRAGMA TODO: isn't the last line enough?
	for (GEventData* evtData : *runData)
		delete evtData;
	runData->clear();
	delete runData;
}


// RecordEvent is called at end of every event
// Method to be overwritten by the user for recording events in this (thread-local) run.
// The observables defined in each run should be filled here with the information from the hits
void G4GRun::RecordEvent(const G4Event *aEvent)
{
	flowMessage("GRun:Local RecordEvent");
	// HitsCollections of This Event
	G4HCofThisEvent* HCsThisEvent = aEvent->GetHCofThisEvent();
	if (!HCsThisEvent) return;
	
	// thread-local event data
	GEventData *eventData = new GEventData();
	
	// looping over all collections
	for(unsigned hci = 0; hci < HCsThisEvent->GetNumberOfCollections(); hci++) {
		GHitsCollection *thisGHC = (GHitsCollection*) HCsThisEvent->GetHC(hci);
		
		if(thisGHC) {
			
			// G4cout << " Collection number  " << hci + 1 << " " << thisGHC << " name " << thisGHC->GetSDname() <<  G4endl ;
			
			// getting digitization for this hit collection
			GDynamic* detectorDigitization = getDigitizationForHitCollection(thisGHC->GetSDname());
			
			if(detectorDigitization != nullptr) {
				
				// collection of observables for this detector
				GDetectorObservables *detectorObservables = new GDetectorObservables();
				
				// looping over hits in this collection
				for(size_t hitIndex = 0; hitIndex<thisGHC->GetSize(); hitIndex++) {
					GHit *thisHit = (GHit*) thisGHC->GetHit(hitIndex);
				
				// digitize hit and add it to detector data
				detectorObservables->addDetectorObservables(detectorDigitization->digitizeHit(thisHit));
				
				//					vector<double> edep = thisHit->getStepEdep();
				//					for(unsigned i=0; i<edep.size(); i++ )
				//						G4cout << " Hit number  " << hitIndex+1 << " step: " << i << "  edep: " << edep[i] <<  G4endl ;
					}
				eventData->addDetectorData(detectorObservables);
			}
		}
	}
	
	runData->push_back(eventData);
	G4Run::RecordEvent(aEvent);
}

// This is global
// Method to be overwritten by the user for merging local
// Run objects to the global Run object
// PRAGMA: But I can use it to save output right? No need to accumulate
void G4GRun::Merge(const G4Run *aRun)
{
	flowMessage("GRun:Global Merge");
	
	const G4GRun *localRun = static_cast<const G4GRun *> (aRun);
	
//	cout << " local run data size " << localRun->runData->size() << "  global size: " << runData->size() << endl;
	
	// output data to all available plugins
	for(auto gmf: (*gmediaFactory)) {
		gmf.second->publishData(localRun->runData);
	}
	
	G4Run::Merge(aRun);
}




GDynamic* G4GRun::getDigitizationForHitCollection(string name)
{
	if(gDigitizationGlobal->find(name) == gDigitizationGlobal->end()) {
		return nullptr;
	}
	
	return (*gDigitizationGlobal)[name];
}

