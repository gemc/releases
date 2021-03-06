#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'CLEO_SIDIS_mrpc';

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

my $material="Scintillator"; # only an approximation

sub make_mrpc
{
 my $color="ff0000";
#  my $z=728-350;
#  my $z=398;
 my $z=400;

    $detector{"name"}        = "$DetectorName\_BaBar_SIDIS_mrpc";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color";
    $detector{"type"}       = "Cons";
#     my $Rmin1 = 105;
#     my $Rmax1 = 194;
#     my $Rmin2 = 106;
#     my $Rmax2 = 195;
#     my $Rmin1 = 115;
#     my $Rmax1 = 195;
#     my $Rmin2 = 115;
#     my $Rmax2 = 195;
    my $Rmin1 = 99;
    my $Rmax1 = 201;
    my $Rmin2 = 99;
    my $Rmax2 = 201;
    my $Dz    = 0.5;
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
    $detector{"identifiers"} = "id manual 4000000";
    print_det(\%detector, $file);
}
make_mrpc();