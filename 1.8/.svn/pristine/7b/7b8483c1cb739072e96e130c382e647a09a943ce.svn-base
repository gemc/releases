// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "txt_output.h"

#include <fstream>

void txt_output :: SetOutpHeader(header head, MOutputs* output)
{
	ofstream *txtout = output->txtoutput ;

	*txtout << " > Event number: "     << head.evn << endl;
	*txtout << " > Event type: "       << head.type << endl;
	*txtout << " > Event Beam Pol: "   << head.beamPol ;
	*txtout << ",  Target Pol: "       << head.targetPol << endl;
}

void txt_output :: SetBankHeader(int bankid, string SDName, MOutputs* output)
{
	ofstream *txtout = output->txtoutput ;

	*txtout << "   > Bank: " << SDName << " - id: " << bankid << endl;
}



void txt_output :: WriteGenerated(MOutputs* output, vector<MGeneratedParticle> MGP)
{
	double MAXP = output->gemcOpt.args["NGENP"].arg;
	ofstream *txtout = output->txtoutput ;
	for(unsigned int i=0; i<MAXP && i<MGP.size(); i++)
	{
		*txtout << "   Gen. Particle id: " << MGP[i].PID
				<< "     -   mom: "        << MGP[i].momentum/MeV
				<< " MeV     -   vert: "   << MGP[i].vertex/cm << " cm" << endl;
	}
}


void txt_output :: ProcessOutput(PH_output PHout, MOutputs* output, MBank mbank)
{
	ofstream *txtout = output->txtoutput ;

	// check for double/int sizes consistency
	unsigned int nraws, ndigit;
	nraws=ndigit=0;
	for(unsigned int i=0; i<mbank.name.size(); i++)
	{
		if(mbank.type[i] == 0) ndigit++;
		if(mbank.type[i] == 1) nraws++;
	}

	if(PHout.raws.size() != nraws || PHout.dgtz.size() != ndigit)
	{
		cout << "    Output does not match bank definition. This hit won't be written in the output stream." << endl;
		cout << "    nraws size: " << nraws  << "      Output nraws: " << PHout.raws.size() << endl;
		cout << "    ndgtz size: " << ndigit << "      Output ndgt: "  << PHout.dgtz.size() << endl;
		return;
	}

	// digitized informations, if any
	if(ndigit)
	{
		*txtout << "     " ;
		for(unsigned int d=0; d<ndigit; d++)
			*txtout << mbank.name[d+nraws]  << ": " << PHout.dgtz[d] << "    " ;
		*txtout << endl;
	}

	// raw informations, if any
	if(nraws)
	{
		*txtout << "    " ;
		for(unsigned int r=0; r<nraws; r++)
			*txtout << mbank.name[r]  << ": " << PHout.raws[r] << "    " ;
		*txtout << endl;
	}
}


void txt_output :: SaveSimConditions(MOutputs* output, map<string, string> simcons)
{
	ofstream *txtout = output->txtoutput ;

  *txtout << "   Simulation Conditions: " << endl;
	
  for(map<string, string>::iterator it = simcons.begin(); it != simcons.end(); it++)
	  *txtout << "   > " << it->first << " " << it->second << endl;
 
   *txtout << "   End of Simulation Conditions" ;
  
}

