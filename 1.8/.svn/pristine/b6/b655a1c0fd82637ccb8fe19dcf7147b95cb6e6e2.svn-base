#!/usr/bin/perl -w


use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

use geo qw($pi);


my $envelope = 'ft_shield';
my $file     = 'ft_shielding_25.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();          # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


use Getopt::Long;
use Math::Trig;


# all dimensions in mm


# HTCC Moller Cup and Vacuum inside it
my $z0_cup    = 25.;
my $theta_cup = 5.*acos(-1.)/180.;
my $tantheta  = (int tan($theta_cup)*10000.)/10000;
my $nplanes_cup = 3;
my @zplane_cup   = (                           380.0   ,                          1380.0   ,                           1795.0  );
my @oradius_cup  = ( ($zplane_cup[0]-$z0_cup)*$tantheta, ($zplane_cup[1]-$z0_cup)*$tantheta, ($zplane_cup[1]-$z0_cup)*$tantheta);
my @iradius_cup  = (      $oradius_cup[0]-1.0          ,                $oradius_cup[1]-1.0,                $oradius_cup[2]-1.0);


# Tungsten and Aluminum Cones and Vacuum Inside
my $nplanes_cone = 2;
my @zplane_cone   = (  750.0, 1795.0);
my @oradius_cone  = (   32.0,   78.0);
my @mradius_cone  = (   31.0,   40.0); 
my @iradius_cone  = (   30.0,   30.0); 


sub make_first_shield
{

#############################
# Carbon Fiber Moller Cup
#############################
 $detector{"name"}        = $envelope;
 $detector{"mother"}      = "root";
 $detector{"description"} = "FT Moeller Cup";
 $detector{"pos"}         = "0*mm 0.0*mm 0.0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "575757";
 $detector{"type"}        = "Polycone";

 my $dimen = "0.0*deg 360*deg $nplanes_cup";
 for(my $i = 0; $i <$nplanes_cup ; $i++)
{
    $dimen = $dimen ." 0.0*mm";
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
# Vacuum Inside Moller Cup
#############################
 $detector{"name"}        = "ft_mcup_vacuum";
 $detector{"mother"}      = "ft_shield";
 $detector{"description"} = "FT Moeller Cup Vacuum";
 $detector{"pos"}         = "0*mm 0.0*mm 0.0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "E0FFFF";
 $detector{"type"}        = "Polycone";

$dimen = "0.0*deg 360*deg $nplanes_cup";
 for(my $i = 0; $i <$nplanes_cup ; $i++)
{
    $dimen = $dimen ." 0.0*mm";
}
 for(my $i = 0; $i <$nplanes_cup; $i++)
{
    $dimen = $dimen ." $iradius_cup[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_cup ; $i++)
{
    $dimen = $dimen ." $zplane_cup[$i]*mm";
}
 $detector{"dimensions"} = $dimen;
 $detector{"material"}   = "Vacuum";
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
 $detector{"name"}        = "ft_w_cone";
 $detector{"mother"}      = "ft_mcup_vacuum";
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
# Aluminum Cone
#############################
 $detector{"name"}        = "ft_al_cone";
 $detector{"mother"}      = "ft_w_cone";
 $detector{"description"} = "FT Tungsten Cone";
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
    $dimen = $dimen ." $mradius_cone[$i]*mm";
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
# print_det(\%detector, $file);



#############################
# Vacuum inside the cone
#############################
 $detector{"name"}        = "ft_cone_vacuum";
 $detector{"mother"}      = "ft_w_cone";
 $detector{"description"} = "FT Tungsten Cone Vacuum";
 $detector{"pos"}         = "0*cm 0.0*cm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "E0FFFF";
 $detector{"type"}        = "Polycone";
 $dimen = "0.0*deg 360*deg $nplanes_cone";
 for(my $i = 0; $i <$nplanes_cone ; $i++) 
 {
    $dimen = $dimen ." 0.0*mm";
 }
 for(my $i = 0; $i <$nplanes_cone ; $i++) 
 {
    $dimen = $dimen ." $iradius_cone[$i]*mm";
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
# print_det(\%detector, $file);
}


make_first_shield();





