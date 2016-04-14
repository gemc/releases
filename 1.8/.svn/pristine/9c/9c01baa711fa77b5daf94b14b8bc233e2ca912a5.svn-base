#!/usr/bin/perl -w
use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'hd_ice_magnet_n60';
my $file     = 'hd_ice_magnet_n60.txt';

my $rmin = 1;
my $rmax = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;
# natural constants
# all dimensions in mm, deg

# Need to reorganize/add air_coils here


my $inner_r1 = 37.5;
my $outer_r1 = 40.5;
my $length1  = 400/2;
my $zpos1    = -100;  # empirical 

sub make_tube_n60
{
  $detector{"name"}        = "nmr";
  $detector{"mother"}      = "root";
  $detector{"description"} = "NMR small magnet";
  $detector{"pos"}         = "0*cm 0*cm $zpos1*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "1122dd";
  $detector{"type"}        = "Tube";
  $detector{"dimensions"}  = "$inner_r*mm $outer_r*mm $length*mm 0*deg 360*deg";
  $detector{"material"}    = "G4_Fe";
  $detector{"mfield"}      = "no";
  $detector{"ncopy"}       = "1";
  $detector{"pMany"}       = 1;
  $detector{"exist"}       = 1;
  $detector{"visible"}     = 1;
  $detector{"style"}       = 1;
  $detector{"sensitivity"} = "no";
  $detector{"hit_type"}    = "";
  $detector{"identifiers"} = "";
  print_det(\%detector, $file);	 
}

make_tube();




my $inner_r2 = 130;
my $outer_r2 = 155;
my $length2  = 300/2;
my $zpos2    = -100;  # empirical 

sub make_tube
{
  $detector{"name"}        = "solenoid";
  $detector{"mother"}      = "root";
  $detector{"description"} = "HD Ice Transverse Magnet Coils - N60 configuration";
  $detector{"pos"}         = "0*cm 0*cm 0*mm";
  $detector{"rotation"}    = "0*deg 0*deg $zpos2*deg";
  $detector{"color"}       = "1122dd";
  $detector{"type"}        = "Tube";
  $detector{"dimensions"}  = "$inner_r*mm $outer_r*mm $length*mm 0*deg 360*deg";
  $detector{"material"}    = "G4_Fe";
  $detector{"mfield"}      = "no";
  $detector{"ncopy"}       = "1";
  $detector{"pMany"}       = 1;
  $detector{"exist"}       = 1;
  $detector{"visible"}     = 1;
  $detector{"style"}       = 1;
  $detector{"sensitivity"} = "no";
  $detector{"hit_type"}    = "";
  $detector{"identifiers"} = "";
  print_det(\%detector, $file);	 
}

make_tube();




