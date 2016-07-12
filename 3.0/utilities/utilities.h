#ifndef GUTILITIES_H
#define GUTILITIES_H

// options framework
#include "options.h"

// qt
#include <QApplication>

// c++
#include <map>
using namespace std;

// loads the option map
map<string, GOption> defineOptions();


// distinguishing between graphical and batch mode
QCoreApplication* createQtApplication(int &argc, char *argv[], bool gui);


#endif