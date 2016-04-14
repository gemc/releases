// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QtGui>
#include <QWebView>
// windows.h must come before gl.h in windows
#ifdef _MSC_VER
	#include <windows.h>	
#endif

#include <gl.h>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "infos.h"
#include "docs/about.h"
#include "docs/particles_color.h"
#include "docs/lund.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%

// Notice:
// For images, use png format.

infos::infos(QWidget *parent, gemc_opts *Opts) : QWidget(parent)
{
	gemcOpt = Opts;
	
	QTabWidget* InfoType = new QTabWidget;
	abouttab   = new AboutTab(this,   gemcOpt);
	pcolorstab = new PColorsTab(this, gemcOpt);
	lundtab    = new LUNDTab(this,    gemcOpt);
	
	InfoType->addTab(abouttab,   tr("About"));
	InfoType->addTab(pcolorstab, tr("Particle Colors"));
	InfoType->addTab(lundtab,    tr("LUND format"));
	
	QVBoxLayout *mainLayout = new QVBoxLayout;
	mainLayout->addWidget(InfoType);
	setLayout(mainLayout);
}


	
infos::~infos()
{
	string hd_msg = gemcOpt->args["LOG_MSG"].args ;
	double VERB   = gemcOpt->args["GEO_VERBOSITY"].arg ;
	if(VERB>2)
		cout << hd_msg << " Infos Widget Deleted." << endl;
	
}


AboutTab::AboutTab(QWidget *parent, gemc_opts *Opts) : QWidget(parent)
{
	QWebView *view = new QWebView(parent);
	view->setHtml(load_doc());
	
	QVBoxLayout *mLayout = new QVBoxLayout;
	mLayout->addWidget(view);
	setLayout(mLayout);
}

PColorsTab::PColorsTab(QWidget *parent, gemc_opts *Opts) : QWidget(parent)
{
	QWebView *view = new QWebView(parent);
	view->setHtml(load_doc());
	
	QVBoxLayout *mLayout = new QVBoxLayout;
	mLayout->addWidget(view);
	setLayout(mLayout);
}

LUNDTab::LUNDTab(QWidget *parent, gemc_opts *Opts) : QWidget(parent)
{
	QWebView *view = new QWebView(parent);
	view->setHtml(load_doc());
	
	QVBoxLayout *mLayout = new QVBoxLayout;
	mLayout->addWidget(view);
	setLayout(mLayout);
}


















