#include <vector>
using namespace std;

class str_strip
{
	public:
		double alpha;
		double pitch;
		double Pi;

		double interlayer;       // distance between 2 layers of a superlayer
		vector<int>    Nsector;  // number of sectors for each layer
		vector<int>    Ncards;   // number of cards by sector for each layer
		vector<double> Z0;       // z of the upstream part of the layer
		vector<double> R;        // radii of layers
		vector<double> MidTile;  // mid angle of the sector

		double DZ_inLength;  // size of the band of dead zones all around in the length of the card
		double DZ_inWidth;   // size of the band of dead zones all around in the width of the card
		double CardLength;   // length of 1 card
		double CardWidth ;   // width 1 card
		int NstripsZ;        // Number of strips for 1 card (zig zag option)
		int Nstrips;         // Number of strips for 1 card (New Design)

		int nCard;           // Card hit by the track
		double x,y,z;        // z of the track is redefined in FindCard. Units are microns - input are millimiters

		void fill_infos();

		void FindCard(int layer, double z);  // Card finding routine (needed for zig zag design)
 
		int FindStripZ(int layer, int sector, double x, double y);  // Zig Zag Strip Finding Routine
		int FindStrip( int layer, int sector, double x, double y, double z);   // New Design Strip Finding Routine

};
