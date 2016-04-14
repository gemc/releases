#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'hps_beamline';
my $file     = 'hps_beamline.txt';
#my $envelope = 'hps_beamlines';
#my $file     = 'hps_beamlines.txt';
#my $envelope = 'hps_beamline_fast';
#my $file     = 'hps_beamline_fast.txt';

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

my $PSZShift   = 36.00*$inches/2.0 ;  # So that target (0,0,0) is at the beginning of the PS Dipole. This corresponds to 45.72 cm
my $MagnetSep  = 85.87*$inches;       # Magnets separation 

if($envelope eq "hps_beamlines")
{
	$MagnetSep  = 67.00*$inches;        # Magnets separation for short beamline
}


# Two different fields for the z-separation
my $field_map  = "";
if($envelope eq 'hps_beamlines')
{
	$field_map = "s";
}

##################
# Frascati Magnets
##################
sub make_frascati_magnet
{
  # Frascati Magnet Yoke
	my $id_x_width = 35.56; # These are semi-widths
	my $id_y_width = 35.56;
	my $id_z_width = 30.48;
	$detector{"name"}        = "id_ayoke";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Frascati Magnet Yoke";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "0000ff";
	$detector{"type"}        = "Box";	
	$detector{"dimensions"}  = "$id_x_width*cm $id_y_width*cm $id_z_width*cm";
	$detector{"material"}    = "Component";	
	print_det(\%detector, $file);
	
	# Frascati Magnet Gap
	my $id_gap_x_width = 22.225;  # 27.7' - 10' 
	my $id_gap_y_width =  4.0;
	my $id_gap_z_width = $id_z_width+0.1;
	$detector{"name"}        = "id_gap";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Frascati Magnet Gap";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "00ff00";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$id_gap_x_width*cm $id_gap_y_width*cm $id_gap_z_width*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);
	
	# Frascati Dipole 1 Yoke - Gap
	my $zpos_id1 = -$MagnetSep + $PSZShift;
	$detector{"name"}        = "id_magnet1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Frascati Dipole 1";
	$detector{"pos"}         = "0*cm 0.0*cm $zpos_id1*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "440000";
	$detector{"type"}        = "Operation: id_ayoke - id_gap";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "G4_Fe";
	print_det(\%detector, $file);	
	
	# Frascati Dipole 2 Yoke - Gap
	my $zpos_id2 = $MagnetSep + $PSZShift ;
	$detector{"name"}        = "id_magnet2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Frascati Dipole 2";
	$detector{"pos"}         = "0*cm 0.0*cm $zpos_id2*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "880000";
	$detector{"type"}        = "Operation: id_ayoke - id_gap";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "G4_Fe";
	print_det(\%detector, $file);	
	
	
	# Solid for the First Field
	my $id_fgap_x_width = $id_gap_x_width - 0.1;
	my $id_fgap_y_width = $id_gap_y_width - 0.1;
	my $id_fgap_z_width = $id_gap_z_width + 6;
	if($envelope eq 'hps_beamline_fast')
	{
		$id_fgap_z_width = $id_gap_z_width - 10;
	}
	
	$detector{"name"}        = "id_field1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Frascati Magnet Gap";
	$detector{"pos"}         = "0*cm 0.0*cm $zpos_id1*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "00ff00";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$id_fgap_x_width*cm $id_fgap_y_width*cm $id_fgap_z_width*cm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "hps_dip1$field_map";
	$detector{"visible"}     = 0;
	if($envelope eq 'hps_beamline_fast')
	{
		$detector{"mfield"}      = "hps_id_fast";
	}
	
	print_det(\%detector, $file);
	
	# Solid for the Second Field
	$detector{"name"}        = "id_field2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Frascati Magnet Gap";
	$detector{"pos"}         = "0*cm 0.0*cm $zpos_id2*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "00ff00";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$id_fgap_x_width*cm $id_fgap_y_width*cm $id_fgap_z_width*cm";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "hps_dip2$field_map";
	$detector{"visible"}     = 0;
	if($envelope eq 'hps_beamline_fast')
	{
		$detector{"mfield"}      = "hps_id_fast";
	}
	print_det(\%detector, $file);
}

make_frascati_magnet();



