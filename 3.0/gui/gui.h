#ifndef GGUI_H
#define GGUI_H 1

// gemc master gui

// c++
#include <string>
using namespace std;

// qt
#include <QtWidgets>

// mlibrary
#include "qtButtonsWidget.h"
#include "goptions.h"

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

private:
	void createLeftButtons();
	void createRightContent(GOptions* gopt);
	void createTopButtons(QHBoxLayout *topLayout);


private slots:
	// definded in topLayout.cc
	void gquit();
	void beamOn();
	void cycleBeamOn();
	void stopCycleBeamOn();

};

#endif
