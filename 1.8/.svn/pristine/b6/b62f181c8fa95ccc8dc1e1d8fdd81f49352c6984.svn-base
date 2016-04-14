#!/usr/bin/perl -w
#
# The LTCC sector 1 is a box centered at 0,0 
# the sides are planes that are cut out from the main box

#use strict;
use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);
use Getopt::Long;
use Math::Trig;

# local quantities.

my $envelope = 'LTCC';
my $file     = 'LTCC.txt'; 
my $rmin = 1;
my $rmax = 1000000;


my $inches = 25.4;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


my $sector_cut_angle = 30;
my $cc_angle         = 25;
my $cc_zpos          = 170 - 500; # 500 if placed into sector

sub build_mother()
{

	# generate  mother volume box - it's 6m along 
	# z axis to contain all mirrors 
	$detector{"name"}        = "ltcc_first_box";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Light Threshold Cerenkov Counter Box at the origin";
	$detector{"pos"}         = "0*mm 0*mm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "2*m 5*m 6*m";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);



	# Cutting off the left/right sides that define the sector
	my $box_dimension = 2000;
  my $additional_shift = 4;  # to be far from the coils
  my $xshift = $box_dimension/cos($sector_cut_angle*$pi/180.0) - $additional_shift;
  
  $detector{"name"}        = "sector_left_cut";
	$detector{"mother"}      = "root";
	$detector{"description"} = "LTCC Left Cut";
	$detector{"pos"}         = "$xshift*cm 0*mm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg $sector_cut_angle*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$box_dimension*cm $box_dimension*cm $box_dimension*cm";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
  
  $detector{"name"}        = "sector_right_cut";
	$detector{"mother"}      = "root";
	$detector{"description"} = "LTCC Left Cut";
	$detector{"pos"}         = "-$xshift*cm 0*mm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg -$sector_cut_angle*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$box_dimension*cm $box_dimension*cm $box_dimension*cm";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
  
  
  # Subtracting left box
  $detector{"name"}        = "sector_box_left_cut";
	$detector{"mother"}      = "root";
	$detector{"description"} = "LTCC After Left Cut";
	$detector{"pos"}         = "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Operation: ltcc_first_box - sector_left_cut";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
 
  # Subtracting right box
  $detector{"name"}        = "sector_box_right_cut";
	$detector{"mother"}      = "root";
	$detector{"description"} = "LTCC After Right Cut";
	$detector{"pos"}         = "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Operation: sector_box_left_cut - sector_right_cut";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
  
  
  
  
 	# Cutting off the back window 
  # WARNING: For now, by EYES by looking at the mirrors and OTOF
  my $zshift = 2740;
  
  $detector{"name"}        = "sector_box_back_cut";
	$detector{"mother"}      = "root";
	$detector{"description"} = "LTCC Left Cut";
	$detector{"pos"}         = "0*cm 0*cm $zshift*cm";
	$detector{"rotation"}    = "$cc_angle*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$box_dimension*cm $box_dimension*cm $box_dimension*cm";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
 
 
 	$zshift = -1830;
  $detector{"name"}        = "sector_box_front_cut";
	$detector{"mother"}      = "root";
	$detector{"description"} = "LTCC Left Cut";
	$detector{"pos"}         = "0*cm 0*cm $zshift*cm";
	$detector{"rotation"}    = "$cc_angle*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$box_dimension*cm $box_dimension*cm $box_dimension*cm";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
  
  
  
  
  # Subtracting back box
  $detector{"name"}        = "sector_back_cut";
	$detector{"mother"}      = "root";
	$detector{"description"} = "LTCC After Backplane Cut";
	$detector{"pos"}         = "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Operation: sector_box_right_cut - sector_box_back_cut";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
  
  # Subtracting front box
  $detector{"name"}        = "sector_front_cut";
	$detector{"mother"}      = "root";
	$detector{"description"} = "LTCC After Backplane Cut";
	$detector{"pos"}         = "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Operation: sector_back_cut - sector_box_front_cut";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
  
  
  # Top box
  my $top_angle = 20;
  my $yshift    = 2400;
  $detector{"name"}        = "sector_box_top_cut";
	$detector{"mother"}      = "root";
	$detector{"description"} = "LTCC Top Cut";
	$detector{"pos"}         = "0*cm $yshift*cm 0*cm";
	$detector{"rotation"}    = "$cc_angle*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$box_dimension*cm $box_dimension*cm $box_dimension*cm";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);

  # Subtracting top box
  $detector{"name"}        = "sector_top_cut";
	$detector{"mother"}      = "root";
	$detector{"description"} = "LTCC After Top Cut";
	$detector{"pos"}         = "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 00*deg 0*deg"; 
	$detector{"color"}       = "1100884";
	$detector{"type"}        = "Operation: sector_front_cut - sector_box_top_cut";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
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
  
  
  
  # Bottom Box
  my $bottom_angle = 20;
  $yshift = -$box_dimension + 10;
  $detector{"name"}        = "sector_box_bottom_cut";
	$detector{"mother"}      = "root";
	$detector{"description"} = "LTCC Bottom Cut";
	$detector{"pos"}         = "0*cm $yshift*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$box_dimension*cm $box_dimension*cm $box_dimension*cm";
	$detector{"material"}    = "CCGas";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
  
  # Subtracting top box
  $detector{"name"}        = "LTCC";
	$detector{"mother"}      = "root";
	$detector{"mother"}      = "sector";
	$detector{"description"} = "LTCC After Bottom Cut";
	$detector{"pos"}         = "0*cm 0*cm $cc_zpos*cm";
	$detector{"rotation"}    = "0*deg 00*deg 0*deg"; 
	$detector{"color"}       = "1100884";
	$detector{"type"}        = "Operation: sector_top_cut - sector_box_bottom_cut";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "CCGas";
	#$detector{"material"}    = "Component";
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

build_mother();




