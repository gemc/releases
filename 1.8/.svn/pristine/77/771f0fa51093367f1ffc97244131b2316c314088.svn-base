// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QApplication>
#include <QLineEdit>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "gemc_MainGui.h"
#include "string_utilities.h"
// All icon images must be 96x84
#include "images/run_control_xpm.h"
#include "images/camera_control_xpm.h"
#include "images/detector_inspector_xpm.h"
#include "images/infos_xpm.h"
#include "images/g4dialog_xpm.h"
#include "images/analog_signal_xpm.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <iostream>
#include <string>
using namespace std;

gemcMainWidget::gemcMainWidget(G4RunManager *RM, G4VisManager *VM, gemc_opts *Opts, map<string, MSensitiveDetector*> SDM)
{
	runManager = RM;
	visManager = VM;
	UImanager  = G4UImanager::GetUIpointer();
	DTree      = NULL;
	gemcOpt    = Opts;
	SeDe_Map   = SDM;
	double qt_mode = gemcOpt->args["USE_QT"].arg ;
	
	contentsWidget = new QListWidget;
	contentsWidget->setViewMode(QListView::IconMode);
	// icon size 
	contentsWidget->setIconSize(QSize(96, 84));
	contentsWidget->setMovement(QListView::Static);

	// icon container sizes
	contentsWidget->setMinimumWidth(125);
	contentsWidget->setMaximumWidth(125);
	contentsWidget->setMinimumHeight(700);
	// makes all icon the same size
	contentsWidget->setUniformItemSizes(1);
	// activate tracking (for mouse over effect)
	contentsWidget->setMouseTracking(1);
	
	contentsWidget->setSpacing(8);

	// Content:
	// Run Control
	// Camera Control
	// Infos
	// G4 Dialog
	// Oscilloscope Signal
  
	pagesWidget = new QStackedWidget;
	pagesWidget->addWidget(new run_control    (this, gemcOpt));
	pagesWidget->addWidget(new camera_control (this, gemcOpt));
	pagesWidget->addWidget(new infos          (this, gemcOpt));
	pagesWidget->addWidget(new g4dialog       (this, gemcOpt));
	pagesWidget->addWidget(gsig = new gsignal (this, gemcOpt, SeDe_Map));
	pagesWidget->setMinimumWidth(650);
	pagesWidget->setMaximumWidth(650);
	
	QPushButton *closeButton = new QPushButton(tr("Exit"));
	
	createIcons();
	contentsWidget->setCurrentRow(0);
	if(qt_mode > 1)
		contentsWidget->setCurrentRow(1);
	
	//connect(closeButton, SIGNAL(clicked()), qApp, SLOT(quit()));
	connect(closeButton, SIGNAL(clicked()), this, SLOT(gemc_quit()));
	
	QHBoxLayout *horizontalLayout = new QHBoxLayout;
	horizontalLayout->addWidget(contentsWidget);
	horizontalLayout->addWidget(pagesWidget, 1);
	
	QHBoxLayout *buttonsLayout = new QHBoxLayout;
	buttonsLayout->addStretch(1);
	buttonsLayout->addWidget(closeButton);
	
	QVBoxLayout *mainLayout = new QVBoxLayout;
	mainLayout->addLayout(horizontalLayout);
	mainLayout->addStretch(1);
	mainLayout->addSpacing(12);
	mainLayout->addLayout(buttonsLayout);
	setLayout(mainLayout);
	
	setWindowTitle(tr("Config Dialog"));

	return;
}

void gemcMainWidget::Build_DTree()
{
	string hd_msg = gemcOpt->args["LOG_MSG"].args;
	double VERB   = gemcOpt->args["GEO_VERBOSITY"].arg ;

	if(DTree != NULL)
	{
		delete DTree;
		if(VERB>3)
			cout << hd_msg << " Detector Widget Tree Already Present." << endl;
	}
	DTree = new detector_tree(Hall_Map, *gemcOpt, runManager, visManager, UImanager, *mats); 
	DTree->show();
}


