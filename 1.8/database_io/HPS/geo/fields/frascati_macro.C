{
	gStyle->SetPalette(1);
	const int NZPOINTS = 27;
	const int NXPOINTS = 3;
	
	// the value for X are 0, 18.256, 32.544. 
	// B dosn't change much so I change those to 0, 17, 34
	// to have them equidistant
	// Z is spaced by 12.7 cm (5 inches)
	
	double z1,z2, tmp;
	
	double BY[NZPOINTS][NXPOINTS];
		
	ifstream f("frascati_magnet_I700.txt");
	
	double max_field         = 1.042;      // max field at 700 amps
	double max_field_desired = 0.50/0.8316;
	double Idesired          =  700*max_field_desired/max_field;
	cout << " Current desired: " << Idesired << endl;
	
	for(int z=0; z<NZPOINTS; z++)
	{
		f >> tmp >> z1;
		z2 = 328.74 - z*12.7;
		for(int x=0; x<NXPOINTS; x++)
		{
			f >> BY[z][x];
		}
		if(z1-z2 > 0.0000001)
			cout << " Indexes are wrong: z1: " << z1 << "     z2: " << z2 <<  " " << z1-z2 << endl;
	}


	TH2F *HBY = new TH2F("HBY", "HBY", NZPOINTS*2-1, -331.66-2.5*2.54, 328.74+2.5*2.54, NXPOINTS*2-1, -42.5, 42.5);
	for(int z=0; z<NZPOINTS; z++)
		for(int x=0; x<NXPOINTS; x++)
		{
			HBY->SetBinContent(NZPOINTS*2-z-1,  NXPOINTS+x, BY[z][x]*max_field_desired/max_field);
			HBY->SetBinContent(NZPOINTS*2-z-1,  NXPOINTS-x, BY[z][x]*max_field_desired/max_field);

			HBY->SetBinContent(z+1,             NXPOINTS+x, BY[z][x]*max_field_desired/max_field);
			HBY->SetBinContent(z+1,             NXPOINTS-x, BY[z][x]*max_field_desired/max_field);
		}
	
	f.close();
	
	double zz,xx;
	ofstream of(Form("frascati_magnet_I%4.1f.dat", Idesired));
	for(int z=0; z<NZPOINTS*2-1; z++)
	{
		zz = -331.66 + z*12.7;
		for(int x=0; x<NXPOINTS*2-1; x++)
		{
			of.precision(10);
			xx = -34  + x*17;
			of.width(10);
			of << zz ;
			of.width(10);
			of << xx ;
			of.width(16);
			of << HBY->GetBinContent(z+1, x+1) << endl;
		
		}
	}		
}

