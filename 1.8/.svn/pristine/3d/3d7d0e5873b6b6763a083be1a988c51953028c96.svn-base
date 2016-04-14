#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope         = $ARGV[0];
my $file             = $envelope.".txt";
my $number_phislices = $ARGV[1];
my $number_rhoslices = $ARGV[2];


my $rmin = 1;
my $rmax = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;


# dimensions in cm

my $r0 = 200.0;   # solenoid inner radius
my $r1 = 500.0;   # solenoid outer radius (part in between includes the hadron calorimeter and the iron of the muon detector)

my $length = 500.0/2.0;     # same as CTOF paddles

my $paddles_gap  = 5.0;    # gap betweens paddles (radial)
my $paddles_gap2 = 0.01;   # gap betweens paddles (phi)
my $mother_gap  = 0.12;    # mother volume gap

my $dR = ($r1-$r0-$paddles_gap*($number_rhoslices-1) - 2*$mother_gap) / $number_rhoslices;  # height of one region

my $angle_slice = 360.0/$number_phislices;

#my @pcolor = ('33dd66', '33bb88', '33aaaa', '3399bb', '33dd66', '33bb88', '33aaaa', '3399bb');
my @pcolor = ('c4c4c4', 'a8a8a8', '8c8c8c', '3399bb', '33dd66', '33bb88', '33aaaa', '3399bb');

# Mother Volume
sub make_CD
{
 my $IR = $r0		- $mother_gap;
 my $OR = $r1		+ $mother_gap;
 my $LL = $length + $mother_gap;

 $detector{"name"}        = $envelope;
 $detector{"mother"}      = "root";
 $detector{"description"} = "Central Detector";
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "a8a8a8";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$IR*cm $OR*cm $LL*cm 0*deg 360*deg";
 $detector{"material"}    = "Air";
 $detector{"mfield"}      = "uniformZ4T";
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


# Paddles
sub make_CD_paddles
{
 for(my $j=1; $j<=$number_rhoslices; $j++)
 {
		my $innerRadius = $r0 + ($j-1) *$dR + ($j-1)*$paddles_gap + $mother_gap;
		my $outerRadius = $innerRadius + $dR;
		my $R = ($innerRadius + $outerRadius) / 2.0;

		my $side1 = 2.0*$innerRadius*sin(rad($angle_slice/2.0));
		my $side2 = 2.0*$outerRadius*sin(rad($angle_slice/2.0));

		for(my $i=1; $i<=$number_phislices; $i++)
		{
			my $pnumber = cnumber($i-1, 10);
			my $theta   = ($i-1)*$angle_slice;
			my $x       = sprintf("%.3f", $R*cos(rad($theta)));
			my $y       = sprintf("%.3f", $R*sin(rad($theta)));
			my $z       = "0.";
			my $theta2  = $theta + 90;
			my $dx1     = ($side2 - $paddles_gap2)/2.0;
			my $dx2     = ($side1 - $paddles_gap2)/2.0;
			my $dy      = $length;
			my $dz      = ($outerRadius - $innerRadius)/2.0;

			$detector{"name"}        =  "CD_Layer$j"."_Paddle_$pnumber";
			$detector{"mother"}      = $envelope;
			$detector{"description"} = "Central Detector, Layer $j, Scintillator $i";
			$detector{"pos"}         = "$x*cm $y*cm $z*cm";
			$detector{"rotation"}    = "90*deg $theta2*deg 0*deg";
			$detector{"color"}       = $pcolor[$j-1];
			$detector{"type"}        =  "Trd";
			$detector{"dimensions"}  = "$dx1*cm $dx2*cm $dy*cm $dy*cm $dz*cm";
			$detector{"material"}    = "Scintillator";
			$detector{"mfield"}      =  "no";
			$detector{"ncopy"}       = $pnumber;
			$detector{"pMany"}       = 1;
			$detector{"exist"}       = 1;
			$detector{"visible"}     = 1;
			$detector{"style"}       = 1;
			$detector{"sensitivity"} = "no";
			$detector{"hit_type"}    = "n0";
			$detector{"identifiers"} = "";

			print_det(\%detector, $file);
    }
 }
}


sub make_CD_Field
{
	
	$detector{"name"}        = "daugther";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Solenoid field";
	$detector{"pos"}         = "0*cm 0*cm 0*m";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ff0000";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "10*cm 200*cm 250*cm 0*deg 360*deg";
	$detector{"material"}    = "Air";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 0;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	
	print_det(\%detector, $file);
}


sub make_CD_CEC
{
	
	$detector{"name"}        = "daugther1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Central Electromagnetic Calorimeter";
	$detector{"pos"}         = "0*cm 0*cm 0*m";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "3232cd";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "150*cm 200*cm 250*cm 0*deg 360*deg";
	$detector{"material"}    = "Air";
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

sub make_CD_DIRC
{
	
	$detector{"name"}        = "daugther2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Central DIRC";
	$detector{"pos"}         = "0*cm 0*cm 0*m";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "05e9ff";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "50*cm 150*cm 250*cm 0*deg 360*deg";
	$detector{"material"}    = "Air";
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


sub make_CD_Tracking
{
	
	$detector{"name"}        = "daugther3";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Central Tracking";
	$detector{"pos"}         = "0*cm 0*cm 0*m";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "fff000";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "0*cm 50*cm 250*cm 0*deg 360*deg";
	$detector{"material"}    = "Air";
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

sub make_CD_RICH
{
	
	$detector{"name"}        = "daugther4";
	$detector{"mother"}      = "root";
	$detector{"description"} = "RICH";
	$detector{"pos"}         = "0*cm 0*cm 3*m";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ee00ee";
	$detector{"type"}        = "Cons";
	$detector{"dimensions"}  = "10*cm 11*cm 200*cm 210*cm 1*m 0*deg 360*deg";
	$detector{"material"}    = "Air";
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


make_CD();
make_CD_paddles();
make_CD_Field();
make_CD_CEC();
make_CD_DIRC();
make_CD_Tracking();
make_CD_RICH();






