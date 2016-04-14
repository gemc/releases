// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4ParticleTable.hh"

// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QtGui>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "detector.h"
#include "run_control.h"
#include "string_utilities.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <ctime>

run_control::run_control(QWidget *parent, gemc_opts *Opts) : QWidget(parent)
{
	gemcOpt   = Opts;
	UImanager  = G4UImanager::GetUIpointer();

	QTabWidget* BeamType = new QTabWidget;
	pbeamtab  = new PrimaryBeamTab(this, gemcOpt);
	lbeamtab  = new LuminosityBeamTab(this, gemcOpt);
	lbeamtab2 = new LuminosityBeamTab(this, gemcOpt, 2);
	
	BeamType->addTab(pbeamtab,  tr("Primary Particle"));
	BeamType->addTab(lbeamtab,  tr("Primary Beam"));
	BeamType->addTab(lbeamtab2, tr("Secondary Beam"));
	
	QPushButton *BeamOn = new QPushButton(tr("Beam On"));
	connect ( BeamOn , SIGNAL( pressed() ), this, SLOT( beamOn() ) );
  
	QPushButton *BeamE2S = new QPushButton(tr("Beam Every 2 seconds"));
	connect ( BeamE2S , SIGNAL( pressed() ), this, SLOT( beam_every2sec() ) );
  


	QGroupBox *neventsGroup = new QGroupBox(tr("Number of Events"));
	
	QLabel *set_nevents = new QLabel(tr("Set N:"));
	
	n_units = new QComboBox;
	n_units->addItem(tr("1"));  n_units->addItem(tr("5"));
	n_units->addItem(tr("10")); n_units->addItem(tr("15"));
	n_units->addItem(tr("20")); n_units->addItem(tr("25"));
	n_units->addItem(tr("30")); n_units->addItem(tr("35"));
	n_units->addItem(tr("40")); n_units->addItem(tr("45"));
	n_units->addItem(tr("50")); n_units->addItem(tr("55"));
	n_units->addItem(tr("60")); n_units->addItem(tr("65"));
	n_units->addItem(tr("70")); n_units->addItem(tr("75"));
	n_units->addItem(tr("80")); n_units->addItem(tr("85"));
	n_units->addItem(tr("90")); n_units->addItem(tr("95"));
	n_units->setMaximumWidth(55);
	connect ( n_units , SIGNAL( currentIndexChanged(int) ), this, SLOT( set_beam_values() ) );

	
	QLabel *times = new QLabel(tr("X"));

	n_mult = new QComboBox;
	n_mult->addItem(tr("1"));
	n_mult->addItem(tr("10"));
	n_mult->addItem(tr("100"));
	n_mult->addItem(tr("1000"));
	n_mult->addItem(tr("10000"));
	n_mult->addItem(tr("100000"));
	n_mult->addItem(tr("1000000"));
	n_mult->setMaximumWidth(95);
	connect ( n_mult , SIGNAL( currentIndexChanged(int) ), this, SLOT( set_beam_values() ) );

	nevents = new QLabel(tr(""));


	
	QHBoxLayout *bottomLayout = new QHBoxLayout;
	bottomLayout->addWidget(set_nevents);
	bottomLayout->addWidget(n_units);
	bottomLayout->addWidget(times);
	bottomLayout->addWidget(n_mult);
	bottomLayout->addSpacing(30);
	bottomLayout->addWidget(nevents);
	bottomLayout->addSpacing(30);
	bottomLayout->addWidget(BeamE2S);
	bottomLayout->addStretch(2);
	neventsGroup->setLayout(bottomLayout);
	
	QVBoxLayout *mainLayout = new QVBoxLayout;
	mainLayout->addWidget(BeamType);
	mainLayout->addWidget(neventsGroup);
	mainLayout->addSpacing(10);
	mainLayout->addWidget(BeamOn);
	setLayout(mainLayout);

 	set_beam_values();
	set_vertex_values();
	gemcOpt->args["N"].arg = 0;
	
}

run_control::~run_control()
{
	string hd_msg = gemcOpt->args["LOG_MSG"].args ;
	double VERB   = gemcOpt->args["GEO_VERBOSITY"].arg ;
	if(VERB>2)
		cout << hd_msg << " Run Control Widget Deleted." << endl;

}

