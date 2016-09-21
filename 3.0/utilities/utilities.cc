// gemc utilities
#include "utilities.h"


// needed for options constructors
#include "gsplash.h"  // gsplash

//#include <QtCore>


// distinguishing between graphical and batch mode
QCoreApplication* createQtApplication(int &argc, char *argv[], bool gui)
{
	if(!gui)
		return new QCoreApplication(argc, argv);
	return new QApplication(argc, argv);
}


map<string, GOption> defineOptions()
{
	map<string, GOption> optionsMap;

	// GUI options
	optionsMap["geometry"] = GOption("Window Geometry", "1400x1200", "gui");

	optionsMap["gui"] = GOption("Use the QT interface", 1, "gui");
	optionsMap["gui"].addHelp("Possible choices are:\n");
	optionsMap["gui"].addHelp("0: run the program in batch mode\n");
	optionsMap["gui"].addHelp("1. run the program in interactive mode\n");


	// GSplash 
	optionsMap += GSplash::defineOptions();


	return optionsMap;
}

// loading a qt resource
int loadQResource(char* argv[], string resourceName)
{
	QFileInfo qrcFileInfoExecutable(argv[0]);
	QString rccPath = qrcFileInfoExecutable.absolutePath() + "/" + QString(resourceName.c_str());
	QResource::registerResource(rccPath);

	return 1;
}
