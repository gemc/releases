// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4ParticleTypes.hh"




// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%

#include "MSteppingAction.h"

MSteppingAction::MSteppingAction(gemc_opts Opt)
{
  gemcOpt = Opt;
  Energy_cut = gemcOpt.args["ENERGY_CUT"].arg; 
  max_x_pos  = gemcOpt.args["MAX_X_POS"].arg; 
  max_y_pos  = gemcOpt.args["MAX_Y_POS"].arg; 
  max_z_pos  = gemcOpt.args["MAX_Z_POS"].arg; 
  
  oldpos = G4ThreeVector(0,0,0);
  nsame  = 0;
}
MSteppingAction::~MSteppingAction(){}


void MSteppingAction::UserSteppingAction(const G4Step* aStep)
{
	G4ThreeVector   pos   = aStep->GetPostStepPoint()->GetPosition();      ///< Global Coordinates of interaction
	G4Track*        track = aStep->GetTrack();
	string          volname(aStep->GetPreStepPoint()->GetPhysicalVolume()->GetName());

	if(fabs(pos.x()) > max_x_pos || 
	   fabs(pos.y()) > max_y_pos || 
		 fabs(pos.z()) > max_z_pos ) track->SetTrackStatus(fStopAndKill);   ///< Killing track if outside of interest region

	if(track->GetKineticEnergy() < Energy_cut )
		track->SetTrackStatus(fStopAndKill); 
		
	// Anything passing material "Kryptonite" is killed 
	if(track->GetMaterial()->GetName() == "Kryptonite")
	{
		track->SetTrackStatus(fStopAndKill); 
	}
  
  
  if(track->GetDefinition() == G4OpticalPhoton::OpticalPhotonDefinition())
  {    
    if(track->GetLogicalVolumeAtVertex()->GetMaterial()->GetName() == "SemiMirror")
    {
      track->SetTrackStatus(fStopAndKill);  
    }
  }
  
  
  
  // checking if a step is stuck in the same position 
  // for more than 10 steps
	if(sqrt( (pos - oldpos).x() *  (pos - oldpos).x() +
           (pos - oldpos).y() *  (pos - oldpos).y() +
           (pos - oldpos).z() *  (pos - oldpos).z() ) < 0.00001)
     
  {
    nsame++;
  	if(nsame > 10)
    {
      cout << " Track is stuck. PID: " <<  track->GetDefinition()->GetPDGEncoding() << " Volume: "
      << volname << ". Killing this track. " << endl;
      cout << " Last step of :  " << pos -oldpos << " was at " << pos <<  "    track id: " << track->GetTrackID() << endl;  
      
      track->SetTrackStatus(fStopAndKill);  

    }
  }
  else
    nsame = 0;
  
  oldpos = pos;
  
  
  // limiting steps in one volume to 1000
  int nsteps = aStep->GetTrack()->GetCurrentStepNumber();
  if(nsteps >= 1000) aStep->GetTrack()->SetTrackStatus(fStopAndKill);
 
     
  
}

