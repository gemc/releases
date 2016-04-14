#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'flux_dets';
my $file     = 'flux_dets.txt';

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



# Flux Detectors
sub make_flux_dets()
{
	# 100: Entrance of the PS vac. box 
	$detector{"name"}        = "flux_box_100";
	$detector{"mother"}      = "ps_field";
	$detector{"description"} = "Flux Box At entrance of PS Vac. Box";
	$detector{"pos"}         = "0*cm 0.0*cm -12*inches";
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
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 100";
	#print_det(\%detector, $file);   
	
	
	# 170: At the last Silicon Layer location
	$detector{"name"}        = "flux_box_170";
	$detector{"mother"}      = "ps_field";
	$detector{"description"} = "Flux Box At Last Silicon Layer Location";
	$detector{"pos"}         = "0*cm 0.0*cm 70*cm";
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
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 170";
	#print_det(\%detector, $file);   
	
	
	my $id_gap_x_width  = 22.225;  # 27.7' - 10' 
	my $id_gap_y_width  =  4.0;
	my $id_fgap_x_width = $id_gap_x_width - 0.2;
	my $id_fgap_y_width = $id_gap_y_width - 0.2;
	# 200: At the last Silicon Layer location
	my $flux_zpos = - $id_z_width ;
	$detector{"name"}        = "flux_box_entrance_2d";
	$detector{"mother"}      = "id_field2";
	$detector{"description"} = "Flux Box At Entrance of second italian dipole";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$id_fgap_x_width*cm $id_fgap_y_width*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 200";
	#print_det(\%detector, $file);   
	
	# 210: Flux Box At Entrance of second italian dipole
	$flux_zpos = $id_z_width;
	$detector{"name"}        = "flux_box_exit_2d";
	$detector{"mother"}      = "id_field2";
	$detector{"description"} = "Flux Box At Entrance of second italian dipole";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$id_fgap_x_width*cm $id_fgap_y_width*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 210";
	#print_det(\%detector, $file);   
	
	
	# 210: Flux Box At Exit of second italian dipole
	$flux_zpos = $id_z_width;
	$detector{"name"}        = "flux_box_exit_2d";
	$detector{"mother"}      = "id_field2";
	$detector{"description"} = "Flux Box At Exit of second italian dipole";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$id_fgap_x_width*cm $id_fgap_y_width*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 210";
	#print_det(\%detector, $file);   
	
	
	# 230: Flux Box At Exit of second italian dipole + 4'' of clearance due to the coils
	my $id_coils_thickness = 4.0*$inches;
	$flux_zpos = $ps_dipole_z + $id_z_width + $MagnetSep + $id_coils_thickness - 0.2;
	$detector{"name"}        = "flux_box_exit_2dflange";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Flux Box At Flange after second italian dipole";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$id_fgap_x_width*cm $id_fgap_y_width*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 220";
	#print_det(\%detector, $file);   
	
	
	# 300: Flux Box At end of 200'' faraday cup pipe
	my $faraday_vac_pipe_length = 200*$inches/2.0;
	my $flange_thickness        = 2.0/2.0;   # Semi-Width
	my $flange_zpos             = $ps_dipole_z + $id_z_width + $MagnetSep + $id_coils_thickness + $flange_thickness;
	$flux_zpos = $flange_zpos + 2*$faraday_vac_pipe_length + $flange_thickness + 2;
	$detector{"name"}        = "flux_box_faraday";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Flux Box At  At end of 200'' faraday cup pipe";
	$detector{"pos"}         = "0*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$id_fgap_x_width*cm $id_fgap_y_width*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 300";
	#print_det(\%detector, $file);   
	
	# 310: Flux Box At end of 150'' helium bag
	my $gamma_hole_X         = 15.7;
	my $helium_bag_length    = 150*$inches/2.0;
	my $photon_absorber_z    = 25;
	my $hb_zpos              = $flange_zpos + $helium_bag_length + $flange_thickness + 0.2;
	my $hb_angle             = 0.03;
	my $hb_xpos              = $gamma_hole_X + $helium_bag_length*sin($hb_angle);
	my $pa_xpos              = $gamma_hole_X + 2*($helium_bag_length+$photon_absorber_z)*sin($hb_angle);
	$flux_zpos               = $hb_zpos + $helium_bag_length  + 0.5;
	$detector{"name"}        = "flux_box_helium_bag";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Flux Box At  At end of 200'' faraday cup pipe";
	$detector{"pos"}         = "$pa_xpos*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg -$hb_angle*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$id_fgap_x_width*cm $id_fgap_y_width*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 310";
	#print_det(\%detector, $file);   
	
	
	# 400: Big Sphere enclosing everything
	$detector{"name"}        = "sphere_det";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Big Sphere Enclosing Everything";
	$detector{"pos"}         = "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "bbddbb";
	$detector{"type"}        = "Sphere";
	$detector{"dimensions"}  = "10*m 10.1*m 0*deg 360*deg 0*deg 180*deg";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 400";
	#print_det(\%detector, $file);   
	
	# 600: Flux Box Near the Electronic
	my $electronic_xpos       = 300;
	$flux_zpos               = 0;
	$detector{"name"}        = "flux_box_electronics";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Flux Box - Beam Left - Electronics";
	$detector{"pos"}         = "$electronic_xpos*cm 100.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 90*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "200*cm 200*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 600";
	print_det(\%detector, $file);   
	
	
	# 700: Flux Box inside the dipolemy
	my $electronic_xpos       = -20;
	$flux_zpos               = 50;
	$detector{"name"}        = "flux_box_dipole";
	$detector{"mother"}      = "ps_field";
	$detector{"description"} = "Flux Box, Beam Right, Inside Dipol";
	$detector{"pos"}         = "$electronic_xpos*cm 0.0*cm $flux_zpos*cm";
	$detector{"rotation"}    = "0*deg 90*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "100*cm 5*cm 1*mm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 700";
	print_det(\%detector, $file);   
	
	
	
}

make_flux_dets();




