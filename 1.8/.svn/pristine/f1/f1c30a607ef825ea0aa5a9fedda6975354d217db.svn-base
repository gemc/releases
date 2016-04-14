#!/usr/bin/perl -w

use strict;
use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);
use Getopt::Long;
use Math::Trig;

# local quantities.

my $envelope = 'LTCC_PMTS';
my $file     = 'LTCC_PMTS.txt'; 
my $rmin = 1;
my $rmax = 1000000;


my $inches = 25.4;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


# All dimensions in cm


# PMTS parameters
# PMTs are tubes
my @x0   = (1..18);
my @y0   = (1..18);
my @rad  = (1..18);
my @len  = (1..18);
my @tilt = (1..18); # Tilt angle of the PMT in the segment ref. system

my @ang = (1..18);  # Segment Angle with respect to the y axis

 
my @segtheta  = (1..18);

my $nmirrors = 18;
my $start_mirror = 1;


sub build_pmts
{

	for(my $n=$start_mirror; $n<$start_mirror + $nmirrors; $n++)
	{
		
		$detector{"name"}        = "pmt_right_$n";
		$detector{"mother"}      = "segment_pmt_$n";
		#$detector{"mother"}      = "root";
		$detector{"description"} = "PMT right $n";
		$detector{"pos"}         = "$x0[$n-1]*cm $y0[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "90*deg -$tilt[$n-1]*deg 0*deg"; 
		$detector{"color"}       = "992200";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "0*cm $rad[$n-1]*cm $len[$n-1]*cm 0*deg 360*deg";
		$detector{"material"}    = "Air_Opt";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = 1;
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "LTCC";
		$detector{"hit_type"}    = "LTCC";
		$detector{"identifiers"} = "sector ncopy 0 side manual 1 nphe_pmt manual $n";
		print_det(\%detector, $file);
		
		$detector{"name"}        = "pmt_left_$n";
		$detector{"mother"}      = "segment_pmt_$n";
		#$detector{"mother"}      = "root";
		$detector{"description"} = "PMT right $n";
		$detector{"pos"}         = "-$x0[$n-1]*cm $y0[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "90*deg $tilt[$n-1]*deg 0*deg"; 
		$detector{"color"}       = "992200";
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "0*cm $rad[$n-1]*cm $len[$n-1]*cm 0*deg 360*deg";
		$detector{"material"}    = "Air_Opt";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = 1;
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "LTCC";
		$detector{"hit_type"}    = "LTCC";
		$detector{"identifiers"} = "sector ncopy 0 side manual 2 nphe_pmt manual $n";
		print_det(\%detector, $file);
		
	  
    # Building the box that contains the pmts (left and right)
    # Starts 1mm above x11
    my $segment_box_length    = $x0[$n-1]  + $rad[$n-1] + 2;
    my $segment_box_thickness = 2*$rad[$n-1] + 2;
    my $segment_box_height    = $y0[$n-1]  + $rad[$n-1] + 2;
    $detector{"name"}        = "segment_pmt_box_$n";
    $detector{"mother"}      = "root";
    $detector{"description"} = "Light Threshold Cerenkov Counter Segment Box $n";
    $detector{"pos"}         = "0*cm 0*cm 0*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"color"}       = "880011";
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$segment_box_length*cm $segment_box_height*cm $segment_box_thickness*cm";
    $detector{"material"}    = "Air_Opt";
    $detector{"material"}    = "Component";
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 0;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = "";
    print_det(\%detector, $file);
  
  
    #  # Box to subract from  segment box
    #  # Starts 1mm below 
 		my $s_segment_box_length    = $segment_box_length    + 0.2;
		my $s_segment_box_thickness = $segment_box_thickness + 0.2;
		my $s_segment_box_height    = $segment_box_height   ;
		my $yshift = $segment_box_thickness;      # Should be enough to encompass all mirrrors
    
    $detector{"name"}        = "segment_pmt_subtract_box_$n";;
    $detector{"mother"}      = "root";
    $detector{"description"} = "Light Threshold Cerenkov Counter Segment Box to Subtract $n";
    $detector{"pos"}         = "0*cm -$yshift*cm 0*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"color"}       = "1100ff";
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$s_segment_box_length*cm $s_segment_box_height*cm $s_segment_box_thickness*cm";
    $detector{"material"}    = "Air_Opt";
    $detector{"material"}    = "Component";
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 0;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = "";
    print_det(\%detector, $file);
 
      
      
    $detector{"name"}        = "segment_pmt_$n";;
    $detector{"mother"}      = "LTCC";
    $detector{"description"} = "Light Threshold Cerenkov Counter ELL segment $n";
    $detector{"pos"}         = "0*cm 0*cm 0*mm";
    #$detector{"mother"}      = "root";
    #$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"rotation"}    = "-$segtheta[$n-1]*deg 0*deg 0*deg"; 
    $detector{"color"}       = "00ff11";
    $detector{"type"}        = "Operation: segment_pmt_box_$n - segment_pmt_subtract_box_$n";
    $detector{"dimensions"}  = "0";
    $detector{"material"}    = "CCGas";
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


  

}	


sub read_theta
{
	my $fname = "thetas.txt" ;
	open ( FILE,  $fname ) or
	die "Sorry, can't open file $fname \n";
	
	my $i    = 0;
	my @lines = <FILE>;
	foreach my $line (@lines)
	{
		chomp($line);
		my @lin_list = split(/[ ]+/,$line);
		
    $segtheta[$i] = 90 - $lin_list[3];
		
		#print $segtheta[$i], "\n";
		
		$i += 1;
	}	
}

sub read_pmts_pars
{

	my $fname = "wcpmts.txt" ;
	
	open ( FILE,  $fname ) or
	die "Sorry, can't open file $fname \n";
	
	my $i    = 0;
	my @lines = <FILE>;
	foreach my $line (@lines)
	{
		chomp($line);
		my @lin_list = split(/[ ]+/,$line);
		
    $x0[$i]   = $lin_list[4];
    $y0[$i]   = $lin_list[5];
    $rad[$i]  = $lin_list[7];
    $tilt[$i] = $lin_list[9];
		$len[$i] = 1;  # Harcoding length here
		#print " x0: ", $x0[$i], " y0: ", $y0[$i], " rad: ", $rad[$i], "  tilt angle: ", $tilt[$i], "\n"; 
		$i += 1;
	}
}

read_theta();
read_pmts_pars();
build_pmts();



















