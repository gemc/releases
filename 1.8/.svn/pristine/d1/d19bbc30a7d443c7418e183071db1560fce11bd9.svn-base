// %%%%%%%%%%%%
// GEMC headers
// %%%%%%%%%%%%
#include "parameter_factory.h"
#include "mysql_parameters.h"

parameters *getParameterFactory(map<string, parameterFactory> *factory, string parametersMethod)
{

	if(factory->find(parametersMethod) == factory->end())
	{
		cout << endl << endl << "  >>> WARNING: " << parametersMethod << " NOT FOUND IN parameter Factory Map." << endl;
		return NULL;
	}
	
	return (*factory)[parametersMethod]();
}

map<string, parameterFactory> registerParameterFactories()
{
	
	map<string, parameterFactory> parameterMethodMap;
	
    
  // MYSQL initialization
	// cout << " Registering parameter Factory: mysql_parameters " << endl;
	parameterMethodMap["MYSQL"] = &mysql_parameters::createParameters;
	
  
    
	return parameterMethodMap;
}

