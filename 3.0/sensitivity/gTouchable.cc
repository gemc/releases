// gemc
#include "gTouchable.h"

// c++
#include <string>

GTouchable::GTouchable(string sensitivity, string gtouchableString, double tWindow) : timeWindow(tWindow), time(0), trackId(0), eFraction(1)
{
	if(sensitivity == "flux") {
		gType = flux;
	} else 	if(sensitivity == "counter") {
		gType = counter;
	} else  {
		gType = readout;
	}


	

}
