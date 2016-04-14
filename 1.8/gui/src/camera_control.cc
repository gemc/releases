// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QtGui>

// windows.h must come before gl.h in windows
#ifdef _MSC_VER
	#include <windows.h>	
#endif

#include <gl.h>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "camera_control.h"
#include "string_utilities.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%

camera_control::camera_control(QWidget *parent, gemc_opts *Opts) : QWidget(parent)
{
	gemcOpt = Opts;
	UImanager  = G4UImanager::GetUIpointer();
	
	QGroupBox *anglesGroup = new QGroupBox(tr("Camera Control"));
	anglesGroup->setMinimumWidth(450);

	QLabel *moveLabel = new QLabel(tr("Move:"));
	moveCombo = new QComboBox;
	moveCombo->addItem(tr("Detector"));
	moveCombo->addItem(tr("Light"));
	
	QLabel *projLabel = new QLabel(tr("Projection:"));
	projCombo = new QComboBox;
	projCombo->addItem(tr("Orthogonal"));
	projCombo->addItem(tr("Perspective 30"));
	projCombo->addItem(tr("Perspective 45"));
	projCombo->addItem(tr("Perspective 60"));
	connect ( projCombo   , SIGNAL( currentIndexChanged (int) ), this, SLOT( set_perspective(int)    ) );
	
	QHBoxLayout *mpLayout = new QHBoxLayout;
	mpLayout->addWidget(moveLabel);
	mpLayout->addWidget(moveCombo);
	mpLayout->addSpacing(100);
	mpLayout->addWidget(projLabel);
	mpLayout->addWidget(projCombo);
	
	theta_hall = phi_hall = 0;  // initial angles
	zoom_value = 1; //initial zoom

	// Theta Controls
	QLabel *thetaLabel = new QLabel(tr("theta"));
	theta_slider = new QSlider(Qt::Horizontal);
	theta_slider->setTickInterval(1);
	theta_slider->setRange(0, 180);
	QLCDNumber *Theta_LCD = new QLCDNumber(this);
	Theta_LCD->setFont(QFont("Helvetica", 32, QFont::Bold));
	Theta_LCD->setMaximumSize(45, 45);
	Theta_LCD->setSegmentStyle(QLCDNumber::Flat);
	for(int t=0; t<=180; t+=30)
	{
		char tmp[100];
		sprintf(tmp, "%d", t);
		ThetaSet.push_back(tmp);
	}
	QComboBox *ThetaCombo = new QComboBox;
	for(unsigned int i=0; i<ThetaSet.size(); i++)  ThetaCombo->addItem(tr(ThetaSet[i].c_str()));
	ThetaCombo->setMaximumSize(60, 45);
	QHBoxLayout *thetaLayout = new QHBoxLayout;
	thetaLayout->addWidget(thetaLabel);
	thetaLayout->addWidget(theta_slider);
	thetaLayout->addWidget(Theta_LCD);
	thetaLayout->addWidget(ThetaCombo);

	connect ( theta_slider , SIGNAL( valueChanged        (int) ),     this,   SLOT( change_theta(int)   ) );
	connect ( theta_slider , SIGNAL( valueChanged        (int) ),  Theta_LCD, SLOT( display(int)        ) );
	connect ( ThetaCombo   , SIGNAL( currentIndexChanged (int) ),     this,   SLOT( set_theta(int)      ) );
	connect ( ThetaCombo   , SIGNAL( currentIndexChanged (int) ),     this,   SLOT( change_theta_s(int) ) );
	
	// Phi Controls
	QLabel *phiLabel = new QLabel(tr("phi"));
	phi_slider = new QSlider(Qt::Horizontal);
	phi_slider->setTickInterval(1);
	phi_slider->setRange(0, 360);
	QLCDNumber *Phi_LCD = new QLCDNumber(this);
	Phi_LCD->setFont(QFont("Helvetica", 32, QFont::Bold));
	Phi_LCD->setMaximumSize(45, 45);
	Phi_LCD->setSegmentStyle(QLCDNumber::Flat);
	for(int t=0; t<=360; t+=30)
	{
		char tmp[100];
		sprintf(tmp, "%d", t);
		PhiSet.push_back(tmp);
	}
	QComboBox *PhiCombo = new QComboBox;
	for(unsigned int i=0; i<PhiSet.size(); i++)  PhiCombo->addItem(tr(PhiSet[i].c_str()));
	PhiCombo->setMaximumSize(60, 45);
	QHBoxLayout *phiLayout = new QHBoxLayout;
	phiLayout->addWidget(phiLabel);
	phiLayout->addWidget(phi_slider);
	phiLayout->addWidget(Phi_LCD);
	phiLayout->addWidget(PhiCombo);
	
	connect ( phi_slider , SIGNAL( valueChanged        (int) ),     this, SLOT( change_phi(int)   ) );
	connect ( phi_slider , SIGNAL( valueChanged        (int) ),  Phi_LCD, SLOT( display(int)      ) );
	connect ( PhiCombo   , SIGNAL( currentIndexChanged (int) ),     this, SLOT( set_phi(int)      ) );
	connect ( PhiCombo   , SIGNAL( currentIndexChanged (int) ),     this, SLOT( change_phi_s(int) ) );

	QVBoxLayout *anglesLayout = new QVBoxLayout;
	anglesLayout->addLayout(mpLayout);
	anglesLayout->addSpacing(12);
	anglesLayout->addLayout(thetaLayout);
	anglesLayout->addSpacing(2);
	anglesLayout->addLayout(phiLayout);
	anglesGroup->setLayout(anglesLayout);
	

	// Pan label, buttons, slider
	QGroupBox *PanGroup = new QGroupBox(tr("Pan"));

	QToolButton *pan_up = new QToolButton(this);
	pan_up->setArrowType(Qt::UpArrow);
	pan_up->setAutoRepeat(1);
	QHBoxLayout *pan_upLayout = new QHBoxLayout;
	pan_upLayout->addWidget(pan_up);

	QLabel *panLabel = new QLabel(tr("Pan Strength"));
	QToolButton *pan_left = new QToolButton(this);
	pan_left->setAutoRepeat(1);
	pan_left->setArrowType(Qt::LeftArrow);

	pan_slider = new QSlider(Qt::Horizontal);
	pan_slider->setTickInterval(1);
	pan_slider->setRange(1, 25);
	pan_slider->setValue(4);
	
	QToolButton *pan_right = new QToolButton(this);
	pan_right->setArrowType(Qt::RightArrow);
	pan_right->setAutoRepeat(1);
	
	QHBoxLayout *pan_lrLayout = new QHBoxLayout;
	pan_lrLayout->addWidget(pan_left);
	pan_lrLayout->addWidget(panLabel);
	pan_lrLayout->addWidget(pan_slider);
	pan_lrLayout->addWidget(pan_right);
	
	QToolButton *pan_down = new QToolButton(this);
	pan_down->setArrowType(Qt::DownArrow);
	pan_down->setAutoRepeat(1);
	QHBoxLayout *pan_downLayout = new QHBoxLayout;
	pan_downLayout->addWidget(pan_down);

	connect(pan_up,   SIGNAL(pressed()), this, SLOT( clickpan_up()    ) );
	connect(pan_left, SIGNAL(pressed()), this, SLOT( clickpan_left()  ) );
	connect(pan_right,SIGNAL(pressed()), this, SLOT( clickpan_right() ) );
	connect(pan_down, SIGNAL(pressed()), this, SLOT( clickpan_down()  ) );
	
	QVBoxLayout *pansLayout = new QVBoxLayout;
	pansLayout->addLayout(pan_upLayout);
	pansLayout->addLayout(pan_lrLayout);
	pansLayout->addLayout(pan_downLayout);
	PanGroup->setLayout(pansLayout);


	
	QGroupBox *vOptionsGroup = new QGroupBox(tr("Visualization Options"));
	
	QLabel *antialiasingLabel = new QLabel(tr("Anti-Aliasing"));
	aliasing = new QComboBox;
	aliasing->addItem(tr("OFF"));
	aliasing->addItem(tr("ON"));
	QHBoxLayout *aliasingLayout = new QHBoxLayout;
	aliasingLayout->addWidget(antialiasingLabel);
	aliasingLayout->addWidget(aliasing);
	connect ( aliasing   , SIGNAL( currentIndexChanged (int) ), this, SLOT( switch_antialiasing(int)    ) );
	
	QLabel *sides_per_circlesLabel = new QLabel(tr("Sides per circle"));
	sides_per_circle = new QComboBox;
	sides_per_circle->addItem(tr("50"));
	sides_per_circle->addItem(tr("100"));
	sides_per_circle->addItem(tr("200"));
	sides_per_circle->addItem(tr("500"));
	sides_per_circle->setCurrentIndex(1);
	QHBoxLayout *sides_per_circleLayout = new QHBoxLayout;
	sides_per_circleLayout->addWidget(sides_per_circlesLabel);
	sides_per_circleLayout->addWidget(sides_per_circle);
	connect ( sides_per_circle   , SIGNAL( currentIndexChanged (int) ), this, SLOT( switch_sides_per_circle(int)    ) );
	
	QLabel *auxiliaryEdgesLabel = new QLabel(tr("Auxiliary Edges"));
	auxiliary = new QComboBox;
	auxiliary->addItem(tr("OFF"));
	auxiliary->addItem(tr("ON"));
	QHBoxLayout *auxedgesLayout = new QHBoxLayout;
	auxedgesLayout->addWidget(auxiliaryEdgesLabel);
	auxedgesLayout->addWidget(auxiliary);
	connect ( auxiliary   , SIGNAL( currentIndexChanged (int) ), this, SLOT( switch_auxiliary_edges(int)    ) );
	
	QVBoxLayout *voptionsLayout = new QVBoxLayout;
	voptionsLayout->addLayout(aliasingLayout);
	voptionsLayout->addLayout(sides_per_circleLayout);
	voptionsLayout->addLayout(auxedgesLayout);
	vOptionsGroup->setLayout(voptionsLayout);
	
	
	QHBoxLayout *PanvOptionsLayout = new QHBoxLayout;
	PanvOptionsLayout->addWidget(PanGroup);
	PanvOptionsLayout->addWidget(vOptionsGroup);
	
	
	// Zoom Controls
	QGroupBox *ZoomGroup = new QGroupBox(tr("Zoom"));
	zoom_slider = new QSlider(Qt::Horizontal);
	zoom_slider->setTickInterval(1);
	zoom_slider->setRange(0, 360);
	
	QHBoxLayout *zoomLayout = new QHBoxLayout;
	zoomLayout->addWidget(zoom_slider);
	ZoomGroup->setLayout(zoomLayout);
	connect ( zoom_slider , SIGNAL( valueChanged(int) ), this, SLOT( zoom(int) ) );


	// Various Controls
	QGroupBox *OptionsGroup = new QGroupBox(tr(""));
	QPushButton *back_color = new QPushButton("Background Color", this);
	QPushButton *screenshot = new QPushButton("Screenshot",       this);
	connect ( back_color, SIGNAL( pressed() ), this, SLOT( change_background_color() ) );
	connect ( screenshot, SIGNAL( pressed() ), this, SLOT( take_screenshot()         ) );
	
	
	QHBoxLayout *optionsLayout = new QHBoxLayout;
	optionsLayout->addWidget(back_color);
	optionsLayout->addWidget(screenshot);
	OptionsGroup->setLayout(optionsLayout);
	
	
	// All together
	QVBoxLayout *mainLayout = new QVBoxLayout;
	mainLayout->addWidget(anglesGroup);
	mainLayout->addLayout(PanvOptionsLayout);
	mainLayout->addSpacing(6);
	mainLayout->addWidget(ZoomGroup);
	mainLayout->addSpacing(8);
	mainLayout->addWidget(OptionsGroup);
	mainLayout->addStretch(1);
	setLayout(mainLayout);
	
	
	
}




