/// \file MagneticField.h 
/// Defines the gemc Magnetic Field class.\n
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n
#ifndef MagneticField_H
#define MagneticField_H 1

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4FieldManager.hh"
#include "G4MagneticField.hh"


// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <sstream>
using namespace std;

/// \class MappedField
/// <b>MappedField </b>\n\n
/// This class defines gemc Mapped Magnetic Field.\n
class MappedField : public G4MagneticField
{
	gemc_opts gemcOpt;               	///< gemc options map
	double table_start[3];
	double cell_size[3];
	double mapOrigin[3];
	
	string hd_msg;
	int MGN_VERBOSITY;
	
	public:
		MappedField();
	 ~MappedField();
	
		// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		// Constructor for 1D-dipole field in cartesian coordinates
		// Example: A field along y that only depends on xz coordinate (code: dipole-y)
		// Arguments:
		// GEMC Options
		// Number of Tranverse Points,  Number of Longitudinal Points
		// Lower and Upper limits of the Tranverse Coordinates
		// Lower and Upper limits of the Longitudinal Coordinates
		// Map Filename
		// Map Origin
		// String of Units
		// Scale Factor
		// Symmetry
		// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		MappedField(gemc_opts, int, int, double Tlimits[2], double Llimits[2], string, double origin[3], string units[5], double scale_factor, string symmetry);
	
		// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		// Constructor for phi-symmetric field in cylindrical coordinates
		// Arguments:
		// GEMC Options
		// Number of Tranverse Points,  Number of Longitudinal Points
		// Lower and Upper limits of the Tranverse Coordinates
		// Lower and Upper limits of the Longitudinal Coordinates
		// Map Filename
		// Map Origin
		// String of Units
		// Scale Factor
		// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		MappedField(gemc_opts, int, int, double Tlimits[2], double Llimits[2], string, double origin[3], string units[5], double scale_factor, string symmetry, int dummy);
	
		// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		// Constructor for phi-segmented field in cylindrical coordinates. Field is in cartesian coordinates.
		// The map is assumed to cover half the segment
		// Arguments:
		// GEMC Options
		// Number of Transverse Points, Number of Azimuthal Points, Number of Longitudinal Points
		// Lower and Upper limits of the Tranverse Coordinates
		// Lower and Upper limits of the Azimuthal Coordinates
		// Lower and Upper limits of the Longitudinal Coordinates
		// Map Filename
		// Map Origin
		// String of Units
		// Scale Factor
		// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		MappedField(gemc_opts, int, int, int, double Tlimits[2], double Llimits[2], double Zlimits[2], string, double origin[3], string units[5], double scale_factor);
	
		// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		// Constructor for segmented field in cartesian coordinates. Field is in cartesian coordinates.
		// Arguments:
		// GEMC Options
		// Number of Y Points, Number of X Points, Number of Z Points
		// Lower and Upper limits of the Y Coordinates
		// Lower and Upper limits of the X Coordinates
		// Lower and Upper limits of the Z Coordinates
		// Map Filename
		// Map Origin
		// String of Units
		// Scale Factor
		// Symmetry
		// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		MappedField(gemc_opts, int, int, int, double Tlimits[2], double Llimits[2], double Zlimits[2], string, double origin[3], 
							  string units[5], double scale_factor, bool ySymmetry);
	
	
		void GetFieldValue( const double x[3], double *Bfield) const;
		
		double segm_phi_span; 	///< azimuthal span of the map for phi-segmented fields
		int    nsegments;     	///< number of segments
		string Symmetry;
	
	private:
	
		// 3D Cartesian Maps
		vector< vector < vector <double> > > B3DCartX ;
		vector< vector < vector <double> > > B3DCartY ;
		vector< vector < vector <double> > > B3DCartZ ;
	
		// 2D Cylindrical Maps - phi-symmetric, need only transverse and longitudinal (z) component
		vector< vector <double> > B2DCylT ;
		vector< vector <double> > B2DCylL ;
	
		// 3D Cylindrical Coordinates, Cartesian field Maps - phi-segmented
		vector< vector < vector <double> > > B3DCylX ;
		vector< vector < vector <double> > > B3DCylY ;
		vector< vector < vector <double> > > B3DCylZ ;

		// Dipole Maps - 1D dependent on two variable
		vector< vector <double> > BDipole ;
	

};


/// \class MagneticField
/// <b>MagneticField </b>\n\n
/// This class defines gemc Magnetic Field.\n
/// The kind of magnetic field is read 
/// from the database.\n
class MagneticField
{
public:
	MagneticField(){;}
	~MagneticField(){;}
	
public:
	gemc_opts gemcOpt;               	///< gemc options map
	string    name;                  	///< Magnetic Field identifier
	string    type;                  	///< Type of Magnetic Field
	string    magnitude;             	///< Magnetic Field magnitude infos
	string    swim_method;           	///< Magnetic Field Swim Method
	string    description;           	///< Field Description
	double    scale_factor;           ///< Scale factor 
	
	MappedField *mappedfield;        	///< Mapped Magnetic Field
	
private:
	G4FieldManager *MFM;             	///< G4 Magnetic Field Manager
	
public:
	G4FieldManager* get_MFM(){return MFM;} 	///< Returns Magnetic Field Manager Pointer
	void init_MFM(){MFM = NULL;}           	///< Initialize Field Manager Pointer to NULL
	void create_MFM();                     	///< Creates the G4 Magnetic Field Manager
	
};

map<string, MagneticField> get_magnetic_Fields(gemc_opts);	///< Fills magnetic field maps from Database


#endif
