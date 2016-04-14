// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "evio_output.h"

#include <fstream>

void evio_output :: RecordAndClear(MOutputs* output, MBank mbank)
{
	// Need to reorganize the vectors.
	// First index must be variable index
	// Second index must be hit number index
	
	vector<vector<double> > rawinfv;
	vector<vector<int> >    dgtinfv;
	
	unsigned int NHITS  = rawinfos.size();
	if(NHITS)
	{
		int NVARSR = rawinfos[0].size();
		int NVARSD = dgtinfos[0].size();
		
		// cout << NHITS << " " << NVARSR << " " << NVARSD << endl;
		
		rawinfv.resize(NVARSR);
		dgtinfv.resize(NVARSD);
		
		for(int i=0; i<NVARSR; i++) rawinfv[i].resize(NHITS);
		for(int i=0; i<NVARSD; i++) dgtinfv[i].resize(NHITS);
		
		
		for(unsigned int nh=0; nh<NHITS; nh++)
			for(int iv=0; iv<NVARSR; iv++)
				rawinfv[iv][nh] = rawinfos[nh][iv];
			
			for(unsigned int nh=0; nh<NHITS; nh++)
				for(int iv=0; iv<NVARSD; iv++)
					dgtinfv[iv][nh] = dgtinfos[nh][iv];
				
		// creating dgthitbank, inserting it in bankevent  >> TAG=bankID NUM=100 <<
		if(NVARSD)
		{
			evioDOMNodeP dgtbankhit = evioDOMNode::createEvioDOMNode(bankID, 100);
			*bankevent << dgtbankhit;
			
			for(int d=0; d<NVARSD; d++)
				*dgtbankhit << evioDOMNode::createEvioDOMNode(bankID, mbank.id[d+NVARSR], dgtinfv[d]);
		}
		
		// creating rawhitbank, inserting it in bankevent  >> TAG=bankID NUM=200 <<
		if(NVARSR)
		{
			evioDOMNodeP rawbankhit = evioDOMNode::createEvioDOMNode(bankID, 200);
			*bankevent << rawbankhit;
			
			for(int r=0; r<NVARSR; r++)
				*rawbankhit << evioDOMNode::createEvioDOMNode(bankID, mbank.id[r], rawinfv[r]);
		}
	}
	
	rawinfos.clear();
	dgtinfos.clear();
}

void evio_output :: WriteEvent(MOutputs* output)
{
	output->pchan->write(*event);
	delete event;
}

void evio_output :: SetOutpHeader(header head,  MOutputs* output)
{
  event = new evioDOMTree(1, 0);
	
	// creating and inserting head bank  >> TAG=1 NUM=1 <<
	// evioDOMNodeP head = evioDOMNode::createEvioDOMNode(1,  1);
	//evioDOMNode::createEvioDOMNode(1,  1);
	*event << evioDOMNode::createEvioDOMNode(1, 1, &head.evn,       1);
	*event << evioDOMNode::createEvioDOMNode(1, 2, &head.type,      1);
	*event << evioDOMNode::createEvioDOMNode(1, 3, &head.beamPol,   1);
	*event << evioDOMNode::createEvioDOMNode(1, 4, &head.targetPol, 1);
}



void evio_output :: WriteGenerated(MOutputs* output, vector<MGeneratedParticle> MGP)
{
	double MAXP = output->gemcOpt.args["NGENP"].arg;
	
	vector<double> pid;
	vector<double> px;
	vector<double> py;
	vector<double> pz;
	vector<double> vx;
	vector<double> vy;
	vector<double> vz;
	
	for(unsigned int i=0; i<MAXP && i<MGP.size(); i++)
	{
		pid.push_back((double) MGP[i].PID);
		px.push_back(MGP[i].momentum.getX()/MeV);
		py.push_back(MGP[i].momentum.getY()/MeV);
		pz.push_back(MGP[i].momentum.getZ()/MeV);
		vx.push_back(MGP[i].vertex.getX()/cm);
		vy.push_back(MGP[i].vertex.getY()/cm);
		vz.push_back(MGP[i].vertex.getZ()/cm);
	}
	
	// creating and inserting generated particles bank  >> TAG=10 NUM=0 <<
	generatedp = evioDOMNode::createEvioDOMNode(10, 0);
	evioDOMNodeP rawbankhit = evioDOMNode::createEvioDOMNode(10, 200);
	*generatedp <<  rawbankhit;
	
  
  // tag, num hardcoded here, should not be
	*rawbankhit << evioDOMNode::createEvioDOMNode(10, 10, pid);
	*rawbankhit << evioDOMNode::createEvioDOMNode(10, 20, px);
	*rawbankhit << evioDOMNode::createEvioDOMNode(10, 30, py);
	*rawbankhit << evioDOMNode::createEvioDOMNode(10, 40, pz);
	*rawbankhit << evioDOMNode::createEvioDOMNode(10, 50, vx);
	*rawbankhit << evioDOMNode::createEvioDOMNode(10, 60, vy);
	*rawbankhit << evioDOMNode::createEvioDOMNode(10, 70, vz);
	
	
	*event << generatedp;
	
}



void evio_output :: SetBankHeader(int bankid, string SDName, MOutputs* output)
{
	bankID = bankid;
	bankevent = evioDOMNode::createEvioDOMNode(bankID, 0);
	*event << bankevent ;
}



void evio_output :: ProcessOutput(PH_output PHout, MOutputs* output, MBank mbank)
{	
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
	
	vector<double> rawinf;
	vector<int>    dgtinf;
	
	for(unsigned int r=0; r<nraws; r++)
		rawinf.push_back(PHout.raws[r]);
	
	for(unsigned int d=0; d<ndigit; d++)
		dgtinf.push_back(PHout.dgtz[d]);
	
	rawinfos.push_back(rawinf);
	dgtinfos.push_back(dgtinf);
}


void evio_output :: SaveSimConditions(MOutputs* output, map<string, string> sims)
{
  vector<string> data;

	// for better formatting, writing both key and argument as one string
	for(map<string, string>::iterator it=sims.begin(); it!=sims.end(); it++)
  {
  	data.push_back(it->first + ":  " + it->second + "  ");
  }

  event = new evioDOMTree(1, 0);

	*event << evioDOMNode::createEvioDOMNode(5, 1, data);

  output->pchan->write(*event);
	delete event;
}





