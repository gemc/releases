#ifndef GLOG_H
#define GLOG_H 1

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
	
	GFlowMessage(GOptions* gopt, string what) : name(what) {
		verbosity = gopt->getInt("gflowv");
		counter = 0;
		if(verbosity > GVERBOSITY_SILENT) {
			G4cout << flowHeader() << name << " constructor" << G4endl;
		}
	}
	~GFlowMessage() {
		if(verbosity > GVERBOSITY_SILENT) {
			G4cout << flowHeader() << name << " destructor" << G4endl;
		}
	}
	
private:
	string name;
	int verbosity;
	int counter;
 	string flowHeader() {
		counter++;
		return string(GFLOWMESSAGEHEADER) + " [" + to_string(counter) + "] " + string(GFLOWMESSAGEHEADER) + " ";
	}
	
public:
	static map<string, GOption> defineOptions();
	void flowMessage(string msg) {
		if(verbosity > GVERBOSITY_SILENT) {
			G4cout << " " << flowHeader() << name << " " << msg << G4endl;
		}
	}
};

#endif
