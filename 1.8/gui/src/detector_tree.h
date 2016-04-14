#ifndef detector_tree_H
#define detector_tree_H 1

// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QTreeWidgetItem>
#include <QAction>
#include <QContextMenuEvent>

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4RunManager.hh"
#include "G4VisManager.hh"
#include "G4UImanager.hh"
#include "G4GDMLParser.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "detector.h"
#include "usage.h"


// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <string>
#include <map>
using namespace std;

// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class tree_item
{
public:
    tree_item(){;}
    ~tree_item(){;}
    
public:
    string volume;
    string mother;
    QTreeWidgetItem *treeItem;
    int scanned;
    int sensitive;
    int exist;
    int visible;
    int wiresolid;
};


// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class detector_tree : public QWidget
{
    // metaobject required for non-qt slots
    Q_OBJECT
    
public:
    detector_tree(){;}
    detector_tree(map<string, detector>*, gemc_opts, G4RunManager*, G4VisManager*, G4UImanager*, map<string, G4Material*>);
    ~detector_tree();
    
    gemc_opts gemcOpt;
    map<string, detector> *Hall_Map;
    
    map<string, tree_item> tree_map; 
    map<string, tree_item> read_geometry(QTreeWidget *motherWidget);
    map<string, G4Material*> *MMats;
    
    QLinearGradient ActiveGrad; 
    QLinearGradient SensitiveGrad;
    QLinearGradient NonActiveGrad;
    QLinearGradient NonVisibleGrad;
    
    QBrush ActiveBrush;
    QBrush SensitiveBrush;
    QBrush NonActiveBrush;
    QBrush NonVisibleBrush;
    
private:
    QTreeWidget *treeWidget;
    QAction *Switch_visibility;
    QAction *Switch_visibility_daughters;
    QAction *Switch_wiresolid;
    QAction *Switch_color;
    QAction *Edit_Detector;
    QAction *Write_GDML_File;

    // passing G4 managers to QT so we can delete them when QT quits
    // and can access directly the UImanager
    G4RunManager *runManager;
    G4VisManager *visManager;
    G4UImanager  *UImanager;
    
    private slots: 
    void switch_visibility();
    void switch_visibility_daughters();
    void switch_wiresolid();
    void switch_color();
    void edit_detector();
    void write_gdml_file();
    
private: 
    void createActions();
    
};

#endif
