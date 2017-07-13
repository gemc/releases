// gemc
#include "gTouchable.h"

// c++
#include <string>

// mlibrary
#include "gstring.h"
using namespace gstring;

GTouchable::GTouchable(string sensitivity, string gtouchableString, double tWindow) :  time(0), timeWindow(tWindow), trackId(0), eFraction(1)
{
	if(sensitivity == "flux") {
		gType = flux;
	} else 	if(sensitivity == "counter") {
		gType = counter;
	} else  {
		gType = readout;
	}

	// loading touchable id
	vector<double> touchD = getG4NumbersFromString(gtouchableString);
	for(auto &td : touchD) {
		gTid.push_back(td);
	}

	

}
