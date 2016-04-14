/// \file evio_output.h 
/// Defines the EVIO Output Class.\n
/// The pointer to the evioFileChannel
/// is passed by the MOutputs class.\n
/// The evioDOMTree and evioDOMNodeP are 
/// created on the heap.
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n
#ifndef EVIO_OUTPUT_H
#define EVIO_OUTPUT_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MOutputBaseClass.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class evio_output : public MOutputBaseClass
{
	public:
  	~evio_output(){}  ///< event is deleted in WriteEvent routine
  
		void SaveSimConditions(MOutputs*, map<string, string>);  
  	void ProcessOutput(PH_output, MOutputs*, MBank);
  	void SetBankHeader(int, string, MOutputs*);
  	void SetOutpHeader(header, MOutputs*);
  	void RecordAndClear(MOutputs*, MBank);
  	void WriteGenerated(MOutputs*, vector<MGeneratedParticle>);
  	void WriteEvent(MOutputs*);
  	static MOutputBaseClass *createOutputClass() {return new evio_output;}
  
  	evioDOMTree *event;
  	evioDOMNodeP bankevent;
  	evioDOMNodeP generatedp;
  	evioDOMNodeP sim_conditions;
  	int bankID;
  	vector<vector<double> > rawinfos;
  	vector<vector<int> >    dgtinfos;
  
};
#endif
