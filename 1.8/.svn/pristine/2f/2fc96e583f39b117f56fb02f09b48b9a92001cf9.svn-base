#ifndef gemc_MAINGUI_H
#define gemc_MAINGUI_H

// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QComboBox>
#include <QGroupBox>
#include <QLCDNumber>
#include <QLineEdit>
#include <QObject>
#include <QPushButton>
#include <QSlider>
#include <QVBoxLayout>
#include <QWidget>

#include <QListWidgetItem>
#include <QStackedWidget>

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4Material.hh"
#include "G4RunManager.hh"
#include "G4VisManager.hh"
#include "G4UImanager.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "MSensitiveDetector.h"
#include "usage.h"
#include "run_control.h"
#include "camera_control.h"
#include "detector_tree.h"
#include "infos.h"
#include "g4dialog.h"
#include "gsignal.h"

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class gemcMainWidget : public QWidget
{
  // metaobject required for non-qt slots
	Q_OBJECT
	
	public:
		gemcMainWidget(G4RunManager*, G4VisManager*, gemc_opts*, map<string, MSensitiveDetector*>);
		~gemcMainWidget();
		
		map<string, detector>             *Hall_Map;      ///< Detectors Map
		map<string, G4Material*>          *mats;          ///< Materials Map
    map<string, MSensitiveDetector*>   SeDe_Map;      ///< Sensitive detector Map
  
		gemc_opts *gemcOpt;
		
	private:
				
		// passing G4 managers to QT so we can delete them when QT quits
		// and can access directly the UImanager
		G4RunManager *runManager;
		G4VisManager *visManager;
		G4UImanager  *UImanager;
		
		detector_tree *DTree;
    gsignal *gsig;
  
	private slots:
		void  Build_DTree();
		// qApp->quit() also calls an exit from main - so need to these
		void  gemc_quit(){delete visManager ; delete runManager; qApp->quit();}
		
	private:
		void createIcons();
		
		QListWidget *contentsWidget;
		QStackedWidget *pagesWidget;
		QColor i_default;
		QColor i_hovered;
		
	public slots:
		void changePage(QListWidgetItem *current, QListWidgetItem *previous);
		void change_background(QListWidgetItem*);
		
};

#endif



