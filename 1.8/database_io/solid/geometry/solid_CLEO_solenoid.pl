#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'CLEO_solenoid';

my $envelope = "solid_$DetectorName";
my $file     = "solid_$DetectorName.txt";

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

#build from Poisson input file CLEOv8.am, add/substract 0.01cm at various interface to avoid overlap 

my $DetectorMother="root";

sub make_coil_yoke
{
 my $NUM  = 17;
 my @name = ("Coil","BarrelYokeInner","BarrelYokeOuter","SlabSpacerUpstream","SlabSpacerDownstream","CoilCollarUpstream","CoilCollarDownstream","EndcapDonut","EndcapBottomInner","EndcapBottomOuter","EndcapNose","FrontPiece","UpstreamShield1","UpstreamShield2","UpstreamShield3","UpstreamShield4","UpstreamShield5");
 my $material_coil = "Aluminum";
 my $material_yoke = "Iron";
 my $color_coil = "ff8000";
 my $color_yoke = "F63BFF";
 
 for(my $n=1; $n<=$NUM; $n++)
 {
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = $DetectorMother;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm 0*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    if ($n==1) {$detector{"color"} = $color_coil;}
    else {$detector{"color"} = $color_yoke;}
    $detector{"type"}       = "Polycone";
    if ($n==1) {$detector{"dimensions"} = "0*deg 360*deg 2 152.30*cm 152.30*cm 154.30*cm 154.30*cm -173.80*cm 173.80*cm";} # Coil
    if ($n==2) {$detector{"dimensions"} = "0*deg 360*deg 4 177.91*cm 177.91*cm 176.60*cm 176.60*cm 212.60*cm 212.60*cm 212.60*cm 212.60*cm -266.50*cm -189.00*cm -189.00*cm 189.00*cm";} # BarrelYokeInner
    if ($n==3) {$detector{"dimensions"} = "0*deg 360*deg 2 221.51*cm 221.51*cm 257.50*cm 257.50*cm -266.50*cm 189.00*cm";} # BarrelYokeOuter 
    if ($n==4) {$detector{"dimensions"} = "0*deg 360*deg 2 212.61*cm 212.61*cm 221.50*cm 221.50*cm -266.50*cm -235.90*cm";} # SlabSpacerUpstream
    if ($n==5) {$detector{"dimensions"} = "0*deg 360*deg 2 212.61*cm 212.61*cm 221.50*cm 221.50*cm 159.00*cm 189.00*cm";} # SlabSpacerDownstream 
    if ($n==6) {$detector{"dimensions"} = "0*deg 360*deg 2 144.01*cm 144.01*cm 177.90*cm 177.90*cm -266.50*cm -189.01*cm";} # CoilCollarUpstream 
    if ($n==7) {$detector{"dimensions"} = "0*deg 360*deg 3 144.00*cm 144.00*cm 156.00*cm 285.00*cm 285.00*cm 285.00*cm 189.01*cm 193.00*cm 209.00*cm";} # CoilCollarDownstream 
    if ($n==8) {$detector{"dimensions"} = "0*deg 360*deg 2 270.00*cm 270.00*cm 285.00*cm 285.00*cm 209.01*cm 485.00*cm";} # EndcapDonut
    if ($n==9) {$detector{"dimensions"} = "0*deg 360*deg 2 30.00*cm 30.00*cm 285.00*cm 285.00*cm 485.01*cm 500.00*cm";} # EndcapBottomInner
    if ($n==10) {$detector{"dimensions"} = "0*deg 360*deg 2 30.00*cm 45.00*cm 185.00*cm 170.00*cm 500.01*cm 515.00*cm";} # EndcapBottomOuter
    if ($n==11) {$detector{"dimensions"} = "0*deg 360*deg 3 20.00*cm 30.00*cm 30.00*cm 60.00*cm 90.00*cm 90.00*cm 189.00*cm 405.00*cm 485.00*cm";} # EndcapNose
    if ($n==12) {$detector{"dimensions"} = "0*deg 360*deg 2 55.60*cm 70.00*cm 144.00*cm 144.00*cm -237.00*cm -207.00*cm";} # FrontPiece
    if ($n==13) {$detector{"dimensions"} = "0*deg 360*deg 2 48.50*cm 50.50.00*cm 144.00*cm 144.00*cm -250.50*cm -246.50*cm";} # UpstreamShield1
    if ($n==14) {$detector{"dimensions"} = "0*deg 360*deg 2 44.60*cm 46.50.00*cm 144.00*cm 144.00*cm -258.50*cm -254.50*cm";} # UpstreamShield2
    if ($n==15) {$detector{"dimensions"} = "0*deg 360*deg 2 40.10*cm 42.70*cm 144.00*cm 144.00*cm -266.50*cm -262.50*cm";} # UpstreamShield3
    if ($n==16) {$detector{"dimensions"} = "0*deg 360*deg 2 36.80*cm 38.80*cm 257.50*cm 257.50*cm -274.50*cm -270.50*cm";} # UpstreamShield4
    if ($n==17) {$detector{"dimensions"} = "0*deg 360*deg 2 33.90*cm 35.30*cm 257.50*cm 257.50*cm -280.50*cm -277.50*cm";} # UpstreamShield5
    if ($n==1) {$detector{"material"} = $material_coil;}
    else {$detector{"material"} = $material_yoke;}
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}	     = 1;
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
make_coil_yoke();

# from CLEO-II NIM paper "The cryostat consists of a 12 mm thick outer cylinder, a 10 mm inner cylinder and two 20 mm thick end flanges which are bolted and sealed with O-rings."

sub make_cryostat
{
 my $Nplate  = 4;
 my @PlateZ  = (0, 0, -(189.00-1),189.00-1);
 my @Rin  = (144.00,176.60-0.12,144.00,144.00);
 my @Rout = (144.00+0.10,176.60-0.01,176.60-0.01,176.60-0.01);
 my @Dz   = ((189*2-2-2)/2,(189*2-2-2)/2,2/2-0.005,2/2-0.005);
 my @name = ("CryostatInner","CryostatOuter","CryostatFlangeUpstream","CryostatFlangeDownstream");
 my $material="StainlessSteel";
 my $color="ffffff";

 for(my $n=0; $n<=$Nplate; $n++)
 {
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $PlateZ[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"material"}   = "$material";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = 1;
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
make_cryostat();