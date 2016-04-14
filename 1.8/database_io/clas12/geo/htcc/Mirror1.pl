#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use Getopt::Long;
use Math::Trig;


my $config_file = 'htcc.config';

# Load configuration
my %configuration = load_configuration($config_file); 

# Load parameters from mysql database
my %parameters    = download_parameters(%configuration);

# Assign paramters to local variables
#my $SteelFrameLength = $parameters{"SteelFrameLength"};

my $envelope = 'HTCCnateM1';
my $file     = 'HTCCnateM1.txt';

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

########## Mirror 1 (layer 1) ###################

sub make_InnerEllipsoid
{
 $detector{"name"}        = "aaa_InnerEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "ellipsoid for subtraction";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Ellipsoid";

 $detector{"dimensions"}  = "1728.6727*mm 1907.8098*mm 1728.6727*mm 0*mm 0*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_InnerEllipsoid();


sub make_OutterEllipsoid
{
 $detector{"name"}        = "aab_OutterEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "acrylic ellipsoid";
 $detector{"pos"}         = "0*mm 806.5149*mm -31.0234*mm";
 $detector{"rotation"}    = "2.202853259*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Ellipsoid";

 $detector{"dimensions"}  = "1728.9727*mm 1908.1098*mm 1728.9727*mm 0*mm 0*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_OutterEllipsoid();


sub make_EllipsoidialShell
{
 $detector{"name"}        = "aac_EllipsoidialShell";
 $detector{"mother"}      = "root";
 $detector{"description"} = "acrylic ellipsoid";
 $detector{"pos"}         = "0*mm 806.5149*mm -31.0234*mm";
 $detector{"rotation"}    = "2.202853259*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Operation:aab_OutterEllipsoid - aaa_InnerEllipsoid";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_EllipsoidialShell();


sub make_Cube
{
 $detector{"name"}        = "aad_Cube";
 $detector{"mother"}      = "root";
 $detector{"description"} = "big cube";
###### relative coords:
 # old $detector{"pos"}         = "0*mm -806.5149*mm -4968.9766*mm";
 $detector{"pos"}         = "0*mm -614.92349697*mm -4996.305017531*mm";
 $detector{"rotation"}    = "-2.202853259*deg 0*deg 0*deg";
###### absolute coords:
 #$detector{"pos"}         = "0*mm 0*mm -5000*mm";
 #$detector{"rotation"}    = "0*deg 0*deg 0*deg";
######
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Box";

 $detector{"dimensions"}  = "5000*mm 5000*mm 5000*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_Cube();


sub make_HalfEllipsoid
{
 $detector{"name"}        = "aae_HalfEllipsoid";
 $detector{"mother"}      = "root";
 $detector{"description"} = "half ellipsoid";
 $detector{"pos"}         = "0*mm 806.5149*mm -31.0234*mm";
 $detector{"rotation"}    = "2.202853259*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Operation: aac_EllipsoidialShell - aad_Cube";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_HalfEllipsoid();


sub make_OutterCylinder
{
 $detector{"name"}        = "aaf_OutterCylinder";
 $detector{"mother"}      = "root";
 $detector{"description"} = "big cylinder";
##### relative coords:
 $detector{"pos"}         = "0*mm -807.11135246*mm 0*mm";
 $detector{"rotation"}    = "-2.202853259*deg 0*deg 0*deg";
##### absolute coords:
 #$detector{"pos"}         = "0*mm 0*mm 0*mm";
 #$detector{"rotation"}    = "0*deg 0*deg 0*deg";
#####
 $detector{"color"}       = "ffee55";
 $detector{"type"}        = "Tube";

 $detector{"dimensions"}  = "1165.5073*mm 5500*mm 2500*mm 0*deg 360*deg";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_OutterCylinder();


sub make_PhiCylinder
{
 $detector{"name"}        = "aag_PhiCylinder";
 $detector{"mother"}      = "root";
 $detector{"description"} = "big cylinder with wedge cut";
##### relative coords:
 $detector{"pos"}         = "0*mm -807.11135246*mm 0*mm";
 $detector{"rotation"}    = "-2.202853259*deg 0*deg 0*deg";
##### absolute coords:
 #$detector{"pos"}         = "0*mm 0*mm 0*mm";
 #$detector{"rotation"}    = "0*deg 0*deg 0*deg";
#####
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Tube";

 $detector{"dimensions"}  = "0*mm 5000*mm 3000*mm 105*deg 330*deg";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_PhiCylinder();


sub make_EllipseSlicePhi
{
 $detector{"name"}        = "aah_EllipseSlicePhi";
 $detector{"mother"}      = "root";
 $detector{"description"} = "sliced ellipsoid";
 $detector{"pos"}         = "0*mm 806.5149*mm -31.0234*mm";
 $detector{"rotation"}    = "2.202853259*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Operation: aae_HalfEllipsoid - aag_PhiCylinder";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_EllipseSlicePhi();


sub make_EllipseSliceCylinder
{
 $detector{"name"}        = "aai_EllipseSliceCylinder";
 $detector{"mother"}      = "root";
 $detector{"description"} = "sliced ellipsoid";
 $detector{"pos"}         = "0*mm 806.5149*mm -31.0234*mm";
 $detector{"rotation"}    = "2.202853259*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Operation: aah_EllipseSlicePhi - aaf_OutterCylinder";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_EllipseSliceCylinder();


sub make_PlaneCube
{
 $detector{"name"}        = "aaj_PlaneCube";
 $detector{"mother"}      = "root";
 $detector{"description"} = "cube with top surface = dividing plane between M1 & M2";
##### relative coords:
 # old $detector{"pos"}         = "0*mm -977.224076318*mm 659.001853109*mm";
 # old $detector{"rotation"}    = "-46.642029273*deg 0*deg 0*deg";
 $detector{"pos"}         = "0*mm -1001.56229011859830*mm 620.952733133649076*mm";
 $detector{"rotation"}    = "-46.642029273*deg 0*deg 0*deg";
##### absolute coords:
 #$detector{"pos"}         = "0*mm -170.709176318*mm 627.978453109*mm";
 #$detector{"rotation"}    = "-44.439176014*deg 0*deg 0*deg";
#####
 $detector{"color"}       = "ee99ff";
 $detector{"type"}        = "Box";

 $detector{"dimensions"}  = "1500*mm 1500*mm 1500*mm";
 $detector{"material"}    = "Air";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_PlaneCube();


#sub make_FinalMirror
#{
# $detector{"name"}        = "aak_FinalMirrorM1L1";
# $detector{"mother"}      = "root";
# $detector{"description"} = "final mirror";
# $detector{"pos"}         = "0*mm 806.5149*mm -31.0234*mm";
# $detector{"rotation"}    = "2.202853259*deg 0*deg 0*deg";
# $detector{"color"}       = "ff0000";
# $detector{"type"}        = "Operation: aai_EllipseSliceCylinder - aaj_PlaneCube";

# $detector{"dimensions"}  = "0";
# $detector{"material"}    = "Air";
# #$detector{"material"}    = "Component";

# print_det(\%detector, $file);
#}

#make_FinalMirror();

 my $zshift = 0;

sub make_FinalMirrorLeft
{
 $detector{"name"}        = "aak_FinalMirrorLeftM1L1";
 #$detector{"name"}        = "Mirror1CopyL1";
 $detector{"mother"}      = "HTCC";
 #$detector{"mother"}      = "root";
 $detector{"description"} = "final mirror";
 my $zpos = -31.0234 + $zshift;
 $detector{"pos"}         = "208.7414163*mm 779.0335712*mm $zpos*mm";
 $detector{"rotation"}    = "ordered: yzx  0*deg 15*deg 2.202853259*deg ";
 $detector{"color"}       = "deb887";
 $detector{"type"}        = "Operation: aai_EllipseSliceCylinder - aaj_PlaneCube";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Rohacell31";
 $detector{"sensitivity"} = "Mirrors";
 $detector{"hit_type"}    = "Mirrors";
 #$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
 $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";

 print_det(\%detector, $file);
}

make_FinalMirrorLeft();



sub make_FinalMirrorRight
{
 $detector{"name"}        = "aak_FinalMirrorRightM1L1";
 #$detector{"name"}        = "Mirror1CopyR1";
 $detector{"mother"}      = "HTCC";
 #$detector{"mother"}      = "root";
 $detector{"description"} = "final mirror";
 my $zpos = -31.0234 + $zshift;
 $detector{"pos"}         = "-208.7414163*mm 779.0335712*mm $zpos*mm";
 $detector{"rotation"}    = "ordered: yzx  0*deg -15*deg 2.202853259*deg ";
 $detector{"color"}       = "f4a460";
 $detector{"type"}        = "Operation: aai_EllipseSliceCylinder - aaj_PlaneCube";

 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "Rohacell31";
 $detector{"sensitivity"} = "Mirrors";
 $detector{"hit_type"}    = "Mirrors";
# $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
 $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";

 print_det(\%detector, $file);
}

make_FinalMirrorRight();


sub make_CopiesLeft
{
    for(my $n=2; $n<7; $n++)
    {
	$detector{"name"}        = "aal_copyLeft_$n";
	#$detector{"name"}        = "Mirror1CopyL$n";
	$detector{"mother"}      = "HTCC";
	#$detector{"mother"}      = "root";
	$detector{"description"} = "mirror 1 $n";
	#$detector{"pos"}         = "208.7414163*mm 779.0335712*mm -31.0234*mm"; # old
	my $xpos = 806.5149*sin(($n*60-45)*(3.14159/180));
	my $ypos = 806.5149*cos(($n*60-45)*(3.14159/180));
	my $zpos = -31.0234 + $zshift;
	$detector{"pos"}         = "$xpos*mm $ypos*mm $zpos*mm"; # shifted 5m for sector
	my $rotation = $n*60-45;
	$detector{"rotation"}    = "ordered: yzx  0*deg $rotation*deg 2.202853259*deg ";
	$detector{"color"}       = "deb887";
	#$detector{"type"}        = "CopyOf Mirror1CopyL1";
	$detector{"type"}        = "CopyOf aak_FinalMirrorLeftM1L1";

	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Rohacell31";
	$detector{"sensitivity"} = "Mirrors";
	$detector{"hit_type"}    = "Mirrors";
	#$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";

	print_det(\%detector, $file);
    }
}

make_CopiesLeft();


sub make_D_CopiesRight
{
    for(my $n=2; $n<7; $n++)
    {
	$detector{"name"}        = "aam_copyRight_$n";
	#$detector{"name"}        = "Mirror1CopyR$n";
	$detector{"mother"}      = "HTCC";
	#$detector{"mother"}      = "root";
	$detector{"description"} = "mirror 1 $n";
	#$detector{"pos"}         = "-208.7414163*mm 779.0335712*mm -31.0234*mm"; # old
	my $xpos = 806.5149*sin((-$n*60+45)*(3.14159/180));
	my $ypos = 806.5149*cos((-$n*60+45)*(3.14159/180));
	my $zpos = -31.0234 + $zshift;
	$detector{"pos"}         = "$xpos*mm $ypos*mm $zpos*mm"; # shifted 5m for sector
	my $rotation = -$n*60+45;
	$detector{"rotation"}    = "ordered: yzx  0*deg $rotation*deg 2.202853259*deg ";
	$detector{"color"}       = "f4a460";
	#$detector{"type"}        = "CopyOf Mirror1CopyR1";
	$detector{"type"}        = "CopyOf aak_FinalMirrorRightM1L1";

	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Rohacell31";
	$detector{"sensitivity"} = "Mirrors";
	$detector{"hit_type"}    = "Mirrors";
#	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";
	$detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCCAlMgF2";

	print_det(\%detector, $file);
    }
}

make_D_CopiesRight();
