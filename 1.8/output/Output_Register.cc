// %%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%
#include "Output_Register.h"
#include "txt_output.h"
#include "evio_output.h"
#include "MOutputBaseClass.h"

map<string, MOutput_Factory> Output_Map()
{
 map<string, MOutput_Factory> OutputMap;
 
 OutputMap["txt"]   =  &txt_output::createOutputClass;
 OutputMap["evio"]  =  &evio_output::createOutputClass;

 return OutputMap;
}
