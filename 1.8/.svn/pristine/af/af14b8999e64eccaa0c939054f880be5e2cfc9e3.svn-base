#ifndef camera_control_H
#define camera_control_H 1

// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QWidget>
#include <QSlider>
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
class camera_control : public QWidget
{
	// metaobject required for non-qt slots
	Q_OBJECT
	
	public:
		camera_control(QWidget *parent, gemc_opts*);
	 ~camera_control();
		
		gemc_opts *gemcOpt;
		G4UImanager  *UImanager;

	private:
		int theta_hall, phi_hall;    ///< theta, phi of the camera
		double zoom_value;           ///< Zoom Value
		
		QSlider *theta_slider;       ///< Theta Slider
		QSlider *phi_slider;         ///< Phi Slider
		vector<string> ThetaSet;     ///< strings to ThetaCombo
		vector<string> PhiSet;       ///< strings to  PhiCombo
		
		QSlider  *pan_slider;        ///< Pan Factor Slider
		QSlider  *zoom_slider;       ///< Pan Factor Slider

		QComboBox *moveCombo;
		QComboBox *projCombo;
	
		QComboBox *aliasing;
		QComboBox *sides_per_circle;
		QComboBox *auxiliary;

	private slots:
		void change_theta(int);
		void change_theta_s(int);
		void set_theta(int);
		void change_phi(int);
		void change_phi_s(int);
		void set_phi(int);
		void clickpan_left();
		void clickpan_right();
		void clickpan_up();
		void clickpan_down();
		void zoom(int);
		void update_angles();
		void set_perspective(int);
		void change_background_color();
		void switch_antialiasing(int);
		void switch_auxiliary_edges(int);
		void switch_sides_per_circle(int);
		void take_screenshot();
		
};

#endif








