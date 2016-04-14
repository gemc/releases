// %%%%%%%%%%
// Qt headers
// %%%%%%%%%% 
#include <QtGui>

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UnitsTable.hh"

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "detector_editor.h"
#include "images/g4Box_xpm.h"
#include "images/g4Cons_xpm.h"
#include "images/g4Polycone_xmp.h"
#include "images/g4Sphere_xpm.h"
#include "images/g4Trd_xpm.h"
#include "images/g4Trap_xpm.h"
#include "images/g4Tubs_xpm.h"
#include "images/g4Torus_xpm.h"
#include "images/g4EllipticalTube_xpm.h"
#include "images/copy_xpm.h"
#include "images/operation_xpm.h"
#include "string_utilities.h"


// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <iostream>
#include <sstream>
using namespace std;

DetectorEditor::DetectorEditor(detector *detect, QWidget *parent):QDialog(parent)
{
	Detector = detect;  
	tabWidget = new QTabWidget;
	tabWidget->addTab(new PlacementTab(Detector),   tr("Placement"));
	tabWidget->addTab(new DimensionsTab(Detector),  tr("Dimensions"));
	tabWidget->addTab(new SensitivityTab(Detector), tr("Material, Sensitivity"));
	
	buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok| QDialogButtonBox::Cancel);
	connect(buttonBox, SIGNAL(accepted()), this, SLOT(accept()));
	connect(buttonBox, SIGNAL(rejected()), this, SLOT(reject()));

	QVBoxLayout *mainLayout = new QVBoxLayout;
	mainLayout->addWidget(tabWidget);
	mainLayout->addWidget(buttonBox);
	setLayout(mainLayout);

	setWindowTitle(tr("Detector Editor"));
}

PlacementTab::PlacementTab(detector *detect, QWidget *parent):QWidget(parent)
{
	Detector = detect;  
	QLabel *dNameLabel = new QLabel(tr("Volume Name:"));
	QLineEdit *dNameEdit = new QLineEdit(Detector->name.c_str());
	QLabel *solidType = new QLabel(detect->type.c_str());
	solidType->setFrameStyle(QFrame::Panel | QFrame::Sunken);
 
	stringstream Dim;
	string d1, d2, dtot;
	Dim.clear();
	QLabel *placeXLabel = new QLabel("X Position");
	Dim << G4BestUnit(Detector->pos.getX(), "Length");
	Dim >> d1 >> d2;
	dtot = d1 + "*" + d2 ;
	placeXEdit = new QLineEdit(dtot.c_str());

	Dim.clear();
	QLabel *placeYLabel = new QLabel("Y Position");
	Dim << G4BestUnit(Detector->pos.getY(), "Length");
	Dim >> d1 >> d2;
	dtot = d1 + "*" + d2 ;
	placeYEdit = new QLineEdit(dtot.c_str());

	Dim.clear();
	QLabel *placeZLabel = new QLabel("Z Position");
	Dim << G4BestUnit(Detector->pos.getZ(), "Length");
	Dim >> d1 >> d2;
	dtot = d1 + "*" + d2 ;
	placeZEdit = new QLineEdit(dtot.c_str());

	Dim.clear();
	QLabel *rotXLabel = new QLabel("Euler Phi Rotation");
	Dim << G4BestUnit(Detector->rot.getPhi(), "Angle");
	Dim >> d1 >> d2;
	dtot = d1 + "*" + d2 ;
	rotXEdit = new QLineEdit(dtot.c_str());

	Dim.clear();
	QLabel *rotYLabel = new QLabel("Euler theta Rotation");
	Dim << G4BestUnit(Detector->rot.getTheta(), "Angle");
	Dim >> d1 >> d2;
	dtot = d1 + "*" + d2 ;
	rotYEdit = new QLineEdit(dtot.c_str());
	
	Dim.clear();
	QLabel *rotZLabel = new QLabel("Euler psi Rotation");
	Dim << G4BestUnit(Detector->rot.getPsi(), "Angle");
	Dim >> d1 >> d2;
	dtot = d1 + "*" + d2 ;
	rotZEdit = new QLineEdit(dtot.c_str());
	
	
	QVBoxLayout *mainLayout = new QVBoxLayout;
	mainLayout->addWidget(dNameLabel);
	mainLayout->addWidget(dNameEdit);
	mainLayout->addWidget(placeXLabel);
	mainLayout->addWidget(placeXEdit);
	mainLayout->addWidget(placeYLabel);
	mainLayout->addWidget(placeYEdit);
	mainLayout->addWidget(placeZLabel);
	mainLayout->addWidget(placeZEdit);
	mainLayout->addSpacing(50);
	mainLayout->addWidget(rotXLabel);
	mainLayout->addWidget(rotXEdit);
	mainLayout->addWidget(rotYLabel);
	mainLayout->addWidget(rotYEdit);
	mainLayout->addWidget(rotZLabel);
	mainLayout->addWidget(rotZEdit);
	
	setLayout(mainLayout);
	connect ( dNameEdit ,  SIGNAL( textChanged (QString) ),  this, SLOT( change_dname(QString) ) );
	connect ( placeXEdit , SIGNAL( textChanged (QString) ),  this, SLOT( change_placement() ) );
	connect ( placeYEdit , SIGNAL( textChanged (QString) ),  this, SLOT( change_placement() ) );
	connect ( placeZEdit , SIGNAL( textChanged (QString) ),  this, SLOT( change_placement() ) );

}


