#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'hps_end_beamline';
my $file     = 'hps_end_beamline.txt';

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


# Beamline Overall Z Shift (To be added on the z position of the magnets and vacuum field boxes)

my $PSZShift    = 36.00*$inches/2.0 ;  # So that target (0,0,0) is at the beginning of the PS Dipole. This corresponds to 45.72 cm
my $MagnetSep   = 85.87*$inches;       # Magnets separation 
my $id_z_width  = 30.48;
my $ps_dipole_z = 36.00*$inches/2.0;

my $flange_thickness   = 2.0/2.0;   # Semi-Width
my $id_coils_thickness = 4.0*$inches;

my $electron_hole_IR = 2.0*$inches/2.0;
my $electron_hole_OR = 2.5*$inches/2.0;

my $gamma_hole_IS    = 2.0*$inches/2.0;
my $gamma_hole_OS    = 3.0*$inches/2.0;
my $gamma_hole_X     = 15.7;

my $faraday_vac_pipe_length = 200*$inches/2.0;

my $helium_bag_length       = 150*$inches/2.0;

my $photon_absorber_x = 15;   # Semi Widths
my $photon_absorber_y = 20;
my $photon_absorber_z = 25;

# Target at the end of beamline to check alignment
sub make_end_beamline()
{
	my $id_gap_x_width  = 22.225;  # 27.7' - 10' 
	my $id_gap_y_width  =  4.0;
	my $id_fgap_x_width = $id_gap_x_width ;
	my $id_fgap_y_width = $id_gap_y_width ;

	# Flange connecting the second italian dipole vacuum box
	$detector{"name"}        = "avac_flange_2id_frame";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Flange connecting the second italian dipole vacuum box";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "557788";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$id_fgap_x_width*cm $id_fgap_y_width*cm $flange_thickness*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	

	
	# Electrons Hole
	$flange_thickness += 0.1;
	$detector{"name"}        = "avac_flange_2id_ehole";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Hole for Electrons";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "557788";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "0*cm $electron_hole_IR*cm $flange_thickness*cm 0*deg 360*deg";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	
	# Photons Hole
	$flange_thickness += 0.1;
	$detector{"name"}        = "avac_flange_2id_ghole";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Hole for Photons";
	$detector{"pos"}         = "$gamma_hole_X*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "557788";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "0*cm $gamma_hole_IS*cm $flange_thickness*cm 0*deg 360*deg";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	
	
	# Frame - Electrons Hole
	$detector{"name"}        = "bvac_flange_2id_f1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Flange Frame - Electron Hole";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "557788";
	$detector{"type"}        = "Operation: avac_flange_2id_frame - avac_flange_2id_ehole";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	# Stainless Steel Flange at the exit of second ID 
	# Frame - Electrons Hole - Photons Hole
	my $flange_zpos = $ps_dipole_z + $id_z_width + $MagnetSep + $id_coils_thickness + $flange_thickness;
	$detector{"name"}        = "cvac_flange_2id_f1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Flange Frame - Electron Hole";
	$detector{"pos"}         = "0*cm 0.0*cm $flange_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "7788aa";
	$detector{"type"}        = "Operation: bvac_flange_2id_f1 - avac_flange_2id_ghole";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "StainlessSteel";
	#print_det(\%detector, $file);	
	
	
	
	# Vacuum Pipe to Faraday Cup
	my $pipe_zpos = $flange_zpos + $faraday_vac_pipe_length + $flange_thickness + 0.1;
	$detector{"name"}        = "faraday_vac_pipe";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Electron Pipe to Faraday Cup";
	$detector{"pos"}         = "0*cm 0.0*cm $pipe_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "bbbbcc";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$electron_hole_IR*cm $electron_hole_OR*cm $faraday_vac_pipe_length*cm 0*deg 360*deg";
	$detector{"material"}    = "StainlessSteel";
	#print_det(\%detector, $file);	
	
	# Kapton Window for Helium Bag
	my $kapton_thickness        = 0.01;
	$detector{"name"}        = "kapton_window";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Kapton Window";
	$detector{"pos"}         = "$gamma_hole_X*cm 0.0*cm $flange_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "0000002";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "0*cm $gamma_hole_IS*cm $kapton_thickness*cm 0*deg 360*deg";
	$detector{"material"}    = "Kapton";
	#print_det(\%detector, $file);	
	
	
	# Photon Helium Bag
	my $hb_zpos  = $flange_zpos + $helium_bag_length + $flange_thickness + 0.1;
	# my $hb_angle = atan($gamma_hole_X/$flange_zpos); # This gives 0.051317518 but it depends on the e- angle at target
	my $hb_angle = 0.03;
	my $hb_xpos  = $gamma_hole_X + $helium_bag_length*sin($hb_angle);
	$detector{"name"}        = "photons_helium_bag";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Electron Pipe to Faraday Cup";
	$detector{"pos"}         = "$hb_xpos*cm 0.0*cm $hb_zpos*cm";
	$detector{"rotation"}    = "0*deg -$hb_angle*rad 0*deg";
	$detector{"color"}       = "9944554";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "0*cm $gamma_hole_OS*cm $helium_bag_length*cm 0*deg 360*deg";
	$detector{"material"}    = "G4_He";
	#print_det(\%detector, $file);	
	

	# Photon Absorber is a cube of Tungsten
	my $pa_zpos  = $hb_zpos + $helium_bag_length + $photon_absorber_z + 1.5;
	my $pa_xpos  = $gamma_hole_X + 2*($helium_bag_length+$photon_absorber_z)*sin($hb_angle);
	$detector{"name"}        = "photon_absorber";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Photon Absorber";
	$detector{"pos"}         = "$pa_xpos*cm 0.0*cm $pa_zpos*cm";
	$detector{"rotation"}    = "0*deg -$hb_angle*rad 0*deg";
	$detector{"color"}       = "222230";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$photon_absorber_x*cm $photon_absorber_y*cm $photon_absorber_z*cm";
	$detector{"material"}    = "G4_W";
	#print_det(\%detector, $file);	
	




	# Second Frascati Magnet Vacuum Flange
	# All dimensions are inches
	# constructed with parallelepiped + box
	
	my $vft     = 1;      # Vacuum Flange thickness
	my $vshift  = 2.39;   # Flange shift
	
	
	my $dx = 3.00*$inches/2.0;
	my $dy = 17.38*$inches/2.0;
	my $dz = 100 + 18.97*$inches/2.0 - 2.50 - 2.00;
	my $ptheta  = 7.4;
	
	$detector{"name"}        = "second_fm_flange";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Second Frascati Magnet Vacuum Flange";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*rad 0*deg";
	$detector{"color"}       = "11ffff";
	$detector{"type"}        = "Parallelepiped";
	$detector{"dimensions"}  = "$dx*mm $dy*mm $dz*mm 0 $ptheta*deg 10";
	$detector{"material"}    = "Vacuum";
	print_det(\%detector, $file);	


	
}


make_end_beamline();




















