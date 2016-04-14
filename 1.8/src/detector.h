/// \file detector.h
/// detector.h defines the detector class.\n
/// The routine will build the geant4 solid, logical and physical volumes 
/// according to the class description.\n
/// The solid operations addition, subtractions, intersections are supported 
/// by implementing the +, -, * operators respectively.\n
/// A utility function that returns a graphic representation of each solid is 
/// also provided.\n
/// Additional utility functions are temporarily added here, to be stored
/// in a separate library.
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n

#ifndef detector_H
#define detector_H 1

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4Colour.hh"
#include "G4FieldManager.hh"
#include "G4LogicalVolume.hh"
#include "G4Material.hh"
#include "G4PVPlacement.hh"
#include "G4ThreeVector.hh"
#include "G4VisAttributes.hh"
#include "G4VSensitiveDetector.hh"
#include "G4VSolid.hh"

// %%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%
#include "usage.h"
#include "identifier.h"
#include "run_conditions.h"
#include "string_utilities.h"


/// \class detector
/// <b> Detector </b>\n\n
/// This is the gemc volume class. It contains:\n
/// - geometry informations (solid type, dimensions, placements)
/// - material
/// - visual attributes information
/// - pointers to the G4 solidV, logicV, physicalV
class detector
{

 public:
   detector();
  ~detector(){;}

   string                 name;   ///< Name of the volume. Since this is the key of the STL map, it has to be unique.
   string               mother;   ///< Mother Volume name.
   string          description;   ///< Volume Description for documentation.

   G4ThreeVector           pos;   ///< Position relative to the mother volume, as G4ThreeVector
   G4RotationMatrix        rot;   ///< Rotation Matrix, defined by rotations along x,y,z axis relative to the mother volume

   G4VisAttributes       VAtts;   ///< Visual Attributes: color, transparency, style (wireframe, solid), visibility

   string                 type;   ///< solid type. This follows the GEANT4 definitions
   vector<double>   dimensions;   ///< vector of dimensions. Size, units depends on solid type

   string             material;   ///< Volume Material name. 
   string             magfield;   ///< Magnetic Field. The string "no" means that the field is inherited from the mother volume.

   int                   ncopy;   ///< copy number
   bool                  pMany;   ///< Needed by geant4 at G4PVPlacement time

   int                   exist;   ///< detector ON/OFF switch
   int                 visible;   ///< visibility of the detector: 0=invisible 1=visible
   int                   style;   ///< Visual style: 0=wireframe 1=solid

   string          sensitivity;   ///< Defines the Sensitive Detector. possible choices: "no" "hits collection name"
   string              hitType;   ///< Hit Process routine name. A Hit Process MPHBaseClass derived class must exists with this name.
   vector<identifier> identity;   ///< Vector of identifiers. Example: superlayer manual 1 type manual 2 segment manual 3 strip manual 4

   int                 scanned;   ///< for use during construction

 private:
   G4VSolid*                     SolidV;   ///< G4 Solid
   G4LogicalVolume*              LogicV;   ///< Logical Volume
   G4VPhysicalVolume*         PhysicalV;   ///< Physical Volume

 public:
   int create_solid(gemc_opts, map<string, detector>*);                             ///< Creates the Solid. If it's a Copy Placement, retrieve and assigns LogicV
   int create_logical_volume(map<string, G4Material*>*, gemc_opts);                 ///< Creates the Logical Volume.
   int create_physical_volumes(gemc_opts, G4LogicalVolume*);                        ///< Creates the Physical Volume
   void setSensitivity(G4VSensitiveDetector *SD){LogicV->SetSensitiveDetector(SD);} ///< Assign the sensitive detector to the Logical Volume

   G4VSolid          *GetSolid()   { return SolidV;}                                ///< Returns G4 Solid pointer
   G4LogicalVolume   *GetLogical() { return LogicV;}                                ///< Returns Logical Volume pointer
   G4VPhysicalVolume *GetPhysical(){ return PhysicalV;}                             ///< Returns Physical Volume pointer
   void SetLogical(G4LogicalVolume *LV){LogicV = LV;}                               ///< Sets Logical Volume pointer
   void SetTranslation(G4ThreeVector TR){PhysicalV->SetTranslation(TR);}            ///< Sets Physical Volume Position
   void RemoveDaughter(G4VPhysicalVolume* PV){LogicV->RemoveDaughter(PV);}          ///< Remove Physical Volumes from LogicV
   void AssignMFM(G4FieldManager* MFM){LogicV->SetFieldManager(MFM, true);}         ///< Assigns Magnetic Field Manager to LogicV

   void SetUserLimits(G4UserLimits* L) { LogicV->SetUserLimits(L);}

   friend ostream &operator<<(ostream &stream, detector);                           ///< Overloaded "<<" for detector class. Dumps infos on screen.
   bool operator== (const detector& D) const;                                       ///< Overloaded "==" operator for detector class
};


// All these functions defined here but maybe should be moved somewhere else for consistency.
map<string, detector> read_detector(gemc_opts, run_conditions);   ///< Reads detector map from database

#endif

