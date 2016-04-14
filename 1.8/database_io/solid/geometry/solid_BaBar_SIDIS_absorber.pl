#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'BaBar_SIDIS_absorber';

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
# }
# make_detector();

my $DetectorMother="root";

sub make_absorber_largeangle
{
 my $material="Kryptonite";
 my $color="000000";
 my $z=390-350;

    $detector{"name"}        = "$DetectorName\_largeangle";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color";
    $detector{"type"}       = "Cons";
    my $Rmin1 = 100;
    my $Rmax1 = 141;
    my $Rmin2 = 120;
    my $Rmax2 = 141;
    my $Dz    = 35;
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
make_absorber_largeangle();

sub make_absorber_forwarangle
{
 my $material="Kryptonite";
 my $color="000000";
 my $z=522.-350;

    $detector{"name"}        = "$DetectorName\_forwarangle";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color";
    $detector{"type"}       = "Cons";
    my $Rmin1 = 30;
    my $Rmax1 = 60;
    my $Rmin2 = 45;
    my $Rmax2 = 75;
    my $Dz    = 80;
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
make_absorber_forwarangle();