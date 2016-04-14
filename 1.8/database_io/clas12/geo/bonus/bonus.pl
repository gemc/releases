#!/usr/bin/perl 

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

my $envelope = 'Bonus';
my $file     = 'Bonus.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


use Getopt::Long;
use Math::Trig;

###########################################################################################
# All dimensions in mm

my @radius  = (20.0,   30.0,  60.0,  63.0,  66.0, 69.0);   # Inner radii of Bonus 6 Layers: 2 mylar + aluminum, 3 gem, kapton
my @phispan = (180.0, 170.0, 170.0, 165.0, 160.0, 155.0);  # Phi Span of layers
my $z_half  = 105.0036;

my @first_layer_thick = (     0.006,  0.0001);
my @first_layer_mater = ('G4_MYLAR', 'G4_Al');
my @first_layer_color = ('330099', 'aaaaff', '330099', 'aaaaff');

my @gem_thick = (   0.005,        0.05,  0.005);
my @gem_mater = ( 'G4_Cu', 'G4_KAPTON', 'G4_Cu');
my @gem_color = ('661122',  '335566', '661122');

my $microgap_width = 0.001;


# mother volume
sub make_bonus
{
 $detector{"name"}        = $envelope;
 $detector{"mother"}      = "root";
 $detector{"description"} = "Bonus Detector";
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "eeeeff";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "19.5*mm 70*mm 110.0*mm 0*deg 360*deg";
 $detector{"material"}    = "G4_He";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 0;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";

 print_det(\%detector, $file);
}

# first two layers
sub make_first_layers
{
 my $which = shift;
 my $layer = shift;

 my $rmin  = 0;
 my $rmax  = 0;
 my $pspan = 0;
 my $mate  = "Air";


 if($layer == 0)
 {
    $rmin  = $radius[0];
    $rmax  = $rmin + $first_layer_thick[0];
    $pspan = $phispan[0];
    $mate  = $first_layer_mater[0];
 }

 if($layer == 1)
 {
    $rmin  = $radius[0] + $first_layer_thick[0] + $microgap_width;
    $rmax  = $rmin + $first_layer_thick[1];
    $pspan = $phispan[0];
    $mate  = $first_layer_mater[1];
 }

 if($layer == 2)
 {
    $rmin  = $radius[1];
    $rmax  = $rmin + $first_layer_thick[0];
    $pspan = $phispan[1];
    $mate  = $first_layer_mater[0];
 }

 if($layer == 3)
 {
    $rmin  = $radius[1] + $first_layer_thick[0] + $microgap_width;
    $rmax  = $rmin + $first_layer_thick[1];
    $pspan = $phispan[1];
    $mate  = $first_layer_mater[1];
 }

 my $phistart = 0;

 if($which == 0)
 {
    $phistart =  90 + (180 - $pspan)/2.0;
    $detector{"name"} = "first_layer_left_".$layer;
 }

 if($which == 1)
 {
    $phistart = 270 + (180 - $pspan)/2.0; 
    $detector{"name"} = "first_layer_right_".$layer;
 }

 $detector{"mother"}      =  $envelope;
 $detector{"description"} = "Layer ".$layer;
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $first_layer_color[$layer];
 $detector{"type"}        = "Tube";

 $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
 $detector{"material"}    = $mate;
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";

 print_det(\%detector, $file);
}


