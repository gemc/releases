#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'HTCCnateM3';
my $file     = 'HTCCnateM3.txt';

print "FILE: ",  $file."\n";

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

$detector{"mfield"}      = "no";
$detector{"ncopy"}       = 1;
$detector{"pMany"}       = 1;
$detector{"exist"}       = 1;
$detector{"visible"}     = 1;
$detector{"style"}       = 1;
$detector{"sensitivity"} = "no";
$detector{"hit_type"}    = "";
$detector{"identifiers"} = "";

########## Mirror 3 (layer 1) ###################

sub make_C_InnerEllipsoid
{
 $detector{"name"}        = "aaa_C_InnerEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "ellipsoid for subtraction";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Ellipsoid";

 $detector{"dimensions"}  = "1497.6043*mm 1786.8590*mm 1497.6043*mm 0*mm 0*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_C_InnerEllipsoid();


sub make_C_OutterEllipsoid
{
 $detector{"name"}        = "aab_C_OutterEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "acrylic ellipsoid";
 $detector{"pos"}         = "0*mm 951.2034*mm 212.7408*mm";
 $detector{"rotation"}    = "-12.606978679*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Ellipsoid";

 $detector{"dimensions"}  = "1497.9043*mm 1787.1590*mm 1497.9043*mm 0*mm 0*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_C_OutterEllipsoid();


sub make_C_EllipsoidialShell
{
 $detector{"name"}        = "aac_C_EllipsoidialShell";
 $detector{"mother"}      = "root";
 $detector{"description"} = "acrylic ellipsoid";
 $detector{"pos"}         = "0*mm 951.2034*mm 212.7408*mm";
 $detector{"rotation"}    = "-12.606978679*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Operation:aab_C_OutterEllipsoid - aaa_C_InnerEllipsoid";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_C_EllipsoidialShell();


sub make_C_Cube
{
 $detector{"name"}        = "aad_C_Cube";
 $detector{"mother"}      = "root";
 $detector{"description"} = "big cube";
 $detector{"pos"}         = "0*mm -800*mm -9350*mm";
 $detector{"rotation"}    = "12.606978679*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Box";

 $detector{"dimensions"}  = "10000*mm 10000*mm 10000*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_C_Cube();


sub make_C_HalfEllipsoid
{
 $detector{"name"}        = "aae_C_HalfEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "half ellipsoid";
 $detector{"pos"}         = "0*mm 951.2034*mm 212.7408*mm";
 $detector{"rotation"}    = "-12.606978679*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Operation: aac_C_EllipsoidialShell - aad_C_Cube";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_C_HalfEllipsoid();


sub make_C_PhiCylinder
{
 $detector{"name"}        = "aag_C_PhiCylinder";
 $detector{"mother"}      = "root";
 $detector{"description"} = "big cylinder with wedge cut";
 $detector{"pos"}         = "0*mm -974.703316993*mm 0*mm";
 $detector{"rotation"}    = "12.606978679*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Tube";

 $detector{"dimensions"}  = "0*mm 5000*mm 3000*mm 105*deg 330*deg";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_C_PhiCylinder();


sub make_C_EllipseSlicePhi
{
 $detector{"name"}        = "aah_C_EllipseSlicePhi";
 $detector{"mother"}      = "root";
 $detector{"description"} = "sliced ellipsoid";
 $detector{"pos"}         = "0*mm 951.2034*mm 212.7408*mm";
 $detector{"rotation"}    = "-12.606978679*deg 0*deg 0*deg";
 $detector{"color"}       = "ff44ff";
 $detector{"type"}        = "Operation: aae_C_HalfEllipsoid - aag_C_PhiCylinder";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_C_EllipseSlicePhi();


sub make_C_UpperPlaneCube
{
 $detector{"name"}        = "aai_C_UpperPlaneCube";
 $detector{"mother"}      = "root";
 $detector{"description"} = "upper plane cube";
#### absolute coordinates:
 #$detector{"pos"}         = "0*mm 1968.176086763*mm 3768.184559993*mm";
 #$detector{"rotation"}    = "-57.335635361*deg 0*deg 0*deg";
#### relative coordinates:
 $detector{"pos"}         = "0*mm 1768.47231171528210*mm 3247.75606484522950*mm";
 $detector{"rotation"}    = "-44.728656682*deg 0*deg 0*deg";
####
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Box";

 $detector{"dimensions"}  = "2500*mm 2500*mm 2500*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_C_UpperPlaneCube();


sub make_C_LowerPlaneCube
{
 $detector{"name"}        = "aaj_C_LowerPlaneCube";
 $detector{"mother"}      = "root";
 $detector{"description"} = "lower plane cube";
#### absolute coordinates:
 #$detector{"pos"}         = "0*mm -490.0621626*mm -758.923929*mm";
 #$detector{"rotation"}    = "-70.170320145*deg 0*deg 0*deg";
#### relative coordinates:
 $detector{"pos"}         = "0*mm -1618.59450760403593*mm -633.664412661667711*mm";
 $detector{"rotation"}    = "-57.563341466*deg 0*deg 0*deg";
####
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Box";

 $detector{"dimensions"}  = "2500*mm 2500*mm 2500*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_C_LowerPlaneCube();


sub make_C_EllipseUpperSlice
{
 $detector{"name"}        = "aak_C_EllipseUpperSlice";
 $detector{"mother"}      = "root";
 $detector{"description"} = "sliced ellipsoid";
 $detector{"pos"}         = "0*mm 951.2034*mm 212.7408*mm";
 $detector{"rotation"}    = "-12.606978679*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Operation: aah_C_EllipseSlicePhi - aai_C_UpperPlaneCube";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_C_EllipseUpperSlice();


#sub make_C_FinalMirrorM3L1
#{
# $detector{"name"}        = "aal_C_FinalMirrorM3L1";
# $detector{"mother"}      = "root";
# $detector{"description"} = "mirror 3";
# $detector{"pos"}         = "0*mm 951.2034*mm 212.7408*mm";
# $detector{"rotation"}    = "-12.606978679*deg 0*deg 0*deg";
# $detector{"color"}       = "000080";
# $detector{"type"}        = "Operation: aak_C_EllipseUpperSlice - aaj_C_LowerPlaneCube";

# $detector{"dimensions"}  = "0";
# $detector{"material"}    = "Air";
# #$detector{"material"}    = "Component";

# print_det(\%detector, $file);
#}

#make_C_FinalMirrorM3L1();

my $zshift = 0;

sub make_C_FinalMirrorLeftM3L1
{
 $detector{"name"}        = "aal_C_FinalMirrorLeftM3L1";
 $detector{"mother"}      = "HTCC";
 #$detector{"mother"}      = "root";
 $detector{"description"} = "mirror 3";
 my $zpos = 212.7408 + $zshift;
 $detector{"pos"}         = "246.189556*mm 918.79193*mm $zpos*mm";
 $detector{"rotation"}    = "ordered: yzx  0*deg 15*deg -12.606978679*deg ";
 $detector{"color"}       = "000080";
 $detector{"type"}        = "Operation: aak_C_EllipseUpperSlice - aaj_C_LowerPlaneCube";

 $detector{"dimensions"}  = "0";
	$detector{"material"}    = "Rohacell31";
	$detector{"sensitivity"} = "Mirrors";
	$detector{"hit_type"}    = "Mirrors";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
 $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
 print_det(\%detector, $file);
}

make_C_FinalMirrorLeftM3L1();


sub make_C_FinalMirrorRightM3L1
{
 $detector{"name"}        = "aal_C_FinalMirrorRightM3L1";
 $detector{"mother"}      = "HTCC";
 #$detector{"mother"}      = "root";
 $detector{"description"} = "mirror 3";
 my $zpos = 212.7408 + $zshift;
 $detector{"pos"}         = "-246.189556*mm 918.79193*mm $zpos*mm";
 $detector{"rotation"}    = "ordered: yzx  0*deg -15*deg -12.606978679*deg ";
 $detector{"color"}       = "5f9ea0";
 $detector{"type"}        = "Operation: aak_C_EllipseUpperSlice - aaj_C_LowerPlaneCube";

 $detector{"dimensions"}  = "0";
	$detector{"material"}    = "Rohacell31";
	$detector{"sensitivity"} = "Mirrors";
	$detector{"hit_type"}    = "Mirrors";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
 $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
	
 print_det(\%detector, $file);
}

make_C_FinalMirrorRightM3L1();


sub make_C_CopiesLeft
{
    for(my $n=2; $n<7; $n++)
    {
	$detector{"name"}        = "aam_C_copyLeft_$n";
	$detector{"mother"}      = "HTCC";
	#$detector{"mother"}      = "root";
	$detector{"description"} = "mirror 3 $n";
	#$detector{"pos"}         = "246.189556*mm 918.79193*mm 212.7408*mm"; # old
	my $xpos = 951.2034*sin(($n*60-45)*(3.14159/180));
	my $ypos = 951.2034*cos(($n*60-45)*(3.14159/180));
	my $zpos = 212.7408 + $zshift;
	$detector{"pos"}         = "$xpos*mm $ypos*mm $zpos*mm"; # shifted 5m for sector
	my $rotation = $n*60-45;
	$detector{"rotation"}    = "ordered: yzx  0*deg $rotation*deg -12.606978679*deg ";
	$detector{"color"}       = "000080";
	$detector{"type"}        = "CopyOf aal_C_FinalMirrorLeftM3L1";

	$detector{"dimensions"}  = "0";
			$detector{"material"}    = "Rohacell31";
			$detector{"sensitivity"} = "Mirrors";
			$detector{"hit_type"}    = "Mirrors";
#			$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
	
	print_det(\%detector, $file);
    }
}

make_C_CopiesLeft();


sub make_C_CopiesRight
{
    for(my $n=2; $n<7; $n++)
    {
	$detector{"name"}        = "aam_C_copyRight_$n";
	$detector{"mother"}      = "HTCC";
	#$detector{"mother"}      = "root";
	$detector{"description"} = "mirror 3 $n";
	#$detector{"pos"}         = "-246.189556*mm 918.79193*mm 212.7408*mm"; # old
	my $xpos = 951.2034*sin((-$n*60+45)*(3.14159/180));
	my $ypos = 951.2034*cos((-$n*60+45)*(3.14159/180));
	my $zpos = 212.7408 + $zshift;
	$detector{"pos"}         = "$xpos*mm $ypos*mm $zpos*mm"; # shifted 5m for sector
	my $rotation = -$n*60+45;
	$detector{"rotation"}    = "ordered: yzx  0*deg $rotation*deg -12.606978679*deg ";
	$detector{"color"}       = "5f9ea0";
	$detector{"type"}        = "CopyOf aal_C_FinalMirrorRightM3L1";

	$detector{"dimensions"}  = "0";
			$detector{"material"}    = "Rohacell31";
			$detector{"sensitivity"} = "Mirrors";
			$detector{"hit_type"}    = "Mirrors";
#			$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
			
	print_det(\%detector, $file);
    }
}

make_C_CopiesRight();
