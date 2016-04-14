#!/usr/bin/perl -w
use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'torus_original';
my $file     = 'torus_original.txt';

my $rmin = 1;
my $rmax = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;
# natural constants
# all dimensions in mm, deg

# Need to reorganize/add air_coils here

my $inches = 25.4;
my $SteelFrameLength  = 94.*$inches/2.0;       # 1/2 length
my $ShieldLength      = 200.0;                 # 1/2 length of shielding
my $col               = '5555ff';
my $TorusZpos         = 151.855*$inches;       # center of the torus position
my $ShieldPlateIR     = 7.87*$inches + 0.001;
my $ShieldPlateThick  = 50.0;                  # 5 cm thick
my $ShieldPlateOR     = 7.87*$inches + $ShieldPlateThick;
my $SpanAnglePlate    = 34.00;

sub make_shield_platesb
{
 for(my $n=0; $n<6; $n++)
 {
	 my $nindex      = $n+1;
	 my $R           = $ShieldPlateIR ;
	 my $start_phi   = -$SpanAnglePlate/2.0;
	 my $length      =  $ShieldLength;
	 my $zpos        = 4880.0;
	 $detector{"name"}        = "Shield_Plate_Back_part$nindex";
	 $detector{"mother"}      = "root";
	 $detector{"description"} = "Shield Plate Back $nindex";
	 $detector{"pos"}         = "0*cm 0*cm $zpos*mm";
	 $detector{"rotation"}    = Rot2($R, $n);
	 $detector{"color"}       = $col;
	 $detector{"type"}        = "Tube";
	 $detector{"dimensions"}  = "$ShieldPlateIR*mm $ShieldPlateOR*mm $length*mm $start_phi*deg $SpanAnglePlate*deg";
	 $detector{"material"}    = "Air";
	 $detector{"mfield"}      = "no";
	 $detector{"ncopy"}       = "1";
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

sub make_shield_platesf
{
	for(my $n=0; $n<6; $n++)
	{
		my $nindex      = $n+1;
		my $R           = $ShieldPlateIR ;
		my $zpos        = 2800.0;
		my $start_phi   = -$SpanAnglePlate/2.0;
		my $length      =  $ShieldLength;
		$detector{"name"}        = "Shield_Plate_Front_part$nindex";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Shield Plate Front $nindex";
		$detector{"pos"}         = "0*cm 0*cm $zpos*mm";
		$detector{"rotation"}    = Rot2($R, $n);
		$detector{"color"}       = $col;
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "$ShieldPlateIR*mm $ShieldPlateOR*mm $length*mm $start_phi*deg $SpanAnglePlate*deg";
		$detector{"material"}    = "Air";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = "1";
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

#make_shield_platesf();
#make_shield_platesb();

sub Rot2
{
	my $R = shift;
	my $i = shift;
	
	my $theta     = $i*60.0;
	
	return "0*deg 0*deg $theta*deg";
}



