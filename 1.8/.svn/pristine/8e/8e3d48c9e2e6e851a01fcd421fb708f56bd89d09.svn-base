#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'BaBar_SIDIS_ec_largeangle';

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

# HOD3SLATS       1
# HOD3MEDIUM    654
# HOD3MOTHER   'HALL' 
# HOD3IDTYPE       42
# HOD3GATE       80.
# HOD3THRES       0
# HOD3SHAP      'CONE'
# HOD3SIZE1      11.  82.00  134. 89. 141.  
# HOD3TYPE        1
# HOD3POSX        0.
# HOD3POSY        0.
# HOD3POSZ        295.5

sub make_ec_largeangle
{
 my $material="Kryptonite";
 my $color="0000ff";
#  my $z=295.5-350;
 my $z=-50.5;

    $detector{"name"}        = "$DetectorName";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color;
    $detector{"type"}       = "Cons";
#     my $Rmin1 = 82;
#     my $Rmax1 = 134;
#     my $Rmin2 = 89;
#     my $Rmax2 = 141;
#     my $Dz    = 11;
    my $Rmin1 = 82;
    my $Rmax1 = 141;
    my $Rmin2 = 82;
    my $Rmax2 = 141;
    my $Dz    = 15;
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
    $detector{"identifiers"} = "id manual 3200000";
    print_det(\%detector, $file);
}
make_ec_largeangle();