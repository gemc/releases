// %%%%%%%%%%%%
// GEMC headers
// %%%%%%%%%%%%
#include "material_factory.h"
#include "cpp_materials.h"
#include "mysql_materials.h"

materials *getMaterialFactory(map<string, materialFactory> *factory, string materialsMethod)
{

	if(factory->find(materialsMethod) == factory->end())
	{
		cout << endl << endl << "  >>> WARNING: " << materialsMethod << " NOT FOUND IN Material Factory Map." << endl;
		return NULL;
	}
	
	return (*factory)[materialsMethod]();
}

map<string, materialFactory> registerMaterialFactories()
{
	
	map<string, materialFactory> materialMethodMap;
	
  
  // CPP initialization
	// cout << " Registering Material Factory: cpp_materials " << endl;
	materialMethodMap["CPP"] = &cpp_materials::createMaterials;
	
  
  // MYSQL initialization
	// cout << " Registering Material Factory: mysql_materials " << endl;
	materialMethodMap["MYSQL"] = &mysql_materials::createMaterials;
	
  
    
    
    
	return materialMethodMap;
}

