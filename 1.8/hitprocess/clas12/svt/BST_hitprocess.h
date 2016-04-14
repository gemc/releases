#ifndef BST_HITPROCESS_H
#define BST_HITPROCESS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MPHBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%

/// \class BST_HitProcess
/// <b> BST_HitProcess </b>\n\n
/// The barrel silicon tracker hit process routine include:\n
/// - strip determination
/// - charge sharing
/// \author \n M. Ungaro
/// \author mail: ungaro@jlab.org\n\n\n


class BST_HitProcess : public MPHBaseClass
{
	public:
		~BST_HitProcess(){}
		PH_output ProcessHit(MHit*, gemc_opts);                                          ///< Method to process the hit
		vector<identifier> ProcessID(vector<identifier>, G4Step*, detector, gemc_opts) ; ///< Method to calculate new identifier
		static MPHBaseClass *createHitClass() {return new BST_HitProcess;}
};

#endif