###################
# Pair Spectrometer
###################
sub make_ps
{
	$detector{"mfield"}      = "no";

	my $ps_dipole_x = 82.50*$inches/2.0;
	my $ps_dipole_y = 45.75*$inches/2.0;
	my $ps_dipole_z = 36.00*$inches/2.0;
	my $id_z_width  = 30.48;
	
	# Mother Volume of PS + ECAL + Vacuum Box dimension
	# Must enclose everything
	my $ps_ecal_mother_x = $ps_dipole_x + 20;
	my $ps_ecal_mother_y = $ps_dipole_y + 20;
	my $ps_ecal_mother_z = $MagnetSep - $id_z_width - $ps_dipole_z - 6.5;
	$detector{"name"}        = "aps_ecal_mother";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Box";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "000088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$ps_ecal_mother_x*cm $ps_ecal_mother_y*cm $ps_ecal_mother_z*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	my $ps_ecal_mother_zpos = $ps_ecal_mother_z + $ps_dipole_z;
	$detector{"name"}        = "bps_ecal_mother";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Box";
	$detector{"pos"}         = "0*cm 0.0*cm $ps_ecal_mother_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "000088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$ps_ecal_mother_x*cm $ps_ecal_mother_y*cm $ps_dipole_z*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	# Mother Volume of PS and ECAL
	$detector{"name"}        = "ps_ecal_mother";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Box";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "000088";
	$detector{"type"}        = "Operation: aps_ecal_mother + bps_ecal_mother";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "pair_spect";
	if($envelope eq 'hps_beamline_fast')
	{
		$detector{"mfield"}      = "no";
	}
	$detector{"visible"}     = 0;
	$detector{"style"}       = 0;
	print_det(\%detector, $file);	
	
	
	$detector{"mfield"}      = "no";
	$detector{"style"}       = 1;
	$detector{"visible"}     = 1;

	# PS Magnet Yoke
	$detector{"name"}        = "ps_ayoke";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Box";
	$detector{"pos"}         = "0*cm 0.0*cm 0*inches";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "000088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$ps_dipole_x*cm $ps_dipole_y*cm $ps_dipole_z*cm";
	$detector{"material"}    = "Component";
	$detector{"visible"}     = 1;
	print_det(\%detector, $file);	
	
	# PS Magnet Gap
	my $ps_gap_x_width = 22.00*$inches;
	my $ps_gap_y_width =  4.05*$inches;
	my $ps_gap_z_width = $ps_dipole_z+0.1;
	$detector{"name"}        = "ps_gap";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Magnet Gap";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "000088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$ps_gap_x_width*cm $ps_gap_y_width*cm $ps_gap_z_width*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);
	
	# PS Dipole 1 Yoke - Gap
	$detector{"name"}        = "ps_magnet";
	$detector{"mother"}      = "ps_ecal_mother";
	$detector{"description"} = "Pair Spectrometer";
	$detector{"pos"}         = "0*cm 0.0*cm $PSZShift*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "440000";
	$detector{"type"}        = "Operation: ps_ayoke - ps_gap";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "G4_Fe";
	print_det(\%detector, $file);	

	
	# PS field
	# The Z dimensions are exactly the same as the
    # PS ECAL MOTHER components (minus 1 cm)
	my $ps_field_x  = 16.38*$inches/2.0 - 0.1;
	my $ps_field_y  =  7.00*$inches/2.0 - 0.1;
	my $ps_vb_az    =  $ps_ecal_mother_z - 1;
	my $ps_vb_bz    =  $ps_dipole_z      - 1;
	my $ps_vb_bzpos =  $ps_vb_az + $ps_vb_bz ;
	if($envelope eq 'hps_beamline_fast')
	{
		$ps_vb_az    = 12 ;   # how much the field stick out of the PS yoke 
		$ps_vb_bz    = $ps_dipole_z;
		$ps_vb_bzpos =  $ps_vb_az + $ps_vb_bz ;		
	}
	

	$detector{"name"}        = "aps_field";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Solid Holding PS Magnet";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "00ff00";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$ps_field_x*cm $ps_field_y*cm $ps_vb_az*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);
	
	$detector{"name"}        = "bps_field";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Solid Holding PS Magnet";
	$detector{"pos"}         = "0*cm 0.0*cm $ps_vb_bzpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "00ff00";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$ps_field_x*cm $ps_field_y*cm $ps_vb_bz*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);
	
	$detector{"name"}        = "ps_field";
	$detector{"mother"}      = "ps_ecal_mother";
	$detector{"description"} = "Solid Holding PS Magnet";
	$detector{"pos"}         = "0*cm 0.0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "00ff00";
	$detector{"type"}        = "Operation: aps_field + bps_field";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "pair_spect";
	$detector{"visible"}     = 0;
	$detector{"style"}       = 0;
	if($envelope eq 'hps_beamline_fast')
	{
		$detector{"mfield"}      = "hps_ps_fast";
	}
	print_det(\%detector, $file);
	
	
	
}

make_ps();

$detector{"visible"}     = 1;
$detector{"style"}       = 1;
$detector{"mfield"}      = "no";


