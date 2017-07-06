// gemc
#include "Gui.h"

QStackedWidget* GemcGUI::rightContent()
{
	vector<string> bicons;

	bicons.push_back(":/images/buttons/firstButton");
	bicons.push_back(":/images/buttons/secondButton");

	QtButtonsWidget *window = new QtButtonsWidget(128, 128, bicons);


	return window;
}
