// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "DC_hitprocess.h"
#include "CLHEP/Random/RandGaussT.h"

// NOTE:
// Need to run gemc with -USE_PHYSICSL=gemc
// otherwise the step size inside the cell is too small
// to calculate DOCA correctly

PH_output DC_HitProcess :: ProcessHit(MHit* aHit, gemc_opts Opt)
{
	HCname = "DC Hit Process";

	double mini_stagger_shift_R2 = Opt.args["DC_MSTAG_R2"].arg*mm;   // Mini Stagger shift for Region 2
	double mini_stagger_shift_R3 = Opt.args["DC_MSTAG_R3"].arg*mm;   // Mini Stagger shift for Region 3
	double mini_stagger_shift;
	
	string hd_msg        = Opt.args["LOG_MSG"].args + " DC Hit Process " ;
	double HIT_VERBOSITY = Opt.args["HIT_VERBOSITY"].arg;
	
	PH_output out;
	out.identity = aHit->GetId();
	int sector   = out.identity[0].id;
	int SL       = out.identity[1].id;
	int Layer    = out.identity[2].id;
	int nwire    = out.identity[3].id;
	
	mini_stagger_shift = 0;
	if(SL > 2 && SL <= 4)     // shift only for region 2
	{
		mini_stagger_shift = mini_stagger_shift_R2;
		if(Layer == 2 || Layer == 4 || Layer == 6)  mini_stagger_shift *= -1;
	}
	else if(SL > 4)           // shift only for region 3
	{
		mini_stagger_shift = mini_stagger_shift_R3;
		if(Layer == 2 || Layer == 4 || Layer == 6)  mini_stagger_shift *= -1;
	}
	
	// nwire position information
	double NWIRES = 113;
	double ylength =  aHit->GetDetector().dimensions[3];  ///< G4Trap Semilength
	double deltay  = 2.0*ylength/NWIRES;                  ///< Y length of cell
	double WIRE_Y  = nwire*deltay + mini_stagger_shift;   ///< Center of wire hit

	// drift velocities
	double drift_velocity = 0;
	if(SL == 1 || SL == 2) drift_velocity = 0.053;      ///< drift velocity is 53 um/ns for region1
		if(SL == 3 || SL == 4) drift_velocity = 0.026;    ///< drift velocity is 26 um/ns for region2
			if(SL == 5 || SL == 6) drift_velocity = 0.036;  ///< drift velocity is 36 um/ns for region3
				
	// %%%%%%%%%%%%%%%%%%%
	// Raw hit information
	// %%%%%%%%%%%%%%%%%%%
	int nsteps = aHit->GetPos().size();
	// Identifying the fastest - given by time + doca(s) / drift velocity
	int trackId     = -1;
	double minTime  = 10000;
	double signal_t = 0;
	
	vector<int>           stepTrackId = aHit->GetTIds();
	vector<double>        stepTime    = aHit->GetTime();
	vector<G4double>      Edep        = aHit->GetEdep();
	vector<G4ThreeVector> pos         = aHit->GetPos();
	vector<G4ThreeVector> Lpos        = aHit->GetLPos();
	
	for(int s=0; s<nsteps; s++)
	{
		G4ThreeVector DOCA(0, Lpos[s].y() + ylength - WIRE_Y, Lpos[s].z()); // local cylinder
		signal_t = stepTime[s]/ns + DOCA.mag()/drift_velocity;
		
		if(signal_t < minTime && Edep[s] >= aHit->GetThreshold())
		{
			trackId = stepTrackId[s];
			minTime = signal_t;
		}
		// debug mode:
/*		cout << "  step: "          << s+1                 << "  w: "          << nwire
		<< "  L: "             << Layer               << "  SL: "         << SL
		<< "  ms: "            << mini_stagger_shift  << "  doca: "       << DOCA.mag()
		<< "  time: "          << stepTime[s]/ns      << "  tdc: "        << signal_t
		<< "  step ID: "       << stepTrackId[s]      << "  fast: "       << trackId
		<< "  Edep (MeV): "    << Edep[s]/MeV         << "  Threshold: "  << aHit->GetThreshold() << endl;*/
	}
	
	// If no step pass the threshold, getting the fastest signal - given by time + doca(s) / drift velocity
	if(trackId == -1)
	{
		for(int s=0; s<nsteps; s++)
		{
			G4ThreeVector DOCA(0, Lpos[s].y() + ylength - WIRE_Y, Lpos[s].z());
			signal_t = stepTime[s]/ns + DOCA.mag()/drift_velocity;
			if(signal_t < minTime)
			{
				trackId = stepTrackId[s];
				minTime = signal_t;
			}
		}
	}
	
	// Get Total Energy deposited of the fastest track
	double Etot = 0;
	int count_track_steps = 0;
	for(int s=0; s<nsteps; s++)
		if(stepTrackId[s] == trackId)
		{
			Etot = Etot + Edep[s];
			count_track_steps++;
		}
		
			
	// average global, local positions of fastest track
	double x, y, z;
	double lx, ly, lz;
	x = y = z = lx = ly = lz = 0;
	
	/* if(Etot>0)*/
	for(int s=0; s<nsteps; s++)
	{
		if(stepTrackId[s] == trackId)
		{
			/*       x  = x  +  pos[s].x()*Edep[s]/Etot;
			y  = y  +  pos[s].y()*Edep[s]/Etot;
			z  = z  +  pos[s].z()*Edep[s]/Etot;
			lx = lx + Lpos[s].x()*Edep[s]/Etot;
			ly = ly + Lpos[s].y()*Edep[s]/Etot;
			lz = lz + Lpos[s].z()*Edep[s]/Etot;*/
			x  = x  +  pos[s].x()/count_track_steps;
			y  = y  +  pos[s].y()/count_track_steps;
			z  = z  +  pos[s].z()/count_track_steps;
			lx = lx + Lpos[s].x()/count_track_steps;
			ly = ly + Lpos[s].y()/count_track_steps;
			lz = lz + Lpos[s].z()/count_track_steps;
		}
	}
	//  else
	//  {
		//    x  = pos[0].x();
		//    y  = pos[0].y();
		//    z  = pos[0].z();
		//    lx = Lpos[0].x();
		//    ly = Lpos[0].y();
		//    lz = Lpos[0].z();
		//  }
		
	// average time of fastest track
	double time = 0;
	vector<G4double> times = aHit->GetTime();
	for(int s=0; s<nsteps; s++) if(stepTrackId[s] == trackId) time = time + times[s]/count_track_steps;
	
	// Energy of the track
	double Ene = aHit->GetE();
	
	out.raws.push_back(Etot);
	out.raws.push_back(x);
	out.raws.push_back(y);
	out.raws.push_back(z);
	out.raws.push_back(lx);
	out.raws.push_back(ly);
	out.raws.push_back(lz);
	out.raws.push_back(time);
	out.raws.push_back((double) aHit->GetPID());
	out.raws.push_back(aHit->GetVert().getX());
	out.raws.push_back(aHit->GetVert().getY());
	out.raws.push_back(aHit->GetVert().getZ());
	out.raws.push_back(Ene);
	out.raws.push_back((double) aHit->GetmPID());
	out.raws.push_back(aHit->GetmVert().getX());
	out.raws.push_back(aHit->GetmVert().getY());
	out.raws.push_back(aHit->GetmVert().getZ());
	
	
	
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// Distance 1: smear by 300 um
	// Drift Time 1: using 50 um/ns
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
	// Finding DOCA
	double doca    = 10000;
	double LR      = 0;
	
	for(int s=0; s<nsteps; s++)
	{
		G4ThreeVector DOCA(0, Lpos[s].y() + ylength - WIRE_Y, Lpos[s].z());
		if(DOCA.mag() <= doca && stepTrackId[s] == trackId )
		{
			doca = DOCA.mag();
			if(DOCA.y() >=0 ) LR = 1;
			else  LR = -1;
			
		}
		// // debug mode:
		//    cout <<  "    wire: "       << nwire    << "    layer: "       << iden[2].id   << "   SL: "  << SL
		//         <<  "    doca: "       << doca     << "    Distance: "    << DOCA.mag()   << "   start Time: "  << stepTime[s]/ns
		//         <<  "    signal: "     << signal_t << "    step: "        << s+1          << "   track ID: "    << stepTrackId[s]
		//         <<  "    fast track: " << trackId  << "    Edep (MeV): "  << Edep[s]/MeV  << endl;
		
	}
	
	
	
	
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// Digitization
	// DC ID:
	// sector, SL, Layer, nwire
	// %%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	double sdoca  = -1;
	sdoca = fabs(CLHEP::RandGauss::shoot(doca, 0.3));  ///< smeared by 300 microns for now
	double time1  = doca/drift_velocity;
	double stime1 = sdoca/drift_velocity;
	
	out.raws.push_back(LR);
	out.raws.push_back(doca);
	out.raws.push_back(sdoca);
	out.raws.push_back(time1);
	out.raws.push_back(stime1);
	
	out.dgtz.push_back(sector);
	out.dgtz.push_back(SL);
	out.dgtz.push_back(Layer);
	out.dgtz.push_back(nwire);
	
	if(HIT_VERBOSITY>4)
		cout <<  hd_msg
		<< "  PID: "        << aHit->GetPID()
		<< "  Sector: "     << sector
		<< "  Superlayer: " << SL
		<< "  Layer: "      << Layer
		<< "  Cell Size: "  << deltay
		<< "  nwire: "      << nwire
		<< "  L/R: "        << LR
		<< "  doca: "       << doca
		<< "  sdoca: "      << sdoca
		<< "  time1: "      << time1
		<< "  stime1: "     << stime1 <<  endl;
	
	return out;
}