PrimaryBeamTab::PrimaryBeamTab(QWidget *parent, gemc_opts *Opts) : QWidget(parent)
{
	string hd_msg    = Opts->args["LOG_MSG"].args + " Beam Settings >> " ;
	G4ParticleTable* particleTable = G4ParticleTable::GetParticleTable();   ///< Geant4 Particle Table

	// vector of string - filled from the various option
	vector<string> values;
	string units;

	// Getting momentum from option value
	values           = get_info(Opts->args["BEAM_P"].args);
	string pname     = TrimSpaces(values[0]);
	double arg_mom   = get_number(values[1]);
	double arg_theta = get_number(values[2]);
	double arg_phi   = get_number(values[3]);
	
	// Getting spread of momentum from option value
	values            = get_info(Opts->args["SPREAD_P"].args);
	double arg_dmom   = get_number(values[0]);
	double arg_dtheta = get_number(values[1]);
	double arg_dphi   = get_number(values[2]);
	
	
	
	G4ParticleDefinition *Particle = particleTable->FindParticle(pname);
	if(!Particle)
		cout << hd_msg << " Particle " << pname << " not found in G4 table." << endl << endl;
	
	// Momentum Group
	QGroupBox *momentumGroup = new QGroupBox(tr(""));
	
	QLabel *beam_particleLabel = new QLabel(tr("Particle Type:"));
	beam_particle = new QComboBox;
	// most important particles on top
	beam_particle->addItem(pname.c_str());
	beam_particle->addItem(tr("e-"));
	beam_particle->addItem(tr("proton"));
	beam_particle->addItem(tr("pi+"));
	beam_particle->addItem(tr("pi-"));
	for(int i=0; i<particleTable->entries(); i++)
		beam_particle->addItem(particleTable->GetParticleName(i).c_str());
	QHBoxLayout *beam_particleLayout = new QHBoxLayout;
	beam_particleLayout->addSpacing(40);
	beam_particleLayout->addWidget(beam_particleLabel);
	beam_particleLayout->addWidget(beam_particle);
	beam_particleLayout->addSpacing(80);
	connect ( beam_particle  , SIGNAL( currentIndexChanged(int) ), parent, SLOT( set_beam_values() ) );
	

	QLabel *col1Label = new QLabel(tr(""));
	QLabel *col2Label = new QLabel(tr("Value"));
	QLabel *col3Label = new QLabel(tr("Dispersion"));
	QHBoxLayout *explanaLayout = new QHBoxLayout;
	explanaLayout->addWidget(col1Label);
	explanaLayout->addWidget(col2Label);
	explanaLayout->addWidget(col3Label);

	QLabel *momentumLabel = new QLabel(tr("p:"));
	momentum_slider = new QSlider(Qt::Horizontal);
	momentum_slider->setRange(1, 2000);
	momentum_slider->setSliderPosition((int) (arg_mom/MeV/10.0));
	rmomentum_slider = new QSlider(Qt::Horizontal);
	rmomentum_slider->setRange(0, 2000);
	rmomentum_slider->setSliderPosition((int) (arg_dmom/MeV/10.0));
	connect ( momentum_slider  , SIGNAL( valueChanged(int) ), parent, SLOT( set_beam_values() ) );
	connect ( rmomentum_slider , SIGNAL( valueChanged(int) ), parent, SLOT( set_beam_values() ) );

	
	QHBoxLayout *momentumLayout = new QHBoxLayout;
	momentumLayout->addWidget(momentumLabel);
	momentumLayout->addSpacing(27);
	momentumLayout->addWidget(momentum_slider);
	momentumLayout->addWidget(rmomentum_slider);
	
	QLabel *thetaLabel = new QLabel(tr("theta:"));
	theta_slider = new QSlider(Qt::Horizontal);
	theta_slider->setRange(0, 3600);
	theta_slider->setSliderPosition( (int) (20.0*arg_theta/deg));
	rtheta_slider = new QSlider(Qt::Horizontal);
	rtheta_slider->setRange(0, 3600);
	rtheta_slider->setSliderPosition((int) (20.0*arg_dtheta/deg));
	connect ( theta_slider  , SIGNAL( valueChanged(int) ), parent, SLOT( set_beam_values() ) );
	connect ( rtheta_slider , SIGNAL( valueChanged(int) ), parent, SLOT( set_beam_values() ) );
	
	
	QHBoxLayout *thetaLayout = new QHBoxLayout;
	thetaLayout->addWidget(thetaLabel);
	thetaLayout->addWidget(theta_slider);
	thetaLayout->addWidget(rtheta_slider);
	
	
	QLabel *phiLabel = new QLabel(tr("phi:"));
	phi_slider = new QSlider(Qt::Horizontal);
	phi_slider->setRange(0, 7200);
	phi_slider->setSliderPosition((int) (20*arg_phi/deg));
	rphi_slider = new QSlider(Qt::Horizontal);
	rphi_slider->setRange(0, 3600);
	rphi_slider->setSliderPosition((int) (20*arg_dphi/deg));
	connect ( phi_slider  , SIGNAL( valueChanged(int) ), parent, SLOT( set_beam_values() ) );
	connect ( rphi_slider , SIGNAL( valueChanged(int) ), parent, SLOT( set_beam_values() ) );
	
	QHBoxLayout *phiLayout = new QHBoxLayout;
	phiLayout->addWidget(phiLabel);
	phiLayout->addSpacing(14);
	phiLayout->addWidget(phi_slider);
	phiLayout->addWidget(rphi_slider);
	
	QVBoxLayout *mLayout = new QVBoxLayout;
	mLayout->addLayout(beam_particleLayout);
	mLayout->addSpacing(10);
	mLayout->addLayout(explanaLayout);
	mLayout->addLayout(momentumLayout);
	mLayout->addLayout(thetaLayout);
	mLayout->addLayout(phiLayout);
	momentumGroup->setLayout(mLayout);


	// Momentum Readout Group
	QGroupBox *mroGroup = new QGroupBox(tr("Beam Values"));

	QLabel *rmomentumLabel = new QLabel(tr("p:"));
	momentum_ro = new QLabel(tr(""));
	QHBoxLayout *momentum_roLayout = new QHBoxLayout;
	momentum_roLayout->addWidget(rmomentumLabel);
	momentum_roLayout->addWidget(momentum_ro);
	
	QLabel *rthetaLabel = new QLabel(tr("theta:"));
	theta_ro = new QLabel(tr(""));
	QHBoxLayout *theta_roLayout = new QHBoxLayout;
	theta_roLayout->addWidget(rthetaLabel);
	theta_roLayout->addWidget(theta_ro);
		
	QLabel *rphiLabel = new QLabel(tr("phi:"));
	phi_ro = new QLabel(tr(""));
	QHBoxLayout *phi_roLayout = new QHBoxLayout;
	phi_roLayout->addWidget(rphiLabel);
	phi_roLayout->addWidget(phi_ro);
		
	QVBoxLayout *mroLayout = new QVBoxLayout;
	mroLayout->addLayout(momentum_roLayout);
	mroLayout->addLayout(theta_roLayout);
	mroLayout->addLayout(phi_roLayout);
	mroGroup->setLayout(mroLayout);
	
	// Vertex read out Group
	QGroupBox *vroGroup = new QGroupBox(tr("Vertex Values"));
	
	QLabel *rvxyzLabel = new QLabel(tr("(x,y,z):"));
	vxyz_ro = new QLabel(tr("(0, 0, 0) mm"));
	QHBoxLayout *vxy_roLayout = new QHBoxLayout;
	vxy_roLayout->addWidget(rvxyzLabel);
	vxy_roLayout->addWidget(vxyz_ro);
	
	QLabel *rvdrLabel = new QLabel(tr("radius:"));
	vdr_ro = new QLabel(tr("0 mm"));
	QHBoxLayout *vdr_roLayout = new QHBoxLayout;
	vdr_roLayout->addWidget(rvdrLabel);
	vdr_roLayout->addWidget(vdr_ro);
	
	QLabel *rvdzLabel = new QLabel(tr("delta z:"));
	vdz_ro = new QLabel(tr("0 mm"));
	QHBoxLayout *vdz_roLayout = new QHBoxLayout;
	vdz_roLayout->addWidget(rvdzLabel);
	vdz_roLayout->addWidget(vdz_ro);
	
	QVBoxLayout *vroLayout = new QVBoxLayout;
	vroLayout->addLayout(vxy_roLayout);
	vroLayout->addLayout(vdr_roLayout);
	vroLayout->addLayout(vdz_roLayout);
	vroGroup->setLayout(vroLayout);
	
	
	QHBoxLayout *beamroLayout = new QHBoxLayout;
	beamroLayout->addWidget(mroGroup);
	beamroLayout->addWidget(vroGroup);



	// Getting vertex from option value
	values = get_info(Opts->args["BEAM_V"].args);
	units = TrimSpaces(values[3]);
	double cvx = get_number(values[0] + "*" + units);
	double cvy = get_number(values[1] + "*" + units);
	double cvz = get_number(values[2] + "*" + units);

	// Getting vertex spread from option value
	values = get_info(Opts->args["SPREAD_V"].args);
	units = TrimSpaces(values[2]);
	double cdvr = get_number(values[0] + "*" + units);
	double cdvz = get_number(values[1] + "*" + units);


	
	
	// Vertex Group
	QGroupBox *vertexGroup = new QGroupBox(tr("Vertex"));
	
	QLabel *col1Label2 = new QLabel(tr(""));
	QLabel *col2Label2 = new QLabel(tr("Value"));
	QLabel *col3Label2 = new QLabel(tr("Dispersion"));
	QHBoxLayout *explanaLayout2 = new QHBoxLayout;
	explanaLayout2->addWidget(col1Label2);
	explanaLayout2->addWidget(col2Label2);
	explanaLayout2->addWidget(col3Label2);
	
	QLabel *vxLabel = new QLabel(tr("vx:"));
	vx_slider = new QSlider(Qt::Horizontal);
	vx_slider->setRange(-200, 200);
	vx_slider->setSliderPosition((int) (cvx/mm));
	QLabel *vrLabel = new QLabel(tr("radius:"));
	rv_slider = new QSlider(Qt::Horizontal);
	rv_slider->setRange(0, 100);
	rv_slider->setSliderPosition((int) (cdvr/mm));
	QHBoxLayout *vxLayout = new QHBoxLayout;
	vxLayout->addWidget(vxLabel);
	vxLayout->addWidget(vx_slider);
	vxLayout->addSpacing(30);
	vxLayout->addWidget(vrLabel);
	vxLayout->addWidget(rv_slider);
	connect ( vx_slider , SIGNAL( valueChanged(int) ), parent, SLOT( set_vertex_values() ) );
	connect ( rv_slider , SIGNAL( valueChanged(int) ), parent, SLOT( set_vertex_values() ) );
	

	QLabel *vyLabel = new QLabel(tr("vy:"));
	vy_slider = new QSlider(Qt::Horizontal);
	vy_slider->setRange(-200, 200);
	vy_slider->setSliderPosition((int) (cvy/mm));
	QLabel *rvzLabel = new QLabel(tr("dvz:"));
	rvz_slider = new QSlider(Qt::Horizontal);
	rvz_slider->setRange(0, 400);
	rvz_slider->setSliderPosition((int) (cdvz/mm));
	QHBoxLayout *vyLayout = new QHBoxLayout;
	vyLayout->addWidget(vyLabel);
	vyLayout->addWidget(vy_slider);
	vyLayout->addSpacing(46);
	vyLayout->addWidget(rvzLabel);
	vyLayout->addWidget(rvz_slider);
	connect ( vy_slider ,  SIGNAL( valueChanged(int) ), parent, SLOT( set_vertex_values() ) );
	connect ( rvz_slider , SIGNAL( valueChanged(int) ), parent, SLOT( set_vertex_values() ) );
	
	QLabel *vzLabel = new QLabel(tr("vz:"));
	vz_slider = new QSlider(Qt::Horizontal);
	vz_slider->setRange(-10000, 10000);
	vz_slider->setTickInterval(1);
	vz_slider->setSliderPosition((int) (cvz/mm));
	QHBoxLayout *vzLayout = new QHBoxLayout;
	vzLayout->addWidget(vzLabel);
	vzLayout->addWidget(vz_slider);
	vzLayout->addSpacing(236);
	QVBoxLayout *vLayout = new QVBoxLayout;
	vLayout->addLayout(explanaLayout2);
	vLayout->addLayout(vxLayout);
	vLayout->addLayout(vyLayout);
	vLayout->addLayout(vzLayout);
	vertexGroup->setLayout(vLayout);
	connect ( vz_slider ,  SIGNAL( valueChanged(int) ), parent, SLOT( set_vertex_values() ) );
	
	
	momentumGroup->setStyleSheet(" * { background-color: rgb(215, 220, 215);} QLabel {background-color: transparent; }");
	mroGroup->setStyleSheet("      * { background-color: rgb(215, 220, 215);} QLabel {background-color: transparent; }");
	vroGroup->setStyleSheet("      * { background-color: rgb(215, 215, 220);} QLabel {background-color: transparent; }");
	vertexGroup->setStyleSheet("   * { background-color: rgb(215, 215, 220);} QLabel {background-color: transparent; }");
	
	// All together
	QVBoxLayout *mainLayout = new QVBoxLayout;
	mainLayout->addWidget(momentumGroup);
	mainLayout->addLayout(beamroLayout);
	mainLayout->addSpacing(10);	
	mainLayout->addWidget(vertexGroup);
	setLayout(mainLayout);
	
	
	
}