void camera_control::change_theta(int theta)
{
	char command[100];
	theta_hall = theta - 1;

	if(gemc_tostring(moveCombo->currentText()) == "Detector")
		sprintf(command,"/vis/viewer/set/viewpointThetaPhi %d %d.", theta_hall, phi_hall);

	if(gemc_tostring(moveCombo->currentText()) == "Light")
		sprintf(command,"/vis/viewer/set/lightsThetaPhi %d %d.", theta_hall, phi_hall);

	UImanager->ApplyCommand(command);
}

void camera_control::set_theta(int index)
{
	char command[100];
	theta_hall = atoi(ThetaSet[index].c_str());
	sprintf(command,"/vis/viewer/set/viewpointThetaPhi %d %d.", theta_hall, phi_hall);
	UImanager->ApplyCommand(command);
}

void camera_control::change_theta_s(int theta)
{
	theta_slider->setSliderPosition(atoi(ThetaSet[theta].c_str()));
}

void camera_control::change_phi(int phi)
{
	char command[100];
	phi_hall = phi - 1;


	if(gemc_tostring(moveCombo->currentText()) == "Detector")
		sprintf(command,"/vis/viewer/set/viewpointThetaPhi %d %d", theta_hall, phi_hall);

	if(gemc_tostring(moveCombo->currentText()) == "Light")
		sprintf(command,"/vis/viewer/set/lightsThetaPhi %d %d.", theta_hall, phi_hall);
		
	UImanager->ApplyCommand(command);
}

