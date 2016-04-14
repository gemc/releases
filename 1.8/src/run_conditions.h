/// \file run_conditions.h
/// Defines the Run Conditions class.\n
/// The Run Conditions are defined in an XML file
/// The Options Map is then filled
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n

#ifndef run_conditions_H
#define run_conditions_H

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4ThreeVector.hh"
#include "G4RotationMatrix.hh"

// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QDomDocument>
#include <QtGui>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <iostream>
using namespace std;

double get_number(string);   ///< Returns dimension from string, i.e. 100*cm

/// \class gcard_detector
/// <b> gcard_detector </b>\n\n
/// This is the gemc gcard detector class. It contains the
/// list of detector tables and their position/rotation and
/// the beam conditions. \n
class gcard_detector
{
	private:
		G4ThreeVector    pos;
		G4RotationMatrix rot;  // Rotation Matrix
  	G4ThreeVector    vrot; // Rotation Vector (ordered X,Y,Z)
  
    
		int is_present;

	public:
		gcard_detector(){is_present = 1;}
		~gcard_detector(){;}

		void set_position(string X, string Y, string Z);
		void set_rotation(string X, string Y, string Z);
		void set_existance(string exist);
	
  	G4ThreeVector    get_position() {return  pos;}
  	G4ThreeVector    get_vrotation(){return  vrot;}
		G4RotationMatrix get_rotation() {return  rot;}
		int              get_existance(){return is_present;}

};



/// \class run_conditions
/// <b> run_conditions </b>\n\n
/// This is the gemc Run Conditions class. It contains the
/// list of detector and their position/rotation and
/// the beam conditions - through a map of class gcard.
/// It reads an XML file (gcard).\n
class run_conditions
{
	public:
		run_conditions(gemc_opts);
		~run_conditions();

		map<string, gcard_detector> gDet_Map;   ///< Map of gcard_detector. Map Key = detector name.
		vector<string>              gTab_Vec;   ///< Vector of SQL tables names.

	private:
		QDomDocument domDocument;

};


#endif






