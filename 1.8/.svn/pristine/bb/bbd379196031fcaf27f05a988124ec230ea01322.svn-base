{


	gStyle->SetPadLeftMargin(-0.08);
	gStyle->SetPadRightMargin(-0.04);
	gStyle->SetPadTopMargin(-0.06);
	gStyle->SetPadBottomMargin(-0.06);
	
	gStyle->SetPalette(1);
	gStyle->SetOptStat(0);
	gStyle->SetOptTitle(0);
	gStyle->SetFrameFillColor(kWhite);
	gStyle->SetCanvasColor(kWhite);
	gStyle->SetPadColor(kWhite);

	gStyle->SetCanvasBorderMode(0);
	gStyle->SetFrameBorderMode(0);
	gStyle->SetPadBorderMode(0);


	const int NSEG = 18;
	double pe0[5][NSEG];
	double el_foci[4][NSEG];
	double x12y12[2][NSEG];
	double el_center[2][NSEG];
	double el_axis[2][NSEG];
	double el_alpha[NSEG];
	
	
	double ph0[5][NSEG];
	double hp_foci[4][NSEG];
	double hp_min[NSEG];
	double x21y21[2][NSEG];
	
	// reading ellipse parameters
	ifstream in("el_pars.txt");
	for(int s=0; s<NSEG; s++)
		for(int p=0; p<5; p++)
			in >> pe0[p][s];
	in.close();

	// reading the elliptical focal points
	in.open("el_foci.txt");
	for(int s=0; s<NSEG; s++)
		for(int j=0; j<4; j++)
			in >> el_foci[j][s];
	in.close();

	// reading the elliptical span points
	in.open("x12y12.dat");
	for(int s=0; s<NSEG; s++)
		for(int j=0; j<2; j++)
			in >> x12y12[j][s];
	in.close();
	
	// reading the elliptical center
	in.open("center.txt");
	for(int s=0; s<NSEG; s++)
		for(int j=0; j<2; j++)
			in >> el_center[j][s];
	in.close();
	
	// reading the elliptical theta
	in.open("alpha.txt");
	for(int s=0; s<NSEG; s++)
			in >> el_alpha[s];
	in.close();
	
	// reading the elliptical axis
	in.open("axis.txt");
	for(int s=0; s<NSEG; s++)
		for(int j=0; j<2; j++)
			in >> el_axis[j][s];
	in.close();
	
	// reading Hyperbola parameters
	ifstream in("hp_pars.txt");
	for(int s=0; s<NSEG; s++)
		for(int p=0; p<5; p++)
			in >> ph0[p][s];
	in.close();

	
	// reading the Hyperbolaal focal points
	in.open("hp_foci.txt");
	for(int s=0; s<NSEG; s++)
		for(int j=0; j<4; j++)
			in >> hp_foci[j][s];
	in.close();
	
	// reading the Hyperbola start points
	in.open("hp_min.txt");
	for(int s=0; s<NSEG; s++)
		in >> hp_min[s];
	in.close();
	
	// reading the Hyperbola span points
	in.open("x21y21.dat");
	for(int s=0; s<NSEG; s++)
		for(int j=0; j<2; j++)
			in >> x21y21[j][s];
	in.close();



	TF3 *ell[NSEG];                 // ellipses
	TF3 *elz[NSEG];                 // ellipses zoomed in
	TPolyMarker3D *EFP[2][NSEG];    // ellipses focal points 
	TPolyMarker3D *x12[NSEG];       // ellipses end point
	double el_y_sol[NSEG];
	TPolyMarker3D *el_start[NSEG];  // ellipses start point
	TPolyMarker3D *el_cent[NSEG];   // ellipses center
	


	TF3 *hyp[NSEG];                 // hyperbole
	TF3 *hyz[NSEG];                 // hyperbole zoomed in
	TPolyMarker3D *HFP[2][NSEG];    // hyperbole focal points
	double hp_y_sol[NSEG];
	TPolyMarker3D *hp_start[NSEG];  // hyperbole start point
	TPolyMarker3D *x21[NSEG];       // hyperbole end point
	 
	

	double maxy = 520;		
	for(int s=0; s<NSEG; s++)
	{
		// calculate the min/max of the foci
		double minyf = 500;
		
		if(minyf>el_foci[3][s]) minyf = el_foci[3][s];
		if(minyf>hp_foci[3][s]) minyf = hp_foci[3][s];
		
	
		ell[s] = new TF3(Form("el_seg%d", s+1), Form("%g*x*x + %g*y*y + %g*x*y + %g*x + %g*y + 1 +z*0", 
		                 pe0[0][s], pe0[1][s], pe0[2][s], pe0[3][s], pe0[4][s] ), 
		                 -300, 400, -200, maxy, -1, 1);
		elz[s] = new TF3(Form("ez_seg%d", s+1), Form("%g*x*x + %g*y*y + %g*x*y + %g*x + %g*y + 1 +z*0", 
		                 pe0[0][s], pe0[1][s], pe0[2][s], pe0[3][s], pe0[4][s] ), 
										 -20,  x12y12[0][s] + 20, minyf-31, maxy, -1, 1);
		ell[s]->SetLineColor(kRed-1);
		elz[s]->SetLineColor(kRed);
		
		
		// ellipses focal points
		EFP[0][s] = new TPolyMarker3D(1, 20);						 								 
		EFP[1][s] = new TPolyMarker3D(1, 20);
		
		EFP[0][s]->SetNextPoint(el_foci[0][s], el_foci[1][s], 0);												 								 								 
		EFP[1][s]->SetNextPoint(el_foci[2][s], el_foci[3][s], 0);		
		EFP[0][s]->SetMarkerColor(kRed);								 								 								 
		EFP[1][s]->SetMarkerColor(kRed);								 								 								 
	
  
		
		// ellipses center
		el_cent[s] = new TPolyMarker3D(1, 33);						 								 
		el_cent[s]->SetNextPoint(el_center[0][s], el_center[1][s], 0);												 								 								 
		el_cent[s]->SetMarkerColor(kRed);								 								 								 
		el_cent[s]->SetMarkerSize(1.5);
		
				
		// ellipses start point
		// the y point on the ellipses at x = 0
		// solving quadratic equation
		double a = pe0[1][s];
		double b = pe0[4][s];
		double c = 1;
		el_y_sol[s] = (-b - sqrt(b*b-4*a*c))/(2*a);
		
	 
		
		el_start[s] = new TPolyMarker3D(1, 32);						 								 
		el_start[s]->SetNextPoint(0, el_y_sol[s], 0);												 								 								 
		el_start[s]->SetMarkerColor(kBlack);								 								 								 
		el_start[s]->SetMarkerSize(1);
		
		// ellipses mirror span point
		x12[s] = new TPolyMarker3D(1, 32);						 								 
		x12[s]->SetNextPoint(x12y12[0][s], x12y12[1][s], 0);												 								 								 
		x12[s]->SetMarkerColor(kBlack);								 								 								 
		x12[s]->SetMarkerSize(1);

		
		hyp[s] = new TF3(Form("el_seg%d", s+1), Form("%g*x*x + %g*y*y + %g*x*y + %g*x + %g*y + 1 +z*0", 
									   ph0[0][s], ph0[1][s], ph0[2][s], ph0[3][s], ph0[4][s] ), 
		                 -250, 320, -180, maxy, -1, 1);
		hyz[s] = new TF3(Form("ez_seg%d", s+1), Form("%g*x*x + %g*y*y + %g*x*y + %g*x + %g*y + 1 +z*0", 
										 ph0[0][s], ph0[1][s], ph0[2][s], ph0[3][s], ph0[4][s] ), 
										 -20,  x12y12[0][s] + 20, minyf-30, maxy, -1, 1);
		hyp[s]->SetLineColor(kGreen-2);
		hyz[s]->SetLineColor(kGreen-3);
		
		hyp[s]->SetNpx(100);
		hyp[s]->SetNpy(100);
		hyz[s]->SetNpx(100);
		hyz[s]->SetNpy(100);

		
		// hyperbole focal points
		HFP[0][s] = new TPolyMarker3D(1, 20);						 								 
		HFP[1][s] = new TPolyMarker3D(1, 20);
		
		HFP[0][s]->SetNextPoint(hp_foci[0][s], hp_foci[1][s], 0);												 								 								 
		HFP[1][s]->SetNextPoint(hp_foci[2][s], hp_foci[3][s], 0);		
		HFP[0][s]->SetMarkerColor(kGreen-3);								 								 								 
		HFP[1][s]->SetMarkerColor(kGreen-3);								 								 								 
		
		
		// Hyperbola start point
		// the y point on the hyperbola at x = hp_min[0][s]
		// solving quadratic equation
		a = ph0[1][s];
		b = ph0[2][s]*hp_min[s] + ph0[4][s];
		c = 1 + ph0[0][s]*hp_min[s]*hp_min[s] + ph0[3][s]*hp_min[s];
		hp_y_sol[s] = (-b - sqrt(b*b-4*a*c))/(2*a);
		
		hp_start[s] = new TPolyMarker3D(1, 5);						 								 
		hp_start[s]->SetNextPoint(hp_min[s], hp_y_sol[s], 0);												 								 								 
		hp_start[s]->SetMarkerColor(kBlack);								 								 								 
		hp_start[s]->SetMarkerSize(1);		
		
		// Hyperbola mirror span point
		x21[s] = new TPolyMarker3D(1, 5);						 								 
		x21[s]->SetNextPoint(x21y21[0][s], x21y21[1][s], 0);												 								 								 
		x21[s]->SetMarkerColor(kBlack);								 								 								 
		x21[s]->SetMarkerSize(1);
		
																										 
	}	

	// since it's 3D plot, these are the numbers to center 
	// at x,y = 0,0
	TPolyLine3D  *xcenter = new TPolyLine3D(2);
	TPolyLine3D  *ycenter = new TPolyLine3D(2);
	xcenter->SetPoint(0, 0, -181, 0);
	xcenter->SetPoint(1, 0,  521, 0);
	ycenter->SetPoint(0, -251, 0, 0 );
	ycenter->SetPoint(1,  321, 0, 0 );
	xcenter->SetLineWidth(2);
	ycenter->SetLineWidth(2);
	
	TPolyLine3D  *ycenter2 = new TPolyLine3D(2);
	ycenter2->SetPoint(1, 0,  521, 0);
	ycenter2->SetLineWidth(1);
	
	TPolyLine3D  *ellipse_vert1 = new TPolyLine3D(2);
	ellipse_vert1->SetLineWidth(2);
	ellipse_vert1->SetLineColor(kRed);
	
	TPolyLine3D  *ellipse_vert2 = new TPolyLine3D(2);
	ellipse_vert2->SetLineWidth(2);
	ellipse_vert2->SetLineColor(kRed);
	



	TCanvas *CE = new TCanvas("CE", "CE", 800, 1300);
	CE->Divide(1,2);

	gROOT->LoadMacro("show_segment.C");


	// writing out y solution
	ofstream outf("el_y11.txt");
	for(int s=0; s<NSEG; s++)
	{
		outf << el_y_sol[s] << endl;
	}
	outf.close();

}




























