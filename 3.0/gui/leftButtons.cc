// gemc
#include "gui.h"

QtButtonsWidget* GemcGUI::createLeftButtons()
{
	map<string, string> bmodel;

	bmodel[":/images/buttons/firstButton"]  = "add monkey 1";
	bmodel[":/images/buttons/secondButton"] = "add monkey 2";
	bmodel[":/images/buttons/thidButton"]   = "add monkey 3";

	QtButtonsWidget *window = new QtButtonsWidget(128, 128, bmodel);


	return window;
}
