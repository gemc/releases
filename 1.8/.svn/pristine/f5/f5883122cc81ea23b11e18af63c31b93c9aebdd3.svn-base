void SF7map_compare(string filename1,string filename2)
{
TFile *rootfile1=new TFile(filename1.c_str());
TFile *rootfile2=new TFile(filename2.c_str());

char *hstname[6]={
  "Br",
  "dBzdr",
  "Bz",
  "dBrdz",
  "B",
  "Field Index"
};

TCanvas *c_SF7map = new TCanvas("SF7map","SF7map",1200,900);
gStyle->SetPalette(1);
gStyle->SetOptStat(0);
c_SF7map->Divide(2,3);

for(int i=0;i<6;i++){
  c_SF7map->cd(i+1);
  TH2F *h1 = (TH2F*) rootfile1->Get(hstname[i]);
  TH2F *h2 = (TH2F*) rootfile2->Get(hstname[i]);
  TH2F *h=h1->Clone();
  h->Add(h2,-1);
  h->Draw("colz");
}

}