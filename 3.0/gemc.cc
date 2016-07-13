/// \file gemc.cc
/// Defines the gemc main( int argc, char **argv )
/// \author \n &copy; Maurizio Ungaro
/// \author e-mail: ungaro@jlab.org\n\n\n
///
/// \mainpage
/// \htmlonly <center><img src="gemc_logo.gif" width="230"></center>\endhtmlonly
/// \section overview Overview
/// gemc (<b>GE</b>ant4 <b>M</b>onte<b>C</b>arlo) GEMC is a C++ framework
/// based on <a href="http://geant4.web.cern.ch/geant4/"> Geant4 </a>
/// Libraries to simulate the passage of particles through matter.\n
/// The simulation parameters are external to the software:
/// Geometry, Materials, Fields, Banks definitions are stored in
/// external databases in various format and are loaded at run
/// time using factory methods.\n
/// \n\n
/// \author \n &copy; Maurizio Ungaro
/// \author e-mail: ungaro@jlab.org\n\n\n

const char *GEMC_VERSION = "gemc 3.0";

// gsplash include options
#include "gsplash.h"

// utilities - include goptions map
#include "utilities.h"


int main(int argc, char* argv[])
{
	// init option map
	GOptions *gopts = new GOptions(argc, argv, defineOptions(), 1);
	bool gui = gopts->getBoolValue("gui");

	// init qt app
	createQtApplication(argc, argv, gui);

	// init splash screen
	GSplash gsplash(gopts);

	if(gui) {
		QMainWindow window;
		window.show();

		for(int i=0; i<200; i++)
			gsplash.message(to_string(i));

		gsplash.finish(&window);
		return qApp->exec();
	}

	

	return 1;
}