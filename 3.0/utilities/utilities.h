#ifndef GUTILITIES_H
#define GUTILITIES_H 1


// gemc
#include "gDetectorConstruction.h"

// mlibrary
#include "goptions.h"

// qt
#include <QApplication>

// c++
#include <map>
using namespace std;

// geant4
#include "G4MTRunManager.hh"


// loading a qt resource
int loadQResource(char* argv[], string resourceName);

// retrieve and define batch commands
// these include possible options/gcard commands
vector<string> batchCommands(GOptions* gopt);

// retrieve and define gui commands
vector<string> interactiveCommands(GOptions* gopt);

// apply initial UIM commands coming from:
// - goptions
// - batch
// - gui (if needed)
void applyInitialUIManagerCommands(GOptions* gopt);



#endif
