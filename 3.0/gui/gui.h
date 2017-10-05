#ifndef GGUI_H
#define GGUI_H 1

// c++
#include <string>
using namespace std;

// qt
#include <QtWidgets>

// mlibrary
#include "qtButtonsWidget.h"
#include "goptions.h"
#include "gruns.h"

class GemcGUI : public QWidget
{
	// metaobject required for non-qt slots
	Q_OBJECT

public:
	GemcGUI(string resources, GOptions* gopt, QWidget *parent = Q_NULLPTR);
	~GemcGUI();


private:
	QtButtonsWidget *leftButtons; 
	QStackedWidget  *rightContent;
	QLineEdit       *nEvents;
	QLabel          *eventNumber;
	QTimer          *gtimer;       // for cycling events

	// gruns to read number of events
	GRuns *gruns;
	
private:
	void createLeftButtons();
	void createRightContent(GOptions* gopt);
	void createTopButtons(QHBoxLayout *topLayout);
	void updateGui();

private slots:
	// definded in topLayout.cc
	// beamOn() causes workers to update the screen
	// from a sub-thread
	void beamOn();
	void cycleBeamOn();
	void stopCycleBeamOn();
	void gquit();
};

#endif
