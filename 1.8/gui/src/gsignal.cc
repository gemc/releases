// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QtGui>


// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "gsignal.h"
#include "MHit.h"
#include "string_utilities.h"

// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4UIcommandTree.hh"

gsignal::gsignal(QWidget *parent, gemc_opts *Opts, map<string, MSensitiveDetector*> SD_Map) : QWidget(parent)
{
  gemcOpt = Opts;
	UImanager  = G4UImanager::GetUIpointer();
  SeDe_Map   = SD_Map;

  //  Layout:
  //
  //  + +-------------------+ +
  //  | |         |         | |
  //  | |  Tree   |  Signal | |
  //  | |         |  Choice | |
  //  | |         |         | |
  //  | +-------------------+ |
  //  | +-------------------+ |
  //  | |                   | |
  //  | |       Graph       | |
  //  | +-------------------+ |
  //  +-----------------------+

  
  // Graph axis origins and legth
  xorig   = -190;
  yorig   =  315;
  xaxil   =  505;
  yaxil   =  290;
  inside  = 20;
  DX      = xaxil - 2*inside;
  DY      = yaxil - 2*inside;
  nticksx = 5;  // in reality this is number of ticks - 1
  nticksy = 5;
  
  // particle colors follow gemc settings
  // red:   positive            
  // gray:  neutral  
  // green: negative         
  // 
  // second argument of QPen is thickness of pencil
  
  pcolors[2112] = QPen(Qt::black,             5);   // neutrons: black
  pcolors[22]   = QPen(Qt::blue,              5);   // photons: blue 
  pcolors[11]   = QPen(Qt::cyan,              5);   // electrons: cyan 
  pcolors[2212] = QPen(QColor(240, 80, 80),   5);   // protons: orange 
  pcolors[211]  = QPen(Qt::magenta,           5);   // pi+: magenta 
  pcolors[-211] = QPen(Qt::yellow,            5);   // pi-: yellow 
  pcolors[-11]  = QPen(Qt::red,               5);   // positrons: positive - red
  pcolors[0]    = QPen(Qt::blue,              5);   // optical photons: blue 

  
  // Vertical Splitter - Top and Bottom layouts
  QSplitter *splitter     = new QSplitter(Qt::Vertical);

  
  
  // %%%%%%%%%%
  // top layout
  // %%%%%%%%%%  
  QWidget   *topWidget    = new QWidget(splitter);
  QSplitter *treesplitter = new QSplitter(Qt::Horizontal);


  QVBoxLayout *topLayout = new QVBoxLayout(treesplitter);

  // Left: The sensitive detectors hits tree
  s_detectors = new QTreeWidget();
  s_detectors = CreateSDetsTree();  
  if(s_detectors)
    topLayout->addWidget(s_detectors);
 
  
  // Right: The individual signals choice
  gsignals = new QTreeWidget();
  gsignals = CreateSignalsTree();
  if(gsignals)
    topLayout->addWidget(gsignals);


  // treesplitter size
  QList<int> tlist;
  tlist.append( 280 );
  tlist.append( 520 );
  treesplitter->setSizes(tlist);

  
  QVBoxLayout *layoutTop = new QVBoxLayout(topWidget);
  layoutTop->addWidget(treesplitter);


  // %%%%%%%%%%%%%
  // bottom layout
  // %%%%%%%%%%%%%
  QWidget     *bottomWidget = new QWidget(splitter);
  bottomWidget->setMinimumSize(600, 450);
  bottomWidget->setMaximumSize(600, 450);

  plots = new QGraphicsView();  
  scene = new QGraphicsScene();
  plots->setScene(scene);
  
  
   
  // putting all together
  QVBoxLayout *layoutBottom = new QVBoxLayout(bottomWidget);
  layoutBottom->addWidget(new QLabel("Signal:"));
  layoutBottom->addWidget(plots);

  
  // splitter size
  QList<int> list;
  list.append( 400 );
  list.append( 450 );
  splitter->setSizes(list);

    
  // %%%%%%%%%%%
  // all layouts
  // %%%%%%%%%%%
  QVBoxLayout *mainLayout = new QVBoxLayout;
  mainLayout->addWidget(splitter);
  setLayout(mainLayout);
  
  
  
  // Has Hit Gradient Color
  HitGrad = QLinearGradient(QPointF(1, 100), QPointF(180, 20));
	HitGrad.setColorAt(0, QColor(255, 80,  80));
	HitGrad.setColorAt(1, QColor(245, 245, 245));
	HitBrush  = QBrush(HitGrad);

}

