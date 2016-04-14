#ifndef MATERIAL_FACTORY_H
#define MATERIAL_FACTORY_H


// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4Material.hh"


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


class materials
{
	public:
		virtual map<string, G4Material*> initMaterials(run_conditions, gemc_opts) = 0;               // Pure Virtual Method to initialize G4 Materials
		virtual ~materials(){}
};

typedef materials *(*materialFactory)();                                // Define materialFactory as a pointer to a function that returns a pointer 

materials *getMaterialFactory(map<string, materialFactory> *, string);  // returns materialFactory Function from Factory Map

map<string, materialFactory> registerMaterialFactories();               // Registers materialFactory in Factory Map



#endif
