#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'beamline_shield';
my $file     = 'beamline_shield.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my $inches = 2.54;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

# Init non used vars
# None of these components are sensitive.
$detector{"mfield"}      = "no";
$detector{"ncopy"}       = 1;
$detector{"pMany"}       = 1;
$detector{"exist"}       = 1;
$detector{"visible"}     = 1;
$detector{"style"}       = 1;
$detector{"sensitivity"} = "no";
$detector{"hit_type"}    = "";
$detector{"identifiers"} = "";



sub make_shields()
{
	my $s1_x  = 10;  # 
	my $s1_y  = 10;  # 
	my $s1_z  = 20;  # 
  my $xpos = -14.5;
  my $zpos1 = 328.2;

	# SHIELD1: simple brick right after flange 
	$detector{"name"}        = "hps_shield1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Shield 1 at flange";
	$detector{"pos"}         = "$xpos*cm 0.0*cm $zpos1*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "5577aa";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$s1_x*cm $s1_y*cm $s1_z*cm";
	$detector{"material"}    = "G4_Pb";
	print_det(\%detector, $file);	


  my $sh_x = 20;
  my $sh_y = 20;
  my $sh_z = 40;
  my $electron_hole_OR = 2.5*$inches/2.0 + 0.5;
 
  
  # SHIELD2: Shielding around the electron pipe right after flange
	$detector{"name"}        = "a_shield_frame";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Shield around the electron end pipe";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "557788";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$sh_x*cm $sh_y*cm $sh_z*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
  
	
	# SHIELD2 Electrons Hole
  my $hole_x  = $sh_z + 1;
  my $shift_x = 10;
	$detector{"name"}        = "a_shield_frame_hole";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Hole for Electron pipe";
	$detector{"pos"}         = "$shift_x*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "557788";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "0*cm $electron_hole_OR*cm $hole_x*cm 0*deg 360*deg";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
  # SHIELD2
  my $zpos2 = 348.2;
 	# Frame - Electrons Hole
	$detector{"name"}        = "hps_shield2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Shield Frame - Electron Hole";
	$detector{"pos"}         = "-$shift_x*cm 0.0*cm $zpos2*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "557788";
	$detector{"type"}        = "Operation: a_shield_frame - a_shield_frame_hole";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "G4_Pb";
	print_det(\%detector, $file);	
 
 
  # SHIELD3 is copy of SHIELD2 placed downstream
  my $zpos3 = 800;
	$detector{"name"}        = "hps_shield3";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Shield Frame - Electron Hole";
	$detector{"pos"}         = "-$shift_x*cm 0.0*cm $zpos3*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "557788";
	$detector{"type"}        = "CopyOf hps_shield2";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "G4_Pb";
	print_det(\%detector, $file);	
  
  
  
  # SHIELD4 is Concrete wall 
	# Trying widths of: 10, 20, 30, 40, 50 cm
  my $cr_x = 200;
  my $cr_y = 200;
  my $pipes_hole_OR = 40;
  my $cw_posz = 600;


  my @cr_z = (5, 10, 15, 20, 25);

  
	for(my $w = 1; $w < 6 ; $w++)
	{

		my $width = $cr_z[$w-1];
	
		# Concrete wall frame
		$detector{"name"}        = "a_cw_shield_frame$w";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Concrete wall around the electron end pipe";
		$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
		$detector{"color"}       = "557788";
		$detector{"type"}        = "Box";
		$detector{"dimensions"}  = "$cr_x*cm $cr_y*cm $width*cm";
		$detector{"material"}    = "Component";
		print_det(\%detector, $file);	
	
		# concrete wall hole for electron
		$hole_x  = $cr_z[$w-1] + 1;
		$detector{"name"}        = "b_cw_shield_hole$w";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Concrete wall Hole for Electron pipe";
		$detector{"pos"}         = "$shift_x*cm 0.0*cm 0*cm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
		$detector{"color"}       = "557788";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "0*cm $electron_hole_OR*cm $hole_x*cm 0*deg 360*deg";
		$detector{"material"}    = "Component";
		print_det(\%detector, $file);	
	
		# Frame - electron hole
		$detector{"name"}        = "c_cw_shield_shield4$w";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Concrete Shield Frame - Electron Hole";
		$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
		$detector{"color"}       = "557788";
		$detector{"type"}        = "Operation: a_cw_shield_frame$w - b_cw_shield_hole$w";
		$detector{"dimensions"}  = "0";
		$detector{"material"}    = "Component";
		print_det(\%detector, $file);	

		# concrete wall hole for photons
		my $gamma_hole_X     = 35 ;
		my $gamma_hole_OS    = 5*$inches/2.0;
		$detector{"name"}        = "b_cw_shield_hole2$w";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Hole for Photons";
		$detector{"pos"}         = "$gamma_hole_X*cm 0.0*cm 0*cm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
		$detector{"color"}       = "557788";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "0*cm $gamma_hole_OS*cm $hole_x*cm 0*deg 360*deg";
		$detector{"material"}    = "Component";
		print_det(\%detector, $file);	
  
		# Frame - Electrons Hole - Photons Hole
		$detector{"name"}        = "hps_cshield4$w";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Concrete Shield Frame - photon Hole";
		$detector{"pos"}         = "-$shift_x*cm 0.0*cm $cw_posz*cm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
		$detector{"color"}       = "557788";
		$detector{"type"}        = "Operation: c_cw_shield_shield4$w - b_cw_shield_hole2$w";
		$detector{"dimensions"}  = "0";
		$detector{"material"}    = "G4_CONCRETE";
		print_det(\%detector, $file);	

	
	
	}
	
	
	
  
  




}


make_shields();




















