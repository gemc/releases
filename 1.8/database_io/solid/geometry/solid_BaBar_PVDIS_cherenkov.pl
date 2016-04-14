#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'BaBar_PVDIS_cherenkov';

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

my $material="CCGas"; # comgeant use C4F10, shoudl change here

# C  ==== Gas Cherenkov definitions
# PARVOL170 'CERV' 840 'SOLE'  0.  0.  200.0   50  'PCON' 15      .0   360.0  4.
#          -0.04 61.0 142.0    24.0  70.3 162.0    24.0  70.3 260.0    90.1  96.0 260.0  

sub make_detector_CERV
{
 $detector{"name"}        = "$DetectorName\_CERV";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "E8EA5A";
 $detector{"type"}        = "Polycone";
 my $phiStart    = 0;
 my $phiTotal    = 360;
 my $numZPlanes  = 4;
#  $detector{"dimensions"}  = "$phiStart*deg $phiTotal*deg $numZPlanes 61.0*cm 70.3*cm 70.3*cm 96.0*cm 142*cm 162*cm 260*cm 260*cm -0.04*cm 24.0*cm 24.0*cm 90.1*cm"; # cherenkov center coordinate
#  $detector{"dimensions"}  = "$phiStart*deg $phiTotal*deg $numZPlanes 61.0*cm 70.3*cm 70.3*cm 96.0*cm 142*cm 162*cm 260*cm 260*cm 199.96*cm 224.0*cm 224.0*cm 290.1*cm";  # in absolute coordinate
 $detector{"dimensions"}  = "$phiStart*deg $phiTotal*deg $numZPlanes 61.0*cm 70.3*cm 70.3*cm 96.0*cm 142*cm 162*cm 260*cm 260*cm 200*cm 225.0*cm 225.0*cm 301*cm";  # in absolute coordinate
 $detector{"material"}    = "$material";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
 print_det(\%detector, $file);
}
make_detector_CERV();

# C  ============== Windows ================== 
# PARVOL171 'CEW1' 209 'CERV'  0.  0. -0.02     0  'TUBE' 3  61.1 141.9 0.02  
# PARVOL172 'CEW2' 209 'CERV'  0.  0. 90.05     0  'TUBE' 3  96.1 260.0 0.05 

sub make_detector_CEW
{
 my $NUM  = 2;
#  my @z    = (-0.02,90.05);  # cherenkov center coordinate
 my @z    = (199.98,290.05); # in absolute coordinate
 my @Rin  = (61.1,96.1);
 my @Rout = (141.9,260.0);
 my @Dz   = (0.02,0.05);
 my @name = ("CEW1","CEW2"); 
 my @mat  = ("Aluminum","Aluminum");

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$DetectorName\_CERV" ;
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
# make_detector_CEW();

# C  ============== Volume to be divided =====
# PARVOL173 'CERD' 840 'CERV'  0.  0. 57.0      0  'CONE' 5  33.0  70.3 260.0  96.0 260.0
# C
# C  ============== Divide the barrel ========
# PARVOL174 'CERS'  840 'CERD'  15  0.  0.  2

sub make_detector_CERD
{
 $detector{"name"}        = "$DetectorName\_CERD";
 $detector{"mother"}      = "$DetectorName\_CERV";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 57*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "003333";
 $detector{"type"}        = "Cons";
 my $Rmin1 = 70.3;
 my $Rmax1 = 260.0;
 my $Rmin2 = 96.0;
 my $Rmax2 = 260.0;
 my $Dz    = 33.0;
 my $Sphi  = 0;
 my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "$material";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
 print_det(\%detector, $file);
}
# make_detector_CERD();

# For PVDIS, the location of the center of the PMT array is
# z = 240 cm, r = 240 cm;
# The tilting angle compared to the z axis is 52 degrees.
# For reminder, the size of the PMT is 3 x 3 PMTs, i.e. 15.6 x 15.6 cm.

sub make_detector_lightout
{
 $detector{"name"}        = "$DetectorName\_lightout";
 $detector{"mother"}      = "$DetectorName\_CERV";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 240*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "003333";
 $detector{"type"}        = "Cons";
 my $Rmin1 = 240-15.6/2.*sin(38./180.*3.1415926);
 my $Rmax1 = $Rmin1+0.1;
 my $Rmin2 = 240+15.6/2.*sin(38./180.*3.1415926);
 my $Rmax2 = $Rmin2+0.1;
 my $Dz    = 15.6/2.*cos(38./180.*3.1415926);
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
 $detector{"identifiers"} = "id manual 2100000";
 print_det(\%detector, $file);
}
make_detector_lightout();

# C  ============== Mirrors definitions ========
# C    f=164.7
# RMATR51    142.6    0.   90.  90.     52.6       0.
# PARVOL175 'CHM1'  860 'CERS'    115.0   0.0 -159.0  -1051  'ELLI'  8  221.5  222.0   33. 70.  155. 205.  0.757 0.757
# PARVOL176 'CHM2'  860 'CERS'      0.0   0.0  -32.7      0  'TUBS'  5  167.0  237.0  0.3  -12.0  12.0 

