#!/usr/bin/perl -w
use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);


my $file     = 'SECTOR.txt';

my $rmin = 1;
my $rmax = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;




# all dimensions in mm, deg

# basic volume is a portion of a tube
my $inches = 25.4;
my $SteelFrameLength = 94.*$inches/2.0+1.;   # add 1. to avoid overlaps
my $TorusZpos        = 151.855*$inches;      # center of the torus position


my $sector_rot     = 90.;
my $forward_length = 7800./2.;
my $forward_zpos   = 5000.; 
#my $forward_IR     = 150.;
my $forward_IR     = 7.87*$inches+1;     # correspond to Torus $SteelPlateOR 
my $forward_OR     = 5000.;
my $forward_phi0    = 60.;
my $forward_dphi    = 60.;

sub make_sector_forward
{
	$detector{"name"}        = "AAa_sector_forward";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Forward Part of Sector Volume";
	$detector{"pos"}         = "0*mm 0.0*mm 0.*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ee11aa";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$forward_IR*mm $forward_OR*mm $forward_length*mm $forward_phi0*deg $forward_dphi*deg";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}
 
my $middle_length = $SteelFrameLength;
my $middle_zpos   = $TorusZpos-$forward_zpos; 
my $middle_IR     = 0.;
my $middle_OR     = 7.87*$inches+1;     # correspond to Torus $SteelPlateOR 
my $middle_phi0   = $forward_phi0-1.;
my $middle_dphi   = $forward_dphi+2.;



sub make_sector_middle
{
	$detector{"name"}        = "AAb_sector_middle";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Middle Part of Sector Volume";
	$detector{"pos"}         = "0.*mm 0.*mm $middle_zpos*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ee11aa";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$middle_IR*mm $middle_OR*mm $middle_length*mm $middle_phi0*deg $middle_dphi*deg";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}


my $coil_tkn    = 50.;
my $coil1_angle =  30.;
my $coil2_angle = 120.;
my $coil3_angle =  25.;
my $coil_dx     = $coil_tkn;
my $coil_dy     = $forward_OR;
my $coil_dz     = $SteelFrameLength*cos(rad($coil3_angle));
my $coil_zpos   = $middle_zpos+$middle_OR*tan(rad($coil3_angle));


sub make_sector_coil1
{
	$detector{"name"}        = "AAd_sector_coil1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Left Coil Volume";
	$detector{"pos"}         = "0.*mm 0.*mm $coil_zpos*mm";
	$detector{"rotation"}    = "ordered: yzx  0.*deg $coil1_angle*deg $coil3_angle*deg ";
	$detector{"color"}       = "ee11aa";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$coil_dx*mm $coil_dy*mm $coil_dz*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}

sub make_sector_coil2
{
	$detector{"name"}        = "AAf_sector_coil2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Right Coil Volume";
	$detector{"pos"}         = "0.*mm 0.*mm $coil_zpos*mm";
	$detector{"rotation"}    = "ordered: yzx  0.*deg -$coil1_angle*deg $coil3_angle*deg ";
	$detector{"color"}       = "ee11aa";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$coil_dx*mm $coil_dy*mm $coil_dz*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}


my $sector_FT_length = 1150.;
my $sector_FT_nplanes = 2;
my @sector_FT_zplane  = ( -$forward_length, -$forward_length+$sector_FT_length);
my @sector_FT_IR      = (               0.,                                0. );
my @sector_FT_OR      = (            3000.,                               300.); 

sub make_sector_ftspace
{
	$detector{"name"}        = "AAh_sector_ftspace";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Sector Space for FT";
	$detector{"pos"}         = "0*mm 0.0*cm 0.0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ee11aa";
	$detector{"type"}        = "Polycone";
	my $dimen = "0.0*deg 360*deg $sector_FT_nplanes";
	for(my $i = 0; $i <$sector_FT_nplanes ; $i++)
	{
	    $dimen = $dimen ." $sector_FT_IR[$i]*mm";
	}
	for(my $i = 0; $i <$sector_FT_nplanes ; $i++)
	{
	    $dimen = $dimen ." $sector_FT_OR[$i]*mm";
	}
	for(my $i = 0; $i <$sector_FT_nplanes ; $i++)
	{
	    $dimen = $dimen ." $sector_FT_zplane[$i]*mm";
	}
	$detector{"dimensions"} = $dimen;
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}



sub make_sector_volume1
{
	$detector{"name"}        = "AAc_sector_volume1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Sector Volume: AAa_sector_forward - AAb_sector_middle";
	$detector{"pos"}         = "0*mm 0.0*mm 0.*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0.*deg";
	$detector{"color"}       = "ee11aa";
	$detector{"type"}        = "Operation: AAa_sector_forward - AAb_sector_middle";
	$detector{"dimensions"}  = "0*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}

sub make_sector_volume2
{
	$detector{"name"}        = "AAe_sector_volume2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Sector Volume: AAc_sector_volume1 - AAd_sector_coil1";
	$detector{"pos"}         = "0*mm 0.0*mm 0.*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0.*deg";
	$detector{"color"}       = "ee11aa";
	$detector{"type"}        = "Operation: AAc_sector_volume1 - AAd_sector_coil1";
	$detector{"dimensions"}  = "0*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}

sub make_sector_volume3
{
	$detector{"name"}        = "AAg_sector_volume3";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Sector Volume: AAe_sector_volume2 - AAf_sector_coil2";
	$detector{"pos"}         = "0*mm 0.0*mm 0.*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0.*deg";
	$detector{"color"}       = "ee11aa";
	$detector{"type"}        = "Operation: AAe_sector_volume2 - AAf_sector_coil2";
	$detector{"dimensions"}  = "0*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}

sub make_sector
{
	$detector{"name"}        = "sector";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Sector 1";
	$detector{"pos"}         = "0*mm 0.0*mm $forward_zpos*mm"; 
	$detector{"rotation"}    = "0*deg 0*deg $sector_rot*deg";
	$detector{"color"}       = "ee11aa";
	$detector{"type"}        = "Operation: AAg_sector_volume3 - AAh_sector_ftspace";
	$detector{"dimensions"}  = "0*mm";
	$detector{"material"}    = "Air_Opt";
	$detector{"mfield"}      = "clas12-torus";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 0;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}

sub make_sector26
{
	for(my $n=2; $n<7; $n++)
	{
		$sector_rot = $sector_rot - 60.;
		$detector{"name"}        = "sector $n";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Sector $n";
		$detector{"pos"}         = "0*mm 0.0*cm $forward_zpos*mm";
		$detector{"rotation"}    = "0*deg 0*deg $sector_rot*deg";
		$detector{"color"}       = "ee11aa";
		$detector{"type"}        = "CopyOf sector";
		$detector{"dimensions"}  = "0*mm";
		$detector{"material"}    = "Air_Opt";
		$detector{"mfield"}      = "clas12-torus";
		$detector{"ncopy"}       = "$n";
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 0;
		$detector{"style"}       = 0;
		$detector{"sensitivity"} = "no";
		$detector{"hit_type"}    = "";
		$detector{"identifiers"} = "";
		print_det(\%detector, $file);
	}
}



make_sector_forward();
make_sector_middle();
make_sector_coil1();
make_sector_coil2();
make_sector_ftspace();
make_sector_volume1();
make_sector_volume2();
make_sector_volume3();
make_sector();
make_sector26();






