#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'HTCC';
my $file     = 'HTCC.txt';

print "FILE: ",  $file."\n";

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

$detector{"mfield"}      = "no";
$detector{"ncopy"}       = 1;
$detector{"pMany"}       = 1;
$detector{"exist"}       = 1;
$detector{"visible"}     = 0; # 0 or 1
$detector{"style"}       = 1;
$detector{"sensitivity"} = "no";
$detector{"hit_type"}    = "";
$detector{"identifiers"} = "";

########## Gas Volume ###################

sub make_BigGasVolume
{
 $detector{"name"}        = "AHTCC1";
 $detector{"mother"}      = "root";
 $detector{"description"} = "volume containing cherenkov gas";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ee99ff5"; # add a 4 or 5 at the end to make transparent (change visibility above too)
 $detector{"type"}        = "Polycone";
 #$detector{"dimensions"}  = "0*mm 2500*mm 1028.8*mm 0*deg 360*deg";
 $detector{"dimensions"}  = "0*deg 360*deg 4 0*mm 15.8*mm 91.5*mm 155.7*mm 1742*mm 2300*mm 2300*mm 1589*mm -275*mm 181*mm 1046*mm 1780*mm";
 #$detector{"material"}    = "HTCCGas";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_BigGasVolume();

############# Entry Dish Volume ##################
my $entrydishNumZplanes = 17;
my @entrydishZplanes = ( -276.4122, -178.6222, -87.1822, 4.2578, 95.6978,
			 187.1378, 278.5778, 370.0178, 461.4578, 
			 552.8978, 644.3378, 735.7778, 827.2178,
			 918.6578, 991.378, 1080.278, 1107.71 );

my @entrydishRinner = ( 0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			0 );
my @entrydishRouter = ( 1416.05, 1410.081, 1404.493, 1398.905,
			1393.317, 1387.729, 1387.729, 1363.4466,
			1339.1388, 1305.8648, 1272.5908, 1239.3168,
			1206.0174, 1158.24, 1105.408, 996.0356,
			945.896 );

my $dimensions = "0.0*deg 360.0*deg $entrydishNumZplanes";
for( my $i=0; $i < $entrydishNumZplanes; $i++){
    $dimensions = $dimensions ." $entrydishRinner[$i]*mm";
}
for( my $i=0; $i < $entrydishNumZplanes; $i++){
    $dimensions = $dimensions ." $entrydishRouter[$i]*mm";
}
for( my $i=0; $i < $entrydishNumZplanes; $i++){
    $dimensions = $dimensions ." $entrydishZplanes[$i]*mm";
}

sub make_entrydishvolume
{
    $detector{"name"}         = "HTCCentrydishvolume";
    $detector{"mother"}       = "root";
    $detector{"description"}  = "HTCC entry dish volume";
    $detector{"pos"}          = "0*mm 0*mm 0*mm";
    $detector{"rotation"}     = "0*deg 0*deg 0*deg";
    $detector{"color"}        = "ee99ff";
    $detector{"type"}         = "Polycone";
    $detector{"dimensions"}   = "$dimensions";
    $detector{"material"}     = "Component";

    print_det(\%detector, $file);
}

make_entrydishvolume();
################## Entry Cone Volume ########################
my $entryconeNumZplanes = 9;
my @entryconeZplanes = ( 380.00, 470.17, 561.61, 653.05, 
			 744.49, 835.93, 927.37, 1018.81, 1116.6 );
my @entryconeRinner  = ( 0, 0, 0, 0, 0, 0, 0, 0, 0 );
my @entryconeRouter  = ( 257.505, 323.952, 390.373, 456.819, 
			 525.831, 599.872, 673.913, 747.979,
			 827.151 );

my $dimensions = "0.0*deg 360.0*deg $entryconeNumZplanes";
for( my $i=0; $i < $entryconeNumZplanes; $i++){
    $dimensions = $dimensions ." $entryconeRinner[$i]*mm";
}
for( my $i=0; $i < $entryconeNumZplanes; $i++){
    $dimensions = $dimensions ." $entryconeRouter[$i]*mm";
}
for( my $i=0; $i < $entryconeNumZplanes; $i++){
    $dimensions = $dimensions ." $entryconeZplanes[$i]*mm";
}

sub make_entryconevolume
{
    $detector{"name"}         = "HTCCentryconevolume";
    $detector{"mother"}       = "root";
    $detector{"description"}  = "HTCC entry cone volume";
    $detector{"pos"}          = "0*mm 0*mm 0*mm";
    $detector{"rotation"}     = "0*deg 0*deg 0*deg";
    $detector{"color"}        = "ee99ff";
    $detector{"type"}         = "Polycone";
    $detector{"dimensions"}   = "$dimensions";
    $detector{"material"}     = "Component";

    print_det(\%detector, $file);
}

make_entryconevolume();


sub make_EntryDishPlusCone
{
    $detector{"name"}        = "HTCCentrydishcone";
    $detector{"mother"}      = "root";
    $detector{"description"} = "subtraction entry dish - cone";
    $detector{"pos"}         = "0*mm 0*mm 0*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = "ee99ff";
    $detector{"type"}        = "Operation:@ HTCCentrydishvolume - HTCCentryconevolume";
    $detector{"dimensions"}  = "0";
    $detector{"material"}    = "Component";

    print_det(\%detector, $file);
}

make_EntryDishPlusCone();

############ Addition ##################

sub make_GasVolumeFinal
{
 $detector{"name"}        = "HTCC";
 $detector{"mother"}      = "root";
 $detector{"description"} = "gas volume for htcc";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0000ff"; # add a 4 or 5 at the end to make transparent (change visibility above too)
 $detector{"type"}        = "Operation:@ AHTCC1 - HTCCentrydishcone";
 $detector{"dimensions"}  = "0";
 $detector{"material"}    = "HTCCGas";
 #$detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

make_GasVolumeFinal();
