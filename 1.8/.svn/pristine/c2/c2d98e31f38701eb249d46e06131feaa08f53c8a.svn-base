#include <vector>
using namespace std;

class fst_strip
{
	public:
		double alpha;
		double pitch;
		double Pi;

		double interlayer;       // distance between 2 layers of a superlayer
		double intersuperlayer;  // distance between 2 superlayers
		int    Nsector;          // number of sectors for each layer
		double DZ;               // size of the band of dead zones
		double Rmin;             // inner radius of disks
		double Rint;             // intermediate radius of disks
		double Rmax;             // outer radius of disks
		double Z_1stlayer;       // z position of the 1st layer

		vector<double> Z0;       // z of the upstream part of the layer
		vector<double> R;        // radii of layers
		vector<double> MidTile;  // mid angle of the sector
		int Nstrips;             // Number of strips for 1 card

		void fill_infos();

		int FindStrip( int layer, int sector, double x, double y, double z);   // Strip Finding Routine

};