vector<identifier>  DC_HitProcess :: ProcessID(vector<identifier> id, G4Step* aStep, detector Detector, gemc_opts Opt)
{
	vector<identifier> yid = id;
	double mini_stagger_shift_R2 = Opt.args["DC_MSTAG_R2"].arg*mm;   // Mini Stagger shift for Region 2
	double mini_stagger_shift_R3 = Opt.args["DC_MSTAG_R3"].arg*mm;   // Mini Stagger shift for Region 3
	double mini_stagger_shift;
	
	double NWIRES             = 113;
	int SL                    = yid[1].id;
	int Layer                 = yid[2].id;
	
	mini_stagger_shift = 0;
	if(SL > 2 && SL <= 4)     // shift only for region 2
	{
		mini_stagger_shift = mini_stagger_shift_R2;
		if(Layer == 2 || Layer == 4 || Layer == 6)  mini_stagger_shift *= -1;
	}
	else if(SL > 4)           // shift only for region 3
	{
		mini_stagger_shift = mini_stagger_shift_R3;
		if(Layer == 2 || Layer == 4 || Layer == 6)  mini_stagger_shift *= -1;
	}
	
	G4StepPoint   *prestep   = aStep->GetPreStepPoint();
	G4StepPoint   *poststep  = aStep->GetPostStepPoint();
	G4VTouchable* TH = (G4VTouchable*) aStep->GetPreStepPoint()->GetTouchable();
	
	string         name    = TH->GetVolume(0)->GetName();                                    ///< Volume name
	G4ThreeVector   xyz    = poststep->GetPosition();                                        ///< Global Coordinates of interaction
	G4ThreeVector  Lxyz    = prestep->GetTouchableHandle()->GetHistory()                     ///< Local Coordinates of interaction
	->GetTopTransform().TransformPoint(xyz);
	
	
	double ylength = Detector.dimensions[3];  ///< G4Trap Semilength
	double deltay  = 2.0*ylength/NWIRES;
	double loc_y   = Lxyz.y() + ylength - mini_stagger_shift;      ///< Distance from bottom of G4Trap - modified by ministaggger
	
	int nwire = (int) floor(loc_y/deltay);
	if(nwire <= 0 )  nwire = 1;
	if(nwire == 113) nwire = 112;
	
	yid[3].id = nwire;
	
	if(fabs( (nwire+1)*deltay - loc_y ) < fabs( nwire*deltay - loc_y ) && nwire != 112 )
		yid[3].id = nwire + 1;

/*	if(nwire > NWIRES) cout << " SuperLayer: " << SL << "      layer: "        << Layer
		<< "       wire: " << nwire     << "      length: "       << ylength
		<< "         ly: " << Lxyz.y()  << "      deltay: "       << deltay
		<< "      loc_y: " << loc_y     << "      nwire*deltay: " << fabs( nwire*deltay - loc_y ) << endl;*/
	
	yid[3].id_sharing = 1;
	
	return yid;
}





