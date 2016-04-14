// gemc headers
#include "ftof_hitprocess.h"

// CLHEP units
#include "CLHEP/Units/PhysicalConstants.h"
using namespace CLHEP;

map<string, double> ftof_HitProcess :: integrateDgt(MHit* aHit, int hitn)
{	
	map<string, double> dgtz;
	vector<identifier> identity = aHit->GetId();
	
	int sector = identity[0].id;
	int paddle = identity[2].id;
	trueInfos tInfos(aHit);

	
	// Get the paddle length: in ftof paddles are boxes, the length the x
	double length = aHit->GetDetector().dimensions[0];
	
	// Distances from left, right
	double dLeft  = length + tInfos.lx;
	double dRight = length - tInfos.lx;
	
	// dummy formulas for now, parameters could come from DB
	int ADCL = (int) (100*tInfos.eTot*exp(-dLeft/length/2  ));
	int ADCR = (int) (100*tInfos.eTot*exp(-dRight/length/2 ));
		
	// speed of light is 30 cm/s
	int TDCL = (int) (100*(tInfos.time/ns + dLeft/cm/30.0));
	int TDCR = (int) (100*(tInfos.time/ns + dRight/cm/30.0));
	
	dgtz["hitn"]   = hitn;
	dgtz["sector"] = sector;
	dgtz["paddle"] = paddle;
	dgtz["ADCL"]   = ADCL;
	dgtz["ADCR"]   = ADCR;
	dgtz["TDCL"]   = TDCL;
	dgtz["TDCR"]   = TDCR;
	
	return dgtz;
}

vector<identifier>  ftof_HitProcess :: processID(vector<identifier> id, G4Step* aStep, detector Detector)
{
	id[id.size()-1].id_sharing = 1;
	return id;
}




map< string, vector <int> >  ftof_HitProcess :: multiDgt(MHit* aHit, int hitn)
{
	map< string, vector <int> > MH;
	
	return MH;
}











