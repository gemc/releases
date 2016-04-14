#!/usr/bin/perl -w
 
use strict;
 
use lib ("$ENV{GEMC}/database_io");
use geo;
 
my $envelope = 'C0';
my $file     = 'C0.txt';
 
my $rmin      = 1;
my $rmax      = 1000000;
 
my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = 1;
$detector{"rmax"} = 10000;
 
  
# Mother Volume
sub make_C0
{                                                                                                                             
 $detector{"name"}        = "C0";
 $detector{"mother"}      = "root";                     
 $detector{"description"} = "C0 Cylindrical Triple GEM Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";           
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";        
 $detector{"color"}       = "33bb99";                     
 $detector{"type"}        = "Tube";                     
 $detector{"dimensions"}  = "70.0*mm 85.230*mm 300*mm 0*deg 360*deg";  
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


sub make_Cathode
{                                                                                                                             
 $detector{"name"}        = "Cathode";
 $detector{"mother"}      = "C0";                      
 $detector{"description"} = "Cathode of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "bb3399";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "70.00*mm 70.021*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Mylar+Al";
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


sub make_Mylar
{                                                                                                                             
 $detector{"name"}        = "Mylar";
 $detector{"mother"}      = "Cathode";                        
 $detector{"description"} = "Mylar of Cathode of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "88bb99";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "70.00*mm 70.020*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Mylar";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 1";
                                                                                                                              
 print_det(\%detector, $file);
}


sub make_Al
{                                                                                                                             
 $detector{"name"}        = "Al";
 $detector{"mother"}      = "Cathode";                        
 $detector{"description"} = "Al of Cathode of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "aa6699";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "70.020*mm 70.021*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "G4_Al";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 2";
                                                                                                                              
 print_det(\%detector, $file);
}






sub make_GEM1
{                                                                                                                             
 $detector{"name"}        = "GEM1";
 $detector{"mother"}      = "C0";                        
 $detector{"description"} = "GEM1 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "888888";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "73.00*mm 73.060*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Copper+Kapton";
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
              

sub make_GEM1CuFoil1
{                                                                                                                             
 $detector{"name"}        = "GEM1CuFoil1";
 $detector{"mother"}      = "GEM1";                        
 $detector{"description"} = "GEM1CuFoil1 of GEM1 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "9911ff";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "73.000*mm 73.005*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Copper";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 3";
                                                                                                                              
 print_det(\%detector, $file);
}


sub make_GEM1Kapton
{                                                                                                                             
 $detector{"name"}        = "GEM1Kapton";
 $detector{"mother"}      = "GEM1";                        
 $detector{"description"} = "GEM1Kapton of GEM1 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "ff0003";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "73.005*mm 73.055*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Kapton";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 4";
                                                                                                                              
 print_det(\%detector, $file);
}




sub make_GEM1CuFoil2
{                                                                                                                             
 $detector{"name"}        = "GEM1CuFoil2";
 $detector{"mother"}      = "GEM1";                        
 $detector{"description"} = "GEM1CuFoil1 of GEM1 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "00ff99";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "73.055*mm 73.060*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Copper";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 5";
                                                                                                                              
 print_det(\%detector, $file);
}


                                                                                                                


sub make_GEM2
{                                                                                                                             
 $detector{"name"}        = "GEM2";
 $detector{"mother"}      = "C0";                        
 $detector{"description"} = "GEM2 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "33bb99";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "76.060*mm 76.120*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Copper+Kapton";
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





sub make_GEM2CuFoil1
{                                                                                                                             
 $detector{"name"}        = "GEM2CuFoil1";
 $detector{"mother"}      = "GEM2";                        
 $detector{"description"} = "GEM2CuFoil1 of GEM2 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "ff00ff";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "76.060*mm 76.065*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Copper";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 6";
                                                                                                                              
 print_det(\%detector, $file);
}


sub make_GEM2Kapton
{                                                                                                                             
 $detector{"name"}        = "GEM2Kapton";
 $detector{"mother"}      = "GEM2";                        
 $detector{"description"} = "GEM2Kapton of GEM2 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "33bb99";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "76.065*mm 76.115*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Kapton";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 7";
                                                                                                                              
 print_det(\%detector, $file);
}




sub make_GEM2CuFoil2
{                                                                                                                             
 $detector{"name"}        = "GEM2CuFoil2";
 $detector{"mother"}      = "GEM2";                        
 $detector{"description"} = "GEM2CuFoil1 of GEM2 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "00ffff";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "76.115*mm 76.120*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Copper";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 8";
                                                                                                                              
 print_det(\%detector, $file);
}





sub make_GEM3
{                                                                                                                             
 $detector{"name"}        = "GEM3";
 $detector{"mother"}      = "C0";                        
 $detector{"description"} = "GEM3 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "33bb99";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "79.120*mm 79.180*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Copper+Kapton";
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


sub make_GEM3CuFoil1
{                                                                                                                             
 $detector{"name"}        = "GEM3CuFoil1";
 $detector{"mother"}      = "GEM3";                        
 $detector{"description"} = "GEM3CuFoil1 of GEM3 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "ffff00";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "79.120*mm 79.125*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Copper";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 9";
                                                                                                                              
 print_det(\%detector, $file);
}


sub make_GEM3Kapton
{                                                                                                                             
 $detector{"name"}        = "GEM3Kapton";
 $detector{"mother"}      = "GEM3";                        
 $detector{"description"} = "GEM3Kapton of GEM3 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "33bb99";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "79.125*mm 79.175*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Kapton";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 10";
                                                                                                                              
 print_det(\%detector, $file);
}




sub make_GEM3CuFoil2
{                                                                                                                             
 $detector{"name"}        = "GEM3CuFoil2";
 $detector{"mother"}      = "GEM3";                        
 $detector{"description"} = "GEM3CuFoil2 of GEM3 of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "00ffff";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "79.175*mm 79.180*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Copper";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 11";
                                                                                                                              
 print_det(\%detector, $file);
}





sub make_Readout
{                                                                                                                             
 $detector{"name"}        = "Readout";
 $detector{"mother"}      = "C0";                        
 $detector{"description"} = "Readout of C0 Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";            
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       = "33bb99";                     
 $detector{"type"}        = "Tube";                     
 $detector{"dimensions"}  = "85.180*mm 85.230*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Kapton";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "TREK";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "layer manual 12";
                                                                                                                              
 print_det(\%detector, $file);
}

make_C0();
make_Cathode();
make_Mylar();
make_Al();
make_GEM1();
make_GEM1CuFoil1();
make_GEM1Kapton();
make_GEM1CuFoil2();
make_GEM2();
make_GEM2CuFoil1();
make_GEM2Kapton();
make_GEM2CuFoil2();
make_GEM3();
make_GEM3CuFoil1();
make_GEM3Kapton();
make_GEM3CuFoil2();
make_Readout();

                                                                                                                             
