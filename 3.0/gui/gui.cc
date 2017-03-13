// gemc
#include "gui.h"

GemcGUI::GemcGUI(string resources, QWidget *parent) : QWidget(parent)
{
	// the exampleResources.rcc is obtained with:
	// rcc -binary exampleResources.qrc -o exampleResources.rcc
	// it is needed in the executable dir in case it is compiled by xcode
	// scons on the other hand knows about it because the qt module
	// compiles exampleResources.qrc directly

	QFileInfo qrcFileInfoExecutable(resources.c_str());
	QString rccPath = qrcFileInfoExecutable.absolutePath() + "/" + "exampleResources.rcc";
	QResource::registerResource(rccPath);

	return;

}

GemcGUI::~GemcGUI()
{
	;
}