LuminosityBeamTab::LuminosityBeamTab(QWidget *parent, gemc_opts *Opts, int type) : QWidget(parent)
{
	string hd_msg    = Opts->args["LOG_MSG"].args + " Beam Settings >> " ;
	G4ParticleTable* particleTable = G4ParticleTable::GetParticleTable();   ///< Geant4 Particle Table


	vector<string> values;
	
	// Getting Luminosity Event infos from command line
	values  = get_info(Opts->args["LUMI_EVENT"].args);
	int lnevents = (int) get_number(values[0]);
	int twindow =  (int) get_number(values[1]);
	int tbunch  =  (int) get_number(values[2]);
	
	if(type == 2)
	{
		values  = get_info(Opts->args["LUMI2_EVENT"].args);
		lnevents = (int) get_number(values[0]);
		tbunch  =  (int) get_number(values[1]);
	}
	QGroupBox *LumiGroup = new QGroupBox(tr(""));
	
	QLabel *neventLabel      = new QLabel(tr("N. Particles/Event"));
	QLabel *timewindowLabel = NULL;
	if(type==1) timewindowLabel = new QLabel(tr("Time Window\n"));
	if(type==2) timewindowLabel = new QLabel(tr("Time Window\n     Set on\n  Primary Tab"));
	QLabel *bunchLabel       = new QLabel(tr("Bunch Time"));
	QHBoxLayout *lumiHLayout = new QHBoxLayout;
	lumiHLayout->addSpacing(45);
	lumiHLayout->addWidget(neventLabel);
	lumiHLayout->addWidget(timewindowLabel);
	lumiHLayout->addSpacing(20);
	lumiHLayout->addWidget(bunchLabel);
	
	nevents     = new QLineEdit();
	timewindow  = new QLineEdit();
	time_bunch  = new QLineEdit();
	nevents->setMaximumWidth(100);
	timewindow->setMaximumWidth(100);
	time_bunch->setMaximumWidth(100);
	QHBoxLayout *lumiHLayout2 = new QHBoxLayout;
	lumiHLayout2->addWidget(nevents);
	if(type==1) lumiHLayout2->addWidget(timewindow);
	if(type==2) lumiHLayout2->addSpacing(135);
	lumiHLayout2->addWidget(time_bunch);

	QString L_ne = stringify(lnevents).c_str();
	nevents->setText(L_ne);
	
	QString L_tw = stringify(twindow/ns).c_str() + QString("*ns");
	timewindow->setText(L_tw);

	QString L_tb = stringify(tbunch/ns).c_str() +  QString("*ns");
	time_bunch->setText(L_tb);

	connect ( nevents     , SIGNAL( textChanged(const QString & ) ), parent, SLOT( set_beam_values() ) );
	connect ( timewindow  , SIGNAL( textChanged(const QString & ) ), parent, SLOT( set_beam_values() ) );
	connect ( time_bunch  , SIGNAL( textChanged(const QString & ) ), parent, SLOT( set_beam_values() ) );
	
	
	QVBoxLayout *LLayout = new QVBoxLayout;
	LLayout->addLayout(lumiHLayout);
	LLayout->addLayout(lumiHLayout2);
	LumiGroup->setLayout(LLayout);
	
	
	// Getting momentum, particle infos from command line
	values  = get_info(Opts->args["LUMI_P"].args);
	if(type == 2)
		values  = get_info(Opts->args["LUMI2_P"].args);
	
	string pname     = TrimSpaces(values[0]);
	double arg_mom   = get_number(values[1]);
	double arg_theta = get_number(values[2]);
	double arg_phi   = get_number(values[3]);
	
	G4ParticleDefinition *Particle = particleTable->FindParticle(pname);
	if(!Particle)
		cout << hd_msg << " Particle " << pname << " not found in G4 table." << endl << endl;
	
	// Momentum Group
	QGroupBox *momentumGroup = new QGroupBox(tr(""));
	
	QLabel *beam_particleLabel = new QLabel(tr("Particle Type:"));
	beam_particle = new QComboBox;
	// first add most important particles, then all the rest
	beam_particle->addItem(pname.c_str());
	for(int i=0; i<particleTable->entries(); i++)
		beam_particle->addItem(particleTable->GetParticleName(i).c_str());
	QHBoxLayout *beam_particleLayout = new QHBoxLayout;
	beam_particleLayout->addSpacing(40);
	beam_particleLayout->addWidget(beam_particleLabel);
	beam_particleLayout->addWidget(beam_particle);
	beam_particleLayout->addSpacing(80);
	connect ( beam_particle  , SIGNAL( currentIndexChanged(int) ), parent, SLOT( set_beam_values() ) );
	
	
	
	QLabel *momentumLabel = new QLabel(tr("p:"));
	momentum_slider = new QSlider(Qt::Horizontal);
	momentum_slider->setRange(1, 11000);
	if(type == 2)
	  momentum_slider->setRange(1, 11000);
	momentum_slider->setSliderPosition((int) (arg_mom/MeV/10.0));
	connect ( momentum_slider  , SIGNAL( valueChanged(int) ), parent, SLOT( set_beam_values() ) );
	
	
	QHBoxLayout *momentumLayout = new QHBoxLayout;
	momentumLayout->addWidget(momentumLabel);
	momentumLayout->addSpacing(27);
	momentumLayout->addWidget(momentum_slider);
	
	QLabel *thetaLabel = new QLabel(tr("theta:"));
	theta_slider = new QSlider(Qt::Horizontal);
	theta_slider->setRange(0, 3600);
	theta_slider->setSliderPosition((int) (20.0*arg_theta/deg));
	connect ( theta_slider  , SIGNAL( valueChanged(int) ), parent, SLOT( set_beam_values() ) );
	
	
	QHBoxLayout *thetaLayout = new QHBoxLayout;
	thetaLayout->addWidget(thetaLabel);
	thetaLayout->addWidget(theta_slider);
	
	QLabel *phiLabel = new QLabel(tr("phi:"));
	phi_slider = new QSlider(Qt::Horizontal);
	phi_slider->setRange(0, 7200);
	phi_slider->setSliderPosition((int) (20.0*arg_phi/deg));
	connect ( phi_slider  , SIGNAL( valueChanged(int) ), parent, SLOT( set_beam_values() ) );
	
	QHBoxLayout *phiLayout = new QHBoxLayout;
	phiLayout->addWidget(phiLabel);
	phiLayout->addSpacing(14);
	phiLayout->addWidget(phi_slider);
	
	QVBoxLayout *mLayout = new QVBoxLayout;
	mLayout->addLayout(beam_particleLayout);
	mLayout->addSpacing(10);
	mLayout->addLayout(momentumLayout);
	mLayout->addLayout(thetaLayout);
	mLayout->addLayout(phiLayout);
	momentumGroup->setLayout(mLayout);
	
	
	// Momentum Readout Group
	QGroupBox *mroGroup = new QGroupBox(tr("Beam Values"));
	
	QLabel *rmomentumLabel = new QLabel(tr("p:"));
	momentum_ro = new QLabel(tr(""));
	QHBoxLayout *momentum_roLayout = new QHBoxLayout;
	momentum_roLayout->addWidget(rmomentumLabel);
	momentum_roLayout->addWidget(momentum_ro);
	
	QLabel *rthetaLabel = new QLabel(tr("theta:"));
	theta_ro = new QLabel(tr(""));
	QHBoxLayout *theta_roLayout = new QHBoxLayout;
	theta_roLayout->addWidget(rthetaLabel);
	theta_roLayout->addWidget(theta_ro);
	
	QLabel *rphiLabel = new QLabel(tr("phi:"));
	phi_ro = new QLabel(tr(""));
	QHBoxLayout *phi_roLayout = new QHBoxLayout;
	phi_roLayout->addWidget(rphiLabel);
	phi_roLayout->addWidget(phi_ro);
	
	QVBoxLayout *mroLayout = new QVBoxLayout;
	mroLayout->addLayout(momentum_roLayout);
	mroLayout->addLayout(theta_roLayout);
	mroLayout->addLayout(phi_roLayout);
	mroGroup->setLayout(mroLayout);
	
	// Vertex read out Group
	QGroupBox *vroGroup = new QGroupBox(tr("Vertex Values"));
	
	QLabel *rvxyzLabel = new QLabel(tr("(x,y,z):"));
	vxyz_ro = new QLabel(tr("(0, 0, 0) mm"));
	QHBoxLayout *vxy_roLayout = new QHBoxLayout;
	vxy_roLayout->addWidget(rvxyzLabel);
	vxy_roLayout->addWidget(vxyz_ro);
	
	
	QVBoxLayout *vroLayout = new QVBoxLayout;
	vroLayout->addLayout(vxy_roLayout);
	vroGroup->setLayout(vroLayout);
	
	
	QHBoxLayout *beamroLayout = new QHBoxLayout;
	beamroLayout->addWidget(mroGroup);
	beamroLayout->addWidget(vroGroup);
	
	
	
	
	// Getting vertex infos from command line
	values  = get_info(Opts->args["LUMI_V"].args);
	if(type == 2)
		values  = get_info(Opts->args["LUMI2_V"].args);
	
	string units = TrimSpaces(values[3]);
	double cvx = get_number(values[0] + "*" + units);
	double cvy = get_number(values[1] + "*" + units);
	double cvz = get_number(values[2] + "*" + units);
	
	
	// Vertex Group
	QGroupBox *vertexGroup = new QGroupBox(tr("Vertex"));
	
	QLabel *vxLabel = new QLabel(tr("vx:"));
	vx_slider = new QSlider(Qt::Horizontal);
	vx_slider->setRange(-200, 200);
	vx_slider->setSliderPosition((int) (cvx/mm));
	QHBoxLayout *vxLayout = new QHBoxLayout;
	vxLayout->addWidget(vxLabel);
	vxLayout->addWidget(vx_slider);
	connect ( vx_slider , SIGNAL( valueChanged(int) ), parent, SLOT( set_vertex_values() ) );
	
	
	QLabel *vyLabel = new QLabel(tr("vy:"));
	vy_slider = new QSlider(Qt::Horizontal);
	vy_slider->setRange(-200, 200);
	vy_slider->setSliderPosition((int) (cvy/mm));
	QHBoxLayout *vyLayout = new QHBoxLayout;
	vyLayout->addWidget(vyLabel);
	vyLayout->addWidget(vy_slider);
	connect ( vy_slider ,  SIGNAL( valueChanged(int) ), parent, SLOT( set_vertex_values() ) );
	
	QLabel *vzLabel = new QLabel(tr("vz:"));
	vz_slider = new QSlider(Qt::Horizontal);
	vz_slider->setRange(-51000, 51000);
	vz_slider->setSliderPosition((int) (cvz/mm));
	QHBoxLayout *vzLayout = new QHBoxLayout;
	vzLayout->addWidget(vzLabel);
	vzLayout->addWidget(vz_slider);
	QVBoxLayout *vLayout = new QVBoxLayout;
	vLayout->addLayout(vxLayout);
	vLayout->addLayout(vyLayout);
	vLayout->addLayout(vzLayout);
	vertexGroup->setLayout(vLayout);
	connect ( vz_slider ,  SIGNAL( valueChanged(int) ), parent, SLOT( set_vertex_values() ) );
	
	
	momentumGroup->setStyleSheet(" * { background-color: rgb(225, 210, 210);} QLabel {background-color: transparent; }");
	mroGroup->setStyleSheet("      * { background-color: rgb(225, 210, 210);} QLabel {background-color: transparent; }");
	vroGroup->setStyleSheet("      * { background-color: rgb(210, 220, 210);} QLabel {background-color: transparent; }");
	vertexGroup->setStyleSheet("   * { background-color: rgb(210, 220, 210);} QLabel {background-color: transparent; }");
	
	// All together
	QVBoxLayout *mainLayout = new QVBoxLayout;
	mainLayout->addWidget(LumiGroup);
	mainLayout->addWidget(momentumGroup);
	mainLayout->addLayout(beamroLayout);
	mainLayout->addSpacing(10);
	mainLayout->addWidget(vertexGroup);
	setLayout(mainLayout);
}


