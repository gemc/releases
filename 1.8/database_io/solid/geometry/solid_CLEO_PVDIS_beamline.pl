#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'CLEO_PVDIS_beamline';

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


# target offset in cm
my $targetoff=10;
# my $targetoff=-340;

# C -- Auxil: target center
# C
# GPARVOL02  'TARC'    0  'SOLE'    0.    0.   10.    0  'TUBE'  3   1.    1.    1.
# C
# C --     Beam pipe: entrance
# C
# GPARVOL03  'BMP1'  209  'TARC'    0.    0. -175.    0  'TUBE'  3   0.    1.25    150.   
# GPARVOL04  'BMV1'  221  'BMP1'    0.    0.    0.    0  'TUBE'  3   0.    1.22    150.   
# GPARVOL05  'BMD1'   99  'BMV1'    0.    0. -149.9   0  'TUBE'  3   0.    1.22      0.1  
# C
# C --     Beam pipe: exit
# C
# GPARVOL06  'BMP2'  209  'TARC'    0.    0.   30.    0  'TUBE'  3   0.    1.50      5.   
# GPARVOL07  'BMV2'  221  'BMP2'    0.    0.    0.    0  'TUBE'  3   0.    1.45      5.   
# GPARVOL08  'BMP3'  209  'TARC'    0.    0.  155.    0  'CONE'  5  120.  0.   1.50   0.  29.00  
# GPARVOL09  'BMV3'  221  'BMP3'    0.    0.    0.    0  'CONE'  5  120.  0.   1.45   0.  28.00  
# GPARVOL10  'BMP4'  209  'TARC'    0.    0.  335.    0  'TUBE'  3   0.   29.0      60.   
# GPARVOL11  'BMV4'  221  'BMP4'    0.    0.    0.    0  'TUBE'  3   0.   28.0      60.   
# GPARVOL12  'BMD4'   99  'BMV4'    0.    0.   59.5   0  'TUBE'  3   0.   28.    0.5
# C

sub make_beam_entrance
{
 my $NUM  = 4;
 my @z    = (-675+330,0.,-329.9,329.9875);
 my @Rin  = (0.,0.0,0.0,0.0);
 my @Rout = (1.25,1.22,1.22,1.22);
 my @Dz   = (330,330,0.1,0.0125);
 my @name = ("BMP1","BMV1","BMD1","BMW1"); 
 my @mother = ("$DetectorMother","$DetectorName\_BMP1","$DetectorName\_BMV1","$DetectorName\_BMV1"); 
 my @mat  = ("Aluminum","Vacuum","Kryptonite","G4_Be");

 for(my $n=1; $n<=$NUM; $n++)
 {
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = "$DetectorName\_$name[$n-1]";
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "808080";
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
make_beam_entrance();

sub make_beam_exit
{
 my $NUM  = 4;
 my @z    = (35+232.5,0.,232.4,-232.4875);
 my @Rmin1  = (0.,0.,0.,0.);
 my @Rmax1 = (1.5,1.4,28.9,1.4);
 my @Rmin2  = (0.,0.,0.,0.);
 my @Rmax2 = (29.,28.9,28.9,1.4);
 my @Dz   = (232.5,232.5,0.1,0.0125);
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
    $detector{"color"}      = "808080";
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
make_beam_exit();
