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

my $TorusLength         = 2158.75/2.0;      # 1/2 length of torus, including plates
my $col            = 'cde6fa';


# Parallelepiped Coils 1
my $PC1_dx    = $TorusLength - 60.0;   # This part will end on the z-axis. Steel plates are 6mm
my $PC1_dy    = 41.59;                    # Air 1/2 Thickness: Steel plates are 6mm thick so it's (95.18 - 12) (/2 =41.59)
my $PC1_dz    = 1800.0;                   # length from beampipe
my $PC1_angle = -25.0;

my $PC1_zpos = 65.0;

# Part 1: main Parallelepiped
sub make_part1
{
	$detector{"name"}        = "aaa_TorusAir_part1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Air Component #1: parallelepiped part";
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
my $B1_posx  = -2300.0 + 6.0;
my $B1_posz  = $B1_dz + $PC1_dz - 1150.0;
my $B1_angle = +22.0;

sub make_part2
{
	$detector{"name"}        = "aaa_TorusAir_part2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Air Component #2: Box to subtract";
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
	$detector{"name"}        = "aaa_TorusAir_part3";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Air Component #3: aaa_TorusAir_part1 - aaa_TorusAir_part2";
	$detector{"pos"}         = "0*mm 0.0*cm -10*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ffff66";
	$detector{"type"}        = "Operation: aaa_TorusAir_part1 - aaa_TorusAir_part2";
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

make_part1();
make_part2();
make_part3();

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