QTreeWidget* gsignal::CreateSDetsTree()
{
  s_detectors->clear();
  s_detectors->setSelectionMode(QAbstractItemView::SingleSelection);
  QStringList labels;
  labels << QString("Hits List");
  s_detectors->setHeaderLabels(labels);

  QTreeWidgetItem * newItem;
  
  
	for(map<string, MSensitiveDetector*>::iterator it = SeDe_Map.begin(); it!= SeDe_Map.end(); it++)
	{
    MHitCollection *MHC = it->second->GetMHitCollection();
		int nhits = 0;
    if(MHC) nhits = MHC->GetSize();
    MHit* aHit;
    
    // Creating sensitive detectors name tree if it's different than "Mirrors"
    if(it->first != "Mirrors")
    {
      newItem = new QTreeWidgetItem(s_detectors);
      newItem->setText(0, QString(it->first.c_str()));
      
      if(nhits)
      {
        newItem->setBackground(0, HitBrush );
        string snhits = it->first + "   " + stringify(nhits)  + " hit";
        if(nhits>1) snhits += "s";
        newItem->setText(0, QString(snhits.c_str()));
        
        
        QTreeWidgetItem *newHit;
        
        // if the sensitive element is nphe_pmt then 
        // visualization screen is different:
        // need to visualize number of photoelectrons only
        for(int h=0; h<nhits; h++)
        {
          aHit = (*MHC)[h];
          int nsteps = aHit->GetPos().size();
          newHit = new QTreeWidgetItem(newItem);
          
          
          string hitindex = "Hit n. " + stringify(h+1) + "  nsteps: " +  stringify(nsteps) ;
          
          // if last sensitive element is nphe_pmt then writing number of photo-electrons
          if(it->second->SDID.IDnames.back().find("nphe_pmt") != string::npos)
            hitindex = "Hit n. " + stringify(h+1) + "  nphe: " +  stringify(nsteps) ;
          
          newHit->setText(0, QString(hitindex.c_str()));
        }
      } 
    }
  }
  connect(s_detectors, SIGNAL(itemSelectionChanged() ),   this, SLOT(CreateSignalsTree() ) );  
  return s_detectors;
}