void run_control::beamOn()
{
	double N_units = atoi(gemc_tostring(n_units->currentText()).c_str());
	double N_mult  = atoi(gemc_tostring(n_mult->currentText()).c_str());
	double NEVENTS = N_units*N_mult;
	gemcOpt->args["N"].arg = NEVENTS;
	
	char command[100];
	sprintf(command, "/run/beamOn %d", (int) NEVENTS);
	UImanager->ApplyCommand(command);	
}

void run_control::beam_every2sec()
{
	// will execute beam on every 2 seconds for 7200 times (4 hours)

	for(int s=0; s<7200; s++)
  {
    char command[100];

    sprintf(command, "/vis/viewer/refresh");
    UImanager->ApplyCommand(command);	
		
    clock_t endwait = clock () + 2 * CLOCKS_PER_SEC ;
    while (clock() < endwait) {}

    sprintf(command, "/run/beamOn 1");
    UImanager->ApplyCommand(command);	


	}
}




#include "MPrimaryGeneratorAction.h"

void run_control::set_beam_values()
{
	// Primary Beam
	double mom  = pbeamtab->momentum_slider->sliderPosition()*10;
	double rmom = pbeamtab->rmomentum_slider->sliderPosition()*10;
	
	QString mro = stringify(mom).c_str();
	mro.append(QString::fromUtf8(" ± "));	
	mro.append(stringify(rmom).c_str());
	mro.append(" MeV");
	pbeamtab->momentum_ro->setText(mro);
	
	double the  = pbeamtab->theta_slider->sliderPosition()/20.0;
	double rthe = pbeamtab->rtheta_slider->sliderPosition()/20.0;

	QString tro = stringify(the).c_str();
	tro.append(QString::fromUtf8(" ± "));	
	tro.append(stringify(rthe).c_str());
	tro.append(" deg");
	pbeamtab->theta_ro->setText(tro);
	
	double phi  = pbeamtab->phi_slider->sliderPosition()/20.0;
	double rphi = pbeamtab->rphi_slider->sliderPosition()/20.0;
	
	QString pro = stringify(phi).c_str();
	pro.append(QString::fromUtf8(" ± "));	
	pro.append(stringify(rphi).c_str());
	pro.append(" deg");
	pbeamtab->phi_ro->setText(pro);
	
	double N_units = atoi(gemc_tostring(n_units->currentText()).c_str());
	double N_mult  = atoi(gemc_tostring(n_mult->currentText()).c_str());
	double NEVENTS = N_units*N_mult;
	QString nev = "Number of Events: " ;
	nev.append(stringify(NEVENTS).c_str());
	nevents->setText(nev);
	

	// Luminosity Beam
	double L_mom  = lbeamtab->momentum_slider->sliderPosition()*10;
	QString L_mro = stringify(L_mom).c_str();
	L_mro.append(" MeV");
	lbeamtab->momentum_ro->setText(L_mro);
	
	double L_theta  = lbeamtab->theta_slider->sliderPosition()/20.0;
	QString L_tro = stringify(L_theta).c_str();
	L_tro.append(" deg");
	lbeamtab->theta_ro->setText(L_tro);
	
	double L_phi  = lbeamtab->phi_slider->sliderPosition()/20.0;
	QString L_pro = stringify(L_phi).c_str();
	L_pro.append(" deg");
	lbeamtab->phi_ro->setText(L_pro);


	// Luminosity Beam 2
	double L_mom2  = lbeamtab2->momentum_slider->sliderPosition()*10;
	QString L_mro2 = stringify(L_mom2).c_str();
	L_mro2.append(" MeV");
	lbeamtab2->momentum_ro->setText(L_mro2);
	
	double L_theta2  = lbeamtab2->theta_slider->sliderPosition()/20.0;
	QString L_tro2   = stringify(L_theta2).c_str();
	L_tro2.append(" deg");
	lbeamtab2->theta_ro->setText(L_tro2);
	
	double L_phi2  = lbeamtab2->phi_slider->sliderPosition()/20.0;
	QString L_pro2 = stringify(L_phi2).c_str();
	L_pro2.append(" deg");
	lbeamtab2->phi_ro->setText(L_pro2);
	
	change_beam_pars();
}

