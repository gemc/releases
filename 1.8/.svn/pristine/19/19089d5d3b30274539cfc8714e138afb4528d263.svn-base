#!/usr/bin/perl -w
 
use strict;
 
use lib ("$ENV{GEMC}/database_io");
use geo;
 
my $envelope = 'C1';
my $file     = 'C1.txt';
 
my $rmin      = 1;
my $rmax      = 1000000;
 
my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = 1;
$detector{"rmax"} = 10000;
 
  
my $C1_x        = -450.00;
my $Cathode2_x = -0.02;
my $Mylar2_x = -0.04;
my $Al2_x = -0.05;
my $GEM4_x = -1.5;
my $GEM4CuFoil1_x = 0.01;
my $GEM4Kapton_x = 0.05;
my $GEM4CuFoil2_x = 0.1;
my $GEM5_x = -3.0;
my $GEM5CuFoil1_x = -0.01;
my $GEM5Kapton_x = -0.05;
my $GEM5CuFoil2_x = -0.1;
my $GEM6_x = -4.5;
my $GEM6CuFoil1_x = -0.01;
my $GEM6Kapton_x = -0.05;
my $GEM6CuFoil2_x = -0.1;
my $Readout2_x = -7.25;





# Mother Volume
sub make_C1
{                                                                                                                             
 $detector{"name"}        = "C1";
 $detector{"mother"}      = "root";                      
 $detector{"description"} = "C1 Cylindrical Triple GEM Detector";  
 $detector{"pos"}         = "$C1_x*mm 0*mm 0*mm";           
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";        
 $detector{"color"}       = "00ffff";               
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "10*mm 70*mm 280*mm"; 
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


sub make_Cathode2
{                                                                                                                             
 $detector{"name"}        = "Cathode2";
 $detector{"mother"}      = "C1";                      
 $detector{"description"} = "Cathode2 of C1 Detector";   
 $detector{"pos"}         = "$Cathode2_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";        
 $detector{"color"}       = "00ffff";                    
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "0.050*mm 70*mm 280*mm";   
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


sub make_Mylar2
{                                                                                                                             
 $detector{"name"}        = "Mylar2";
 $detector{"mother"}      = "Cathode2";                      
 $detector{"description"} = "Mylar2 of Cathode2 of C1 Detector";   
 $detector{"pos"}         = "$Mylar2_x*mm 0*cm 0*cm";            
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "00ffff";                   
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.020*mm 70*mm 280*mm";
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


sub make_Al2
{                                                                                                                             
 $detector{"name"}        = "Al2";
 $detector{"mother"}      = "Cathode2";                      
 $detector{"description"} = "Al2 of Cathode of C1 Detector";   
 $detector{"pos"}         = "$Al2_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";        
 $detector{"color"}       = "00ffff";                
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "0.001*mm 70*mm 280*mm";   
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






sub make_GEM4
{                                                                                                                             
 $detector{"name"}        = "GEM4";
 $detector{"mother"}      = "C1";                         
 $detector{"description"} = "GEM4 of C1 Detector";   
 $detector{"pos"}         = "$GEM4_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       = "ffff00";                
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.200*mm 70*mm 280*mm";  
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
              

sub make_GEM4CuFoil1
{                                                                                                                             
 $detector{"name"}        = "GEM4CuFoil1";
 $detector{"mother"}      = "GEM4";                      
 $detector{"description"} = "GEM4CuFoil1 of GEM4 of C1 Detector";   
 $detector{"pos"}         = "$GEM4CuFoil1_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "ffff00";                  
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "0.005*mm 70*mm 280*mm";   
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


sub make_GEM4Kapton
{                                                                                                                             
 $detector{"name"}        = "GEM4Kapton";
 $detector{"mother"}      = "GEM4";                       
 $detector{"description"} = "GEM4Kapton of GEM4 of C1 Detector";   
 $detector{"pos"}         = "$GEM4Kapton_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       =  "ffff00";              
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.050*mm 70*mm 280*mm";   
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




sub make_GEM4CuFoil2
{                                                                                                                             
 $detector{"name"}        = "GEM4CuFoil2";
 $detector{"mother"}      = "GEM4";                        
 $detector{"description"} = "GEM4CuFoil1 of GEM4 of C1 Detector";   
 $detector{"pos"}         = "$GEM4CuFoil2_x*mm 0*cm 0*cm";            
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       = "ffff00";               
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.005*mm 70*mm 280*mm";   
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


                                                                                                                


sub make_GEM5
{                                                                                                                             
 $detector{"name"}        = "GEM5";
 $detector{"mother"}      = "C1";                      
 $detector{"description"} = "GEM5 of C1 Detector";  
 $detector{"pos"}         = "$GEM5_x*mm 0*cm 0*cm";           
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       = "ff00ff";                   
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.200*mm 70*mm 280*mm";   
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





sub make_GEM5CuFoil1
{                                                                                                                             
 $detector{"name"}        = "GEM5CuFoil1";
 $detector{"mother"}      = "GEM5";                       
 $detector{"description"} = "GEM5CuFoil1 of GEM5 of C1 Detector";   
 $detector{"pos"}         = "$GEM5CuFoil1_x*mm 0*cm 0*cm";            
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       = "ff00ff";          
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.005*mm 70*mm 280*mm";   
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


sub make_GEM5Kapton
{                                                                                                                             
 $detector{"name"}        = "GEM5Kapton";
 $detector{"mother"}      = "GEM5";                        
 $detector{"description"} = "GEM5Kapton of GEM5 of C1 Detector";  
 $detector{"pos"}         = "$GEM5Kapton_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       = "ff00ff";            
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.050*mm 70*mm 280*mm";   
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




sub make_GEM5CuFoil2
{                                                                                                                             
 $detector{"name"}        = "GEM5CuFoil2";
 $detector{"mother"}      = "GEM5";                      
 $detector{"description"} = "GEM5CuFoil2 of GEM5 of C1 Detector";   
 $detector{"pos"}         = "$GEM5CuFoil2_x*mm 0*cm 0*cm";         
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "ff00ff";                
 $detector{"type"}        = "Box";                       
 $detector{"dimensions"}  = "0.005*mm 70*mm 280*mm";   
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





sub make_GEM6
{                                                                                                                             
 $detector{"name"}        = "GEM6";
 $detector{"mother"}      = "C1";                      
 $detector{"description"} = "GEM6 of C1 Detector";   
 $detector{"pos"}         = "$GEM6_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "00ff99";                 
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.200*mm 70*mm 280*mm";  
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


sub make_GEM6CuFoil1
{                                                                                                                             
 $detector{"name"}        = "GEM6CuFoil1";
 $detector{"mother"}      = "GEM6";                     
 $detector{"description"} = "GEM6CuFoil1 of GEM6 of C1 Detector";  
 $detector{"pos"}         = "$GEM6CuFoil1_x*mm 0*cm 0*cm";            
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";       
 $detector{"color"}       = "00ff99";                  
 $detector{"type"}        = "Box";                     
 $detector{"dimensions"}  = "0.005*mm 70*mm 280*mm";  
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


sub make_GEM6Kapton
{                                                                                                                             
 $detector{"name"}        = "GEM6Kapton";
 $detector{"mother"}      = "GEM6";                         
 $detector{"description"} = "GEM6Kapton of GEM6 of C1 Detector";   
 $detector{"pos"}         = "$GEM6Kapton_x*mm 0*cm 0*cm";       
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "00ff99";               
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.050*mm 70*mm 280*mm";   
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




sub make_GEM6CuFoil2
{                                                                                                                             
 $detector{"name"}        = "GEM6CuFoil2";
 $detector{"mother"}      = "GEM6";                       
 $detector{"description"} = "GEM6CuFoil2 of GEM6 of C1 Detector"; 
 $detector{"pos"}         = "$GEM6CuFoil2_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "00ff99";               
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.005*mm 70*mm 280*mm";   
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





sub make_Readout2
{                                                                                                                             
 $detector{"name"}        = "Readout2";
 $detector{"mother"}      = "C1";                       
 $detector{"description"} = "Readout2 of C1 Detector"; 
 $detector{"pos"}         = "$Readout2_x*mm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";         
 $detector{"color"}       = "33bb99";                     
 $detector{"type"}        = "Box";                      
 $detector{"dimensions"}  = "0.050*mm 70*mm 280*mm";   
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


make_C1();
make_Cathode2();
make_Mylar2();
make_Al2();
make_GEM4();
make_GEM4CuFoil1();
make_GEM4Kapton();
make_GEM4CuFoil2();
make_GEM5();
make_GEM5CuFoil1();
make_GEM5Kapton();
make_GEM5CuFoil2();
make_GEM6();
make_GEM6CuFoil1();
make_GEM6Kapton();
make_GEM6CuFoil2();
make_Readout2();




                                                                                                                           