QTreeWidget* gsignal::CreateSignalsTree()
{
  gsignals->clear();
  gsignals->setSelectionMode(QAbstractItemView::SingleSelection);
  QStringList labels;
  labels << QString("Signal");
  gsignals->setHeaderLabels(labels);
  
  QTreeWidgetItem* item =  NULL;
  if(s_detectors)
  {
    QList<QTreeWidgetItem *> list = s_detectors->selectedItems();
    if(!list.isEmpty())
    {
      item = list.first();

      // trick to look for the index of this item
      // will return zero if it's the sensitive detector name
      // this index is also the index of the hit
      
      // itext looks like this:
      // Hit n. 1  nsteps: 6
      string itext = item->text(0).toStdString();
      
      stringstream sitext(itext);
      string a, b, c;
      
      // index is the hit index
      unsigned int index;
      sitext >> a >> b >> c;
      index = atoi(c.c_str());
      
      string SD;
      MSensitiveDetector *MSD = NULL;
      if(index==0) 
      { 
        SD = a;
        MSD = SeDe_Map[SD];
      }
      else 
      {
      
        stringstream mtext(item->parent()->text(0).toStdString());
        mtext >> SD; 
        MSD = SeDe_Map[SD];
        SD += "  Hit n. " + c;
      }
      
      QTreeWidgetItem * newHit = new QTreeWidgetItem(gsignals);
      newHit->setText(0, QString(SD.c_str()));
      newHit->setExpanded(1);
      
      MHitCollection *MHC = MSD->GetMHitCollection();
      
			if(MHC)  
        if(index>0 && index<=MHC->GetSize())
        { 
          MHit* aHit = (*MHC)[index-1];
          int nsteps = aHit->GetPos().size();
                    
          // photo electron tubes are treated differently than 
          // normal sensitive detectors 
          if(MSD->SDID.IDnames.back().find("nphe_pmt") != string::npos)
        	{
            SD += "  nphe: " + stringify(nsteps);
             
            newHit->setText(0, QString(SD.c_str()));
            
            vector<double>        ene = aHit->GetEs();
            vector<double>       time = aHit->GetTime();
            vector<int>           pid = aHit->GetPIDs();
            
            vector<double> lambda;
            // 1 nm = 1240 / eV
            for(unsigned int i=0; i<ene.size(); i++)
            	lambda.push_back(1240.0/(ene[i]/eV));
              
            
            vector<identifier> identi = aHit->GetId();
            string title = "";
            for(unsigned int i=0; i<identi.size(); i++)
              title += identi[i].name + " " + stringify(identi[i].id) + "   " ;

            QTreeWidgetItem * EneI = new QTreeWidgetItem(newHit);
            EneI->setText(0, QString("   Wavelenght[nm]    pid      Time[ns] "));
            EneI->setExpanded(1);

            QTreeWidgetItem * EneItems;
            for(int i=0; i<nsteps; i++)
            {
              EneItems = new QTreeWidgetItem(EneI);
              char etext[200];
              sprintf(etext, "      %4.1f             %d        %5.4f     ", lambda[i], pid[i], time[i]);
              EneItems->setText(0, QString(etext));
              EneItems->setTextAlignment(1, Qt::AlignJustify);
              EneItems->setTextAlignment(2, Qt::AlignJustify);
            }
            plots_bg("time [ns]", "Wavelenght [nm]", time, lambda, title);
            plot_graph(time, lambda, pid);
         }
        	else
          {
            SD += "  nsteps: " + stringify(nsteps);
                      
            newHit->setText(0, QString(SD.c_str()));
            
            vector<double>       edep = aHit->GetEdep();
            vector<double>       time = aHit->GetTime();
            vector<G4ThreeVector> mom = aHit->GetMoms();
            vector<int>           pid = aHit->GetPIDs();
            vector<identifier> identi = aHit->GetId();
            string title = "";
            for(unsigned int i=0; i<identi.size(); i++)
              title += identi[i].name + " " + stringify(identi[i].id) + "   " ;
            
            
            // calculating max EDEP
            double max_edep=0;
            for(unsigned int i=0; i<edep.size(); i++)
            	if(edep[i]>max_edep) max_edep = edep[i];
            
            // scale depends on max_edep
            // to be completed
            // cout << max_edep << "    MAX " << endl;
            
            QTreeWidgetItem * EdepI = new QTreeWidgetItem(newHit);
            EdepI->setText(0, QString("   Edep[MeV]    pid      Time[ns]       p[MeV]"));
            EdepI->setExpanded(1);
            
            QTreeWidgetItem * EdepItems;
            for(int i=0; i<nsteps; i++)
            {
              EdepItems = new QTreeWidgetItem(EdepI);
              char etext[200];
              sprintf(etext, "%6.5f      %d       %5.4f        %4.2f", edep[i], pid[i], time[i], mom[i].mag());
              EdepItems->setText(0, QString(etext));
              EdepItems->setTextAlignment(1, Qt::AlignJustify);
              EdepItems->setTextAlignment(2, Qt::AlignJustify);
            }
            plots_bg("time [ns]", "EDep [MeV]", time, edep, title);
            plot_graph(time, edep, pid);
            
          }
        }
    }
  }
  return gsignals;
}


