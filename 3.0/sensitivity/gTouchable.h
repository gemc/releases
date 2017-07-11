#ifndef  GTOUCHABLE_H
#define  GTOUCHABLE_H 1


// c++
#include <vector>
using namespace std;

enum GType { readout, flux, counter };


class GTouchable {


public:



private:
	GType       gType;
	double       time;   ///< Time of the first step
	double TimeWindow;   ///< System Time Window, used to determine if steps belong to the same hit
	int       TrackId;   ///< Used to determine if steps belong to the same hit for flux detectors
	double  eFraction;   ///< Energy sharing Fraction
	vector<int>   gid;   ///< Uniquely identify a sensitive element

};


#endif
