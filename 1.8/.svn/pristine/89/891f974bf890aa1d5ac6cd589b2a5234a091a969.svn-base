#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use Getopt::Long;
use Math::Trig;


my $config_file = 'ctof.config';

# Load configuration
my %configuration = load_configuration($config_file); 

# Load parameters from mysql database
my %parameters    = download_parameters(%configuration);

# Assign paramters to local variables
my $NUM_BARS = $parameters{"ctof_number_of_bars"};
my $dx1    =   $parameters{"bar_top_width"}*$inches/2.0;      # width at top,cm
my $dx2    =   $parameters{"bar_bottom_width"}*$inches/2.0;   # width at bottom, cm
my $dy     =   $parameters{"bar_length"}*$inches/2.0;         # length, cm
my $dz     =   $parameters{"bar_heigth"}*$inches/2.0;         # heigth, cm
my $theta0 = 360./$NUM_BARS;                                  # double the angle of one of the trapezoid sides



my $envelope = 'CTOF';
my $file     = 'CTOF.txt';


my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


# All dimension in cm


# Paddle Dimensions
my $R      =  25.0 + $dz + 0.1;    # midway between R_outer and R_inner - cm

# Mother Volume
sub make_ITOF_mother
{
 $detector{"name"}        = "CTOF";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Central TOF Envelope";
 $detector{"pos"}         = "0*cm 0.0*cm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff11aa5";
 $detector{"type"}        = "Tube";

 my $Rin        = $R - $dz - 0.1;
 my $Rout       = $R + $dz + 0.1;
 my $DZ         = $dy;

 $detector{"dimensions"}  = "$Rin*cm $Rout*cm $DZ*cm 0*deg 360*deg";
 $detector{"material"}    = "Air";
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



# Paddles
sub make_ITOF
{
 for(my $n=1; $n<=$NUM_BARS; $n++)
 {
		my $pnumber     = cnumber($n-1, 10);

		$detector{"name"}        = "CTOF_Paddle_$pnumber";
		$detector{"mother"}      = "CTOF" ;
		$detector{"description"} = "Central TOF Scintillator $n";

		# positioning
		# The angle $theta is defined off the y-axis (going clockwise) so $x and $y are reversed
		my $theta  = ($n-1)*$theta0;
		my $theta2 = $theta + 90;
		my $x      = sprintf("%.3f", $R*cos(rad($theta)));
		my $y      = sprintf("%.3f", $R*sin(rad($theta)));
		my $z      = "0";
		$detector{"pos"}        = "$x*cm $y*cm $z*cm";
		$detector{"rotation"}   = "90*deg $theta2*deg 0*deg";
		$detector{"color"}      = "66bbff";
		$detector{"type"}       = "Trd";
		$detector{"dimensions"} = "$dx1*cm $dx2*cm $dy*cm $dy*cm $dz*cm";
		$detector{"material"}   = "Scintillator";
		$detector{"mfield"}     = "no";
		$detector{"ncopy"}      = $n;

		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "CTOF";
		$detector{"hit_type"}    = "CTOF";
		$detector{"identifiers"} = "paddle manual $n";

		print_det(\%detector, $file);
 }
}


make_ITOF_mother();
make_ITOF();


