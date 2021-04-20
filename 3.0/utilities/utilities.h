#ifndef GUTILITIES_H
#define GUTILITIES_H 1

#define GEMCLOGMSGITEM  " ⌘"

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

// return number of cores from options. If 0 or none given,
// returns max number of available cores
int getNumberOfThreads(GOptions* gopt);

// initialize run manager
void initGemcG4RunManager(G4MTRunManager *grm, GOptions* gopt);

// loads plugins from sensitive map <names, paths>
int loadGPlugins(GOptions* gopt, map<string, string> sensD, map<string, GDynamic*> *gDigiGlobal);

#endif
