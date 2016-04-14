#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'CLEO_PVDIS_gem';

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

# C  ================ Collimator wheel 5  =================================
# RMATR48  90.0    -0.90  90.    89.10  0.  0.
# C      ----  absorber wheel ----
# PARVOL114 'WL05' 215 'SOLE'  0.  0.    152.0  48  'TUBE' 3     28.9   140.0  4.5
# C      ----  detector wheel ----
# PARVOL115 'WD05' 215 'SOLE'  0.  0.    157.5   0  'TUBE' 3     28.9   140.0  0.5
# C      ---- Internal ring ----
# PARVOL116 'WA05' 200 'WL05'  0.  0.     0.     0  'TUBE' 3     28.9    49.2  4.5
# C      ---- External ring ----
# PARVOL117 'WB05' 200 'WL05'  0.  0.     0.     0  'TUBE' 3    112.8   140.0  4.5
# PARVOL115 'WD05' 215 'SOLE'  0.  0.    157.5   0  'TUBE' 3     28.9   140.0  0.5
# C  -------------- Hodoscope 5 --------
# PARVOL139 'WC05' 209 'WD05'  0.  0.     -0.4999   0  'TUBE' 3   48.70 113.30  0.0001
# VOLPOS160 'WC05'     'WD05'  0.  0.      0.4999   0  
# HOD5SLATS       1
# HOD5MEDIUM   636
# HOD5MOTHER  'WD05' 
# HOD5IDTYPE     41
# HOD5GATE       50.
# HOD5THRES       0
# C 
# HOD5SHAP    'TUBE'
# HOD5SIZE1     48.70 113.30   0.48000
# HOD5TYPE        1
# HOD5POSX        0.
# HOD5POSY        0.
# HOD5POSZ        0.
# C  ================ Collimator wheel 6  =================================
# RMATR49  90.0     0.10  90.    90.10  0.  0.
# C      ----  absorber wheel ----
# PARVOL140 'WL06' 215 'SOLE'  0.  0.    180.0  49  'TUBE' 3     33.8   140.0  4.5
# C      ----  detector wheel ----
# PARVOL141 'WD06' 215 'SOLE'  0.  0.    185.5   0  'TUBE' 3     33.8   140.0  0.5
# C      ---- Internal ring ----
# PARVOL142 'WA06' 200 'WL06'  0.  0.     0.     0  'TUBE' 3     33.8    60.4  4.5
# C      ---- External ring ----
# PARVOL143 'WB06' 200 'WL06'  0.  0.     0.     0  'TUBE' 3    132.1   140.0  4.5
# C  -------------- Hodoscope 6 --------
# PARVOL141 'WD06' 215 'SOLE'  0.  0.    185.5   0  'TUBE' 3     33.8   140.0  0.5
# PARVOL165 'WC06' 209 'WD06'  0.  0.     -0.4999   0  'TUBE' 3   59.90 132.60  0.0001
# VOLPOS190 'WC06'     'WD06'  0.  0.      0.4999   0  
# HOD6SLATS       1
# HOD6MEDIUM   636
# HOD6MOTHER  'WD06' 
# HOD6IDTYPE     41
# HOD6GATE       50.
# HOD6THRES       0
# C 
# HOD6SHAP    'TUBE'
# HOD6SIZE1     59.90 132.60   0.48000
# HOD6TYPE        1
# HOD6POSX        0.
# HOD6POSY        0.
# HOD6POSZ        0.
# C  -------------- Hodoscope 7 --------
# HOD7SLATS       1
# HOD7MEDIUM   636
# HOD7MOTHER  'SOLE' 
# HOD7IDTYPE     41
# HOD7GATE       50.
# HOD7THRES       0
# C 
# HOD7SHAP    'TUBE'
# HOD7SIZE1     102. 223.   0.48000
# HOD7TYPE        1
# HOD7POSX        0.
# HOD7POSY        0.
# HOD7POSZ      297.
# C  -------------- Hodoscope 8 --------
# HOD8SLATS       1
# HOD8MEDIUM   636
# HOD8MOTHER  'SOLE' 
# HOD8IDTYPE     41
# HOD8GATE       50.
# HOD8THRES       0
# C 
# HOD8SHAP    'TUBE'
# HOD8SIZE1     103. 226.   0.48000
# HOD8TYPE        1
# HOD8POSX        0.
# HOD8POSY        0.
# HOD8POSZ      306.

# on p56 of pac34 proposal, the z location are 155,185,295,310cm, but it seems Eugene later tweaked a bit togther with baffle. refer to http://hallaweb.jlab.org/12GeV/SoLID/download/sim/geant3/solid_comgeant_pvdis/pvdis_02_01_p_14_01/fort.22

sub make_gem
{
 my $Nplate  = 4;
# my @PlateZ  = (155,185,295,310);  # as on p56 of pac34 proposal
# my @PlateZ  = (157.5,185.5,297,306); # as in Eugen's code
#  my @PlateZ  = (157.5,185.5,306,321);  # change for last two planes further back as Cherenkov needs 10cm more
#  my @Rin  = (55,65,105,115);
#  my @Rout = (115,140,200,215);
 my @PlateZ = (157.5,185.5,306,315);
 my @Rin = (56,67,113,117);
 my @Rout = (108,129,215,222);
 my $Dz   = 0.5;
 my $material="GEMgas"; 
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