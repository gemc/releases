#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'BaBar_PVDIS_ec_forwardangle';

my $envelope = "solid_$DetectorName";
my $file     = "solid_$DetectorName.txt";

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

my $DetectorMother="root";

# C  -------------- Hodoscope 7 Full Absorber - preshower
# HOD9SLATS       1
# HOD9MEDIUM   638
# HOD9MOTHER  'SOLE' 
# HOD9IDTYPE     42
# HOD9GATE       50.
# HOD9THRES       0
# C 
# HOD9SHAP    'CONE'
# HOD9SIZE1   4.    110. 237.  114. 242.  
# HOD9TYPE        1
# HOD9POSX        0.
# HOD9POSY        0.
# HOD9POSZ       320.0
# C  
# C  ---  Shower
# HOD10SLATS       1
# HOD10MEDIUM   638
# HOD10MOTHER  'SOLE' 
# HOD10IDTYPE     42
# HOD10GATE       50.
# HOD10THRES       0
# C 
# HOD10SHAP    'CONE'
# HOD10SIZE1   11.    114. 242.  122. 258.
# HOD10TYPE        1
# HOD10POSX        0.
# HOD10POSY        0.
# HOD10POSZ       335.0

# sub make_ec_forwardangle_preshower
# {
#  my $material="Kryptonite";
#  my $color="0000ff";
#  my $z=320;
# 
#     $detector{"name"}        = "$DetectorName\_preshower";
#     $detector{"mother"}      = "$DetectorMother" ;
#     $detector{"description"} = $detector{"name"};
#     $detector{"pos"}        = "0*cm 0*cm $z*cm";
#     $detector{"rotation"}   = "0*deg 0*deg 0*deg";
#     $detector{"color"}      = $color;
#     $detector{"type"}       = "Cons";
#     my $Rmin1 = 110;
#     my $Rmax1 = 237;
#     my $Rmin2 = 114;
#     my $Rmax2 = 242;
#     my $Dz    = 4;
#     my $Sphi  = 0;
#     my $Dphi  = 360;
#     $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
#     $detector{"material"}   = "$material";
#     $detector{"mfield"}     = "no";
#     $detector{"ncopy"}      = 1;
#     $detector{"pMany"}       = 1;
#     $detector{"exist"}       = 1;
#     $detector{"visible"}     = 1;
#     $detector{"style"}       = 1;
#     $detector{"sensitivity"} = "FLUX";
#     $detector{"hit_type"}    = "FLUX";
#     $detector{"identifiers"} = "id manual 31";
#     print_det(\%detector, $file);
# }
# make_ec_forwardangle_preshower();
# 
# sub make_ec_forwardangle_shower
# {
#  my $material="Kryptonite";
#  my $color="0000ff";
#  my $z=335;
# 
#     $detector{"name"}        = "$DetectorName\_shower";
#     $detector{"mother"}      = "$DetectorMother" ;
#     $detector{"description"} = $detector{"name"};
#     $detector{"pos"}        = "0*cm 0*cm $z*cm";
#     $detector{"rotation"}   = "0*deg 0*deg 0*deg";
#     $detector{"color"}      = $color;
#     $detector{"type"}       = "Cons";
#     my $Rmin1 = 114;
#     my $Rmax1 = 242;
#     my $Rmin2 = 122;
#     my $Rmax2 = 258;
#     my $Dz    = 11;
#     my $Sphi  = 0;
#     my $Dphi  = 360;
#     $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
#     $detector{"material"}   = "$material";
#     $detector{"mfield"}     = "no";
#     $detector{"ncopy"}      = 1;
#     $detector{"pMany"}       = 1;
#     $detector{"exist"}       = 1;
#     $detector{"visible"}     = 1;
#     $detector{"style"}       = 1;
#     $detector{"sensitivity"} = "FLUX";
#     $detector{"hit_type"}    = "FLUX";
#     $detector{"identifiers"} = "id manual 32";
#     print_det(\%detector, $file);
# }
# make_ec_forwardangle_shower();

sub make_ec_forwardangle
{
 my $material="Kryptonite";
 my $color="0000ff";
 my $z=350;

    $detector{"name"}        = "$DetectorName";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color;
    $detector{"type"}       = "Cons";
    my $Rmin1 = 110;
    my $Rmax1 = 265;
    my $Rmin2 = 110;
    my $Rmax2 = 265;
    my $Dz    = 25;
    my $Sphi  = 0;
    my $Dphi  = 360;
    $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
    $detector{"material"}   = "$material";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "FLUX";
    $detector{"hit_type"}    = "FLUX";
    $detector{"identifiers"} = "id manual 3100000";
    print_det(\%detector, $file);
}
make_ec_forwardangle();