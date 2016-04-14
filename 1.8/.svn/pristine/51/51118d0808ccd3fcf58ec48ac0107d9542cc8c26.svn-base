/// \file usage.h
/// Defines the option class.\n
/// The main argv options
/// are filled into a map<string opts>.
/// Defines init_dmseg, init_dvmseg, exec_dmseg
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n

#ifndef gemc_OPTIONS_H
#define gemc_OPTIONS_H

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4VisManager.hh"

// %%%%%%%%%%%
// Qt4 headers
// %%%%%%%%%%%
#include <QDomDocument>
#include <QtGui>
#include <QString>

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <iostream>
#include <map>
#include <vector>
#include <string>
#include <ctime>
#include <fstream>
using namespace std;

/// \class opts
/// <b> opts </b>\n\n
/// Single Argument class.\n
/// - arg:  double assigned to argument.
/// - args: string assigned to argument.
/// - name: name to be displayed for the argument variable.
/// - help: help for the argument variable.
/// - type: 0 = number, 1 = string
class opts
{
 public:
   double  arg;  ///< double assigned to argument.
   string args;  ///< string assigned to argument.
   string name;  ///< name to be displayed for the argument variable.
   string help;  ///< help for the argument variable.
   int    type;  ///< 0 = number, 1 = string
   string ctgr;  ///< help category
};


/// \class gemc_opts
/// <b> gemc_opts </b>\n\n
/// This is the gemc options class. It contains a map of opts which key is
/// the command line argument.\n
class gemc_opts
{
	public:

		gemc_opts();
	 ~gemc_opts();
		void Scan_gcard(string file);
		int Set(int argc, char **args); ///< Sets map from command line arguments
   
		map<string, opts> args;         ///< Options map

		vector<opts> get_args(string);  ///< get a vector of arguments matching a string
};

vector<string> init_dmesg(gemc_opts);                  ///< General Initialization Routine
vector<string> init_dvmesg(gemc_opts, G4VisManager*);  ///< Initialization Routine for Visualization
vector<string> get_info(string);                       ///< get information from strings such as "5*GeV, 2*deg, 10*deg"



#endif