void gsignal::plots_bg(string xtit, string ytit, vector<double> x, vector<double> y, string title)
{
  scene->clear();
  // title
  QGraphicsSimpleTextItem *Title = new QGraphicsSimpleTextItem(QString(title.c_str()));
  scene->addItem(Title);
  QFont sansFont("Times", 18);
  Title->setFont(sansFont);
  Title->moveBy(20 - (double) title.length()*3.0, 10); // this should more or less center it
  
  if(x.size()<1) return;
  
  // axis
  QGraphicsLineItem *xaxis  = new QGraphicsLineItem( xorig-4, yorig, xorig+xaxil,  yorig);
  QGraphicsLineItem *xaxisa = new QGraphicsLineItem( xorig+xaxil,  yorig, xorig+xaxil - 15,  yorig + 4);
  QGraphicsLineItem *xaxisb = new QGraphicsLineItem( xorig+xaxil,  yorig, xorig+xaxil - 15,  yorig - 4);
  xaxis->setPen( QPen(Qt::black, 3));
  xaxisa->setPen(QPen(Qt::black, 2));
  xaxisb->setPen(QPen(Qt::black, 2));
  scene->addItem(xaxis);
  scene->addItem(xaxisa);
  scene->addItem(xaxisb);
  

  QGraphicsLineItem *yaxis  = new QGraphicsLineItem(xorig, yorig+4, xorig,  yorig-yaxil);
  QGraphicsLineItem *yaxisa = new QGraphicsLineItem(xorig,  yorig-yaxil, xorig - 4,  yorig-yaxil + 15);
  QGraphicsLineItem *yaxisb = new QGraphicsLineItem(xorig,  yorig-yaxil, xorig + 4,  yorig-yaxil + 15);
  yaxis->setPen( QPen(Qt::black, 3));
  yaxisa->setPen(QPen(Qt::black, 3));
  yaxisb->setPen(QPen(Qt::black, 3));
  scene->addItem(yaxis);
  scene->addItem(yaxisa);
  scene->addItem(yaxisb);
  

  // labels
  QGraphicsSimpleTextItem *xlab = new QGraphicsSimpleTextItem(QString(xtit.c_str()));
  QGraphicsSimpleTextItem *ylab = new QGraphicsSimpleTextItem(QString(ytit.c_str()));
  scene->addItem(xlab);
  scene->addItem(ylab);
  xlab->moveBy(xorig+xaxil-60, yorig + 10);
  ylab->moveBy(xorig-30, yorig-yaxil+50);
  ylab->setRotation(-90);
  
  // calculating minima and maxima
  xmin = 100000;
  ymin = 100000;
  for(unsigned int i=0; i<x.size(); i++) if(x[i] < xmin) xmin = x[i];
  for(unsigned int i=0; i<y.size(); i++) if(y[i] < ymin) ymin = y[i];
  xmax = -100000;
  ymax = -100000;
  for(unsigned int i=0; i<x.size(); i++) if(x[i] > xmax) xmax = x[i];
  for(unsigned int i=0; i<y.size(); i++) if(y[i] > ymax) ymax = y[i];

	
  // putting 5 vertical axis - dashed lines - between xmin and xmax
  dx = (xmax - xmin);
  dy = (ymax - ymin);
  
  
  
  // lab should be at least size 10
  char lab[10];
  QGraphicsSimpleTextItem *alab;
  
  QGraphicsLineItem *xtick;
  for(int a=0; a<nticksx+1; a++)
  {
    xtick = new QGraphicsLineItem(xorig + inside + a*DX/nticksx, yorig + 4, xorig + inside + a*DX/nticksx,  yorig-yaxil+inside);
    xtick->setPen( QPen(Qt::blue, 1, Qt::DashDotLine));
    scene->addItem(xtick);
  }
  
  
  for(int a=0; a<nticksx; a++)
  {
    sprintf(lab, "%4.3f", xmin+ a*dx/nticksx); 
    alab = new QGraphicsSimpleTextItem(QString(lab));
    QFont sansFont("Helvetica", 12);
    alab->setFont(sansFont);
    alab->moveBy(xorig + inside + a*DX/nticksx - 12, yorig + 8);
    scene->addItem(alab);
  }
 
  
  QGraphicsLineItem *ytick;
  for(int a=0; a<nticksy+1; a++)
  {
    ytick = new QGraphicsLineItem(xorig - 4, yorig - inside - a*DY/nticksy, xorig + xaxil - inside,  yorig - inside - a*DY/nticksy);
    ytick->setPen( QPen(Qt::blue, 1, Qt::DashDotLine));
    scene->addItem(ytick);
  }
  
  
  for(int a=0; a<nticksy; a++)
  {
        
    if     (ymin+ a*dy/nticksy < 0.01)
    	sprintf(lab, "%5.4f", ymin+ a*dy/nticksy); 
    else if(ymin+ a*dy/nticksy < 1)
    	sprintf(lab, "%5.3f", ymin+ a*dy/nticksy); 
    else if(ymin+ a*dy/nticksy < 10)
    	sprintf(lab, "%5.2f", ymin+ a*dy/nticksy); 
    else if(ymin+ a*dy/nticksy < 100)
    	sprintf(lab, "%5.1f", ymin+ a*dy/nticksy); 
    else
    	sprintf(lab, "%5.0f", ymin+ a*dy/nticksy); 
   
    alab = new QGraphicsSimpleTextItem(QString(lab));
    QFont sansFont("Helvetica", 12);
    alab->setFont(sansFont);
    alab->moveBy(xorig - 50, yorig - inside - a*DY/nticksy - 6);
    scene->addItem(alab);
  }
  
}

void gsignal::plot_graph(vector<double> x, vector<double> y, vector<int> pid)
{
  if(x.size()<2) return;

  QGraphicsRectItem    *rect;
    
  for(unsigned int i=0; i<x.size(); i++)
  {
    if(pcolors.find(pid[i]) == pcolors.end())
      cout << " Attention: color not found for: " << pid[i] << endl;
    else
    {
      rect = scene->addRect(0, 0, 6, 6, pcolors[pid[i]]);
      rect->moveBy(xorig + inside + DX*(x[i]-xmin)/dx, yorig - inside - DY*(y[i]-ymin)/dy);
    }
  }
}

gsignal::~gsignal()
{
	string hd_msg = gemcOpt->args["LOG_MSG"].args ;
	double VERB   = gemcOpt->args["GEO_VERBOSITY"].arg ;
	if(VERB>2)
		cout << hd_msg << " Signal Widget Deleted." << endl;
	
}


















