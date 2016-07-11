/// \file options.cc
/// Defines the gemc options


map<string, GOption> defineOptions()
{
	map<string, GOption> optionsMap;
	optionsMap["geometry"]      = GOption("Window Geometry", "1400x1200");
	optionsMap["timeWindow"]    = GOption("Defines the Time Window", 100, "time");
	optionsMap["interpolation"] = GOption("Interpolation algorithm", "linear", "process");
	optionsMap["interpolation"].addHelp("Possible choices are:\n");
	optionsMap["interpolation"].addHelp("- linear\n");
	optionsMap["interpolation"].addHelp("- none (no interpolation)\n");

	return optionsMap;
}