# three gem
sub make_gems
{
 my $which = shift;
 my $layer = shift;

 my $rmin  = 0;
 my $rmax  = 0;
 my $pspan = 0;
 my $color = "000000";
 my $mate  = "Air";

 # first gem
 if($layer == 0)
 {
    $rmin  = $radius[2];
    $rmax  = $rmin + $gem_thick[0];
    $pspan = $phispan[2];
    $color = $gem_color[0];
    $mate  = $gem_mater[0];
 }

 if($layer == 1)
 {
    $rmin  = $radius[2] + $gem_thick[0] + $microgap_width;
    $rmax  = $rmin + $gem_thick[1];
    $pspan = $phispan[2];
    $color = $gem_color[1];
    $mate  = $gem_mater[1];
 }

 if($layer == 2)
 {
    $rmin  = $radius[2] + $gem_thick[0] + $microgap_width + $gem_thick[1] + $microgap_width;
    $rmax  = $rmin + $gem_thick[2];
    $pspan = $phispan[2];
    $color = $gem_color[2];
    $mate  = $gem_mater[2];
 }

 # second gem
 if($layer == 3)
 {
    $rmin  = $radius[3];
    $rmax  = $rmin + $gem_thick[0];
    $pspan = $phispan[3];
    $color = $gem_color[0];
    $mate  = $gem_mater[0];
 }

 if($layer == 4)
 {
    $rmin  = $radius[3] + $gem_thick[0] + $microgap_width;
    $rmax  = $rmin + $gem_thick[1];
    $pspan = $phispan[3];
    $color = $gem_color[1];
    $mate  = $gem_mater[1];
 }

 if($layer == 5)
 {
    $rmin  = $radius[3] + $gem_thick[0] + $microgap_width + $gem_thick[1] + $microgap_width;
    $rmax  = $rmin + $gem_thick[2];
    $pspan = $phispan[3];
    $color = $gem_color[2];
    $mate  = $gem_mater[2];
 }

 # third gem
 if($layer == 6)
 {
    $rmin  = $radius[4];
    $rmax  = $rmin + $gem_thick[0];
    $pspan = $phispan[4];
    $color = $gem_color[0];
    $mate  = $gem_mater[0];
 }

 if($layer == 7)
 {
    $rmin  = $radius[4] + $gem_thick[0] + $microgap_width;
    $rmax  = $rmin + $gem_thick[1];
    $pspan = $phispan[4];
    $color = $gem_color[1];
    $mate  = $gem_mater[1];
 }

 if($layer == 8)
 {
    $rmin  = $radius[4] + $gem_thick[0] + $microgap_width + $gem_thick[1] + $microgap_width;
    $rmax  = $rmin + $gem_thick[2];
    $pspan = $phispan[4];
    $color = $gem_color[2];
    $mate  = $gem_mater[2];
 }


 my $phistart = 0;

 if($which == 0)
 {
    $phistart =  90 + (180 - $pspan)/2.0;
    $detector{"name"} = "gem_left_".$layer;
 }

 if($which == 1)
 {
    $phistart = 270 + (180 - $pspan)/2.0; 
    $detector{"name"} = "gemc_right_".$layer;
 }

 $detector{"mother"}      =  $envelope;
 $detector{"description"} = "gem layer ".$layer;
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $color;
 $detector{"type"}        = "Tube";

 $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
 $detector{"material"}    = $mate;
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";

 print_det(\%detector, $file);
}


sub make_sensitive_he
{
 my $which = shift;

 my $rmin  = $radius[1] + $first_layer_thick[0] + $microgap_width + $first_layer_thick[1] + $microgap_width;
 my $rmax  = $radius[2] - $microgap_width;
 my $pspan = $phispan[1];

 my $phistart = 0;

 if($which == 1)
 {
    $phistart =  90 + (180 - $pspan)/2.0;
    $detector{"name"} = "sensitive_he_left";
 }

 if($which == 2)
 {
    $phistart = 270 + (180 - $pspan)/2.0; 
    $detector{"name"} = "sensitive_he_right";
 }

 $detector{"mother"}      =  $envelope;
 $detector{"description"} = "Sensitive He";
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff8899";
 $detector{"type"}        = "Tube";

 $detector{"dimensions"}  = "$rmin*mm $rmax*mm $z_half*mm $phistart*deg $pspan*deg";
 $detector{"material"}    = "G4_He";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "Bonus";
 $detector{"hit_type"}    = "Bonus";
 $detector{"identifiers"} = "bonus manual $which";

 print_det(\%detector, $file);
}


make_bonus();

for(my $l = 0; $l < 4; $l++)
{
 make_first_layers(0, $l);
 make_first_layers(1, $l);
}

for(my $l = 0; $l < 9; $l++)
{
 make_gems(0, $l);
 make_gems(1, $l);
}

make_sensitive_he(1);
make_sensitive_he(2);





