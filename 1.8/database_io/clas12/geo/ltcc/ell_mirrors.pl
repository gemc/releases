#!/usr/bin/perl -w

use strict;
use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);
use Getopt::Long;
use Math::Trig;

# local quantities.

my $envelope = 'LTCC_EL_Mirrors';
my $file     = 'LTCC_EL_Mirrors.txt'; 
my $rmin = 1;
my $rmax = 1000000;


my $inches = 25.4;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


# All dimensions in cm

my @focal1x = (1..18);
my @focal1y = (1..18);
my @focal2x = (1..18);
my @focal2y = (1..18);
my @centerx = (1..18);
my @centery = (1..18);

my @axisa = (1..18);
my @axisb = (1..18);

my @alpha = (1..18);


my @x12           = (1..18);
my @y12           = (1..18);
my @y11           = (1..18);
my @end_tocangle  = (1..18);   # angle between the end of right segment and the center of the ellipse
my @sta_tocangle  = (1..18);   # angle between the start of right segment and the center of the ellipse

my @thickness = (1..18);
my @segtheta  = (1..18);

my $mirrors_thickness = 1;

my $nmirrors = 18;
my $start_mirror = 1;


sub build_points
{
	
	for(my $n=$start_mirror; $n<$start_mirror + $nmirrors; $n++)
	{
		# Putting a small sphere at the two focal points
		my $fp1x  = $focal1x[$n-1];
		my $fp2x  = $focal2x[$n-1];
		my $mfp1x = -$focal1x[$n-1];
		my $mfp2x = -$focal2x[$n-1];
		
	
		
		$detector{"name"}        = "el_focal1_right_$n";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Focal Point for Ell Mirror $n";
		$detector{"pos"}         = "$fp1x*cm $focal1y[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"color"}       = "0000aa";
		$detector{"type"}        = "Sphere";
		$detector{"dimensions"}  = "0*cm 2*cm 0*deg 360*deg 0*deg 180*deg";
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
		#print_det(\%detector, $file);
		
		$detector{"name"}        = "el_focal1_left_$n";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Focal Point for Ell Mirror $n";
		$detector{"pos"}         = "$mfp1x*cm $focal1y[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"color"}       = "aa0000";
		$detector{"type"}        = "Sphere";
		$detector{"dimensions"}  = "0*cm 2*cm 0*deg 360*deg 0*deg 180*deg";
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
		
		$detector{"name"}        = "el_focal2_right_$n";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Focal Point for Ell Mirror $n";
		$detector{"pos"}         = "$fp2x*cm $focal2y[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"color"}       = "0000aa";
		$detector{"type"}        = "Sphere";
		$detector{"dimensions"}  = "0*cm 2*cm 0*deg 360*deg 0*deg 180*deg";
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
		
		
		$detector{"name"}        = "el_focal2_left_$n";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Focal Point for Ell Mirror $n";
		$detector{"pos"}         = "$mfp2x*cm $focal2y[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"color"}       = "aa0000";
		$detector{"type"}        = "Sphere";
		$detector{"dimensions"}  = "0*cm 2*cm 0*deg 360*deg 0*deg 180*deg";
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
		
	
		# Putting a small sphere at the x12 point (right)
		$detector{"name"}        = "el_x12_right_$n";
		$detector{"mother"}      = "root";
		$detector{"description"} = "x12for Ell Mirror $n";
		$detector{"pos"}         = "$x12[$n-1]*cm $y12[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"color"}       = "222299";
		$detector{"type"}        = "Sphere";
		$detector{"dimensions"}  = "0*cm 2*cm 0*deg 360*deg 0*deg 180*deg";
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
		
		# Putting a small sphere at the x12 point (left)
		$detector{"name"}        = "el_x12_left_$n";
		$detector{"mother"}      = "root";
		$detector{"description"} = "x12for Ell Mirror $n";
		$detector{"pos"}         = "-$x12[$n-1]*cm $y12[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"color"}       = "992222";
		$detector{"type"}        = "Sphere";
		$detector{"dimensions"}  = "0*cm 2*cm 0*deg 360*deg 0*deg 180*deg";
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
}	








# Read the focal points from file
# Alpha and center are calculated from this
sub read_foci
{
	my $fname = "el_foci.txt" ;
	
	open ( FILE,  $fname ) or
	die "Sorry, can't open file $fname \n";
	
	my $i    = 0;
	my @lines = <FILE>;
	foreach my $line (@lines)
	{
		chomp($line);
		my @lin_list = split(/[ ]+/,$line);
		
    $focal1x[$i] = $lin_list[1];
    $focal1y[$i] = $lin_list[2];
    $focal2x[$i] = $lin_list[3];
    $focal2y[$i] = $lin_list[4];
		
		$centerx[$i] = ($focal1x[$i] + $focal2x[$i])/2.0;
		$centery[$i] = ($focal1y[$i] + $focal2y[$i])/2.0;
		
		$alpha[$i]   = atan(($focal2y[$i]-$focal1y[$i])/($focal2x[$i]-$focal1x[$i]))*180/$pi;
		
		#print $i, "  alpha: " , $alpha[$i], "centerx: ", $centerx[$i], " center y: ", $centery[$i], "\n";
		$i += 1;
	}	
}

# Read the axis from file
sub read_axis
{
	my $fname = "axis.txt" ;
	
	open ( FILE,  $fname ) or
	die "Sorry, can't open file $fname \n";
	
	my $i    = 0;
	my @lines = <FILE>;
	foreach my $line (@lines)
	{
		chomp($line);
		my @lin_list = split(/[ ]+/,$line);
		
    $axisa[$i] = $lin_list[1];
    $axisb[$i] = $lin_list[2];
		
		my $focal1 = sqrt($axisa[$i]*$axisa[$i] - $axisb[$i]*$axisb[$i]);
		my $focal2 = sqrt( ($focal2y[$i] - $focal1y[$i])*($focal2y[$i] - $focal1y[$i]) + ($focal2x[$i] - $focal1x[$i])*($focal2x[$i] - $focal1x[$i]) )/2 ;
		
		my $check = $focal1 - $focal2;
		
		if($check > 0.0001) 
		{
			#print " WARNING: segment", $i, "   shows a difference in focal points calculation  " ,  $check , "\n";
		}
		$i += 1;
	}	
}


# reading the elliptical span points
sub read_x12y12
{
	my $fname = "x12y12.dat" ;
	
	open ( FILE,  $fname ) or
	die "Sorry, can't open file $fname \n";
	
	my $i    = 0;
	my @lines = <FILE>;
	foreach my $line (@lines)
	{
		chomp($line);
		my @lin_list = split(/[ ]+/,$line);
		
    $x12[$i] = $lin_list[1];
    $y12[$i] = $lin_list[2];
		
		
		# calculating the span angles in the system
		# with (0, 0) at the midpoint between the focal points
		

		# angle between end of segment E and center of the ellipse
		# in respect to the y axis
    
		#  |     E
		#  |    /
		#  |   /
		#  |  /
		#  | C
		#  |/
    #  /
		# /|
		
  
		my $xloc2 = $x12[$i] - $centerx[$i];
		my $yloc2 = $y12[$i] - $centery[$i];
		$end_tocangle[$i] = 90 - (atan($yloc2/$xloc2))*180.0/$pi;
		
				
		# angle between start of segment O and center of the ellipse
		# in respect to the y axis
		# for the first two ellipses it has negative sign

		# S  |
		#  \ |
		#   \|
		#    \
		#    |\
		#    | C
		
    my $xloc1 = 0         - $centerx[$i];
		my $yloc1 = $y11[$i]  - $centery[$i];
	
		
		if($centerx[$i]<0) { $sta_tocangle[$i] =  -90 + (atan($yloc1/$xloc1))*180.0/$pi ; }
		if($centerx[$i]>0) { $sta_tocangle[$i] =   90 + (atan($yloc1/$xloc1))*180.0/$pi ; }
		
		print "segment " , $i+1,  " end to c ", $end_tocangle[$i], "  start to c " , $sta_tocangle[$i], "\n";
	
		$i += 1;
	}	
}

# reading the mirror start point
sub read_el_y11
{
	my $fname = "el_y11.txt" ;
	open ( FILE,  $fname ) or
	die "Sorry, can't open file $fname \n";
	
	my $i    = 0;
	my @lines = <FILE>;
	foreach my $line (@lines)
	{
		chomp($line);
		my @lin_list = split(/[ ]+/,$line);
		
    $y11[$i] = $lin_list[0];
		
		#print $y11[$i], "\n";
		
		$i += 1;
	}	
}


sub read_thickness
{
	my $fname = "thicknesses.txt" ;
	open ( FILE,  $fname ) or
	die "Sorry, can't open file $fname \n";
	
	my $i    = 0;
	my @lines = <FILE>;
	foreach my $line (@lines)
	{
		chomp($line);
		my @lin_list = split(/[ ]+/,$line);
		
    
    $thickness[$i] = $lin_list[1];
		
		#print $thickness[$i], "\n";
		
		$i += 1;
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

read_el_y11();
read_foci();
read_axis();
read_x12y12();
read_thickness();
read_theta();


build_mirrors_frames();
#build_points();



















