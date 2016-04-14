/// \file MOutputBaseClass.h
/// Defines the Output Class.\n
/// It contains the factory method MOutput_Factory
/// that returns a pointer to a MOutputBaseClass.\n
/// The virtual method ProcessOutput writes events to
/// the correct stream.\n
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n
#ifndef MOUTBASECLASS_H
#define MOUTBASECLASS_H 1

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MBankdefs.h"
#include "evioFileChannel.hxx"
#include "usage.h"

// %%%%
// EVIO
// %%%%
#include "evioUtil.hxx"
#include "evioUtil.hxx"
using namespace evio;


/// \class MGeneratedParticle
/// <b> MGeneratedParticle </b>\n\n
/// Contains particle informations.
/// The Primary Particles will be written to the output.\n
/// Secondary Particles will be written to the output if option is specified.\n
class MGeneratedParticle
{
	public:
		MGeneratedParticle(){;}
		~MGeneratedParticle(){;}
		
		G4ThreeVector vertex;
		G4ThreeVector momentum;
		int PID;
};


class header
{
	public:
  
		int evn;               ///< Event number
  	int type;              ///< Event Type:
                           ///< MC number are opposite in sign of real data
                           ///< 1: Physics Event 
                           ///< 10: Scaler event
  	double beamPol;        ///< Beam Polarization
  	double targetPol;      ///< Target Polarization
  	double time;           ///< Event Time
};


/// \class MOutputs
/// <b> MOutputs </b>\n\n
/// Contains all possible outputs.
class MOutputs
{
	public:
		MOutputs(gemc_opts);
		~MOutputs();
		
		gemc_opts gemcOpt;
		string outType;
		string outFile;
		
		ofstream        *txtoutput;
		evioFileChannel *pchan;
};

/// \class MOutputBaseClass
/// <b> MOutputBaseClass </b>\n\n
/// This class is istantiated by the factory method MOutput_Factory.\n
/// MOutput_Factory is registered in a map<string, MOutput_Factory>, with
/// key defined at command line (default: "txt").\n
/// The virtual method ProcessOutput is called at the end of each event.
class MOutputBaseClass
{
	public:
  	virtual void SaveSimConditions(MOutputs*, map<string, string>)       = 0;  ///< Pure Virtual Method to save the simulation conditions on the file
  	virtual void ProcessOutput(PH_output, MOutputs*, MBank)              = 0;  ///< Pure Virtual Method to process the output
		virtual void SetBankHeader(int, string, MOutputs*)                   = 0;  ///< Pure Virtual Method to set the bank header
		virtual void SetOutpHeader(header,  MOutputs*)                       = 0;  ///< Pure Virtual Method to set the output header.  MOutputs needed for some output (txt)
		virtual void RecordAndClear(MOutputs*, MBank)                        = 0;  ///< Pure Virtual Method to record hits in event / then clear hits objects on heap
		virtual void WriteGenerated(MOutputs*, vector<MGeneratedParticle>)   = 0;  ///< Pure Virtual Method to write generated particles infos
		virtual void WriteEvent(MOutputs*)                                   = 0;  ///< Pure Virtual Method to write event on disk
		string outputType;
		
	virtual ~MOutputBaseClass(){;}
};

typedef MOutputBaseClass *(*MOutput_Factory)();                            ///< Define MOutput_Factory as a pointer to a function that returns a pointer to a MOutputBaseClass

MOutputBaseClass *GetMOutputClass (map<string, MOutput_Factory> *MOutput, string);  ///< Instantiates MOutputBaseClass


#endif
