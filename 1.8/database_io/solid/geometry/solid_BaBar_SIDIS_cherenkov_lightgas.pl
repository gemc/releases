#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'BaBar_SIDIS_cherenkov_lightgas';

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

my $CCgas="CCGas"; # currently CF gas used for clas12

# C  ==== Gas Cherenkov definitions
# PARVOL71  'CHRA'  828  'SOLE'    0.    0.    0.    0  'PCON'  12 0. 360. 3.  
#	97. 62. 127.  200. 78. 142. 225. 82. 160.   

sub make_detector_CHRA
{
 $detector{"name"}        = "$DetectorName\_CHRA";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "FF3399";
 $detector{"type"}        = "Polycone";
 my $phiStart    = 0;
 my $phiTotal    = 360;
 my $numZPlanes  = 3;
 $detector{"dimensions"}  = "$phiStart*deg $phiTotal*deg $numZPlanes 62.0*cm 78.0*cm 82.0*cm 127.0*cm 142.0*cm 160.*cm 97.0*cm 200.0*cm 225.0*cm" ;
#  $detector{"material"}    = "Vacuum";
 $detector{"material"}    = "Component";
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
make_detector_CHRA();

# PARVOL72  'CHRB'  235  'CHRA'    0.    0.    97.02    0  'TUBE'  3 62.1  126.9 0.02

# PARVOL73  'CHRC'  828  'SOLE'    0.    0.    0.    0  'PCON'  15 0. 360. 4.
#	209. 240. 257.   225. 190. 265.   225. 82. 265.   301. 90. 265.

sub make_detector_CHRC
{
 $detector{"name"}        = "$DetectorName\_CHRC";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "FF9999";
 $detector{"type"}        = "Polycone";
 my $phiStart    = 0;
 my $phiTotal    = 360;
 my $numZPlanes  = 4;
 $detector{"dimensions"}  = "$phiStart*deg $phiTotal*deg $numZPlanes 240.0*cm 190.0*cm 82.0*cm 90.0*cm 257.0*cm 265.*cm 265.0*cm 265.0*cm 209.0*cm 225.0*cm 225.0*cm 301.0*cm " ;
#  $detector{"material"}    = "Vacuum";
 $detector{"material"}    = "Component";
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
make_detector_CHRC();

sub make_detector_CHRT
{
 $detector{"name"}        = "$DetectorName\_CHRT";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33FFFF";
 $detector{"type"}        = "Operation:$DetectorName\_CHRA+$DetectorName\_CHRC";
 $detector{"material"}    = $CCgas;
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

sub make_window
{
 $detector{"name"}        = "$DetectorName\_window";
 $detector{"mother"}      = "$DetectorName\_CHRT";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 97.02*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CCFF33";
 $detector{"type"}        = "Tube";
 my $Rin        = 62.1;
 my $Rout       = 126.9;
 my $Dz         = 0.02;
 $detector{"dimensions"}  = "$Rin*cm $Rout*cm $Dz*cm 0*deg 360*deg";
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

make_detector_CHRA();
make_detector_CHRC();
make_detector_CHRT();
make_window();

sub make_detector_lightout
{
 $detector{"name"}        = "$DetectorName\_lightout";
 $detector{"mother"}      = "$DetectorName\_CHRT";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 240*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "003333";
 $detector{"type"}        = "Cons";
 my $Rmin1 = 240-15.6/2.*sin(23./180.*3.1415926);
 my $Rmax1 = $Rmin1+0.1;
 my $Rmin2 = 240+15.6/2.*sin(23./180.*3.1415926);
 my $Rmax2 = $Rmin2+0.1;
 my $Dz    = 15.6/2.*cos(23./180.*3.1415926);
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