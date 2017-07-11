// gemc
#include "gui.h"

// geant4 headers
#include "G4UImanager.hh"

// qt
#include <QString>

// mlibrary
#include "gstring.h"
using namespace gstring;

void GemcGUI::createTopButtons(QHBoxLayout *topLayout)
{
	QLabel *nEventsLabel = new QLabel(tr("N. Events:"));

	QPushButton *runButton = new QPushButton(tr("Run"));
	runButton->setToolTip("Run events");
	runButton->setIcon(style()->standardIcon(QStyle::SP_MediaPlay));

	nEvents = new QLineEdit(tr("1"));
	nEvents->setMaximumWidth(50);

	QPushButton *cycleButton = new QPushButton(tr("Cycle"));
	cycleButton->setToolTip("Run 1 event every 2 seconds");
	cycleButton->setIcon(style()->standardIcon(QStyle::SP_BrowserReload));

	QPushButton *stopButton = new QPushButton(tr("Stop"));
	stopButton->setToolTip("Stops running events");
	stopButton->setIcon(style()->standardIcon(QStyle::SP_MediaStop));

	QPushButton *closeButton = new QPushButton(tr("Exit"));
	closeButton->setToolTip("Quit GEMC");
	closeButton->setIcon(style()->standardIcon(QStyle::SP_TitleBarCloseButton));

	eventNumber  = new QLabel(tr("Event Number: 0"));

	topLayout->addWidget(nEventsLabel);
	topLayout->addWidget(nEvents);
	topLayout->addWidget(runButton);
	topLayout->addWidget(cycleButton);
	topLayout->addWidget(stopButton);
	topLayout->addStretch(1);
	topLayout->addWidget(eventNumber);
	topLayout->addStretch(40);
	topLayout->addWidget(closeButton);


	connect(closeButton, &QPushButton::clicked, this, &GemcGUI::gquit);
	connect(runButton,   &QPushButton::clicked, this, &GemcGUI::beamOn);
	connect(cycleButton, &QPushButton::clicked, this, &GemcGUI::cycleBeamOn);
	connect(stopButton,  &QPushButton::clicked, this, &GemcGUI::stopCycleBeamOn);
}



void GemcGUI::gquit()
{
	qApp->quit();
}


void GemcGUI::beamOn()
{
	G4UImanager *g4uim = G4UImanager::GetUIpointer();

	// by construction this has 3 strings, no need to check
	vector<string> sBefore = getStringVectorFromString(eventNumber->text().toStdString());

	int nBefore = stoi(sBefore[2]);
	int nToRun  = nEvents->text().toInt();

	// interestingly enough this the accumulate directive will prevent this:
	// oreAnimation: warning, deleted thread with uncommitted CATransaction
	g4uim->ApplyCommand("/vis/scene/endOfEventAction accumulate -1");

	g4uim->ApplyCommand("/gun/particle proton");
	g4uim->ApplyCommand("/gun/energy 2 GeV");
	g4uim->ApplyCommand("/gun/direction 0 0 1");
	g4uim->ApplyCommand("/vis/scene/add/trajectories rich smooth");

	g4uim->ApplyCommand( "/run/beamOn " + to_string(nToRun));


	QString newNEvents("Event Number: ");
	newNEvents.append(to_string(nBefore+nToRun).c_str());

	eventNumber->setText(newNEvents);
}


void GemcGUI::cycleBeamOn()
{
	G4UImanager *g4uim = G4UImanager::GetUIpointer();
}


void GemcGUI::stopCycleBeamOn()
{
}