void gemcMainWidget::changePage(QListWidgetItem *current, QListWidgetItem *previous)
{
	if (!current)
		current = previous;
	
	if(gemc_tostring(current->text()) == "Detector")
	{
		Build_DTree();
		return;
	}

	// manually setting the content index because "detector" doesn't have a content
	if(contentsWidget->row(current) == 0) pagesWidget->setCurrentIndex(0);
	if(contentsWidget->row(current) == 1) pagesWidget->setCurrentIndex(1);
	if(contentsWidget->row(current) == 3) pagesWidget->setCurrentIndex(2);
	if(contentsWidget->row(current) == 4) pagesWidget->setCurrentIndex(3);
	if(contentsWidget->row(current) == 5) 
  {
    pagesWidget->setCurrentIndex(4);
    gsig->CreateSDetsTree();    
  }
}

void gemcMainWidget::createIcons()
{
	i_default = QColor( 220,  220, 255);
	i_hovered = QColor( 210,  210, 240);
	
	QListWidgetItem *rcontrol = new QListWidgetItem(contentsWidget);
	rcontrol->setIcon(QPixmap(run_control_xpm));
	rcontrol->setText(tr("Run Control"));
	rcontrol->setBackground(QBrush(i_default));
	rcontrol->setTextAlignment(Qt::AlignHCenter);
	rcontrol->setFlags( Qt::ItemIsSelectable | Qt::ItemIsEnabled);

	QListWidgetItem *ccontrol = new QListWidgetItem(contentsWidget);
	ccontrol->setIcon(QPixmap(camera_control_xpm));
	ccontrol->setText(tr("Camera"));
	ccontrol->setBackground(QBrush(i_default));
	ccontrol->setTextAlignment(Qt::AlignHCenter);
	ccontrol->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled);
	
	QListWidgetItem *dinspector = new QListWidgetItem(contentsWidget);
	dinspector->setIcon(QPixmap(detector_inspector_xpm));
	dinspector->setText(tr("Detector"));
	dinspector->setBackground(QBrush(i_default));
	dinspector->setTextAlignment(Qt::AlignHCenter);
	dinspector->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled);

	QListWidgetItem *infos = new QListWidgetItem(contentsWidget);
	infos->setIcon(QPixmap(infos_xpm));
	infos->setText(tr("Infos"));
	infos->setBackground(QBrush(i_default));
	infos->setTextAlignment(Qt::AlignHCenter);
	infos->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled);
  
	QListWidgetItem *g4dialog = new QListWidgetItem(contentsWidget);
	g4dialog->setIcon(QPixmap(g4dialog_xpm));
	g4dialog->setText(tr("G4Dialog"));
	g4dialog->setBackground(QBrush(i_default));
	g4dialog->setTextAlignment(Qt::AlignHCenter);
	g4dialog->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled);
  
	QListWidgetItem *gsignal = new QListWidgetItem(contentsWidget);
	gsignal->setIcon(QPixmap(analog_signal_xpm));
	gsignal->setText(tr("Signals"));
	gsignal->setBackground(QBrush(i_default));
	gsignal->setTextAlignment(Qt::AlignHCenter);
	gsignal->setFlags(Qt::ItemIsSelectable | Qt::ItemIsEnabled);
  
	connect(contentsWidget,
					SIGNAL(currentItemChanged(QListWidgetItem *, QListWidgetItem*)),
          this, SLOT(changePage(QListWidgetItem *, QListWidgetItem*)));
	
	connect(contentsWidget,	SIGNAL(itemEntered(QListWidgetItem *)), this, SLOT(change_background(QListWidgetItem *)) );
	
}

void gemcMainWidget::change_background(QListWidgetItem* item)
{
	for(int i=0; i<contentsWidget->count(); i++)
		contentsWidget->item(i)->setBackground(QBrush(i_default));
	
	item->setBackground(QBrush(i_hovered));

}


gemcMainWidget::~gemcMainWidget()
{
	string hd_msg = gemcOpt->args["LOG_MSG"].args;

	if(DTree != NULL)
		delete DTree;

	cout << endl;
}





