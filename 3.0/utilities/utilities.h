#ifndef GUTILITIES_H
#define GUTILITIES_H 1

// general utility functions needed by gemc

// options framework
#include "goptions.h"

// qt
#include <QApplication>

// c++
#include <map>
using namespace std;

// loads the option map
map<string, GOption> defineOptions();

// distinguishing between graphical and batch mode
QCoreApplication* createQtApplication(int &argc, char *argv[], bool gui);

// loading a qt resource
int loadQResource(char* argv[], string resourceName);

#endif
