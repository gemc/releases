// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "string_utilities.h"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "G4UnitsTable.hh"


#include <algorithm>
vector<string> get_info(string input)
{
	
  char chars[] = "(),\"";
	string stripped = replaceCharsWithSpaces(input, chars);

	
	
	return get_strings(stripped);
}

// Trims Both leading and trailing spaces
string TrimSpaces(string in)
{
	string out;

	size_t leapos = in.find_first_not_of(" \t"); // Find the first character position after excluding leading blank spaces
	size_t endpos = in.find_last_not_of(" \t");  // Find the first character position from reverse af

	// if all spaces or empty return an empty string
	if(( string::npos == leapos ) || ( string::npos == endpos))
		out = "";
	else
		out = in.substr( leapos, endpos-leapos+1 );

	return out;
}



// returns a vector of strings from a stringstream
vector<string> get_strings(string input)
{
	vector<string> pvalues;
  stringstream plist(input);
  while(!plist.eof())
  {
    string tmp;
    plist >> tmp;
    pvalues.push_back(tmp);
  }
	return pvalues;
}                             




// assigns G4 units to a variable
/// \fn double get_number(string value)
/// \brief Return value + units
/// \param value input string. Ex: 10.2*cm
/// \return value with correct G4 unit.
double get_number(string v)
{
	string value = TrimSpaces(v);

	if(value.find("*") == string::npos)
	{
		// no * found, this should be a number
		return atof(value.c_str());
	}
	
	else
	{
		double answer = atof(value.substr(0, value.find("*")).c_str());
		string units  = TrimSpaces(value.substr(value.find("*")+1, value.find("*") + 20));
		if(       units == "m")      answer *= m;
		else if(  units == "inches") answer *= 2.54*cm;
		else if(  units == "cm")     answer *= cm;
		else if(  units == "mm")     answer *= mm;
		else if(  units == "um")     answer *= 1E-6*m;
		else if(  units == "fm")     answer *= 1E-15*m;
		else if(  units == "deg")    answer *= deg;
		else if(  units == "arcmin") answer = answer/60.0*deg;
		else if(  units == "rad")    answer *= rad;
		else if(  units == "mrad")   answer *= mrad;
		else if(  units == "eV")     answer *= eV;
		else if(  units == "MeV")    answer *= MeV;
		else if(  units == "KeV")    answer *= 0.001*MeV;
		else if(  units == "GeV")    answer *= GeV;
		else if(  units == "T")      answer *= tesla;
		else if(  units == "Tesla")  answer *= tesla;
		else if(  units == "ns")     answer *= ns;
		else cout << ">" << units << "<: unit not recognized for string <" << v << ">" << endl;
		return answer;
	}

	return 0;
}




void print_vstring(vector<string> s)
{
	for(unsigned int i=0; i<s.size(); i++)
		cout << "string element: " << i << "  content: " << s[i] << endl;
}






