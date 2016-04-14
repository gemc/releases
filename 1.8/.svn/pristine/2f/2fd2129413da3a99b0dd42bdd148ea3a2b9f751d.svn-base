#!/usr/bin/perl -w


use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

use geo qw($pi);


my $envelope = 'FT_shield';
my $file     = 'ft_shielding.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();          # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


use Getopt::Long;
use Math::Trig;


# all dimensions in mm

# Tungsten Cone
my $nplanes_cone = 4;
#my @zplane_cone   = (  750.0, 1754.0, 1754.0, 1809.2);
my @zplane_cone   = (  750.0, 1750.0, 1750.0, 1809.2);
my @oradius_cone  = (   32.0,   76.0,   59.0,   59.0);
my @mradius_cone  = (   31.0,   40.0,   40.0,   40.0); 
my @iradius_cone  = (   30.0,   30.0,   30.0,   30.0); 

# Aluminum Beam Pipe
my $al_tube_TN=1.0;
my $al_tube_IR=27.;
my $al_tube_OR=$al_tube_IR+$al_tube_TN;
my $al_tube_LT=($zplane_cone[3]-($zplane_cone[0]+300.))/2.;
my $al_tube_Z =($zplane_cone[3]+($zplane_cone[0]+300.))/2.;

# Aluminum Beam Pipe Window
my $al_window_TN=0.05;
my $al_window_OR=$al_tube_OR;
my $al_window_Z =$al_tube_Z-$al_tube_LT-$al_window_TN;

# HTCC Moller Cup 
my $nplanes_cup = 4;
my @zplane_cup   = (350.0, 1318.4, 1415.2, 1724.1);
my @oradius_cup  = ( 30.0,  114.8,  114.8,  139.0);
my @iradius_cup  = ( 29.0,  113.8,  113.8,  138.0);


# Mother Volume
my $nplanes_mv = 7;
my @zplane_mv   = ( $zplane_cup[0],  $zplane_cup[1],  $zplane_cup[2],  $zplane_cup[3], $zplane_cone[1], $zplane_cone[2], $zplane_cone[3]);
my @oradius_mv  = ($oradius_cup[0], $oradius_cup[1], $oradius_cup[2], $oradius_cup[3], $oradius_cup[3],$oradius_cone[2],$oradius_cone[2]);
my @iradius_mv  = (            0.0,             0.0,             0.0,             0.0,             0.0,             0.0,             0.0);


sub make_first_shield
{

#############################
# Mother Volume
#############################
 $detector{"name"}        = $envelope;
 $detector{"mother"}      = "root";
 $detector{"description"} = "FT Shield Mother Volume";
 $detector{"pos"}         = "0*mm 0.0*mm 0.0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff8000";
 $detector{"type"}        = "Polycone";

 my $dimen = "0.0*deg 360*deg $nplanes_mv";
 for(my $i = 0; $i <$nplanes_mv ; $i++)
{
    $dimen = $dimen ." $iradius_mv[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_mv ; $i++)
{
    $dimen = $dimen ." $oradius_mv[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_mv ; $i++)
{
    $dimen = $dimen ." $zplane_mv[$i]*mm";
}
 $detector{"dimensions"} = $dimen;
 $detector{"material"}   = "Vacuum";
 $detector{"mfield"}     = "no";
 $detector{"ncopy"}      = "1";
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 0;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
 print_det(\%detector, $file);


#############################
# Carbon Fiber Moller Cup
#############################
 $detector{"name"}        = "HTCC_Moeller_Cup";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "HTCC Moeller Cup";
 $detector{"pos"}         = "0*mm 0.0*mm 0.0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "575757";
 $detector{"type"}        = "Polycone";

 my $dimen = "0.0*deg 360*deg $nplanes_cup";
 for(my $i = 0; $i <$nplanes_cup ; $i++)
{
    $dimen = $dimen ." $iradius_cup[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_cup ; $i++)
{
    $dimen = $dimen ." $oradius_cup[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_cup ; $i++)
{
    $dimen = $dimen ." $zplane_cup[$i]*mm";
}
 $detector{"dimensions"} = $dimen;
 $detector{"material"}   = "CarbonFiber";
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
# Tungsten Cone
#############################
 $detector{"name"}        = "FT_w_cone";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Tungsten Cone";
 $detector{"pos"}         = "0*mm 0.0*mm 0.0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "F88017";
 $detector{"type"}        = "Polycone";
 $dimen = "0.0*deg 360*deg $nplanes_cone";
 for(my $i = 0; $i <$nplanes_cone ; $i++)
 {
    $dimen = $dimen ." $iradius_cone[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes_cone ; $i++)
 {
    $dimen = $dimen ." $oradius_cone[$i]*mm";
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
# Aluminum Tube
#############################
 $detector{"name"}        = "FT_al_tube";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Aluminum Beam Pipe";
 $detector{"pos"}         = "0*mm 0.0*mm $al_tube_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "F2F2F2";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$al_tube_IR*mm $al_tube_OR*mm $al_tube_LT*mm 0.*deg 360.*deg";
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
# Aluminum Window
#############################
 $detector{"name"}        = "FT_al_window";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Aluminum Beam Pipe Window";
 $detector{"pos"}         = "0*mm 0.0*mm $al_window_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "F2F2F2";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0.0*mm $al_window_OR*mm $al_window_TN*mm 0.*deg 360.*deg";
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
 $detector{"name"}        = "FT_albpipe_vacuum";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Aluminum Beam Pipe Vacuum";
 $detector{"pos"}         = "0*mm 0.0*mm $al_tube_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0.0*mm $al_tube_IR*mm $al_tube_LT*mm 0.*deg 360.*deg";
 $detector{"material"}    = "Vacuum";
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


make_first_shield();