# ############################
# Pair Spectrometer Vacuum Box
# ############################
sub make_ps_vacuum_box
{

	# Vacuum box thicknesses
	my $box_thickness_x = ((17.88 - 16.38)/2.0)*$inches; 
	my $box_thickness_y = (( 8.00 -  7.00)/2.0)*$inches; 
	my $box_tlength     = 63.93*$inches - 2;  # Vacuum Box Total Length - this includes 2cm of steel flange at the end so need to subtract it

	# Vacuum box - this is the first box, dimensions from the drawing
	# The z - positioning will be done based on this box
	my $ps_vb_x = 17.88*$inches/2.0;
	my $ps_vb_y = 8.000*$inches/2.0;
	my $ps_vb_z = (36+12)*$inches/2.0; 
	$detector{"name"}        = "vca_box";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Vacuum Box Frame";
	$detector{"pos"}         = "0*cm 0.0*cm 0*inches";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "00aa00";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$ps_vb_x*cm $ps_vb_y*cm $ps_vb_z*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	

	# Vacuum box Vacuum
	my $psv_vb_x = $ps_vb_x - $box_thickness_x; 
	my $psv_vb_y = $ps_vb_y - $box_thickness_y; 
	my $psv_vb_z = $ps_vb_z + 0.1; 
	$detector{"name"}        = "vca_vbox";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Vacuum box Vacuum";
	$detector{"pos"}         = "0*cm 0.0*cm 0*inches";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "006600";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$psv_vb_x*cm $psv_vb_y*cm $psv_vb_z*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	
	# Trapezoidal vacuum box on front of dipole - sideview
	# $ps_vb_dx_2 is set here the same as $ps_vb_dx_1 in the constructor
	# This so I can sum the other Trapezoid
	my $ps_vb_dx_1    = $ps_vb_x;
	my $ps_vb_dx_2    = 13.75*$inches + $box_thickness_x;
	my $ps_vb_dy_1    = $ps_vb_y;
	my $ps_vb_dy_2    = 7.626*$inches + $box_thickness_y;
	my $ps_vb_dz_1    = ($box_tlength - 48*$inches)/2.0 ; 
	my $ps_vb_angle_1 = (10.74*$pi/180)/2.0;
	my $ps_vb_z_1     = ($ps_vb_y - $box_thickness_y)/tan($ps_vb_angle_1); 
	my $shift_z1      = $ps_vb_z + $ps_vb_dz_1;
	$detector{"name"}        = "vca_trd1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Vacuum Trapezoid ";
	$detector{"pos"}         = "0*cm 0.0*cm $shift_z1*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "0000ff";
	$detector{"type"}        = "Trd";
	$detector{"dimensions"}  = "$ps_vb_dx_1*cm $ps_vb_dx_1*cm $ps_vb_dy_1*cm $ps_vb_dy_2*cm $ps_vb_dz_1*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
		
	# Trapezoidal vacuum box vacuum on front of dipole - sideview
	my $psv_vb_dx_1 = $ps_vb_dx_1 - $box_thickness_x;
	my $psv_vb_dx_2 = $ps_vb_dx_2 - $box_thickness_x;
	my $psv_vb_dy_1 = $ps_vb_dy_1 - $box_thickness_y;
	my $psv_vb_dy_2 = $ps_vb_dy_2 - $box_thickness_y;
	my $psv_vb_dz_1 = $ps_vb_dz_1 + 0.5 ; 
	$detector{"name"}        = "vca_vtrd1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Vacuum Trapezoid Vacuum";
	$detector{"pos"}         = "0*cm 0.0*cm $shift_z1*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "000066";
	$detector{"type"}        = "Trd";
	$detector{"dimensions"}  = "$psv_vb_dx_1*cm $psv_vb_dx_1*cm $psv_vb_dy_1*cm $psv_vb_dy_2*cm $psv_vb_dz_1*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	# Trapezoidal vacuum box on front of dipole - topview
	my $ps_vb_angle_2 = (21.55*$pi/180)/2.0;
	my $ps_vb_z_2     = ($ps_vb_x - $box_thickness_x)/tan($ps_vb_angle_2); 
	my $ps_vb_dy_12   = $ps_vb_dy_1 + ($ps_vb_z_2 - $ps_vb_z_1)*tan(10.55*$pi/180) + $box_thickness_y;
	my $ps_vb_dz_2    = $ps_vb_dz_1 - ($ps_vb_z_2 - $ps_vb_z_1)/2.0 ; 
	my $shift_z2      = $ps_vb_z + ($ps_vb_z_2 - $ps_vb_z_1) + $ps_vb_dz_2;
	$detector{"name"}        = "vca_trd2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Vacuum Trapezoid ";
	$detector{"pos"}         = "0*cm 0.0*cm $shift_z2*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "00ff66";
	$detector{"type"}        = "Trd";
	$detector{"dimensions"}  = "$ps_vb_dx_1*cm $ps_vb_dx_2*cm $ps_vb_dy_12*cm $ps_vb_dy_2*cm $ps_vb_dz_2*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	# Trapezoidal vacuum box vacuum on front of dipole - topview
	my $psv_vb_dy_22 = $ps_vb_dy_12 - $box_thickness_y ; 
	my $psv_vb_dz_2  = $ps_vb_dz_2  + 0.5 ; 
	$detector{"name"}        = "vca_vtrd2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Vacuum Trapezoid ";
	$detector{"pos"}         = "0*cm 0.0*cm $shift_z2*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ffff66";
	$detector{"type"}        = "Trd";
	$detector{"dimensions"}  = "$psv_vb_dx_1*cm $psv_vb_dx_2*cm $psv_vb_dy_22*cm $psv_vb_dy_2*cm $psv_vb_dz_2*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	# Exit Window Flange
	my $flange_dx  = 30.25*$inches/2.0;
	my $flange_dy  = 18*$inches/2.0;
	my $flange_dz  = 1*$inches/2.0;
	my $flange_pos =  $ps_vb_z + 2*$ps_vb_dz_1 - $flange_dz;
	$detector{"name"}        = "vca_flange";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Downstream Flange Frame";
	$detector{"pos"}         = "0*cm 0.0*cm $flange_pos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "0000ff";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$flange_dx*cm $flange_dy*cm $flange_dz*cm";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
		
	# PS Box + Tr1 Union
	$detector{"name"}        = "vcb_frame";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Vacuum Box + Tr1 Frame";
	$detector{"pos"}         = "0*cm 0.0*cm 0*inches";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "aa00ff";
	$detector{"type"}        = "Operation: vca_box + vca_trd1";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	# PS Frame Union
	$detector{"name"}        = "vcc_frame";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Vacuum Box + Tr2 Frame";
	$detector{"pos"}         = "0*cm 0.0*cm 0*inches";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "aa00ff";
	$detector{"type"}        = "Operation: vcb_frame + vca_trd2";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	# Adding Flange
	$detector{"name"}        = "vcd_frame";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Vacuum Box + Flange";
	$detector{"pos"}         = "0*cm 0.0*cm 0*inches";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "dedddf";
	$detector{"type"}        = "Operation: vcc_frame + vca_flange";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	
	# Subtracting First Vacuum Box
	$detector{"name"}        = "vce_frame";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Frame - Box";
	$detector{"pos"}         = "0*cm 0.0*cm 0*inches";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "aa00ff";
	$detector{"type"}        = "Operation: vcd_frame - vca_vbox";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	
	# Subtracting Vacuum Sideview Trapezoid
	$detector{"name"}        = "vcf_frame";
	$detector{"mother"}      = "root";
	$detector{"description"} = "PS Vacuum Box+Trapezoid Frame - Box - Tr1";
	$detector{"pos"}         = "0*cm 0.0*cm 0*inches";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "aa00ff";
	$detector{"type"}        = "Operation: vce_frame - vca_vtrd1";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Component";
	print_det(\%detector, $file);	
	

	# Subtracting Vacuum Topview Trapezoid
	# This is the final Vacuum Box
	# Positioning is relative to the target which is the same as 
	# The mother volume
	my $vb_zpos = $ps_vb_z - 12*$inches;
	$detector{"name"}        = "vcg_frame";
	$detector{"mother"}      = "ps_ecal_mother";
	$detector{"description"} = "PS Vacuum Box+Trapezoid Frame - Box Tr1 - Tr2";
	$detector{"pos"}         = "0*cm 0.0*cm $vb_zpos*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "dcdcf2";
	$detector{"type"}        = "Operation: vcf_frame - vca_vtrd2";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Component";
	$detector{"material"}    = "StainlessSteel";
	print_det(\%detector, $file);	
	
}
make_ps_vacuum_box();


# Target at the end of beamline to check alignment
sub make_end_beamline()
{
	# Beam Alignment Tube 1 at 10 m
	$detector{"name"}        = "alignment_tube1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Beam Alignment Tube 1 at 10 m";
	$detector{"pos"}         = "0*cm 0.0*cm 10*m";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "0*cm 2*cm 10*cm 0*deg 360*deg";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 1";
	print_det(\%detector, $file);	
	
	# Beam Alignment Tube 1 at 10 m
	$detector{"name"}        = "alignment_tube2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Beam Alignment Tube 2 at 20 m";
	$detector{"pos"}         = "0*cm 0.0*cm 20*m";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "005500";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "0*cm 2*cm 10*cm 0*deg 360*deg";
	$detector{"material"}    = "Vacuum";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "id manual 2";
	print_det(\%detector, $file);	
	
}


make_end_beamline();


