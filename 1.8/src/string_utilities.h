/// \file string_utilities.h
/// Set of string manipulation functions: \n
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n

#ifndef string_utilities_H
#define string_utilities_H

// %%%%%%%%%%%
// Qt4 headers
// %%%%%%%%%%%
#include <QString>


// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <vector>
#include <iostream>
#include <string>
#include <sstream>
using namespace std;


inline string stringify(double x)
{
  ostringstream o;
  o << x;
  return o.str();
}

inline string stringify(int x)
{
  ostringstream o;
  o << x;
  return o.str();
}


// from QString to string
// OS dependance
inline string gemc_tostring(QString input)
{

	string output;
	// In Windows we need to initialize the string from toAscii
	// In Posix we need the toStdString
	
	#ifdef _MSC_VER
		output = input.toAscii();
	#else
		output = input.toStdString();
	#endif

	return output;
}


// Replaces first argument's characters specified in the second argument by spaces
inline string replaceCharsWithSpaces(string input, char* x)
{
	string output = "";

	for(unsigned int k=0; k<input.size(); k++)
	{
		int replace = 1;
		for(unsigned int j=0; j<sizeof(x); j++)
		{
			
			if(input[k] == x[j]) 
			{
				output.append(" ");
				replace = 0;
			}
		}
		if(replace) output += input[k];
	}
	return output;
}

vector< vector<string> > dimensionstype(string);  ///< Returns dimensions nomenclature for different solid type
double get_number(string);                        ///< Returns dimension from string, i.e. 100*cm
string TrimSpaces(string in);                     ///< Removes leading and trailing spaces
vector<string> get_strings(string);               ///< returns a vector of strings from a stringstream
void print_vstring(vector<string>);               ///< prints each element of a string vector

#endif





