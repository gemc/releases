#ifndef infos_H
#define infos_H 1

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


// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <string>
#include <map>
using namespace std;


// %%%%%%%%%%%%%%%%
// Class definition
// %%%%%%%%%%%%%%%%


class AboutTab : public QWidget
{
	Q_OBJECT
	
	public:
		AboutTab(QWidget *parent = 0, gemc_opts* = 0);
		QString load_doc();
};

class PColorsTab : public QWidget
{
	Q_OBJECT
	
	public:
		PColorsTab(QWidget *parent = 0, gemc_opts* = 0);
		QString load_doc();
};


class LUNDTab : public QWidget
{
	Q_OBJECT
	
	public:
		LUNDTab(QWidget *parent = 0, gemc_opts* = 0);
		QString load_doc();
};



class infos : public QWidget
{
	// metaobject required for non-qt slots
	Q_OBJECT
	
	public:
		infos(QWidget *parent, gemc_opts*);
	 ~infos();
		
		gemc_opts *gemcOpt;

		AboutTab   *abouttab;
		PColorsTab *pcolorstab;
		LUNDTab    *lundtab;
};

#endif








