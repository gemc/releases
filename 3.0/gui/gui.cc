// gemc
#include "gui.h"

// mlibrary
#include "gstring.h"
using namespace gstring;

GemcGUI::GemcGUI(string resources, GOptions* gopt, GRuns *gr, QWidget *parent) : QWidget(parent), gruns(gr)
{
	// the exampleResources.rcc is obtained with:
	// rcc -binary exampleResources.qrc -o exampleResources.rcc
	// it is needed in the executable dir in case it is compiled by xcode
	// scons on the other hand knows about it because the qt module
	// compiles exampleResources.qrc directly

	QFileInfo qrcFileInfoExecutable(resources.c_str());
	QString rccPath = qrcFileInfoExecutable.absolutePath() + "/" + "gemcResources.rcc";
	QResource::registerResource(rccPath);

	createLeftButtons();       // instantiates leftButtons
	createRightContent(gopt);  // instantiates rightContent

	// top rows button
	QHBoxLayout *topLayout = new QHBoxLayout;
	createTopButtons(topLayout);


	QHBoxLayout *bottomLayout = new QHBoxLayout;
	bottomLayout->addWidget(leftButtons);
	bottomLayout->addWidget(rightContent);

	QVBoxLayout *mainLayout = new QVBoxLayout;
	mainLayout->addLayout(topLayout);
	mainLayout->addLayout(bottomLayout);
	setLayout(mainLayout);
	setWindowTitle(tr("GEMC: Geant4 Monte-Carlo"));
}


void GemcGUI::updateGui()
{
	vector<string> sBefore = getStringVectorFromString(eventNumber->text().toStdString());
	
	int nBefore      = stoi(sBefore[2]);
	int nThatWasRun  = nEvents->text().toInt();

	QString newNEvents("Event Number: ");
	newNEvents.append(to_string(nBefore+nThatWasRun).c_str());
	
	eventNumber->setText(newNEvents);
}


GemcGUI::~GemcGUI()
{
	cout << endl << " % Quitting Gemc GUI. " << endl;
}

