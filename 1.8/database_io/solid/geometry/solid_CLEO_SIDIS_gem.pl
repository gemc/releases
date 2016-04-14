#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'CLEO_SIDIS_gem';

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

# C GEM chamber
# HOD1SLATS       6
# HOD1MEDIUM    658
# HOD1MOTHER  'HALL' 
# HOD1IDTYPE     41
# HOD1GATE       50.
# HOD1THRES       0
# HOD1SHAP    'TUBE' 'TUBE' 'TUBE' 'TUBE' 'TUBE' 'TUBE'
# HOD1ROT       0      0      0     0       0     0
# HOD1SIZE1     50.00  80.    0.40
# HOD1SIZE2     28.0   93.    0.40
# HOD1SIZE3     31.5   107.5  0.40
# HOD1SIZE4     39.00  135.   0.40
# HOD1SIZE5     50.00  98.   0.40
# HOD1SIZE6     64.00  122.   0.40
# HOD1TYPE        1  2  3   4   5  6  
# HOD1POSX        6*0.
# HOD1POSY        6*0.
# HOD1POSZ        175. 200.  231.  282.  355.   442.

 my $material="GEMgas";

sub make_gem
{
 my $Nplate  = 6;
 # BaBar config
#  my @PlateZ  = (175.-350, 200.-350,  231.-350,  282.-350,  355.-350,   442.-350,);
#  my @Rin  = (50,28,31.5,39,50,64);
#  my @Rout = (80,93,107.5,135,98,122);
 my @PlateZ  = (-175, -155,  -135,  -120,  5, 92);
 my @Rin  = (46,25,28,30,46,58);
 my @Rout = (87,97,107,114,94,117);

 my $Dz   = 0.4;
 my $color="44ee11";

 for(my $n=1; $n<=$Nplate; $n++)
 {
    my $n_c     = cnumber($n-1, 1);
    $detector{"name"}        = "$DetectorName\_$n_c";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $PlateZ[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz*cm 0*deg 360*deg";
    $detector{"material"}   = "$material";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = $n;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "FLUX";
    $detector{"hit_type"}    = "FLUX";
    my $id=1000000+$n*100000;
    $detector{"identifiers"} = "id manual $id";
    print_det(\%detector, $file);
 }
}
make_gem();