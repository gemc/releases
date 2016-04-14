#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'CLEO_PVDIS_cherenkov';

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

# C  ==== Gas Cherenkov definitions
# PARVOL170 'CERV' 840 'SOLE'  0.  0.  200.0   50  'PCON' 15      .0   360.0  4.
#          -0.04 61.0 142.0    24.0  70.3 162.0    24.0  70.3 260.0    90.1  96.0 260.0  
# C  ============== Windows ================== 
# PARVOL171 'CEW1' 209 'CERV'  0.  0. -0.02     0  'TUBE' 3  61.1 141.9 0.02  
# PARVOL172 'CEW2' 209 'CERV'  0.  0. 90.05     0  'TUBE' 3  96.1 260.0 0.05 
# C  ============== Volume to be divided =====
# PARVOL173 'CERD' 840 'CERV'  0.  0. 57.0      0  'CONE' 5  33.0  70.3 260.0  96.0 260.0
# C
# C  ============== Divide the barrel ========
# PARVOL174 'CERS'  840 'CERD'  15  0.  0.  2

# comgeant use C4F10

my $material_gas="CCGas"; # currently CF gas used for clas12

sub make_backchamber
{
 $detector{"name"}        = "$DetectorName\_backchamber";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Polycone";
 $detector{"dimensions"}  = "0*deg 360*deg 4 71*cm 73*cm 73*cm 85*cm 144*cm 155*cm 265*cm 265*cm 194*cm 209.01*cm 209.01*cm 301*cm";
 $detector{"material"}    = $material_gas;
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
make_backchamber();

sub make_backchamber_window_front
{
 $detector{"name"}        = "$DetectorName\_backchamber_window_front";
 $detector{"mother"}      = "$DetectorName\_backchamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 194.02*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "71*cm 144*cm 0.02*cm 0*deg 360*deg";
 $detector{"material"}    = "Aluminum";
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
make_backchamber_window_front();

sub make_backchamber_window_back
{
 $detector{"name"}        = "$DetectorName\_backchamber_window_back";
 $detector{"mother"}      = "$DetectorName\_backchamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 300.98*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "85*cm 265*cm 0.02*cm 0*deg 360*deg";
 $detector{"material"}    = "Aluminum";
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
make_backchamber_window_back();

# For PVDIS, the location of the center of the PMT array is
# z = 240 cm, r = 240 cm;
# The tilting angle compared to the z axis is 52 degrees.
# For reminder, the size of the PMT is 3 x 3 PMTs, i.e. 15.6 x 15.6 cm.

sub make_detector_lightout
{
 $detector{"name"}        = "$DetectorName\_lightout";
 $detector{"mother"}      = "$DetectorName\_backchamber";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 240*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6633";
 $detector{"type"}        = "Cons";
 my $Rmin1 = 240-15.6/2.*sin(38./180.*3.1415926);
 my $Rmax1 = $Rmin1+0.1;
 my $Rmin2 = 240+15.6/2.*sin(38./180.*3.1415926);
 my $Rmax2 = $Rmin2+0.1;
 my $Dz    = 15.6/2.*cos(38./180.*3.1415926);
 my $Sphi  = 0;
 my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Kryptonite";
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

