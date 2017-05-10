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

class GemcGUI : public QWidget
{
	// metaobject required for non-qt slots
	Q_OBJECT

	public:

	GemcGUI(string resources, QWidget *parent = 0);
	~GemcGUI();

	private:

	QtButtonsWidget* createLeftButtons();

};

#endif
