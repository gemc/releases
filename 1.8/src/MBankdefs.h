/// \file MBankdefs.h
/// Defines the bank class.\n
/// The output information is dynamic, 
/// based on the DB column "activated".
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n
#ifndef MBankdefs_H
#define MBankdefs_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"
#include "usage.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <sstream>
using namespace std;

/// \class MBank
/// <b>MBank </b>\n\n
/// This class defines the general bank content.\n
/// The structure of the content is read
/// from the database.\n
/// Each variable is activated with the column "activated"
class MBank
{
 public:
   MBank(){;}
  ~MBank(){;}

 public:
   vector<string> name;         ///< Variable name
   vector<int>    id;           ///< Output variable identifier
   vector<int>    type;         ///< Type of variable: 0=int, 1=double
   vector<int>    activated;    ///< Activated means this variable will be written to the output
   vector<string> description;  ///< Variable description
};

map<string, MBank> read_banks(gemc_opts, map<string, MPHB_Factory>); ///< Fills bank maps according to Hit Process Map.


#endif
