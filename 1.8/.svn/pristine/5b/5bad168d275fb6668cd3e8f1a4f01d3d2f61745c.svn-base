/// \file MPHBaseClass.h 
/// Defines the Process Hit Base Class.\n
/// It contains the factory method MPHB_Factory
/// that returns a pointer to a MPHBaseClass.\n
/// The virtual method ProcessHit returns a PH_output.\n
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n
#ifndef MPHBASECLASS_H
#define MPHBASECLASS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "detector.h"
#include "MHit.h"
#include "usage.h"

/// \class PH_output
/// <b> PH_output</b>\n\n
/// Contains dynamic output informations 
/// - raw information: vector<double>
/// - digitized information: vector<int>
class PH_output
{
	public:
		vector<double>     raws;        ///< Raw information
		vector<int>        dgtz;        ///< Digitized information
		vector<identifier> identity;    ///< Identifier
};

/// \class MPHBaseClass
/// <b> MPHBaseClass </b>\n\n
/// This class is istantiated by the factory method MPHB_Factory.\n
/// MPHB_Factory is registered in a map<string, MPHB_Factory>, with key referred by the detector hitType.\n
/// The virtual method ProcessHit is called at the end of each event  by each Hit Collection.
class MPHBaseClass
{
	public:
		virtual PH_output ProcessHit(MHit*, gemc_opts) = 0;                                            ///< Virtual Method to process the hit
		virtual vector<identifier> ProcessID(vector<identifier>, G4Step*, detector, gemc_opts) = 0;    ///< Virtual Method to calculate new identifier
		string HCname;                                                                                 ///< Hit Collection name
		map<string, double> gpars;
  
		virtual ~MPHBaseClass(){;}
};

typedef MPHBaseClass *(*MPHB_Factory)();                       ///< Define MPHB_Factory as a pointer to a function that returns a pointer 

MPHBaseClass *GetMPHClass(map<string, MPHB_Factory> *MProcessHit_Map, string); ///< Return MPHBaseClass from the Hit Process Map


#endif
