/// \file txt_output.h 
/// Defines the Text Output Class.\n
/// The pointer to the output stream
/// is passed by the MOutputs class.\n
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n
#ifndef TXT_OUTPUT_H
#define TXT_OUTPUT_H 1



// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MOutputBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class txt_output : public MOutputBaseClass
{
	public:
		~txt_output(){}  ///< event is deleted in WriteEvent routine

	  void SaveSimConditions(MOutputs*, map<string, string>);  
		void ProcessOutput(PH_output, MOutputs*, MBank);
		void SetBankHeader(int, string, MOutputs*);
  	void SetOutpHeader(header, MOutputs*);
		void RecordAndClear(MOutputs*, MBank){;}
		void WriteGenerated(MOutputs*, vector<MGeneratedParticle>);
		void WriteEvent(MOutputs*){;};
		static MOutputBaseClass *createOutputClass() {return new txt_output;}








};
#endif
