#ifndef gsignal_H
#define gsignal_H 1

// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QWidget>
#include <QSlider>
#include <QComboBox>
#include <QTextEdit>


// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"
#include "MSensitiveDetector.h"

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UImanager.hh"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <string>
#include <map>
using namespace std;


// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%
class gsignal : public QWidget
{
	// metaobject required for non-qt slots
	Q_OBJECT
	
	public:
		gsignal(QWidget *parent, gemc_opts*, map<string, MSensitiveDetector*>);
	 ~gsignal();
		
    int xorig, yorig;    // origin of the axis
    int xaxil, yaxil;    // axis length
    double xmin, ymin;      // graph minima
    double xmax, ymax;      // graph maxima
    double inside;          // how much inside the graph will be  
    double dx, dy, DX, DY;  // lowercase: graph limits; uppercase: scene inside limits 
    int nticksx, nticksy;
  
    void plots_bg(string xtit, string ytit, vector<double> x, vector<double> y, string title);  // draw axis, ticks and labels
    void osci_bg( string xtit, string ytit, vector<double> x, vector<double> y, string title);  // draw axis, ticks, labels and oscilloscope background
    void plot_graph(vector<double> x, vector<double> y, vector<int> pid);
  
    gemc_opts *gemcOpt;
		G4UImanager  *UImanager;
    map<string, MSensitiveDetector*>   SeDe_Map;
  
    map<int, QPen> pcolors;
  
	private:
    QTreeWidget *gsignals;
    QTreeWidget *s_detectors;
    
    QLinearGradient HitGrad;
    QBrush          HitBrush;

    QGraphicsView *plots;
    QGraphicsScene *scene;
	
  
  public slots:

    QTreeWidget* CreateSDetsTree();           // creates Sensitive Detector / Hits Tree
    QTreeWidget* CreateSignalsTree();         // creates signals tree
 

};

#endif








