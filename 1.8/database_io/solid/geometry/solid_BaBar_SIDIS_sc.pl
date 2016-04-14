#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'BaBar_SIDIS_sc';

my $envelope = "solid_$DetectorName";
my $file     = "solid_$DetectorName.txt";

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

# sub make_detector
# {
#     $detector{"name"}        = "$DetectorName";
#     $detector{"mother"}      = "root" ;
#     $detector{"description"} = $detector{"name"};
#     $detector{"pos"}        = "0*cm 0*cm 0*cm";
#     $detector{"rotation"}   = "0*deg 0*deg 0*deg";
#     $detector{"color"}      = "00ff00";
#     $detector{"type"}       = "Tube";
#     $detector{"dimensions"} = "0*cm 150*cm 170*cm 0*deg 360*deg";
#     $detector{"material"}   = "Vacuum";
#     $detector{"mfield"}     = "no";
#     $detector{"ncopy"}      = 1;
#     $detector{"pMany"}       = 1;
#     $detector{"exist"}       = 1;
#     $detector{"visible"}     = 0;
#     $detector{"style"}       = 0;
#     $detector{"sensitivity"} = "no";
#     $detector{"hit_type"}    = "";
#     $detector{"identifiers"} = "";
#     print_det(\%detector, $file);
# 
# }
# make_detector();

my $DetectorMother="root";

# HOD4SLATS       1
# HOD4MEDIUM    625
# HOD4MOTHER   'HALL' 
# HOD4IDTYPE       46
# HOD4GATE       100.
# HOD4THRES       0
# HOD4SHAP      'CONE'
# HOD4SIZE1      0.25  95.00  177. 95. 177.  
# HOD4TYPE        1
# HOD4POSX        0.
# HOD4POSY        0.
# HOD4POSZ        654.

# GPARMED14  625 'Scintillator  mf$   '  25  1  1 30. -1. -1.   -1.   0.1    -1. 

sub make_sc
{
 my $material="Scintillator";
 my $color="2230ff";
 my $z=654-350;

    $detector{"name"}        = "$DetectorName\_sc";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color";
    $detector{"type"}       = "Cons";
    my $Rmin1 = 95;
    my $Rmax1 = 177;
    my $Rmin2 = 95;
    my $Rmax2 = 177;
    my $Dz    = 0.25;
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
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = "";
    print_det(\%detector, $file);
}
make_sc();