void camera_control::change_phi_s(int phi)
{
	phi_slider->setSliderPosition(atoi(PhiSet[phi].c_str()));
}

void camera_control::set_phi(int index)
{
	char command[100];
	phi_hall = atoi(PhiSet[index].c_str());
	sprintf(command,"/vis/viewer/set/viewpointThetaPhi %d %d.", theta_hall, phi_hall);
	UImanager->ApplyCommand(command);
}

void camera_control::clickpan_left()
{
	char command[100];
	sprintf(command,"/vis/viewer/pan %3.2f 0 cm", -(pan_slider->value()*pan_slider->value()/4.0) /zoom_value);
	UImanager->ApplyCommand(command);
}

void camera_control::clickpan_right()
{
	char command[100];
	sprintf(command,"/vis/viewer/pan %3.2f 0 cm", (pan_slider->value()*pan_slider->value()/4.0) / zoom_value);
	UImanager->ApplyCommand(command);
}

void camera_control::clickpan_up()
{
	char command[100];
	sprintf(command,"/vis/viewer/pan 0 %3.2f cm", (pan_slider->value()*pan_slider->value()/4.0) / zoom_value);
	UImanager->ApplyCommand(command);
}

void camera_control::clickpan_down()
{
	char command[100];
	sprintf(command,"/vis/viewer/pan 0 %3.2f cm", -(pan_slider->value()*pan_slider->value()/4.0) / zoom_value);
	UImanager->ApplyCommand(command);
}

