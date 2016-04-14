#ifndef run_control_H
#define run_control_H 1

// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QWidget>
#include <QSlider>
#include <QLabel>
#include <QComboBox>


// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "usage.h"

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


class PrimaryBeamTab : public QWidget
{
		Q_OBJECT
		
	public:
		PrimaryBeamTab(QWidget *parent = 0, gemc_opts* = 0);
		
		QComboBox *beam_particle;
		QSlider *momentum_slider;
		QSlider *rmomentum_slider;
		QSlider *theta_slider;
		QSlider *rtheta_slider;
		QSlider *phi_slider;
		QSlider *rphi_slider;
		
		QSlider *vx_slider;
		QSlider *vy_slider;
		QSlider *vz_slider;
		QSlider *rv_slider;
		QSlider *rvz_slider;

		QLabel *momentum_ro;
		QLabel *theta_ro;
		QLabel *phi_ro;

		QLabel *vxyz_ro;
		QLabel *vdr_ro;
		QLabel *vdz_ro;

};


class LuminosityBeamTab : public QWidget
{
		Q_OBJECT
		
	public:
		LuminosityBeamTab(QWidget *parent = 0, gemc_opts* = 0, int type = 1);

		QLineEdit *nevents;
		QLineEdit *timewindow;
		QLineEdit *time_bunch;
		
		QComboBox *beam_particle;
		QSlider *momentum_slider;
		QSlider *theta_slider;
		QSlider *phi_slider;
		
		QSlider *vx_slider;
		QSlider *vy_slider;
		QSlider *vz_slider;
		
		QLabel *momentum_ro;
		QLabel *theta_ro;
		QLabel *phi_ro;
		
		QLabel *vxyz_ro;
};



class run_control : public QWidget
	{
		// metaobject required for non-qt slots
		Q_OBJECT
		
	public:
		run_control(QWidget *parent, gemc_opts*);
		~run_control();
		
		gemc_opts *gemcOpt;
		G4UImanager  *UImanager;
		
		
	private:
		PrimaryBeamTab *pbeamtab;
		LuminosityBeamTab *lbeamtab;
		LuminosityBeamTab *lbeamtab2;
		QComboBox *n_units;
		QComboBox *n_mult;
		QLabel *nevents;
		void change_beam_pars();
		
		
	private slots:
		void beamOn();
    void beam_every2sec();
		void set_beam_values();
		void set_vertex_values();
	};






#endif
