#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'BaBar_SIDIS_cherenkov_heavygas';

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

sub make_cherenkov_heavygas
{
 my $material="CCGas"; # currently CF gas used for clas12
 my $color="ffffc0";
#  my $z=691-350;
 my $z=351;

    $detector{"name"}        = "$DetectorName";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color";
    $detector{"type"}       = "Cons";
#     my $Rmin1 = 96;
#     my $Rmax1 = 265;
#     my $Rmin2 = 104;
#     my $Rmax2 = 265;
#     my $Dz    = 35;
    my $Rmin1 = 96;
    my $Rmax1 = 265;
    my $Rmin2 = 113;
    my $Rmax2 = 265;
    my $Dz    = 45;
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
make_cherenkov_heavygas();

sub make_detector_lightout
{
 $detector{"name"}        = "$DetectorName\_lightout";
 $detector{"mother"}      = "$DetectorName";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -36*cm"; #315-351=-36
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "003333";
 $detector{"type"}        = "Cons";
 my $Rmin1 = 230-15.6/2.*sin(46./180.*3.1415926);
 my $Rmax1 = $Rmin1+0.1;
 my $Rmin2 = 230+15.6/2.*sin(46./180.*3.1415926);
 my $Rmax2 = $Rmin2+0.1;
 my $Dz    = 15.6/2.*cos(46./180.*3.1415926);
 my $Sphi  = 0;
 my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "FLUX";
 $detector{"hit_type"}    = "FLUX";
 $detector{"identifiers"} = "id manual 2200000";
 print_det(\%detector, $file);
}
make_detector_lightout();