void camera_control::zoom(int zoom)
{
	static float current_zoom = 0;
	char command[100];
	float dz = zoom - current_zoom;
	
	zoom_value = 1 + dz/18.0;
	
	// cout << current_zoom << " " << dz << " " << zoom_value << endl;
	
	sprintf(command,"/vis/viewer/zoom %3.2f", zoom_value);
	
	UImanager->ApplyCommand(command);
	current_zoom = zoom_slider->value();
}

void camera_control::set_perspective(int index)
{
	char command[100];
	double angles[4] = { 0,   30,  45, 60};
	string which[4]  = {"o", "p", "p", "p"};

	sprintf(command,"/vis/viewer/set/projection %s %4.2f ",which[index].c_str(),  angles[index]);
	UImanager->ApplyCommand(command);
}

void camera_control::switch_antialiasing(int index)
{
	if(index == 0)
	{
		glDisable (GL_LINE_SMOOTH);
		glDisable (GL_POLYGON_SMOOTH);
	}
	else
	{
		glEnable (GL_LINE_SMOOTH);
		glHint (GL_LINE_SMOOTH_HINT, GL_NICEST);
		glEnable (GL_POLYGON_SMOOTH);
		glHint (GL_POLYGON_SMOOTH_HINT, GL_NICEST);
	}
	UImanager->ApplyCommand("/vis/viewer/flush");
}

void camera_control::switch_auxiliary_edges(int index)
{
	if(index == 0)
	{
		UImanager->ApplyCommand("/vis/viewer/set/auxiliaryEdge 0");
		UImanager->ApplyCommand("/vis/viewer/set/hiddenEdge 0");
	}
	else
	{
		UImanager->ApplyCommand("/vis/viewer/set/auxiliaryEdge 1");
		UImanager->ApplyCommand("/vis/viewer/set/hiddenEdge 1");
	}
	UImanager->ApplyCommand("/vis/viewer/flush");
}

void camera_control::switch_sides_per_circle(int index)
{
	char command[100];
	int sides[4] = { 50,   100,  200, 500};
	
	sprintf(command,"/vis/viewer/set/lineSegmentsPerCircle %d ", sides[index]);
	UImanager->ApplyCommand(command);
	UImanager->ApplyCommand("/vis/viewer/flush");
}

void camera_control::change_background_color()
{
	int r, g, b;
	QColor color = QColorDialog::getColor(Qt::green, this);
	color.getRgb(&r, &g, &b);
	char command[100];
	sprintf(command, "/vis/viewer/set/background %3.2f %3.2f %3.2f", r/255.0, g/255.0, b/255.0);
	UImanager->ApplyCommand(command);	
}

void camera_control::take_screenshot()
{
}

void camera_control::update_angles()
{
// 	  G4VViewer* currentViewer = visManager->GetCurrentViewer();
// 	  theta_hall = (int) floor(currentViewer->GetViewParameters().GetViewpointDirection().getTheta()/deg);
// 	  phi_hall   = (int) floor(currentViewer->GetViewParameters().GetViewpointDirection().getPhi()/deg );
// 	  TransfSli[0]->setSliderPosition ( theta_hall + 1);
// 	  TransfSli[1]->setSliderPosition ( phi_hall + 1);
}
	
	
camera_control::~camera_control()
{
	string hd_msg = gemcOpt->args["LOG_MSG"].args ;
	double VERB   = gemcOpt->args["GEO_VERBOSITY"].arg ;
	if(VERB>2)
		cout << hd_msg << " Camera Control Widget Deleted." << endl;
	
}