SensitivityTab::SensitivityTab(detector *detect, QWidget *parent):QWidget(parent)
{
	string what;
	Detector = detect;
	
	what = "Volume Name: " + Detector->name;
	QLabel *dNameLabel = new QLabel(what.c_str());

	what = "Description: " + Detector->description;
	QLabel *dDescLabel = new QLabel(what.c_str());
	
	what = "Material: " + Detector->material;
	QLabel *dMateLabel = new QLabel(what.c_str());

	what = "Magnetic Field: " + Detector->magfield;
	QLabel *dMagfLabel = new QLabel(what.c_str());
	
	what = "Sensitivity, bank: " + Detector->sensitivity;
	QLabel *dSensLabel = new QLabel(what.c_str());


	
	QLabel *dHitLabel, *dIdenLabel;
	dHitLabel  = NULL;
	dIdenLabel = NULL;
	
	if(Detector->identity.size())
	{
		what = "Hit Type: " + Detector->hitType;
		dHitLabel = new QLabel(what.c_str());

		what = "Identifier: " ;
		for(unsigned int i=0; i<Detector->identity.size(); i++)
			what = what + Detector->identity[i].name + " " + stringify(Detector->identity[i].id) + "   ";
		dIdenLabel = new QLabel(what.c_str());
	}
	
	QVBoxLayout *mainLayout = new QVBoxLayout;
	mainLayout->addWidget(dNameLabel);
	mainLayout->addWidget(dDescLabel);
	mainLayout->addWidget(dMateLabel);
	mainLayout->addWidget(dMagfLabel);
	mainLayout->addWidget(dSensLabel);
	if(Detector->identity.size())
	{
		mainLayout->addWidget(dHitLabel);
		mainLayout->addWidget(dIdenLabel);
	}
	
	setLayout(mainLayout);
	
}




void PlacementTab::change_dname(QString dname)
{
	Detector->name = gemc_tostring(dname);
}


DimensionsTab::DimensionsTab(detector *detect, QWidget *parent):QWidget(parent)
{
	Detector = detect;  
	QLabel *solidType = new QLabel(detect->type.c_str());
	solidType->setFrameStyle(QFrame::Panel | QFrame::Sunken);
	vector< vector<string> > dimTypes = dimensionstype(Detector->type);
	for(unsigned int i=0; i<dimTypes.size(); i++)
	{
		stringstream Dim;
		string d1, d2, dtot;
		Dim << G4BestUnit(Detector->dimensions[i], dimTypes[i][1]);
		Dim >> d1 >> d2;
		dtot = d1 + "*" + d2 ;
		dimTypesLabel.push_back(new QLabel(dimTypes[i][0].c_str()));
		dimTypesEdit.push_back(new QLineEdit(dtot.c_str()));
	}
	QPixmap solidpic;
	if(Detector->type == "Box")        solidpic = QPixmap(g4Box_xpm);
	if(Detector->type == "Cons")       solidpic = QPixmap(g4Cons_xpm);
	if(Detector->type == "G4Trap")     solidpic = QPixmap(g4Trap_xpm);
	if(Detector->type == "ITrd")       solidpic = QPixmap(g4Trap_xpm);
	if(Detector->type == "Polycone")   solidpic = QPixmap(g4Polycone_xpm);
	if(Detector->type == "Tube")       solidpic = QPixmap(g4Tubs_xpm);
	if(Detector->type == "Sphere")     solidpic = QPixmap(g4Sphere_xpm);
	if(Detector->type == "Trd")        solidpic = QPixmap(g4Trd_xpm);
	if(Detector->type == "Ellipsoid")  solidpic = QPixmap(g4EllipticalTube_xpm);
	if(Detector->type == "Torus")      solidpic = QPixmap(g4Torus_xpm);
	if(Detector->type.find("CopyOf")     != string::npos) solidpic = QPixmap(copy_xpm);
	if(Detector->type.find("Operation:") != string::npos) solidpic = QPixmap(operation_xpm);
	
	QLabel *solidPicL = new QLabel();
	solidPicL->setPixmap(solidpic);
 
	QWidget *VPlacements = new QWidget(this);
 
	QVBoxLayout *mainLayout = new QVBoxLayout;
	mainLayout->addWidget(solidType);
	for(unsigned int i=0; i<dimTypes.size(); i++)
	{
		mainLayout-> addWidget( dimTypesLabel[i]);
		mainLayout-> addWidget( dimTypesEdit[i]);
	}
	VPlacements ->setLayout(mainLayout);
	VPlacements->show();

 
	QHBoxLayout *viewLayout = new QHBoxLayout(this);
	viewLayout->addWidget(VPlacements);
	viewLayout->addWidget(solidPicL);
 
	for(unsigned int i=0; i<dimTypes.size(); i++)
	{   
		mainLayout-> addWidget( dimTypesLabel[i]);
		mainLayout-> addWidget( dimTypesEdit[i]);
		connect ( dimTypesEdit[i] , SIGNAL( textChanged (QString) ),  this, SLOT( change_dimension() ) );
	}

}
 
void DimensionsTab::change_dimension()
{
	vector<double> newdimensions;
	vector< vector<string> > dimTypes = dimensionstype(Detector->type);
	for(unsigned int i=0; i<dimTypes.size(); i++)
		newdimensions.push_back(get_number(gemc_tostring(dimTypesEdit[i]->text())));
	Detector->dimensions = newdimensions;

}


void PlacementTab::change_placement()
{
 
	double x = get_number(gemc_tostring(placeXEdit->text()));
	double y = get_number(gemc_tostring(placeYEdit->text()));
	double z = get_number(gemc_tostring(placeZEdit->text()));
 
	G4ThreeVector newpos(x, y, z);

 // for(int i=0; i<dimTypes.size(); i++)
 //  newdimensions.push_back(get_number(gemc_tostring(dimTypesEdit[i]->text())));
	Detector->pos = newpos;

}












