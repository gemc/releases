#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'HTCCnateM4';
my $file     = 'HTCCnateM4.txt';

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

########## Mirror 4 (layer 1) ###################

my $EcenterX41 = 0;
my $EcenterX41neg = -$EcenterX41;
my $EcenterY41 = 973.4736;
my $EcenterY41neg = -$EcenterY41;
my $EcenterZ41 = 353.8694;
my $EcenterZ41neg = -$EcenterZ41;

my $EradiusX41 = 1383.6210;
my $EradiusY41 = 1728.3754;
my $EradiusZ41 = 1383.6210;

my $EradiusX41outer = $EradiusX41 + 0.3;
my $EradiusY41outer = $EradiusY41 + 0.3;
my $EradiusZ41outer = $EradiusZ41 + 0.3;

my $ErotationX41 = -19.9768163;
my $ErotationX41neg = -$ErotationX41;

sub make_D_InnerEllipsoid
{
 $detector{"name"}        = "aaa_D_InnerEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "ellipsoid for subtraction";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Ellipsoid";

 $detector{"dimensions"}  = "$EradiusX41*mm $EradiusY41*mm $EradiusZ41*mm 0*mm 0*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_D_InnerEllipsoid();


sub make_D_OutterEllipsoid
{
 $detector{"name"}        = "aab_D_OutterEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "acrylic ellipsoid";
 $detector{"pos"}         = "$EcenterX41*mm $EcenterY41*mm $EcenterZ41*mm";
 $detector{"rotation"}    = "$ErotationX41*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Ellipsoid";

 $detector{"dimensions"}  = "$EradiusX41outer*mm $EradiusY41outer*mm $EradiusZ41outer*mm 0*mm 0*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_D_OutterEllipsoid();


sub make_D_EllipsoidialShell
{
 $detector{"name"}        = "aac_D_EllipsoidialShell";
 $detector{"mother"}      = "root";
 $detector{"description"} = "acrylic ellipsoid";
 $detector{"pos"}         = "$EcenterX41*mm $EcenterY41*mm $EcenterZ41*mm";
 $detector{"rotation"}    = "$ErotationX41*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Operation:aab_D_OutterEllipsoid - aaa_D_InnerEllipsoid";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_D_EllipsoidialShell();


sub make_D_Cube
{
 $detector{"name"}        = "aad_D_Cube";
 $detector{"mother"}      = "root";
 $detector{"description"} = "big cube";
 $detector{"pos"}         = "0*mm -800*mm -9350*mm";
 $detector{"rotation"}    = "$ErotationX41neg*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Box";

 $detector{"dimensions"}  = "10000*mm 10000*mm 10000*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_D_Cube();


sub make_D_HalfEllipsoid
{
 $detector{"name"}        = "aae_D_HalfEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "half ellipsoid";
 $detector{"pos"}         = "$EcenterX41*mm $EcenterY41*mm $EcenterZ41*mm";
 $detector{"rotation"}    = "$ErotationX41*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Operation: aac_D_EllipsoidialShell - aad_D_Cube";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_D_HalfEllipsoid();

my $PhiStart41 = 105;
my $DeltaPhi41 = 330;

sub make_D_PhiCylinder
{
 $detector{"name"}        = "aag_D_PhiCylinder";
 $detector{"mother"}      = "root";
 $detector{"description"} = "big cylinder with wedge cut";
#### absolute coords:
 #$detector{"pos"}         = "0*mm 0*mm 0*mm";
 #$detector{"rotation"}    = "0*deg 0*deg 0*deg";
#### relative coords:
 $detector{"pos"}         = "0*mm -1035.79650615*mm 0*mm";
 $detector{"rotation"}    = "$ErotationX41neg*deg 0*deg 0*deg";
####
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Tube";

 $detector{"dimensions"}  = "0*mm 5000*mm 4000*mm $PhiStart41*deg $DeltaPhi41*deg";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_D_PhiCylinder();


sub make_D_EllipseSlicePhi
{
 $detector{"name"}        = "aah_D_EllipseSlicePhi";
 $detector{"mother"}      = "root";
 $detector{"description"} = "sliced ellipsoid";
 $detector{"pos"}         = "$EcenterX41*mm $EcenterY41*mm $EcenterZ41*mm";
 $detector{"rotation"}    = "$ErotationX41*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Operation: aae_D_HalfEllipsoid - aag_D_PhiCylinder";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_D_EllipseSlicePhi();


sub make_D_UpperPlaneCube
{
 $detector{"name"}        = "aai_D_UpperPlaneCube";
 $detector{"mother"}      = "root";
 $detector{"description"} = "upper plane cube";
#### absolute coordinates:
 #$detector{"pos"}         = "0*mm 1206.06413*mm 3944.6019286*mm";
 #$detector{"rotation"}    = "-70.170320145*deg 0*deg 0*deg";
#### relative coordinates:
 $detector{"pos"}         = "0*mm 1445.33325895279268*mm 3295.21929909176743*mm";
 $detector{"rotation"}    = "-50.193503845*deg 0*deg 0*deg";
####
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Box";

 $detector{"dimensions"}  = "2500*mm 2500*mm 2500*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_D_UpperPlaneCube();


sub make_D_LowerCone
{
 $detector{"name"}        = "aaj_D_LowerCone";
 $detector{"mother"}      = "root";
 $detector{"description"} = "lower plane cube";
#### absolute coordinates:
 #$detector{"pos"}         = "0*mm 0*mm 2995*mm";
 #$detector{"rotation"}    = "0*deg 0*deg 0*deg";
#### relative coordinates:
 $detector{"pos"}         = "0*mm -12.5850469888612224*mm 2814.79365315480436*mm";
 $detector{"rotation"}    = "19.9768163*deg 0*deg 0*deg";
####
 $detector{"color"}       = "ff44ff";
 $detector{"type"}        = "Cons";

 $detector{"dimensions"}  = "0*mm 0.874886635*mm 0*mm 524.931981156*mm 2995*mm 0*deg 360*deg";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_D_LowerCone();


sub make_D_EllipseUpperSlice
{
 $detector{"name"}        = "aak_D_EllipseUpperSlice";
 $detector{"mother"}      = "root";
 $detector{"description"} = "sliced ellipsoid";
 $detector{"pos"}         = "$EcenterX41*mm $EcenterY41*mm $EcenterZ41*mm";
 $detector{"rotation"}    = "$ErotationX41*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Operation: aah_D_EllipseSlicePhi - aai_D_UpperPlaneCube";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_D_EllipseUpperSlice();


#sub make_D_FinalMirrorM4L1 # do not use this in the end
#{
# $detector{"name"}        = "aal_D_FinalMirrorM4L1";
# $detector{"mother"}      = "root";
# $detector{"description"} = "mirror 4";
# $detector{"pos"}         = "$EcenterX41*mm $EcenterY41*mm $EcenterZ41*mm";
# $detector{"rotation"}    = "-19.9768163*deg 0*deg 0*deg";
# $detector{"color"}       = "ffffff";
# $detector{"type"}        = "Operation: aak_D_EllipseUpperSlice - aaj_D_LowerCone";

# $detector{"dimensions"}  = "0";
# $detector{"material"}    = "Air";
# $detector{"material"}    = "Component";

# print_det(\%detector, $file);
#}

#make_D_FinalMirrorM4L1();

my $zshift = 0;

sub make_D_FinalMirrorLeftM4L1
{
 $detector{"name"}        = "aal_D_FinalMirrorLeftM4L1";
 $detector{"mother"}      = "HTCC";
 #$detector{"mother"}      = "root";
 $detector{"description"} = "mirror 4";
 my $zpos = 353.8694 + $zshift;
 $detector{"pos"}         = "251.953508*mm 940.303292*mm $zpos*mm";
 $detector{"rotation"}    = "ordered: yzx  0*deg 15*deg -19.9768163*deg ";
 $detector{"color"}       = "ffd700";
 $detector{"type"}        = "Operation: aak_D_EllipseUpperSlice - aaj_D_LowerCone";

 $detector{"dimensions"}  = "0";
	$detector{"material"}    = "Rohacell31";
	$detector{"sensitivity"} = "Mirrors";
        $detector{"hit_type"}    = "Mirrors";
	#$detector{"identifiers"} = "Mirror WithSurface: 0 With Finish: 0 WithBorderVolume:: HTCC";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
 $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume:: HTCC";
 print_det(\%detector, $file);
}

make_D_FinalMirrorLeftM4L1();


sub make_D_FinalMirrorRightM4L1
{
 $detector{"name"}        = "aal_D_FinalMirrorRightM4L1";
 $detector{"mother"}      = "HTCC";
 #$detector{"mother"}      = "root";
 $detector{"description"} = "mirror 4";
 my $zpos = 353.8694 + $zshift;
 $detector{"pos"}         = "-251.953508*mm 940.303292*mm $zpos*mm";
 $detector{"rotation"}    = "ordered: yzx  0*deg -15*deg -19.9768163*deg ";
 $detector{"color"}       = "778899";
 $detector{"type"}        = "Operation: aak_D_EllipseUpperSlice - aaj_D_LowerCone";

 $detector{"dimensions"}  = "0";
	$detector{"material"}    = "Rohacell31";
	$detector{"sensitivity"} = "Mirrors";
	$detector{"hit_type"}    = "Mirrors";
	#$detector{"identifiers"} = "Mirror With Properties: Surfaces : dielectric_dielectric Finish : polished BorderVolume : HTCC Reflectivity : 0.99 Refractive_Index : 1.2";
	#$detector{"identifiers"} = "Mirror WithSurface: 0 With Finish: 0 WithBorderVolume:: HTCC";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
#        $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume:: HTCC";
 $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
 print_det(\%detector, $file);
}

make_D_FinalMirrorRightM4L1();


sub make_D_CopiesLeft
{
    for(my $n=2; $n<7; $n++)
    {
	$detector{"name"}        = "aam_D_copyLeft_$n";
	$detector{"mother"}      = "HTCC";
	#$detector{"mother"}      = "root";
	$detector{"description"} = "mirror 4 $n";
	#$detector{"pos"}         = "251.953508*mm 940.303292*mm 353.8694*mm"; # old
	my $xpos = $EcenterY41*sin(($n*60-45)*(3.14159/180));
	my $ypos = $EcenterY41*cos(($n*60-45)*(3.14159/180));
	my $zpos = 353.8694 + $zshift;
	$detector{"pos"}         = "$xpos*mm $ypos*mm $zpos*mm"; # shifted 5m for sector
	my $rotation = $n*60-45;
	$detector{"rotation"}    = "ordered: yzx  0*deg $rotation*deg -19.9768163*deg ";
	$detector{"color"}       = "ffd700";
	$detector{"type"}        = "CopyOf aal_D_FinalMirrorLeftM4L1";

	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Rohacell31";
	$detector{"sensitivity"} = "Mirrors";
	$detector{"hit_type"}    = "Mirrors";
	#$detector{"identifiers"} = "Mirror WithSurface: 0 With Finish: 0 WithBorderVolume:: HTCC";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume:: HTCC";
	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
	print_det(\%detector, $file);
    }
}

make_D_CopiesLeft();


sub make_D_CopiesRight
{
    for(my $n=2; $n<7; $n++)
    {
	$detector{"name"}        = "aam_D_copyRight_$n";
	$detector{"mother"}      = "HTCC";
	#$detector{"mother"}      = "root";
	$detector{"description"} = "mirror 4 $n";
	#$detector{"pos"}         = "-251.953508*mm 940.303292*mm 353.8694*mm"; # old
	my $xpos = $EcenterY41*sin((-$n*60+45)*(3.14159/180));
	my $ypos = $EcenterY41*cos((-$n*60+45)*(3.14159/180));
	my $zpos = 353.8694 + $zshift;
	$detector{"pos"}         = "$xpos*mm $ypos*mm $zpos*mm"; # shifted 5m for sector
	my $rotation = -$n*60+45;
	$detector{"rotation"}    = "ordered: yzx  0*deg $rotation*deg -19.9768163*deg ";
	$detector{"color"}       = "778899";
	$detector{"type"}        = "CopyOf aal_D_FinalMirrorRightM4L1";

	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Rohacell31";
	$detector{"sensitivity"} = "Mirrors";
	$detector{"hit_type"}    = "Mirrors";
	#$detector{"identifiers"} = "Mirror WithSurface: 0 With Finish: 0 WithBorderVolume:: HTCC";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume:: HTCC";
	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
	print_det(\%detector, $file);
    }
}

make_D_CopiesRight();