void run_control::set_vertex_values()
{
	// Primary Beam
	double vx  = pbeamtab->vx_slider->sliderPosition();
	double vy  = pbeamtab->vy_slider->sliderPosition();
	double vz  = pbeamtab->vz_slider->sliderPosition();
	
	QString vro = "(";
	vro.append(stringify(vx).c_str());
	vro.append(", ");
	vro.append(stringify(vy).c_str());
	vro.append(", ");
	vro.append(stringify(vz).c_str());
	vro.append(") mm");
	pbeamtab->vxyz_ro->setText(vro);


	double dvr  = pbeamtab->rv_slider->sliderPosition();
	QString dvro = stringify(dvr).c_str();
	dvro.append(" mm");
	pbeamtab->vdr_ro->setText(dvro);
	
	double dvz  = pbeamtab->rvz_slider->sliderPosition();
	QString dvzro = stringify(dvz).c_str();
	dvzro.append(" mm");
	pbeamtab->vdz_ro->setText(dvzro);
	
	// Luminosity Beam
	double L_vx  = lbeamtab->vx_slider->sliderPosition();
	double L_vy  = lbeamtab->vy_slider->sliderPosition();
	double L_vz  = lbeamtab->vz_slider->sliderPosition();
	
	QString L_vro = "(";
	L_vro.append(stringify(L_vx).c_str());
	L_vro.append(", ");
	L_vro.append(stringify(L_vy).c_str());
	L_vro.append(", ");
	L_vro.append(stringify(L_vz).c_str());
	L_vro.append(") mm");
	lbeamtab->vxyz_ro->setText(L_vro);
	
	// Luminosity Beam 2
	double L_vx2  = lbeamtab2->vx_slider->sliderPosition();
	double L_vy2  = lbeamtab2->vy_slider->sliderPosition();
	double L_vz2  = lbeamtab2->vz_slider->sliderPosition();
	
	QString L_vro2 = "(";
	L_vro2.append(stringify(L_vx2).c_str());
	L_vro2.append(", ");
	L_vro2.append(stringify(L_vy2).c_str());
	L_vro2.append(", ");
	L_vro2.append(stringify(L_vz2).c_str());
	L_vro2.append(") mm");
	lbeamtab2->vxyz_ro->setText(L_vro2);
	
	change_beam_pars();
}


