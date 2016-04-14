/// \file MDetectorConstruction.h
/// Derived from G4VUserDetectorConstruction.\n
/// Contains:
/// - materials map
/// - sensitive detector map
/// - detector map
/// - Hit Process Routine Factory map
/// \n
/// The Construct() function builds the detector
/// from the detector map.
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n
#ifndef MDetectorConstruction_h
#define MDetectorConstruction_h 1

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4VUserDetectorConstruction.hh"
#include "globals.hh"
#include "G4Material.hh"
#include "G4Region.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"
#include "detector.h"
#include "MagneticField.h"
#include "MPHBaseClass.h"
#include "MSensitiveDetector.h"
class MDetectorMessenger;

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class MDetectorConstruction : public G4VUserDetectorConstruction
{
 public:
   MDetectorConstruction(gemc_opts Opts);
  ~MDetectorConstruction();

 public:
   gemc_opts gemcOpt;
   map<string, G4Material*>        *mats;
   map<string, MSensitiveDetector*> SeDe_Map;
   map<string, detector>           *Hall_Map;
   map<string, MagneticField>      *FieldMap;
   map<string, G4Region*>           SeRe_Map;
   map<string, G4ProductionCuts*>   SePC_Map;

 private:
//   MDetectorMessenger *mdetectorMessenger;      ///< pointer to the Messenger

	detector FindDetector(string);   // returns map detector
	void BuildDetector(string);      // build detector

 public:
   void IsSensitive(detector, gemc_opts);
   void HasMagfield(detector, gemc_opts);
   G4VPhysicalVolume* Construct();
   void UpdateGeometry();

};

#endif
