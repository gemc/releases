// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UnitsTable.hh"

// %%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%
#include "detector.h"
#include "identifier.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <iostream>
using namespace std;


bool identifier::operator == (const identifier& I) const
{
	// If the volume is the same, and if hits are within the time window, it's one hit
	if(I.name == this->name && I.rule == this->rule && I.id == this->id && fabs(I.time - this->time) <= this->TimeWindow)
		return true;
	
	// If the volume is the same, if it's a "flux" detector, and if it's the same track, it's one hit
	if(I.name == this->name && I.rule == this->rule && I.id == this->id && this->TimeWindow == 0 && I.TrackId == this->TrackId)
		return true;
	
	return false;
}


bool identifier::operator < (const identifier& I) const
{
	if(this->name == I.name)
		if(this->id < I.id)   return true;
	if(this->time < I.time) return true;

	return false;
}

bool identifier::operator > (const identifier& I) const
{
	if(this->name == I.name)
		if(this->id > I.id)   return true;
	if(this->time > I.time) return true;

	return false;
}


ostream &operator<<(ostream &stream, vector<identifier> Iden)
{
	for(unsigned int i=0; i<Iden.size(); i++)
	{
		cout << "      id " << i+1 ;
		cout << "           " ;
		cout.width(10);
		if(Iden[i].id_sharing <1 && Iden[i].id_sharing > 0.001) 
			cout << Iden[i].name << " " << Iden[i].id << " Percentage: " << Iden[i].id_sharing << endl ;
		else 		
			cout << Iden[i].name << " " << Iden[i].id                                          << endl ;
	}
	if(Iden.size())
		cout << "      identifier time:  " <<  Iden[0].time/ns << " ns - TimeWindow: " << Iden[0].TimeWindow/ns << " ns." << endl;

	return stream;
}


// Sets the ncopy ID accordingly to Geant4 Volumes copy number
vector<identifier> SetId(vector<identifier> Iden, G4VTouchable* TH, double time, double TimeWindow, int TrackId)
{
	vector<identifier> identity = Iden;

	// Look for "ncopy" flag, set to volume copy number
	for(unsigned int i=0; i<identity.size(); i++)
	{
		if(identity[i].rule.find("ncopy") != string::npos)
		{
			// h=1 don't need to check volume itself
			for(int h=0; h<TH-> GetHistoryDepth(); h++)
			{
				string pname = TH->GetVolume(h)->GetName();
				int    pcopy = TH->GetVolume(h)->GetCopyNo();
				if(pname.find(identity[i].name) != string::npos) identity[i].id = pcopy;
			}
			
			// Make sure id is not still zero
			if(identity[i].id == 0)
			{
				cout << " Something is wrong. Identity not completely set." << endl;
				cout << identity;
				cout << " Exiting. " << endl;
				exit(0);
			}
			
		}
 
		identity[i].time       = time;
		identity[i].TimeWindow = TimeWindow;
		identity[i].TrackId    = TrackId;
	}

	return identity;
}