void run_control::change_beam_pars()
{
	string hd_msg    = gemcOpt->args["LOG_MSG"].args + " Beam Settings >> " ;

	// Primary Beam momentum
	string particle = gemc_tostring(pbeamtab->beam_particle->currentText());
	double mom      = pbeamtab->momentum_slider->sliderPosition()*10*MeV;
	double theta    = pbeamtab->theta_slider->sliderPosition()/20.0*deg;
	double phi      = pbeamtab->phi_slider->sliderPosition()/20.0*deg;

	string beam_p = particle + ", " +
									stringify(mom) + "*MeV" + ", " +
									stringify(theta/deg) + "*deg" + ", " +
									stringify(phi/deg) + "*deg";
	
	gemcOpt->args["BEAM_P"].args = beam_p;

	// Primary Beam momentum dispersion
	double dmom      = pbeamtab->rmomentum_slider->sliderPosition()*10*MeV;
	double dtheta    = pbeamtab->rtheta_slider->sliderPosition()/20.0*deg;
	double dphi      = pbeamtab->rphi_slider->sliderPosition()/20.0*deg;
	
	string spread_p = stringify(dmom/MeV) + "*MeV" + ", " +
										stringify(dtheta/deg) + "*deg" + ", " +
										stringify(dphi/deg) + "*deg";
	
	gemcOpt->args["SPREAD_P"].args = spread_p;

	// Luminosity Event
	string L_ne = gemc_tostring(lbeamtab->nevents->text());
	string L_tw = gemc_tostring(lbeamtab->timewindow->text());
	string L_tb = gemc_tostring(lbeamtab->time_bunch->text());
	
	string L_event = L_ne + ", " + L_tw + ", " + L_tb;
	gemcOpt->args["LUMI_EVENT"].args = L_event;
	
	// Luminosity Event 2
	string L_ne2 = gemc_tostring(lbeamtab2->nevents->text());
	string L_tb2 = gemc_tostring(lbeamtab2->time_bunch->text());
	
	string L_event2 = L_ne2 + ", " + L_tb2;
	gemcOpt->args["LUMI2_EVENT"].args = L_event2;
	
	
	// Luminosity Beam momentum
	string L_particle = gemc_tostring(lbeamtab->beam_particle->currentText());
	double L_mom      = lbeamtab->momentum_slider->sliderPosition()*10*MeV;
	double L_theta    = lbeamtab->theta_slider->sliderPosition()/20.0*deg;
	double L_phi      = lbeamtab->phi_slider->sliderPosition()/20.0*deg;
	
	string L_beam_p = L_particle + ", " +
	stringify(L_mom) + "*MeV" + "," +
	stringify(L_theta/deg) + "*deg" + "," +
	stringify(L_phi/deg) + "*deg";
	
	gemcOpt->args["LUMI_P"].args = L_beam_p;
	
	// Luminosity Beam momentum 2
	string L_particle2 = gemc_tostring(lbeamtab2->beam_particle->currentText());
	double L_mom2      = lbeamtab2->momentum_slider->sliderPosition()*10*MeV;
	double L_theta2    = lbeamtab2->theta_slider->sliderPosition()/20.0*deg;
	double L_phi2      = lbeamtab2->phi_slider->sliderPosition()/20.0*deg;
	
	string L_beam_p2 = L_particle2 + ", " +
	stringify(L_mom2) + "*MeV" + ", " +
	stringify(L_theta2/deg) + "*deg" + ", " +
	stringify(L_phi2/deg) + "*deg";
	
	gemcOpt->args["LUMI2_P"].args = L_beam_p2;
	
	
	
	// Primary vertex
	double vx      = pbeamtab->vx_slider->sliderPosition()*mm;
	double vy      = pbeamtab->vy_slider->sliderPosition()*mm;
	double vz      = pbeamtab->vz_slider->sliderPosition()*mm;

	string beam_v = "(" + 
									stringify(vx/mm) + "," +
									stringify(vy/mm) + "," +
									stringify(vz/mm) + ") mm";
	
	gemcOpt->args["BEAM_V"].args = beam_v;


	
	// Primary vertex dispersion	
	double vdr  = pbeamtab->rv_slider->sliderPosition()*mm;
	double vdz  = pbeamtab->rvz_slider->sliderPosition()*mm;
	string spread_v = "(" +
										stringify(vdr/mm) + "," +
										stringify(vdz/mm) + ") mm";
	
	gemcOpt->args["SPREAD_V"].args = spread_v;

	// Luminosity vertex
	double L_vx      = lbeamtab->vx_slider->sliderPosition()*mm;
	double L_vy      = lbeamtab->vy_slider->sliderPosition()*mm;
	double L_vz      = lbeamtab->vz_slider->sliderPosition()*mm;
	
	string L_beam_v = "(" +
	stringify(L_vx/mm) + ", " +
	stringify(L_vy/mm) + ", " +
	stringify(L_vz/mm) + ") mm";
	
	gemcOpt->args["LUMI_V"].args = L_beam_v;
	
	// Luminosity vertex 2
	double L_vx2      = lbeamtab2->vx_slider->sliderPosition()*mm;
	double L_vy2      = lbeamtab2->vy_slider->sliderPosition()*mm;
	double L_vz2      = lbeamtab2->vz_slider->sliderPosition()*mm;
	
	string L_beam_v2 = "(" +
	stringify(L_vx2/mm) + ", " +
	stringify(L_vy2/mm) + ", " +
	stringify(L_vz2/mm) + " ) mm";
	
	gemcOpt->args["LUMI2_V"].args = L_beam_v2;
}













