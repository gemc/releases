#ifndef PARAMETER_FACTORY_H
#define PARAMETER_FACTORY_H

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <map>
#include <iostream>
using namespace std;


// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "run_conditions.h"
#include "usage.h"


class parameters
{
	public:
		virtual map<string, double> initParameters(run_conditions, gemc_opts) = 0;               // Pure Virtual Method to initialize the parameters
		virtual ~parameters(){}
};

typedef parameters *(*parameterFactory)();                                 // Define parameterFactory as a pointer to a function that returns a pointer 

parameters *getParameterFactory(map<string, parameterFactory> *, string);  // returns parameterFactory Function from Factory Map

map<string, parameterFactory> registerParameterFactories();                // Registers parameterFactory in Factory Map



#endif
