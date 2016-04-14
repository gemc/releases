// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"

using namespace std;

MPHBaseClass* GetMPHClass (map<string, MPHB_Factory> *MProcessHit_Map, string HCname)
{
	if(MProcessHit_Map->find(HCname) == MProcessHit_Map->end())
	{
		cout << endl << endl << "  >>> WARNING: " << HCname << " NOT FOUND IN  ProcessHit Map." << endl;
		return NULL;
	}
	
	return (*MProcessHit_Map)[HCname]();
}
