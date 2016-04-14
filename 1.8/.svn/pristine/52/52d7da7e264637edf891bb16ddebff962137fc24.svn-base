#include <iomanip>
#include <iostream>
using namespace std;

void SF7toGEMCmap(string input_filename,int opt=0,double x1=0,double y1=0,double x2=0,double y2=0)
{

ifstream input(input_filename.c_str());
if (input.good()) cout << "open SF7 file " << input_filename << " OK" <<endl;
else {cout << "can't open the file" << endl; return;}

double Rmin,Rmax,Zmin,Zmax;
int Num_R,Num_Z;
char textline[200];
string pl;

  // reads and discard the first 27 lines of text
for (int k = 0; k<27; k++) input.getline(textline,200);

//================================== 
//(Rmin,Zmin) = (0.0,-300)
// (Rmax,Zmax) = (300,475)
// R and Z increments:   300   775
//================================== 

//readin R and Z info
// input.getline(textline,200);
input >> textline >> textline >> textline;
pl=textline;
int pl_first= pl.find(",");pl_last= pl.rfind(",");pl_init=1;pl_end=pl.size()-1;
Rmin=atof(pl.substr(pl_init,pl_first).c_str());
Zmin=atof(pl.substr(pl_last+1,pl_end).c_str());
cout << "Rmin " << Rmin << " Zmin " << Zmin << endl; 
// input.getline(textline,200);
input >> textline >> textline >> textline;
pl=textline;
pl_first= pl.find(",");pl_last= pl.rfind(",");pl_init=1;pl_end=pl.size()-1;
Rmax=atof(pl.substr(pl_init,pl_first).c_str());
Zmax=atof(pl.substr(pl_last+1,pl_end).c_str());
cout << "Rmax " << Rmax << " Zmax " << Zmax << endl; 
input >> textline >> textline >> textline >> textline >> Num_R >> Num_Z; //reads the line like "R and Z increments:   300   775"
cout << "R and Z increments:\t" << Num_R << "\t" << Num_Z << endl;
const int constNum_R=Num_R+1,constNum_Z=Num_Z+1;
cout << "please put " << constNum_R << " " << constNum_Z << " instead into database" << endl;
cout << "the units are in cm and G" << endl;


//using info to intialize histogram
string rootfilename=input_filename+".root";
TFile *rootfile=new TFile(rootfilename.c_str(), "recreate");
TH2F *hBr = new TH2F("Br","Br",constNum_Z,Zmin-0.5,Zmax-0.5,constNum_R,Rmin-0.5,Rmax-0.5);
TH2F *hBz = new TH2F("Bz","Bz",constNum_Z,Zmin-0.5,Zmax-0.5,constNum_R,Rmin-0.5,Rmax-0.5);
TH2F *hB = new TH2F("B","B",constNum_Z,Zmin-0.5,Zmax-0.5,constNum_R,Rmin-0.5,Rmax-0.5);
TH2F *hdBzdr = new TH2F("dBzdr","dBz/dz",constNum_Z,Zmin-0.5,Zmax-0.5,constNum_R,Rmin-0.5,Rmax-0.5);
TH2F *hdBrdz = new TH2F("dBrdz","dBr/dz",constNum_Z,Zmin-0.5,Zmax-0.5,constNum_R,Rmin-0.5,Rmax-0.5);
TH2F *hFI = new TH2F("Field Index","Field Index",constNum_Z,Zmin-0.5,Zmax-0.5,constNum_R,Rmin-0.5,Rmax-0.5);
hBr->SetOption("colz");
hBz->SetOption("colz");
hB->SetOption("colz");
hdBzdr->SetOption("colz");
hdBrdz->SetOption("colz");
hFI->SetOption("colz");

//================================== //================================== //================================== 
/*      R             Z              Br            Bz            |B|           A           dBz/dr        dBr/dz        Field 
    (cm)          (cm)             (G)           (G)           (G)         (G-cm)        (G/cm)        (G/cm)        Index
   0.00000      -300.000      0.000000E+00  1.182612E+02  1.182612E+02  0.000000E+00  0.000000E+00  0.000000E+00  0.000000E+00
   1.00000      -300.000     -4.421302E+00  1.181201E+02  1.182028E+02  5.910655E+01 -3.715369E-01 -3.715369E-01 -3.145416E-03
   2.00000      -300.000     -8.787357E+00  1.175323E+02  1.178603E+02  1.178899E+02 -7.141002E-01 -7.141002E-01 -1.215156E-02
   3.00000      -300.000     -1.313440E+01  1.166421E+02  1.173792E+02  1.761655E+02 -1.065480E+00 -1.065480E+00 -2.740383E-02
   4.00000      -300.000     -1.743836E+01  1.153939E+02  1.167041E+02  2.336502E+02 -1.421415E+00 -1.421415E+00 -4.927177E-02*/
//================================== //================================== //================================== 

// reads and discard the next 3 lines of text  
for (int k = 0; k<4; k++) input.getline(textline,200);

// reads in R Z Br Bz (R increase first when Z fixed)
string R_s[constNum_R][constNum_Z],Z_s[constNum_R][constNum_Z],Br_s[constNum_R][constNum_Z],Bz_s[constNum_R][constNum_Z];
double  R,Z,Br,Bz,B,A,dBzdr,dBrdz,FI;
for (int j = 0; j<constNum_Z; j++) {
  for (int i = 0; i<constNum_R; i++) {
	input >> R_s[i][j] >> Z_s[i][j] >> Br_s[i][j] >> Bz_s[i][j] >>B>>A>>dBzdr>>dBrdz>>FI;
	R=atof(R_s[i][j].c_str()); 
	Z=atof(Z_s[i][j].c_str());
	Br=atof(Br_s[i][j].c_str());
	Bz=atof(Bz_s[i][j].c_str());

	hBr->Fill(Z,R,Br);
	hBz->Fill(Z,R,Bz);
	hB->Fill(Z,R,B);
	hdBzdr->Fill(Z,R,dBzdr);
	hdBrdz->Fill(Z,R,dBrdz);
	hFI->Fill(Z,R,FI);
	
// 	input.getline(textline,200); //get the rest of line
//       cout.width(10);
//       cout.setf(0,ios::floatfield);
//       cout.setf(ios::fixed,ios::floatfield);
//     cout.precision(6);
//     cout << scientific << 
//     cout << R[i][j] << "\t" <<  Z[i][j] <<  "\t" <<  Br[i][j] <<  "\t" <<  Bz[i][j] << endl; 
	cout << j << "\t" << i << "\r";
  }
}
//     cout << R << "\t" <<  Z <<  "\t" <<  Br <<  "\t" <<  Bz << endl;  
input.close();
cout << "finish reading in" << endl;

rootfile->Write();
rootfile->Flush();
cout << "output rootfile " << rootfilename << endl;

if (opt==0||opt==1){
//write  R Z Br Bz (Z increase first when R fixed)
string output_filename=input_filename+".GEMCmap";
// string output_filename="GEMCmap";
ofstream output(output_filename.c_str(),ios::trunc);
for (int i = 0; i<constNum_R; i++) {
  for (int j = 0; j<constNum_Z; j++) {
    output << R_s[i][j] << "\t" <<  Z_s[i][j] <<  "\t" <<  Br_s[i][j] <<  "\t" <<  Bz_s[i][j] << endl; 
    cout << j << "\t" << i << "\r";
  }
}
cout << "finish writing out" << endl;

output.close();
cout << "covert to GEMC map file " <<  output_filename << " OK" << endl;
cout << "the units are in cm and G" << endl;
}


if (opt==1||opt==2){
TCanvas *c_SF7map = new TCanvas("SF7map","SF7map",1200,900);
gStyle->SetPalette(1);
gStyle->SetOptStat(0);
c_SF7map->Divide(2,3);
c_SF7map->cd(1);
hBr->Draw("colz");
c_SF7map->cd(3);
hBz->Draw("colz");
c_SF7map->cd(5);
// hB->SetMinimum(20);
hB->Draw("colz");
c_SF7map->cd(2);
hdBzdr->Draw("colz");
c_SF7map->cd(4);
hdBrdz->Draw("colz");
c_SF7map->cd(6);
hFI->Draw("colz");
}

if(opt==3){
  int bin_low=hB->FindBin(x1,y1);
  int binx_low,biny_low,binz_low;
  hB->GetBinXYZ(bin_low,binx_low,biny_low,binz_low);
  int bin_high=hB->FindBin(x2,y2);
  int binx_high,biny_high,binz_high;
  hB->GetBinXYZ(bin_high,binx_high,biny_high,binz_high);
  
  int Num_binX=binx_high-binx_low;
  int Num_binY=biny_high-biny_low;  
  int nstep=Num_binX > Num_binY ? Num_binX:Num_binY;
  
  double widthX=(x2-x1)/nstep;
  double widthY=(y2-y1)/nstep;
  
  double curl_Br=0,curl_Bz=0,curl_B=0;
  for (int i=0;i<=nstep;i++){
    double x=x1+i*widthX;
    double y=y1+i*widthY;
    int bin=hB->FindBin(x,y);
    int binx,biny,binz;
    hB->GetBinXYZ(bin,binx,biny,binz);
    
    curl_Bz += hBz->GetBinContent(binx,biny)*widthY;    
    curl_Br += hBr->GetBinContent(binx,biny)*widthX;
    curl_B  += hBz->GetBinContent(binx,biny)*widthY - hBr->GetBinContent(binx,biny)*widthX;
  }
  
  cout << endl;
  cout << "======= here we calculate the integral(B cross product dR) ============" << endl;
  cout << "curl_Bz = Sum(Bz*dy) = "  << curl_Bz << " cm*G" << endl;
  cout << "curl_Br = Sum(Br*dx) = "  << curl_Br << " cm*G" << endl;
  cout << "curl_B  = Sum(Bz*dy-Br*dx) = "  << curl_B << " cm*G" << endl;
  
 TLine *l=new TLine(x1,y1,x2,y2);  
 l->SetLineColor(kBlack);
 l->SetLineWidth(2);
 c_SF7map->cd(1);
 l->Draw();
 c_SF7map->cd(3);
 l->Draw();
 c_SF7map->cd(5);
 l->Draw();  
}

}
