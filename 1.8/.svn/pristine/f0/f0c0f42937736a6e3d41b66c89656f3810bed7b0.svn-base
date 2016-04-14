#!/usr/bin/perl -w
 
use strict;
 
use lib ("$ENV{GEMC}/database_io");
use geo;
 
my $envelope = 'C2';
my $file     = 'C2.txt';
 
my $rmin      = 1;
my $rmax      = 1000000;
 
my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = 1;
$detector{"rmax"} = 10000;
 
  



my $C2_x        = -580.00;
my $GAP3_x        =20.00;

my $Window1_x = -71.00;
my $Mylar3_x = -0.02;
my $Al3_x = -0.04;

my $BStrips_x = -72.0;
my $BStripsCopper_x = -0.02;
my $BStripsKapton_x = -0.05;

my $TStrips_x = -81.0;
my $TStripsCopper_x = -0.02;
my $TStripsKapton_x = -0.05;

my $Window2_x = -82.00;
my $Mylar4_x = -0.02;
my $Al4_x = -0.04;










# Mother Volume
sub make_C2
{                                                                                                                             
 $detector{"name"}        = "C2";
 $detector{"mother"}      = "root";                      
 $detector{"description"} = "C2 MWPC  Detector";  
 $detector{"pos"}         = "$C2_x*mm 0*mm 0*mm";           
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";        
 $detector{"color"}       = "00ffff";               
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "110*mm 80*mm 280*mm"; 
 $detector{"material"}    = "Air";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 0;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}






sub make_GAP3
{                                                                                                                             
 $detector{"name"}        = "GAP3";
 $detector{"mother"}      = "C2";                      
 $detector{"description"} = "GAP3 of C2 Detector";   
 $detector{"pos"}         = "$GAP3_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";        
 $detector{"color"}       = "55bb22";                   
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "80*mm 80*mm 280*mm";   
 $detector{"material"}    = "Helium";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}





sub make_Window1
{                                                                                                                             
 $detector{"name"}        = "Window1";
 $detector{"mother"}      = "C2";                      
 $detector{"description"} = "Window1 of C2 Detector";   
 $detector{"pos"}         = "$Window1_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";        
 $detector{"color"}       = "00ffff";                    
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "0.070*mm 80*mm 280*mm";   
 $detector{"material"}    = "Air";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}


sub make_Mylar3
{                                                                                                                             
 $detector{"name"}        = "Mylar3";
 $detector{"mother"}      = "Window1";                      
 $detector{"description"} = "Mylar3 of Window1 of C2 Detector";   
 $detector{"pos"}         = "$Mylar3_x*mm 0*cm 0*cm";            
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "00ffff";                   
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.010*mm 80*mm 280*mm";
 $detector{"material"}    = "Mylar";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}


sub make_Al3
{                                                                                                                             
 $detector{"name"}        = "Al3";
 $detector{"mother"}      = "Window1";                      
 $detector{"description"} = "Al3 of Cathode of C2 Detector";   
 $detector{"pos"}         = "$Al3_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";        
 $detector{"color"}       = "00ffff";                
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "0.005*mm 80*mm 280*mm";   
 $detector{"material"}    = "Al";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}






sub make_BStrips
{                                                                                                                             
 $detector{"name"}        = "BStrips";
 $detector{"mother"}      = "C2";                         
 $detector{"description"} = "BStrips of C2 Detector";   
 $detector{"pos"}         = "$BStrips_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       = "ffff00";                
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.90*mm 80*mm 280*mm";  
 $detector{"material"}    = "Air";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}
              

sub make_BStripsCopper
{                                                                                                                             
 $detector{"name"}        = "BStripsCuFoil1";
 $detector{"mother"}      = "BStrips";                      
 $detector{"description"} = "BStripsCuFoil1 of BStrips of C2 Detector";   
 $detector{"pos"}         = "$BStripsCopper_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "ffff00";                  
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "0.009*mm 80*mm 280*mm";   
 $detector{"material"}    = "Copper";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}


sub make_BStripsKapton
{                                                                                                                             
 $detector{"name"}        = "BStripsKapton";
 $detector{"mother"}      = "BStrips";                       
 $detector{"description"} = "BStripsKapton of BStrips of C2 Detector";   
 $detector{"pos"}         = "$BStripsKapton_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       =  "ffff00";              
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.018*mm 80*mm 280*mm";   
 $detector{"material"}    = "Kapton";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}




                                                                                                                


sub make_TStrips
{                                                                                                                             
 $detector{"name"}        = "TStrips";
 $detector{"mother"}      = "C2";                      
 $detector{"description"} = "TStrips of C2 Detector";  
 $detector{"pos"}         = "$Window1_x*mm 0*cm 0*cm";           
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       = "ff00ff";                   
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.080*mm 80*mm 280*mm";   
 $detector{"material"}    = "Air";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}





sub make_TStripsCopper
{                                                                                                                             
 $detector{"name"}        = "TStripsCuFoil1";
 $detector{"mother"}      = "TStrips";                       
 $detector{"description"} = "TStripsCuFoil1 of TStrips of C2 Detector";   
 $detector{"pos"}         = "$TStripsCopper_x*mm 0*cm 0*cm";            
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       = "ff00ff";          
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.009*mm 80*mm 280*mm";   
 $detector{"material"}    = "Copper";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}


sub make_TStripsKapton
{                                                                                                                             
 $detector{"name"}        = "TStripsKapton";
 $detector{"mother"}      = "TStrips";                        
 $detector{"description"} = "TStripsKapton of TStrips of C2 Detector";  
 $detector{"pos"}         = "$TStripsKapton_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       = "ff00ff";            
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.018*mm 80*mm 280*mm";   
 $detector{"material"}    = "Kapton";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}




sub make_Window2
{                                                                                                                             
 $detector{"name"}        = "Window2";
 $detector{"mother"}      = "C2";                      
 $detector{"description"} = "Window2 of C2 Detector";   
 $detector{"pos"}         = "$Window2_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";        
 $detector{"color"}       = "00ffff";                    
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "0.040*mm 80*mm 280*mm";   
 $detector{"material"}    = "Air";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}


sub make_Mylar4
{                                                                                                                             
 $detector{"name"}        = "Mylar4";
 $detector{"mother"}      = "Window2";                      
 $detector{"description"} = "Mylar4 of Window2 of C2 Detector";   
 $detector{"pos"}         = "$Mylar4_x*mm 0*cm 0*cm";            
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "00ffff";                   
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.010*mm 80*mm 280*mm";
 $detector{"material"}    = "Mylar";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}


sub make_Al4
{                                                                                                                             
 $detector{"name"}        = "Al4";
 $detector{"mother"}      = "Window2";                      
 $detector{"description"} = "Al4 of Cathode of C2 Detector";   
 $detector{"pos"}         = "$Al4_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";        
 $detector{"color"}       = "00ffff";                
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "0.005*mm 80*mm 280*mm";   
 $detector{"material"}    = "Al";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
                                                                                                                              
 print_det(\%detector, $file);
}










make_C2();
make_GAP3();
make_Window1();
make_Mylar3();
make_Al3();
make_BStrips();
make_BStripsCopper();
make_BStripsKapton();
make_TStrips();
make_TStripsCopper();
make_TStripsKapton();
make_Window2();
make_Mylar4();
make_Al4();
