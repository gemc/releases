#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'HTCCnateM2';
my $file     = 'HTCCnateM2.txt';

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

########## Mirror 2 (layer 1) ###################

sub make_B_InnerEllipsoid
{
 $detector{"name"}        = "aaa_B_InnerEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "ellipsoid for subtraction";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Ellipsoid";

 $detector{"dimensions"}  = "1612.9985*mm 1846.1550*mm 1612.9985*mm 0*mm 0*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_B_InnerEllipsoid();


sub make_B_OutterEllipsoid
{
 $detector{"name"}        = "aab_B_OutterEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "acrylic ellipsoid";
 $detector{"pos"}         = "0*mm 894.3460*mm 81.6664*mm";
 $detector{"rotation"}    = "-5.217443165*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Ellipsoid";

 $detector{"dimensions"}  = "1613.2985*mm 1846.4550*mm 1613.2985*mm 0*mm 0*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_B_OutterEllipsoid();


sub make_B_EllipsoidialShell
{
 $detector{"name"}        = "aac_B_EllipsoidialShell";
 $detector{"mother"}      = "root";
 $detector{"description"} = "acrylic ellipsoid";
 $detector{"pos"}         = "0*mm 894.3460*mm 81.6664*mm";
 $detector{"rotation"}    = "-5.217443165*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Operation:aab_B_OutterEllipsoid - aaa_B_InnerEllipsoid";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_B_EllipsoidialShell();


sub make_B_Cube
{
 $detector{"name"}        = "aad_B_Cube";
 $detector{"mother"}      = "root";
 $detector{"description"} = "big cube";
 #$detector{"pos"}         = "0*mm -894.3460*mm -10081.6664*mm"; # old
 $detector{"pos"}         = "0*mm -800*mm -9500*mm"; # new
 $detector{"rotation"}    = "5.217443165*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Box";

 $detector{"dimensions"}  = "10000*mm 10000*mm 10000*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_B_Cube();


sub make_B_HalfEllipsoid
{
 $detector{"name"}        = "aae_B_HalfEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "half ellipsoid";
 $detector{"pos"}         = "0*mm 894.3460*mm 81.6664*mm";
 $detector{"rotation"}    = "-5.217443165*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Operation: aac_B_EllipsoidialShell - aad_B_Cube";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_B_HalfEllipsoid();


sub make_B_PhiCylinder
{
 $detector{"name"}        = "aag_B_PhiCylinder";
 $detector{"mother"}      = "root";
 $detector{"description"} = "big cylinder with wedge cut";
 $detector{"pos"}         = "0*mm -898.06690653*mm 0*mm";
 $detector{"rotation"}    = "5.217443165*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Tube";

 $detector{"dimensions"}  = "0*mm 5000*mm 3000*mm 105*deg 330*deg";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_B_PhiCylinder();


sub make_B_EllipseSlicePhi
{
 $detector{"name"}        = "aah_B_EllipseSlicePhi";
 $detector{"mother"}      = "root";
 $detector{"description"} = "sliced ellipsoid";
 $detector{"pos"}         = "0*mm 894.3460*mm 81.6664*mm";
 $detector{"rotation"}    = "-5.217443165*deg 0*deg 0*deg";
 $detector{"color"}       = "ffee55";
 $detector{"type"}        = "Operation: aae_B_HalfEllipsoid - aag_B_PhiCylinder";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_B_EllipseSlicePhi();


sub make_B_UpperPlaneCube
{
 $detector{"name"}        = "aai_B_UpperPlaneCube";
 $detector{"mother"}      = "root";
 $detector{"description"} = "upper plane cube";
#### absolute coordinates:
 #$detector{"pos"}         = "0*mm 4470.252588*mm 5178.964489*mm";
 #$detector{"rotation"}    = "-44.439176014*deg 0*deg 0*deg";
#### relative coordinates:
 # old $detector{"pos"}         = "0*mm 3575.906588*mm 5097.298089*mm";
 # old $detector{"rotation"}    = "-39.221732849*deg 0*deg 0*deg";
 $detector{"pos"}         = "0*mm 4024.61744426893347*mm 4751.00096413795200*mm";
 $detector{"rotation"}    = "-39.221732849*deg 0*deg 0*deg";
####
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Box";

 $detector{"dimensions"}  = "5000*mm 5000*mm 5000*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_B_UpperPlaneCube();


sub make_B_LowerPlaneCube
{
 $detector{"name"}        = "aaj_B_LowerPlaneCube";
 $detector{"mother"}      = "root";
 $detector{"description"} = "lower plane cube";
#### absolute coordinates:
 #$detector{"pos"}         = "0*mm -2079.700174*mm -2545.66512*mm";
 #$detector{"rotation"}    = "-57.335635361*deg 0*deg 0*deg";
#### relative coordinates:
 # old $detector{"pos"}         = "0*mm -2974.046174*mm -2627.33152*mm";
 # old $detector{"rotation"}    = "-52.118192196*deg 0*deg 0*deg";
 $detector{"pos"}         = "0*mm -3200.64238593233904*mm -2345.99869534849950*mm";
 $detector{"rotation"}    = "-52.118192196*deg 0*deg 0*deg";
####
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Box";

 $detector{"dimensions"}  = "5000*mm 5000*mm 5000*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_B_LowerPlaneCube();


sub make_B_EllipseUpperSlice
{
 $detector{"name"}        = "aak_B_EllipseUpperSlice";
 $detector{"mother"}      = "root";
 $detector{"description"} = "sliced ellipsoid";
 $detector{"pos"}         = "0*mm 894.3460*mm 81.6664*mm";
 $detector{"rotation"}    = "-5.217443165*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Operation: aah_B_EllipseSlicePhi - aai_B_UpperPlaneCube";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_B_EllipseUpperSlice();


#sub make_B_FinalMirrorM2L1
#{
# $detector{"name"}        = "aal_B_FinalMirrorM2L1";
# $detector{"mother"}      = "root";
# $detector{"description"} = "mirror 2";
# $detector{"pos"}         = "0*mm 894.3460*mm 81.6664*mm";
# $detector{"rotation"}    = "-5.217443165*deg 0*deg 0*deg";
# $detector{"color"}       = "2e8b57";
# $detector{"type"}        = "Operation: aak_B_EllipseUpperSlice - aaj_B_LowerPlaneCube";

# $detector{"dimensions"}  = "0";
# $detector{"material"}    = "Air";
# #$detector{"material"}    = "Component";

# print_det(\%detector, $file);
#}

#make_B_FinalMirrorM2L1();

my $zshift = 0;

sub make_B_FinalMirrorLeftM2L1
{
 $detector{"name"}        = "aal_B_FinalMirrorLeftM2L1";
 $detector{"mother"}      = "HTCC";
 #$detector{"mother"}      = "root";
 $detector{"description"} = "mirror 2";
 my $zpos = 81.6664 + $zshift;
 $detector{"pos"}         = "231.473778*mm 863.871899*mm $zpos*mm";
 $detector{"rotation"}    = "ordered: yzx  0*deg 15*deg -5.217443165*deg ";
 $detector{"color"}       = "2e8b57";
 $detector{"type"}        = "Operation: aak_B_EllipseUpperSlice - aaj_B_LowerPlaneCube";

 $detector{"dimensions"}  = "0";
	$detector{"material"}    = "Rohacell31";
	$detector{"sensitivity"} = "Mirrors";
	$detector{"hit_type"}    = "Mirrors";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2 ";
 $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2 ";	
 print_det(\%detector, $file);
}

make_B_FinalMirrorLeftM2L1();


sub make_B_FinalMirrorRightM2L1
{
 $detector{"name"}        = "aal_B_FinalMirrorRightM2L1";
 $detector{"mother"}      = "HTCC";
 #$detector{"mother"}      = "root";
 $detector{"description"} = "mirror 2";
 my $zpos = 81.6664 + $zshift;
 $detector{"pos"}         = "-231.473778*mm 863.871899*mm $zpos*mm";
 $detector{"rotation"}    = "ordered: yzx  0*deg -15*deg -5.217443165*deg ";
 $detector{"color"}       = "6b8e23";
 $detector{"type"}        = "Operation: aak_B_EllipseUpperSlice - aaj_B_LowerPlaneCube";

 $detector{"dimensions"}  = "0";
	$detector{"material"}    = "Rohacell31";
	$detector{"sensitivity"} = "Mirrors";
	$detector{"hit_type"}    = "Mirrors";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2 ";
 $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2 ";
	
 print_det(\%detector, $file);
}

make_B_FinalMirrorRightM2L1();


sub make_B_CopiesLeft
{
    for(my $n=2; $n<7; $n++)
    {
	$detector{"name"}        = "aam_B_copyLeft_$n";
	$detector{"mother"}      = "HTCC";
	#$detector{"mother"}      = "root";
	$detector{"description"} = "mirror 2 $n";
	#$detector{"pos"}         = "231.473778*mm 863.871899*mm 81.6664*mm"; # old 
	my $xpos = 894.3460*sin(($n*60-45)*(3.14159/180));
	my $ypos = 894.3460*cos(($n*60-45)*(3.14159/180));
	my $zpos = 81.6664 + $zshift;
	$detector{"pos"}         = "$xpos*mm $ypos*mm $zpos*mm"; # shifted 5m for sector
	my $rotation = $n*60-45;
	$detector{"rotation"}    = "ordered: yzx  0*deg $rotation*deg -5.217443165*deg ";
	$detector{"color"}       = "2e8b57";
	$detector{"type"}        = "CopyOf aal_B_FinalMirrorLeftM2L1";

	$detector{"dimensions"}  = "0";
			$detector{"material"}    = "Rohacell31";
			$detector{"sensitivity"} = "Mirrors";
			$detector{"hit_type"}    = "Mirrors";
	#		$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2 ";
	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2 ";			
	print_det(\%detector, $file);
    }
}

make_B_CopiesLeft();


sub make_B_CopiesRight
{
    for(my $n=2; $n<7; $n++)
    {
	$detector{"name"}        = "aam_B_copyRight_$n";
	$detector{"mother"}      = "HTCC";
	#$detector{"mother"}      = "root";
	$detector{"description"} = "mirror 2 $n";
	#$detector{"pos"}         = "-231.473778*mm 863.871899*mm 81.6664*mm"; # old
	my $xpos = 894.3460*sin((-$n*60+45)*(3.14159/180));
	my $ypos = 894.3460*cos((-$n*60+45)*(3.14159/180));
	my $zpos = 81.6664 + $zshift;
	$detector{"pos"}         = "$xpos*mm $ypos*mm $zpos*mm"; # shifted 5m for sector
	my $rotation = -$n*60+45;
	$detector{"rotation"}    = "ordered: yzx  0*deg $rotation*deg -5.217443165*deg ";
	$detector{"color"}       = "6b8e23";
	$detector{"type"}        = "CopyOf aal_B_FinalMirrorRightM2L1";

	$detector{"dimensions"}  = "0";
			$detector{"material"}    = "Rohacell31";
	$detector{"sensitivity"} = "Mirrors";
	$detector{"hit_type"}    = "Mirrors";
	#$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2 ";
	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2 ";

	print_det(\%detector, $file);
    }
}

make_B_CopiesRight();
