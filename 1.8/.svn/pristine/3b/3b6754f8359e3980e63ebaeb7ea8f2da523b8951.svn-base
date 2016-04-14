#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'BaBar_SIDIS_target';

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

#C --     Beam pipe: entrance
#C
#GPARVOL02  'BMP1'  235  'HALL'    0.    0. -175.    0  'TUBE'  3   0.    1.25    150.   
#GPARVOL03  'BMV1'  203  'BMP1'    0.    0.    0.    0  'TUBE'  3   0.    1.22    150.   
#GPARVOL04  'BMD1'   99  'BMV1'    0.    0. -149.9   0  'TUBE'  3   0.    1.22      0.1  
#GPARVOL05  'BMW1'  265  'BMV1'    0.    0.  149.9   0  'TUBE'  3   0.    1.22      0.0125 

sub make_beam_entrance_SIDIS
{
 my $NUM  = 4;
 my @z    = (-175.-350,0.,-149.9,149.9);
 my @Rin  = (0.,0.0,0.0,0.0);
 my @Rout = (1.25,1.22,1.22,1.22);
 my @Dz   = (150.0,150.0,0.1,0.0125);
 my @name = ("BMP1","BMV1","BMD1","BMW1"); 
 my @mother = ("$DetectorMother","$DetectorName\_BMP1","$DetectorName\_BMV1","$DetectorName\_BMV1"); 
 my @mat  = ("Aluminum","Vacuum","Kryptonite","G4_Be");

# C           #       name              mat sen F Fmx Fan stmx  Elo epsi st(mu,lo)  user words
#             #       name               A    Z    g/cm3        RLcm   Int.len cm
# GPARMED19  235 'Alum,  mf$          '   9  0  1 30. -1. -1.   -1.   0.2    -1.
# GPARMED04  203 'Vacuum,    mf$      '  16  0  1 30. -1.  2.0  -1.   0.1    -1.
# GPARMED43   99 'Dead absorber$      '  10  0  0  0. -1. -1.   -1.   1.     -1.
# GPARMED63  265 'Be, mf             $'   5  0  1 30. -1. -1.   -1.   0.05   -1.

 for(my $n=1; $n<=$NUM; $n++)
 {
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "FF6633";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"material"}   = $mat[$n-1];
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = $n;
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
make_beam_entrance_SIDIS();


#  --     Target  ==================================
# GPARVOL20  'TRGB'    1  'HALL'    0.    0.   0.    0  'TUBE'  3   0.    8.0   24.0
# GPARVOL21  'TCEL'  264  'TRGB'    0.    0.   0.    0  'TUBE'  3   0.9   1.0   20.0
# GPARVOL22  'TLHE'  233  'TRGB'    0.    0.   0.    0  'TUBE'  3   0.    0.90  20.0   
# GPARVOL23  'TLW1'  264  'TRGB'    0.    0. -20.006 0  'TUBE'  3   0.    0.90   0.0060   
# GPARVOL24  'TLW2'  264  'TRGB'    0.    0.  20.006 0  'TUBE'  3   0.    0.90   0.0060   

sub make_target_SIDIS
{
 my $NUM  = 5;
 my @z    = (0.-350,0.,0.,-20.006,20.006);
 my @Rin  = (0.0,0.9,0.0,0.0,0.0);
 my @Rout = (8.0,1.0,0.9,0.9,0.9);
 my @Dz   = (24.0,20.0,20.0,0.006,0.006);
 my @name = ("TRGB","TCEL","TLHE","TLW1","TLW2"); 
 my @mother = ("$DetectorMother","$DetectorName\_TRGB","$DetectorName\_TRGB","$DetectorName\_TRGB","$DetectorName\_TRGB");
 my @mat  = ("Air","Glass_GE180","He3_10amg","Glass_GE180","Glass_GE180");

# GPARMED58  233 '3He 10 atm$         '  33  0  1  1. -1. -1.   -1.   0.1    -1. 
# GPARMXT05   33 '3He 10 atm $        ' 1.33E-3  -1      3.  2.  1.
# GPARMED62  264 'Glass GE 180 mf    $'  64  0  1 30. -1. -1.   -1.   0.01   -1.
# GPARMXT08   64 'Glass al-sil  GE180$' 2.76      7     16.  8. 0.524  28.1 14. 0.266   27. 13. 0.072  24.3 12. 0.072 
#                                                       40. 20. 0.036  11.   5. 0.013   23. 11. 0.007   

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "ffff00";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"material"}   = $mat[$n-1];
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = $n;
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
make_target_SIDIS();

#C --     Beam pipe: exit
#C
#GPARVOL10  'B3PP'  235  'HALL'    0.    0.  335.    0  'CONE'  5  310.  0.   1.80   0.  40.00  
#GPARVOL11  'B3PV'  203  'B3PP'    0.    0.    0.    0  'CONE'  5  310.  0.   1.70   0.  39.00  
#GPARVOL12  'B3DM'   99  'B3PV'    0.    0.  309.    0  'TUBE'  3   0.   38.0   1.0
#GPARVOL13  'B3W1'  265  'B3PV'    0.    0. -309.9   0  'TUBE'  3   0.    1.7  0.0125

sub make_beam_exit_SIDIS

{
 my $NUM  = 4;
#  my @z    = (335.-350,0.,309,-309.9);
#  my @Rmin1  = (0.,0.,0.,0.);
#  my @Rmax1 = (1.80,1.70,38.0,1.7);
#  my @Rmin2  = (0.,0.,0.,0.);
#  my @Rmax2 = (40.,39.,38.,1.7);
#  my @Dz   = (310.,310.,1.,0.0125);
# to avoid overlap with downsteam yoke
 my @z    = (315.-350,0.,289.9,-289.9875);
 my @Rmin1  = (0.,0.,0.,0.);
 my @Rmax1 = (1.80,1.70,35.0,1.7);
 my @Rmin2  = (0.,0.,0.,0.);
 my @Rmax2 = (37.,36.,35.,1.7);
 my @Dz   = (290.,290.,0.1,0.0125);
 my @name = ("B3PP","B3PV","B3DM","B3W1"); 
 my @mother=("$DetectorMother","$DetectorName\_B3PP","$DetectorName\_B3PV","$DetectorName\_B3PV");
 my @mat  = ("Aluminum","Vacuum","Kryptonite","G4_Be");

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "ff6633";
    $detector{"type"}       = "Cons";
    $detector{"dimensions"} = "$Rmin1[$n-1]*cm $Rmax1[$n-1]*cm $Rmin2[$n-1]*cm $Rmax2[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"material"}   = $mat[$n-1];
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = $n;
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

make_beam_exit_SIDIS();
