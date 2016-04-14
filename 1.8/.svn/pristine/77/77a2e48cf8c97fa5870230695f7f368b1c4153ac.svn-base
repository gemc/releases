#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'CLEO_PVDIS_target';

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

# C --     Target  ==================================
# C
# GPARVOL21  'TACH'  209  'TARC'    0.    0.    0.    0  'TUBE'  3   0.    5.00   25.00    
# GPARVOL22  'TACV'  221  'TACH'    0.    0.    0.    0  'TUBE'  3   0.    4.95   24.95    
# GPARVOL23  'TAW1'  221  'TACH'    0.    0.  -24.975 0  'TUBE'  3   0.    1.22    0.025   
# GPARVOL24  'TAW2'  221  'TACH'    0.    0.   24.975 0  'TUBE'  3   0.    1.50    0.025   
# GPARVOL25  'TALU'  209  'TACV'    0.    0.    0.    0  'TUBE'  3   0.    1.918  20.0     
# GPARVOL26  'TLH2'  201  'TALU'    0.    0.    0.    0  'TUBE'  3   0.    1.900  19.982   

#40cm LH2/LD2 target

sub make_target_PVDIS_target
{
 my $NUM  = 6;
 my @z    = (0.+$targetoff,0.,-24.975,24.975,0.,0.);
 my @Rin  = (0.,0.,0.,0.,0.,0.);
 my @Rout = (5.,4.95,1.22,1.5,1.918,1.9);
 my @Dz   = (25.,24.95,0.025,0.025,20.,19.982);
 my @name = ("$DetectorName\_TACH","$DetectorName\_TACV","$DetectorName\_TAW1","$DetectorName\_TAW2","$DetectorName\_TALU","$DetectorName\_TAH2"); 
 my @mother=("$DetectorMother","$DetectorName\_TACH","$DetectorName\_TACH","$DetectorName\_TACH","$DetectorName\_TACV","$DetectorName\_TALU");
 my @mat  = ("Aluminum","Vacuum","Vacuum","Vacuum","Aluminum","LH2");

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
    $detector{"name"}        = "$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "ff0000";
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
make_target_PVDIS_target();
