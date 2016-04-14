#!/usr/bin/perl -w


use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

use geo qw($pi);


my $envelope = 'eic_beamline2';
my $file     = 'eic_beamline2.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();          # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


# Dimensions in cm

my $ir     = 4.0;                
my $or     = 5.0;                
my $length = 12000.0/2.0;             
my $zshift = 20;        

sub make_first_shield
{
  ######
  # Pipe
  ######
	my $zpos = -$length + $zshift;
  $detector{"name"}        = "eic_proton_pipe";
  $detector{"mother"}      = "root";
  $detector{"description"} = "EIC Proton pipe";
  $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "2299ff";
  $detector{"type"}        = "Tube";
  $detector{"dimensions"}  = "$ir*cm $or*cm $length*cm 0*deg 360*deg";
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
  
  
  
  ########################
  # Vacuum inside the pipe
  ########################
	my $irv = $ir-0.01;
  $detector{"name"}        = "eic_proton_pipev";
  $detector{"mother"}      = "root";
  $detector{"description"} = "EIC Proton pipe vacuum";
  $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "99ffff";
  $detector{"type"}        = "Tube";
  $detector{"dimensions"}  = "0*cm $irv*cm $length*cm 0*deg 360*deg";
  $detector{"material"}    = "vacuum_m3";
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



  ###############
  # FLUX detector 
  ###############
	my $zpos = -50;
	my $orf = $or+0.01;
  $detector{"name"}        = "eic_proton_flux";
  $detector{"mother"}      = "root";
  $detector{"description"} = "EIC Proton pipe flux";
  $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "2299ff";
  $detector{"type"}        = "Tube";
  $detector{"dimensions"}  = "$orf*cm 200*cm 0.1*cm 0*deg 360*deg";
  $detector{"material"}    = "vacuum_m9";
  $detector{"mfield"}      = "no";
  $detector{"ncopy"}       = "1";
  $detector{"pMany"}       = 1;
  $detector{"exist"}       = 1;
  $detector{"visible"}     = 1;
  $detector{"style"}       = 1;
  $detector{"sensitivity"} = "FLUX";
  $detector{"hit_type"}    = "FLUX";
  $detector{"identifiers"} = "flux manual 1";
  
  print_det(\%detector, $file);
  


}


make_first_shield();


