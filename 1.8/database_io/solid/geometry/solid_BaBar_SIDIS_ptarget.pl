#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'BaBar_SIDIS_ptarget';

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
}
make_beam_entrance_SIDIS();

#1. Scattering chamber : cylinder of  74cm(height) with inner diameter of 45cm and thickness of 2.5cm made of Aluminum.  
#2. The scattering chamber has entrance and exit windows on them, made of thin Al ( 0.04cm)
#  a) beam entrance window dimensions can be small:  20cm wide  and 30cm  height
#  b) beam exit  window dimensions should be large enough to cover +/- 28deg in the scattering particles. You can keep the same height (30cm) but need at least 100cm width to cover angular range.
sub make_scattering_chamber_SIDIS
{
 my $NUM  = 4;
 my @y    = (26.0,-26.0,0.0,0.0);
 my @z    = (0.0-350,0.0-350,0.0-350,0.0-350);
 my @Rin  = (22.5,22.5,22.5,22.5);
 my @Rout = (25.,25.,25.,25.);
 my @Dz   = (11.0,11.0,15.0,15.0);
 my @SPhi = (0.0,0.0,95.0,300.0);
 my @DPhi = (360.0,360.0,145.0,145.0);
 my @name = ("SC1","SC2","SC3","SC4");
 my @mother = ("$DetectorMother","$DetectorMother","$DetectorMother","$DetectorMother"); 
 my @mat  = ("Aluminum","Aluminum","Aluminum","Aluminum");


 for(my $n=1; $n<=$NUM; $n++)
 {
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm $y[$n-1]*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "90*deg 0*deg 0*deg";
    $detector{"color"}      = "FF6600";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm $SPhi[$n-1]*deg $DPhi[$n-1]*deg";
    $detector{"material"}   = $mat[$n-1];
    $detector{"mfield"}     = "solenoid_ptarget";
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
}
make_scattering_chamber_SIDIS();

#2. The scattering chamber has entrance and exit windows on them, made of thin Al ( 0.04cm)
#  a) beam entrance window dimensions can be small:  20cm wide  and 30cm  height
#  b) beam exit  window dimensions should be large enough to cover +/- 28deg in the scattering particles. You can keep the same height (30cm) but need at least 100cm width to cover angular range.

sub make_scattering_windows_SIDIS
{
 my $NUM  = 2;
 my @z    = (0.0-350,0.0-350);
 my @Rin  = (24.96,24.96);
 my @Rout = (25.,25.);
 my @Dz   = (15.0,15.0);
 my @SPhi = (85.0,240.0);
 my @DPhi = (10.0,60.0);
 my @name = ("Winentr","Winexit");
 my @mother = ("$DetectorMother","$DetectorMother"); 
 my @mat  = ("Aluminum","Aluminum");


 for(my $n=1; $n<=$NUM; $n++)
 {
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "90*deg 0*deg 0*deg";
    $detector{"color"}      = "FFFFFF";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm $SPhi[$n-1]*deg $DPhi[$n-1]*deg";
    $detector{"material"}   = $mat[$n-1];
    $detector{"mfield"}     = "solenoid_ptarget";
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
}
make_scattering_windows_SIDIS();

sub make_target_SIDIS
{
 my $NUM  = 1;
 my @z    = (0.0-350);
 my @Rin  = (0.0);
 my @Rout = (1.413);
 my @Dz   = (1.423);
 my @name = ("target",); 
 my @mother = ("$DetectorMother");
 my @mat  = ("NH3He");

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm 0*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "ff0000";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"material"}   = $mat[$n-1];
    $detector{"mfield"}     = "solenoid_ptarget";
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
}
make_target_SIDIS();

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
 my @z    = (315.-350,0.,290,-290);
 my @Rmin1  = (0.,0.,0.,0.);
 my @Rmax1 = (1.80,1.70,35.0,1.7);
 my @Rmin2  = (0.,0.,0.,0.);
 my @Rmax2 = (37.,36.,35.,1.7);
 my @Dz   = (290.,290.,1.,0.0125);
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
}
make_beam_exit_SIDIS();
