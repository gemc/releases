// gemc
#include "gui.h"

// mlibrary
#include "displayUI.h"

void GemcGUI::createRightContent(GOptions* gopt)
{
	rightContent = new QStackedWidget;

	rightContent->addWidget(new DisplayUI(gopt));

}
