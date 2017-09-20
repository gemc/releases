#ifndef GLOG_H
#define GLOG_H 1

// mlibrary
#include "goptions.h"

// geant4
#include "G4UIsession.hh"

// c++
#include <fstream>
using namespace std;

class GSession : public G4UIsession
{
public:
	GSession();
	G4int ReceiveG4cout(const G4String& coutString);
	G4int ReceiveG4cerr(const G4String& cerrString);

private:
	ofstream logFile;
	ofstream errFile;
};

#define GFLOWMESSAGEHEADER  ">.>"

class GFlowMessage
{
public:
	
	GFlowMessage(GOptions* gopt, string what) : flowName(what) {
		flowVerbosity = gopt->getInt("gflowv");
		flowCounter = 0;
		if(flowVerbosity > GVERBOSITY_SILENT) {
			G4cout << flowHeader() << flowName << " constructor" << G4endl;
		}
	}
	~GFlowMessage() {
		if(flowVerbosity > GVERBOSITY_SILENT) {
			G4cout << flowHeader() << flowName << " destructor" << G4endl;
		}
	}
	int getFlowCounter() const {return flowCounter;}
	void setFlowCounter (int c) const { flowCounter = c; }
private:
	string flowName;
	int flowVerbosity;
	mutable int flowCounter;
 	string flowHeader() const {
		//flowCounter++;
		setFlowCounter(getFlowCounter() + 1);
		return string(GFLOWMESSAGEHEADER) + " [" + to_string(flowCounter) + "] " + string(GFLOWMESSAGEHEADER) + " ";
	}
	
public:
	static map<string, GOption> defineOptions();
	void flowMessage(string msg) const {
		if(flowVerbosity > GVERBOSITY_SILENT) {
			G4cout << " " << flowHeader() << flowName << " " << msg << G4endl;
		}
	}
};

#endif
