#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use Getopt::Long;
use Math::Trig;



my $envelope = 'bstfluxes';
my $file     = 'bstfluxes.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


my @SL_ir = (57.0, 77.0, 105.0,  132.0, 173.0);    # Inner Flux Radius
my $SL_dz = 605.0;

for(my $l = 0; $l < 5; $l++)
{
	make_fluxes($l);
}





sub make_fluxes
{
	my $slnumber = shift;
  
  
	my $RIN = $SL_ir[$slnumber] ;  
  my $ROU = $RIN + 0.1;
  
	$detector{"name"}        = "flux_$slnumber";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Super Layer $slnumber";
	$detector{"pos"}         = "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "aaaaff";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$RIN*mm $ROU*mm $SL_dz*mm 0*deg 360*deg";
	$detector{"material"}    = "Air";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;		
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 0;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "FLUX";
	$detector{"hit_type"}    = "FLUX";
	$detector{"identifiers"} = "if manual $slnumber";
	print_det(\%detector, $file);
  
}


