#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'DC12';
my $file     = 'DC12.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;


# c++ convention for indexes
my $region = $ARGV[0] - 1;
my $iregion = $region + 1;

my @mother_dx1;
my @mother_dx2;
my @mother_dy;
my @mother_dz;
my @mother_xcent;
my @mother_ycent;
my @mother_zcent;


# read parameters of the mother volume for 3 regions
my $ifile = 'mother-geom.dat';
open(FILE, $ifile);
my @lines = <FILE>;
close(FILE);
foreach my $line (@lines)
{
   if ($line !~ /#/)
   {
      chomp($line);
      my @numbers = split(/[ \t]+/,$line);
      (my $ireg, my $dx1, my $dx2, my $dy, my $dz, my $xcent, my $ycent, my $zcent) = @numbers;
      $ireg-- ;  # index is c++ convention
      $mother_dx1[$ireg]     = $dx1 + 1;   # Custom enlarging mother volume to contain daugthers
      $mother_dx2[$ireg]     = $dx2 + 1;
      $mother_dy[$ireg]      = $dy  + 0.5;
      $mother_dz[$ireg]      = $dz;
      $mother_xcent[$ireg]   = $xcent;
      $mother_ycent[$ireg]   = $ycent;
      $mother_zcent[$ireg]   = $zcent;
   }
}

my @daughter_dx1;
my @daughter_dx2;
my @daughter_dy;
my @daughter_dz;
my @daughter_palp;
my @daughter_xcent;
my @daughter_ycent;
my @daughter_zcent;
my @daughter_tilt;

# read parameters of the daughter volumes for 3 regions, 6 superlayers
$ifile = 'layers-geom.dat';
open(FILE, $ifile);
@lines = <FILE>;
close(FILE);
foreach my $line (@lines)
{
   if ($line !~ /#/)
   {
      chomp($line);
      my @numbers = split(/[ \t]+/,$line);
      (my $isup, my $ilayer, my $xcent, my $ycent, my $zcent, my $dx1, my $dx2, my $dy, my $palp, my $dz, my $tilt) = @numbers;
      # print $isup."\t".$ilayer."\t".$xcent."\t".$ycent."\t".$zcent."\t".$dx1."\t".$dx2."\t".$dy."\t".$palp."\t".$dz."\n"; 
      # index is c++ convention
      $ilayer-- ;
      $daughter_dx1[$isup][$ilayer]   = $dx1;
      $daughter_dx2[$isup][$ilayer]   = $dx2;
      $daughter_dy[$isup][$ilayer]    = $dy;
      $daughter_dz[$isup][$ilayer]    = $dz;
      # $daughter_dz[$isup][$ilayer]    = 0.1;
      $daughter_palp[$isup][$ilayer]  = $palp;
      $daughter_xcent[$isup][$ilayer] = $xcent;
      $daughter_ycent[$isup][$ilayer] = $ycent;
      $daughter_zcent[$isup][$ilayer] = $zcent;
      $daughter_tilt[$isup][$ilayer]  = $tilt;
   }
}

for (my $ilayer = 0; $ilayer < 8 ; $ilayer++)
{
   $daughter_zcent[6][$ilayer] = $daughter_zcent[6][$ilayer];
}

# MOTHER: region volume.
# placement parameters for the mother region volume
my $mxrot   = 25.0;
my $myrot   = 0.0;
my $mzrot   = 0.0;
my $mxplace = $mother_xcent[$region];
my $myplace = $mother_ycent[$region];
my $mzplace = $mother_zcent[$region] - 500.0;  # Shifted because the sector volume is placed 500 cm downstream
my $mpDX1   = $mother_dx1[$region];
my $mpDX2   = $mother_dx2[$region];
my $mpDX3   = $mpDX1;
my $mpDX4   = $mpDX2;
my $mpDY1   = $mother_dy[$region];
my $mpDY2   = $mpDY1;
my $mpDZ    = $mother_dz[$region];
my $mpALP1  = 0.0;
my $mpALP2  = $mpALP1;
my $mtheta  = -25.0;
my $mphi    =  90.0;
sub make_region
{
 my $iregion = $region + 1;
 $detector{"name"}        = "regionb$iregion";
 $detector{"mother"}      = "sector";
 $detector{"description"} = "Region $iregion Drift Chambers";
 $detector{"pos"}         = "$mxplace*cm $myplace*cm $mzplace*cm";
 $detector{"rotation"}    = "$mxrot*deg $myrot*deg $mzrot*deg";
 $detector{"color"}       = "aa0000";
 $detector{"type"}        = "G4Trap";

 $detector{"dimensions"}  = "$mpDZ*cm $mtheta*deg $mphi*deg $mpDY1*cm $mpDX1*cm $mpDX2*cm $mpALP1*deg $mpDY2*cm $mpDX3*cm $mpDX4*cm $mpALP2*deg";
 $detector{"material"}    = "DCgas";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 0;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";

 print_det(\%detector, $file);
}



# Layers
# fixed placement parameters for the daughter (layer) volume
my $dxrot = 0.0;
my $dyrot = 0.0;

my $superlayer_min = $iregion*2 -1;
my $superlayer_max = $iregion*2;
my $microgap = 0.01;  # 100 microns microgap between layers

sub make_layers
{

 for (my $isup = $superlayer_min; $isup < $superlayer_max+1 ; $isup++)
 {
    for (my $ilayer = 1; $ilayer < 7 ; $ilayer++)
    {
       my $dxplace = $daughter_xcent[$isup][$ilayer];
       my $dyplace = $daughter_ycent[$isup][$ilayer];
       my $dzplace = $daughter_zcent[$isup][$ilayer];

       my $dpDX1   = $daughter_dx1[$isup][$ilayer];
       my $dpDX2   = $daughter_dx2[$isup][$ilayer];
       my $dpDX3   = $dpDX1;
       my $dpDX4   = $dpDX2;
       my $dpDY1   = $daughter_dy[$isup][$ilayer];
       my $dpDY2   = $dpDY1;
       my $dpDZ    = $daughter_dz[$isup][$ilayer] - $microgap;
       my $dpALP1  = $daughter_palp[$isup][$ilayer];
       my $dpALP2  = $dpALP1;
       my $dzrot   = $daughter_tilt[$isup][$ilayer];
       my $dtheta  = -25.0;
       my $dphi    =  90.0;

       #if ($isup == $superlayer_min){$dzrot = 6.0};
       #if ($isup == $superlayer_max){$dzrot = -6.0};

       # names
       my $nlayer               = $ilayer;
       $detector{"name"}        = "SL$isup\_layer$nlayer";
       $detector{"mother"}      = "regionb$iregion";
       $detector{"description"} = "Region $iregion, Super Layer $isup, layer $ilayer";
       $detector{"pos"}         = "$dxplace*cm $dyplace*cm $dzplace*cm";
       $detector{"rotation"}    = "$dxrot*deg $dyrot*deg $dzrot*deg";
       $detector{"color"}       = "66aadd";

       $detector{"type"}        = "G4Trap";
       $detector{"dimensions"}  = "$dpDZ*cm $dtheta*deg $dphi*deg $dpDY1*cm $dpDX1*cm $dpDX2*cm $dpALP1*deg $dpDY2*cm $dpDX3*cm $dpDX4*cm $dpALP2*deg";
       $detector{"material"}    = "DCgas";
       $detector{"mfield"}      = "no";
       $detector{"ncopy"}       = "1";
       $detector{"pMany"}       = 1;
       $detector{"exist"}       = 1;
       $detector{"visible"}     = 1;
       $detector{"style"}       = 1;
       $detector{"sensitivity"} = "DC";
       $detector{"hit_type"}    = "DC";
       $detector{"identifiers"} = "sector ncopy 0 superlayer manual $isup layer manual $nlayer wire manual 1";
       print_det(\%detector, $file);
    }
  }
}

make_region();
make_layers();


















