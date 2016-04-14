#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'flux_dets2';
my $file     = 'flux_dets2.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my $inches = 2.54;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;


my $MagnetSep   = 85.87*$inches;       # Magnets separation 
my $id_z_width  = 30.48;               # ID semi-width
my $ps_dipole_z = 36.00*$inches/2.0;   # PS semi-width

my $new_z_start = -30.02*$inches + $ps_dipole_z;      # Add this to put flux dets on drawing 
                                       # locations indicated by Stepan
																			 # This is entrance of PS vacuum box

# Flux Detectors
sub make_flux_dets()
{
	# 40: Upstream Entrance of the PS vac. box 
	my $flux_zpos = -40.57*$inches + 30.02*$inches + $new_z_start ;
	$detector{"name"}        = "flux_box_40";
	$detector{"mother"}      = "ps_field";
	$detector{"description"} = "Flux Box At entrance of PS Vac. Box";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "16*cm 8*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 40";
	print_det(\%detector, $file);   
	
	# 100: Downstream Entrance of the PS vac. box 
	$flux_zpos = $new_z_start ;
	$detector{"name"}        = "flux_box_100";
	$detector{"mother"}      = "ps_field";
	$detector{"description"} = "Flux Box At entrance of PS Vac. Box";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "16*cm 8*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 100";
	print_det(\%detector, $file);   
	
	
	# 170: At the PS center
	$flux_zpos = 30.02*$inches + $new_z_start ;
	$detector{"name"}        = "flux_box_170";
	$detector{"mother"}      = "ps_field";
	$detector{"description"} = "Flux Box At PS Center";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "16*cm 8*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 170";
	print_det(\%detector, $file);   
	
	
	# 200: At the Vacuum Box Exit
	$flux_zpos = 33.91*$inches + 30.02*$inches + $new_z_start ;
	$detector{"name"}        = "flux_box_200";
	$detector{"mother"}      = "ps_field";
	$detector{"description"} = "Flux Box At Vacuum Box Exit";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "16*cm 8*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 200";
	print_det(\%detector, $file);   
	
	
	# 300: At the First Flange
	$flux_zpos = 51.23*$inches + 30.02*$inches + $new_z_start ;
	$detector{"name"}        = "flux_box_300";
	$detector{"mother"}      = "ps_field";
	$detector{"description"} = "Flux Box At At the First Flange";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "16*cm 8*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 300";
	print_det(\%detector, $file);   
	
	
	# 400: At the Second Flange
	$flux_zpos = 68.27*$inches + 30.02*$inches + $new_z_start ;
	$detector{"name"}        = "flux_box_400";
	$detector{"mother"}      = "ps_field";
	$detector{"description"} = "Flux Box At Second Flange";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "16*cm 8*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 400";
	print_det(\%detector, $file);   
	
	
	# 500: At the center of second magnet
	$flux_zpos = 103.47*$inches + 30.02*$inches + $new_z_start - 5 ;
	$detector{"name"}        = "flux_box_500";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Flux Box At PS Exit";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "26*cm 8*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 500";
	print_det(\%detector, $file);   
	
	
	
	
}

make_flux_dets();




