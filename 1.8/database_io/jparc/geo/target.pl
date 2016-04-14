#!/usr/bin/perl -w
 
use strict;
 
use lib ("$ENV{GEMC}/database_io");
use geo;
 
my $envelope = 'Target';
my $file     = 'Target.txt';
 
my $rmin      = 1;
my $rmax      = 1000000;
 
my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = 1;
$detector{"rmax"} = 10000;
 


  
# Mother Volume
sub make_Target
{                                                                                                                             
 $detector{"name"}        = "Target";
 $detector{"mother"}      = "root";                     
 $detector{"description"} = "Target Cylindrical Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";           
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";        
 $detector{"color"}       = "33bb99";                     
 $detector{"type"}        = "Tube";                     
 $detector{"dimensions"}  = "0.0*mm 30.00*mm 300*mm 0*deg 360*deg";  
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


sub make_Cylinder
{                                                                                                                             
 $detector{"name"}        = "Cylinder";
 $detector{"mother"}      = "Target";                      
 $detector{"description"} = "Cylinder of Target Detector";  
 $detector{"pos"}         = "0*cm 0*cm 0*cm";             
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";          
 $detector{"color"}       = "bb3399";                     
 $detector{"type"}        = "Tube";                       
 $detector{"dimensions"}  = "0.0*mm 30.00*mm 300*mm 0*deg 360*deg";  
 $detector{"material"}    = "Scintillator";
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


make_Target();
make_Cylinder();
