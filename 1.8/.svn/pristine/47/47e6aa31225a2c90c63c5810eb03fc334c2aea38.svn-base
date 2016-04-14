{
	gStyle->SetPalette(1);
	const int NZPOINTS = 301;
	const int NXPOINTS = 26;
	
	double z1,z2;
	
	double BY[NZPOINTS][NXPOINTS];
		
	//ifstream f("f10000.dat");
	ifstream f("f5000.dat");
	
	for(int z=0; z<NZPOINTS; z++)
	{
		f >> z1;
		z2 = z*0.5;
		for(int x=0; x<NXPOINTS; x++)
		{
			f >> BY[z][x];
		}
		if(z1-z2 != 0)
			cout << " Indexes are wrong: z1: " << z1 << "     z2: " << z2 << endl;
	}


	TH2F *HBY = new TH2F("HBY", "HBY", NZPOINTS*2-1, -150.5, 150.5, NXPOINTS*2-1, -25.5, 25.5);
	for(int z=0; z<NZPOINTS; z++)
		for(int x=0; x<NXPOINTS; x++)
		{
			HBY->SetBinContent(NZPOINTS+z,  NXPOINTS+x, BY[z][x]);
			HBY->SetBinContent(NZPOINTS-z,  NXPOINTS+x, BY[z][x]);
			
			HBY->SetBinContent(NZPOINTS+z, NXPOINTS-x, BY[z][x]);
			HBY->SetBinContent(NZPOINTS-z, NXPOINTS-x, BY[z][x]);
		}
	
	f.close();
	
	double zz,xx;
	ofstream of("pair_spectrometer.dat");
	for(int z=0; z<NZPOINTS*2-1; z++)
	{
		zz = -150 + z*0.5;
		for(int x=0; x<NXPOINTS*2-1; x++)
		{
			of.precision(10);
			xx = -25  + x;
			of.width(10);
			of << zz ;
			of.width(10);
			of << xx ;
			of.width(16);
			of << HBY->GetBinContent(z+1, x+1) << endl;
		
		}
	}		
}

