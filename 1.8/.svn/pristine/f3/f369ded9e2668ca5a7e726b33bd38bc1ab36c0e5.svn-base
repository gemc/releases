#!/usr/bin/perl -w
use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'torus_thickWH';
my $file     = 'torus_thickWH.txt';

my $rmin = 1;
my $rmax = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

# all dimensions in mm, deg

my $inches = 25.4;

# Inner Ring:
my $ColdHubLength =  1948.0/2.0;  # 1/2 length aluminum cold hub
my $ColdHubIR     =   175.0/2.0;  # taken from new drawing sent by L. Quettier (April 2010)
my $ColdHubOR     =   240.0/2.0;
my $col           = 'ffffff';

sub make_IRing
{
	my $length  = $ColdHubLength;
	
	$detector{"name"}        = "Torus_ColdHub";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Cold Hub Ring";
	$detector{"pos"}         = "0.0*cm 0.0*cm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $col;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$ColdHubIR*mm $ColdHubOR*mm $length*mm  0.0*deg 360.0*deg";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
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


# Parallelepiped Coils 1
my $PC1_dx    = $ColdHubLength - 100.0;   # This part will end on the z-axis
my $PC1_dy    = 52.8/2.0;                     # Aluminum 1/2 Thickness = 41.8 mm
my $PC1_dz    = 1700.0;                   # length from beampipe
my $PC1_angle = -25.0;

my $PC1_zpos = -20.0;

# Part 1: main Parallelepiped
sub make_part1
{
	$detector{"name"}        = "aaa_Torus_part1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Component #1: parallelepiped part";
	$detector{"pos"}         = "0*mm 0.0*cm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ff88bb";
	$detector{"type"}        = "Parallelepiped";
	$detector{"dimensions"}  = "$PC1_dx*mm $PC1_dy*mm $PC1_dz*mm 0*deg $PC1_angle*deg 0*deg";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
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


# Part 2: Box to subtract to part1: Hole near the Outer Ring
my $B1_dx    = $PC1_dx + 500.0;   # This will end on the z-axis
my $B1_dy    = $PC1_dy + 100;
my $B1_dz    = 600.0;
my $B1_posx  = -1700.0;
my $B1_posz  = $B1_dz + $PC1_dz - 1100.0;
my $B1_angle = +22.0;

sub make_part2
{
	$detector{"name"}        = "aaa_Torus_part2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Component #2: Box to subtract";
	$detector{"pos"}         = "$B1_posx*mm 0.0*cm $B1_posz*mm";
	$detector{"rotation"}    = "0*deg $B1_angle*deg 0*deg";
	$detector{"color"}       = "ff00ff";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$B1_dx*mm $B1_dy*mm $B1_dz*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
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

# Part 3 - Parallelepiped with top Hole: Part 2 - Part1
sub make_part3
{
	$detector{"name"}        = "aaa_Torus_part3";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Component #3: aaa_Torus_part1 - aaa_Torus_part2";
	$detector{"pos"}         = "0*mm 0.0*cm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ffff66";
	$detector{"type"}        = "Operation: aaa_Torus_part1 - aaa_Torus_part2";
	$detector{"dimensions"}  = "0*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
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



# Part 4: Box to add to part3: it will make the hole look like the drawings
my $B2_dx    =  510.0;   # This will end on the z-axis
my $B2_dz    =  200.0;
my $B2_posx  =  -270.0;
my $B2_posz  = 1180.0;
my $B2_angle = +90.0;

sub make_part4
{
	$detector{"name"}        = "aaa_Torus_part4";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Coil: small Box to add";
	$detector{"pos"}         = "$B2_posx*mm 0.0*cm $B2_posz*mm";
	$detector{"rotation"}    = "0*deg $B2_angle*deg 0*deg";
	$detector{"color"}       = "ff66ff";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$B2_dx*mm $PC1_dy*mm $B2_dz*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
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


# Part 5 - Parallelepiped with final top: Part3 + part4
sub make_part5
{
	$detector{"name"}        = "aaa_Torus_part5";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Component #5: aaa_Torus_part3 + aaa_Torus_part4";
	$detector{"pos"}         = "0*mm 0.0*cm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $col;
	$detector{"type"}        = "Operation: aaa_Torus_part3 + aaa_Torus_part4";
	$detector{"dimensions"}  = "0*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
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



# Part6: Box to add to make front face perperndicolar to beam
my $B3_dx    =  120.0;   # This will end on the z-axis
my $B3_dy    =  $PC1_dy + .05;
my $B3_dz    =  200.0;
my $B3_x     =  -200.0;
my $B3_z     =  -1505.0;

sub make_part6
{
	$detector{"name"}        = "aaa_Torus_part6";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Coil: Box to add to make front face perperndicolar to beam";
	$detector{"pos"}         = "$B3_x*mm 0*mm $B3_z*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ff0000";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$B3_dx*mm $B3_dy*mm $B3_dz*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
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



# inal Parallelepiped: Part 5 + part6. Make copies of all Coils, call them aab_Torus_part$nindex
my $overlap = 30.00;
sub make_coils
{
	for(my $n=0; $n<6; $n++)
	{
		my $nindex      = $n+1;
		my $R           = $ColdHubOR + $PC1_dz - $overlap;

		$detector{"name"}        = "aab_Torus_part$nindex";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Torus Component #$nindex: aaa_Torus_part5 + aaa_Torus_part6";
		$detector{"pos"}         = Pos($R, $n);
		$detector{"rotation"}    = Rot($R, $n);
		$detector{"color"}       = $col;
		$detector{"type"}        = "Operation: aaa_Torus_part5 + aaa_Torus_part6";
		$detector{"dimensions"}  = "0*mm";
		$detector{"material"}    = "Air";
		$detector{"material"}    = "Component";
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
}

# Sum Cold Hub with first Coil
sub make_coil1
{
	$detector{"name"}        = "aac_Torus_part1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Ring + aab_Torus_part1";
	$detector{"pos"}         = "0.0*cm 0.0*cm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $col;
	$detector{"type"}        = "Operation: Torus_ColdHub + aab_Torus_part1";
	$detector{"dimensions"}  = "0*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
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

# Add remaining coils: Final Aluminum Cold Hub + Coils it's aac_Torus_part6
my $TorusZpos        = 151.855*$inches;                 # center of the torus position
sub make_sumcoils
{
	for(my $n=1; $n<6; $n++)
	{
		my $iname       = $n+1;
		
		$detector{"name"}        = "aac_Torus_part$iname";
		$detector{"mother"}      = "root";
		$detector{"description"} = "aac_Torus_part$n + aab_Torus_part$iname";
		$detector{"pos"}         = "0.0*cm 0.0*cm $TorusZpos*mm";
		$detector{"rotation"}    = "0*deg 180*deg 0*deg";
		$detector{"color"}       = $col;
		$detector{"type"}        = "Operation: aac_Torus_part$n + aab_Torus_part$iname";
		$detector{"dimensions"}  = "0*mm";
		$detector{"material"}    = "Component";
		if($n == 5)
		{
			$detector{"name"}        = "torus_Aluminum_Coils";
			$detector{"mother"}      = "root";
			$detector{"material"}    = "G4_Al";
		}
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = "1";
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 0;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "no";
		$detector{"hit_type"}    = "";
		$detector{"identifiers"} = "";
		print_det(\%detector, $file);
	}
}
	
make_IRing();
make_part1();
make_part2();
make_part3();
make_part4();
make_part5();
make_part6();
make_coils();
make_coil1();
make_sumcoils();

sub Pos
{
	my $R = shift;
	my $i = shift;
	my $z         = $PC1_zpos + $PC1_dz*tan(abs(rad($PC1_angle))) - 80.0;
	
	my $theta     = 30.0 + $i*60.0;
	my $x         = sprintf("%.3f", $R*cos(rad($theta)));
	my $y         = sprintf("%.3f", $R*sin(rad($theta)));
	return "$x*mm $y*mm $z*mm";
}

sub Rot
{
	my $R = shift;
	my $i = shift;
	
	my $theta     = 30.0 + $i*60.0;
	
	return "ordered: yxz -90*deg $theta*deg 0*deg";
}




	