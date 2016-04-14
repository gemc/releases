#!/usr/bin/perl -w


use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

use geo qw($pi);


my $envelope = 'noft_shielding_raster';
my $file     = 'noft_shielding_raster.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();          # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


use Getopt::Long;
use Math::Trig;


# all dimensions in mm
my $torus_z    = 2663.;


###########################################################################################
# Define the tube between Calorimeter and Torus Inner Ring

my $ATube_IR         =  30.0;
my $ATube_OR         =  41.0;
my $TTube_OR         =  60.0;
my $FTube_OR         =  80.0;
my $FTube_FR         =  90.0;

my $Tube_LT         = 365.6;
my $flange_TN       =  15.0;

# define positions based on z of torus inner ring front face
my $Tube_end  = $torus_z-0.5;    # leave 0.5 mm to avoid overlaps
my $Tube_z1   = $Tube_end - $flange_TN;
my $Tube_z2   = $Tube_z1 - $Tube_LT;
my $Tube_beg  = $Tube_z2 - $flange_TN;
my $Tube_Z    =($Tube_end+$Tube_beg)/2.;
my $Tube_LZ   =($Tube_end-$Tube_beg)/2.;

my $nplanes_Tube = 6;
my @z_plane_Tube = ( $Tube_beg,  $Tube_z2,  $Tube_z2,  $Tube_z1,  $Tube_z1, $Tube_end);
my @oradius_Tube = ( $FTube_FR, $FTube_FR, $FTube_OR, $FTube_OR, $FTube_FR, $FTube_FR);

sub make_Cone_2_Torus_Tube
{
#####################################
# Stainless Steel Tube with Flanges
#####################################
 $detector{"name"}        = "Cone_2_Torus_Tube_F";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Flanged Tube from Cone to Torus";
 $detector{"pos"}         = "0.0*cm 0.0*cm 0.0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff8883";
 $detector{"type"}        = "Polycone";
 my $dimen = "0.0*deg 360*deg $nplanes_Tube";
 for(my $i = 0; $i <$nplanes_Tube ; $i++)
{
    $dimen = $dimen ." 0.0*mm";
}
 for(my $i = 0; $i <$nplanes_Tube ; $i++)
{
    $dimen = $dimen ." $oradius_Tube[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_Tube ; $i++)
{
    $dimen = $dimen ." $z_plane_Tube[$i]*mm";
}
 $detector{"dimensions"}  = $dimen;
 $detector{"material"}    = "StainlessSteel";
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


#####################################
# Tungsten Tube 
#####################################
 $detector{"name"}        = "Cone_2_Torus_Tube_T";
 $detector{"mother"}      = "Cone_2_Torus_Tube_F";
 $detector{"description"} = "Tungsten Tube from Cone to Torus";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Tube_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffff9b";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0.0*mm $TTube_OR*mm $Tube_LZ*mm 0.*deg 360.*deg";
 $detector{"material"}    = "Tungsten";
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


#####################################
# Aluminum Tube 
#####################################
 $detector{"name"}        = "Cone_2_Torus_Tube_A";
 $detector{"mother"}      = "Cone_2_Torus_Tube_T";
 $detector{"description"} = "Aluminum Tube from Cone to Torus";
 $detector{"pos"}         = "0.0*cm 0.0*cm 0.0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0.0*mm $ATube_OR*mm $Tube_LZ*mm 0.*deg 360.*deg";
 $detector{"material"}    = "Aluminum";
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


#####################################
# Vacuum Tube 
#####################################
 $detector{"name"}        = "Cone_2_Torus_Tube_V";
 $detector{"mother"}      = "Cone_2_Torus_Tube_A";
 $detector{"description"} = "Vacuum Tube from Cone to Torus";
 $detector{"pos"}         = "0.0*cm 0.0*cm 0.0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "aaffff";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0.*mm $ATube_IR*mm $Tube_LZ*mm 0.*deg 360.*deg";
 $detector{"material"}    = "Vacuum";
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





# Tungsten Cone and Vacuum Inside
my $oz_cone = 122.4;
my $otheta_cone = 2.*acos(-1.)/180.;
my $otantheta  = (int tan($otheta_cone)*10000.)/10000;
#my $iz_cone = 18.2;
my $iz_cone = 18.2-500.;
my $itheta_cone = 0.75*acos(-1.)/180.;
my $itantheta  = (int tan($itheta_cone)*10000.)/10000;

my $nplanes_cone = 3;
my @zplane_cone     = ( 420.0,    1390.0, $Tube_beg-0.1 );
my @oradius_cone_T  = (  30.0, $FTube_FR,      $FTube_FR);
my @oradius_cone_A  = (  24.0, $ATube_OR,      $ATube_OR);
my @oradius_cone_V  = (  23.0, $ATube_IR,      $ATube_IR); 


sub make_first_shield
{

#############################
# Tungsten Cone
#############################
 $detector{"name"}        = "W_cone";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Tungsten Cone";
 $detector{"pos"}         = "0*mm 0.0*mm 0.0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffff9b";
 $detector{"type"}        = "Polycone";

my $dimen = "0.0*deg 360*deg $nplanes_cone";
 for(my $i = 0; $i <$nplanes_cone ; $i++)
 {
    $dimen = $dimen ." 0.0*mm";
 }
 for(my $i = 0; $i <$nplanes_cone ; $i++)
 {
    $dimen = $dimen ." $oradius_cone_T[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes_cone ; $i++)
 {
    $dimen = $dimen ." $zplane_cone[$i]*mm";
 }
 $detector{"dimensions"} = $dimen;
 $detector{"material"}   = "Tungsten";
 $detector{"mfield"}     = "no";
 $detector{"ncopy"}      = "1";
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";

 print_det(\%detector, $file);

#############################
# Aluminum Cone
#############################
 $detector{"name"}        = "Al_cone";
 $detector{"mother"}      = "W_cone";
 $detector{"description"} = "Aluminum Cone";
 $detector{"pos"}         = "0*mm 0.0*mm 0.0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Polycone";

 $dimen = "0.0*deg 360*deg $nplanes_cone";
 for(my $i = 0; $i <$nplanes_cone ; $i++)
 {
    $dimen = $dimen ." 0.0*mm";
 }
 for(my $i = 0; $i <$nplanes_cone ; $i++)
 {
    $dimen = $dimen ." $oradius_cone_A[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes_cone ; $i++)
 {
    $dimen = $dimen ." $zplane_cone[$i]*mm";
 }
 $detector{"dimensions"} = $dimen;
 $detector{"material"}   = "Aluminum";
 $detector{"mfield"}     = "no";
 $detector{"ncopy"}      = "1";
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";

 print_det(\%detector, $file);

#############################
# Vacuum inside the cone
#############################

 $detector{"name"}        = "cone_vacuum";
 $detector{"mother"}      = "Al_cone";
 $detector{"description"} = "Tungsten Cone Vacuum";
 $detector{"pos"}         = "0*cm 0.0*cm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "aaffff";
 $detector{"type"}        = "Polycone";

 $dimen = "0.0*deg 360*deg $nplanes_cone";
 for(my $i = 0; $i <$nplanes_cone ; $i++) 
 {
    $dimen = $dimen ." 0.0*mm";
 }
 for(my $i = 0; $i <$nplanes_cone ; $i++) 
 {
    $dimen = $dimen ." $oradius_cone_V[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes_cone ; $i++) 
 {
    $dimen = $dimen ." $zplane_cone[$i]*mm";
 }

 $detector{"dimensions"} = $dimen;
 $detector{"material"}    = "Vacuum";
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

make_Cone_2_Torus_Tube;
make_first_shield();





