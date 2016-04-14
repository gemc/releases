#ifndef MYSQL_PARAMETERS_H
#define MYSQL_PARAMETERS_H

#include "parameter_factory.h"

class mysql_parameters : public parameters
{
	public:
		~mysql_parameters(){}
	
		map<string, double> initParameters(run_conditions, gemc_opts);  // Method to define the parameters
  
  static parameters *createParameters() 
  {
    return new mysql_parameters;
  }

};


#endif
