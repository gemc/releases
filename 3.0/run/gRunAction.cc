// gemc
#include "gRunAction.h"
#include "gRun.h"

// geant4
#include "globals.hh"
#include "G4Threading.hh"
#include "G4MTRunManager.hh"


// c++
using namespace std;

// Constructor for workers
GRunAction::GRunAction(GOptions* opt) : G4UserRunAction(), gopt(opt)
{
	G4cout << " Constructor GRunAction" << G4endl;
	myID = 400;
}

// Constructor for master
GRunAction::GRunAction(GOptions* opt, GRuns *gr) : G4UserRunAction(), gopt(opt), gruns(gr)
{
	G4cout << " Constructor GRunAction" << G4endl;
	
	myID = 400;
}


// Destructor
GRunAction::~GRunAction()
{
	G4cout << " Destructor GRunAction" << G4endl;
}

// this is not local?
G4Run* GRunAction::GenerateRun()
{
	G4cout << " GRunAction GenerateRun with id " << myID << G4endl;

	// PRAGMA: why this doesn't work?
	myID++;
	
	return new GRun(myID);
}

// executed after BeamOn
void GRunAction::BeginOfRunAction(const G4Run* aRun)
{

	G4cout << "### RunNUMBER " << aRun->GetRunID() << " start." << G4endl;

	// PRAGMA TODO: why this cannot be set in GRun constructor?
	// why so complicated?
//	GRun* grun = static_cast<GRun*>( G4RunManager::GetRunManager()->GetNonConstCurrentRun() );
	
//	cout << " ASD AAA " << G4MTRunManager::GetMasterRunManager()->GetUserRunAction()->gruns->getCurrentRun() << endl;
	
	
	
	if(IsMaster()) {
		
		
//		grun->SetRunID( gruns->getCurrentRun() );
//		gruns->setNextRun();
//		cout << grun << " ASD " << gruns->getCurrentRun() << " " << IsMaster() << endl;
	}
	
	
	G4cout << "### GRunAction run id:  " << aRun->GetRunID() << " BeginOfRunAction in thread " << G4Threading::G4GetThreadId()  << G4endl;
	
}

void GRunAction::EndOfRunAction(const G4Run* aRun)
{
	G4cout << "### GRunAction " << aRun->GetRunID() << " EndOfRunAction in thread " << G4Threading::G4GetThreadId()  << G4endl;
	
	const GRun* theRun = static_cast<const GRun*> (aRun);
	if(IsMaster())
	{
		G4cout << "Global result with " << theRun->GetNumberOfEvent() << G4endl;
	} else {
		G4cout << "Local thread result with " << theRun->GetNumberOfEvent() << G4endl;
	}
}
