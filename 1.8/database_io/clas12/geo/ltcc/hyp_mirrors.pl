#!/usr/bin/perl -w

use strict;
use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);
use Getopt::Long;
use Math::Trig;

# local quantities.

my $envelope = 'LTCC_HP_Mirrors';
my $file     = 'LTCC_HP_Mirrors.txt'; 
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
my @alpha = (1..18);

# Hyperbola parameters
my @p1 = (1..18);
my @p2 = (1..18);
my @p3 = (1..18);
my @p4 = (1..18);
my @p5 = (1..18);


my @x21           = (1..18);
my @y21           = (1..18);
my @hp_min        = (1..18);
my @end_tocangle  = (1..18);   # angle between the end of right segment and the center of the hyperbola
my @sta_tocangle  = (1..18);   # angle between the start of right segment and the center of the hyperbola

my @thickness = (1..18);
my @segtheta  = (1..18);

my $mirrors_thickness = 0.1;

my $nmirrors = 18;
my $start_mirror = 1;


sub build_mirrors_frames
{

	for(my $n=$start_mirror; $n<$start_mirror + $nmirrors; $n++)
	{
		my $mirrors_thickness    = $thickness[$n-1];

		# Modify number of sides here to make it more precise
		my $nsides = int(($x21[$n-1] - $hp_min[$n-1])/3) + 1 ;
		#my $nsides = 30 ;
    
    print $n, "  length: ", $x21[$n-1] - $hp_min[$n-1], "  number of sides: ", $nsides, "\n";
    
    my @XPOS  = (1..$nsides);
    my @YPOS1 = (1..$nsides);
    my @YPOS2 = (1..$nsides);
    
    my $MINY = 9999;
    for(my $s=0; $s<$nsides; $s++)
    {
    	my $dx = ($x21[$n-1] - $hp_min[$n-1])/$nsides;
      $XPOS[$s]  = $s*$dx;
      $YPOS1[$s] = calc_yp($hp_min[$n-1] + $s*$dx, $n-1);
    
    	# Finding minimum
      if($YPOS1[$s] < $MINY) {$MINY=$YPOS1[$s];}
    
    }
   
   	# We want to add thickness to the minimum
    my $YPOSSUB = -$mirrors_thickness - 2;
    
    my $SUBY = $MINY + $YPOSSUB;
    
    my $YPOS0 =  $YPOSSUB + $y21[$n-1];
    
    
    for(my $s=0; $s<$nsides; $s++)
    {
    	$YPOS1[$s] -= $SUBY;	
      $YPOS2[$s] = $YPOS1[$s] + 1;  # mirror depth thickness 
    	print " x: ", $XPOS[$s] , "  y1: " , $YPOS1[$s], "  y2: " , $YPOS2[$s], "\n"; 
		}   	
   
   
  	my $dimensions = "45*deg 90*deg 1 $nsides";
    for(my $s=0; $s<$nsides; $s++)
    {
      $dimensions = $dimensions ." $YPOS1[$s]*cm";
    }
    for(my $s=0; $s<$nsides; $s++)
    {
      $dimensions = $dimensions ." $YPOS2[$s]*cm";
    }
    for(my $s=0; $s<$nsides; $s++)
    {
      $dimensions = $dimensions ." $XPOS[$s]*cm";
    }
   
   
		# Right Box to subtract
    my $box_d = 100;
    my $xpos  = $thickness[$n-1] + $box_d;
    $detector{"name"}        = "right_sbox_$n";
    $detector{"mother"}      = "root";
    $detector{"description"} = "LTCC Hyperbolic mirror right subtract box $n";
    $detector{"pos"}         = "$xpos*cm 0*mm 0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = "4455aa";
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$box_d*cm $box_d*cm $box_d*cm";
    $detector{"material"}    = "Air";
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
 		
    # Left Box to subtract
    $xpos  = -$thickness[$n-1] - $box_d;
    $detector{"name"}        = "left_sbox_$n";
    $detector{"mother"}      = "root";
    $detector{"description"} = "LTCC Hyperbolic mirror left subtract box $n";
    $detector{"pos"}         = "$xpos*cm 0*mm 0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = "4455aa";
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$box_d*cm $box_d*cm $box_d*cm";
    $detector{"material"}    = "Air";
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
 
   
    
		# hyperbolic shape (full)
    $detector{"name"}        = "hyperbolic_$n";
    $detector{"mother"}      = "root";
    $detector{"description"} = "LTCC Hyperbolic full shape $n";
    $detector{"pos"}         = "0*mm 0*mm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
    $detector{"color"}       = "4455aa";
    $detector{"type"}        = "Pgon";
    $detector{"dimensions"}  = "$dimensions";
    $detector{"material"}    = "Air";
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
		    
    
    # Subtracting left box 
    $detector{"name"}        = "hyperbolix_rbox_$n";
    $detector{"mother"}      = "root";
    $detector{"description"} = "LTCC Hyperbolic mirror right minus right box $n";
    $detector{"pos"}         = "0*mm 0*mm 0*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = "4455aa";
    $detector{"type"}        = "Operation: hyperbolic_$n - left_sbox_$n";
    $detector{"dimensions"}  = "$dimensions";
    $detector{"material"}    = "Air";
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
		
    # Subtracting right box - RIGHT MIRROR
    $detector{"name"}        = "hyp_mirror_right_$n";
    $detector{"mother"}      = "segment_hyp_$n";
    $detector{"description"} = "LTCC Hyperbolic mirror right $n";
    $detector{"pos"}         = "$hp_min[$n-1]*cm $YPOS0*cm 0*cm";
    $detector{"rotation"}    = "0*deg -90*deg 0*deg";
    $detector{"color"}       = "4455aa";
    $detector{"type"}        = "Operation: hyperbolix_rbox_$n - right_sbox_$n";
    $detector{"dimensions"}  = "$dimensions";
    $detector{"material"}    = "Air";
		$detector{"mfield"}      = "no";
    $detector{"ncopy"}       = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
		$detector{"sensitivity"} = "Mirrors";
		$detector{"hit_type"}    = "Mirrors";
		$detector{"identifiers"} = "Mirror WithSurface: 0    With Finish: 0   Refraction Index: 1108000  With Reflectivity  1000000   With Efficiency 1000000   WithBorderVolume: MirrorSkin";
		print_det(\%detector, $file);
		
    # Subtracting right box - LEFT MIRROR
    $detector{"name"}        = "hyp_mirror_left_$n";
    $detector{"mother"}      = "segment_hyp_$n";
    $detector{"description"} = "LTCC Hyperbolic mirror right $n";
    $detector{"pos"}         = "-$hp_min[$n-1]*cm $YPOS0*cm 0*cm";
    $detector{"rotation"}    = "0*deg 90*deg 0*deg";
    $detector{"color"}       = "aa4455";
    $detector{"type"}        = "Operation: hyperbolix_rbox_$n - right_sbox_$n";
    $detector{"dimensions"}  = "$dimensions";
    $detector{"material"}    = "Air";
		$detector{"mfield"}      = "no";
    $detector{"ncopy"}       = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
		$detector{"sensitivity"} = "Mirrors";
		$detector{"hit_type"}    = "Mirrors";
		$detector{"identifiers"} = "Mirror WithSurface: 0    With Finish: 0   Refraction Index: 1108000  With Reflectivity  1000000   With Efficiency 1000000   WithBorderVolume: MirrorSkin";
		print_det(\%detector, $file);
		
    
    
 		# Building the box that contains the mirrors (left and right)
		# Starts 1mm above x11
		my $segment_box_length    = $x21[$n-1] + 0.1;
		my $segment_box_thickness = $thickness[$n-1] + 0.1;
		my $yshift = 20;      # Should be enough to encompass all mirrrors
		my $segment_box_height    = $YPOS0 + $yshift;
		$detector{"name"}        = "segment_hyp_box_$n";;
		$detector{"mother"}      = "root";
		$detector{"description"} = "Light Threshold Cerenkov Counter HYP Segment Box $n";
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
   
 		# Box to subract from  segment box
		# Starts at YPOS0
		my $s_segment_box_length    = $segment_box_length    + 0.2;
		my $s_segment_box_thickness = $segment_box_thickness + 0.2;
		my $s_segment_box_height    = $segment_box_height   ;
		$detector{"name"}        = "segment_hyp_subtract_box_$n";;
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
  
    
		$detector{"name"}        = "segment_hyp_$n";;
		$detector{"mother"}      = "LTCC";
		$detector{"description"} = "Light Threshold Cerenkov Counter HYP segment $n";
		$detector{"pos"}         = "0*cm 0*cm 0*mm";
    #$detector{"mother"}      = "root";
    #$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"rotation"}    = "-$segtheta[$n-1]*deg 0*deg 0*deg"; 
		$detector{"color"}       = "00ff11";
		$detector{"type"}        = "Operation: segment_hyp_box_$n - segment_hyp_subtract_box_$n";
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


sub build_points
{
	
	for(my $n=$start_mirror; $n<$start_mirror + $nmirrors; $n++)
	{
		# Putting a small sphere at the two focal points
		my $fp1x  = $focal1x[$n-1];
		my $fp2x  = $focal2x[$n-1];
		my $mfp1x = -$focal1x[$n-1];
		my $mfp2x = -$focal2x[$n-1];
		
	
		$detector{"name"}        = "hy_focal1_right_$n";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Focal Point for Hyperbolic Mirror $n";
		$detector{"pos"}         = "$fp1x*cm $focal1y[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"color"}       = "00ffaa";
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
		
		$detector{"name"}        = "hy_focal1_left_$n";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Focal Point for Hyperbolic Mirror $n";
		$detector{"pos"}         = "$mfp1x*cm $focal1y[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"color"}       = "aaff00";
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
		
		$detector{"name"}        = "hy_focal2_right_$n";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Focal Point for Hyperbolic Mirror $n";
		$detector{"pos"}         = "$fp2x*cm $focal2y[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"color"}       = "00ffaa";
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
		
		
		$detector{"name"}        = "hy_focal2_left_$n";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Focal Point for Hyperbolic Mirror $n";
		$detector{"pos"}         = "$mfp2x*cm $focal2y[$n-1]*cm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
		$detector{"color"}       = "aaff00";
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
	my $fname = "hp_foci.txt" ;
	
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



# reading the Hyperbola span points
sub read_x21y21
{
	my $fname = "x21y21.dat" ;
	
	open ( FILE,  $fname ) or
	die "Sorry, can't open file $fname \n";
	
	my $i    = 0;
	my @lines = <FILE>;
	foreach my $line (@lines)
	{
		chomp($line);
		my @lin_list = split(/[ ]+/,$line);
		
    $x21[$i] = $lin_list[1];
    $y21[$i] = $lin_list[2];
				
		# calculating Hyperbola start point
		# the y point on the hyperbola at x = hp_min[0][s]
		# solving quadratic equation
		my $a = $p2[$i];
		my $b = $p3[$i]*$hp_min[$i] + $p5[$i];
		my $c = 1 + $p1[$i]*$hp_min[$i]*$hp_min[$i] + $p4[$i]*$hp_min[$i];
		my $hp_y_sol = (-$b - sqrt($b*$b-4*$a*$c))/(2*$a);
		
		#print " segment ", $i+1, " x start: " , $hp_min[$i] , "  y start: " , $hp_y_sol, "\n";
		
		
		
		
    
    
		# angle between end of segment E and center of the hyperbola
		# in respect to the y axis

 		# C  |
		#  \ |
		#   \|
		#    \
		#    |\
		#    | E
		
		my $xloc2 = $centerx[$i] - $x21[$i] ;
		my $yloc2 = $centery[$i] - $y21[$i] ;

		$end_tocangle[$i] = 90 - (atan($yloc2/$xloc2))*180.0/$pi;
		
				
    
		
		# angle between start of segment S and center of the hyperbola
		# in respect to the y axis

		#  |     C
		#  |    /
		#  |   /
		#  |  /
		#  | S
		#  |/
    #  /
		# /|
		
		
		my $xloc1 = $centerx[$i] - $hp_min[$i];
		my $yloc1 = $centery[$i] - $hp_y_sol;
    $sta_tocangle[$i] =  90 - (atan($yloc1/$xloc1))*180.0/$pi ; 
		
    # For the second segment the center is BELOW the hyperbola start point
    
		#print "segment " , $i+1,  " end to c ", $end_tocangle[$i], "  start to c " , $sta_tocangle[$i], "\n";
	
		$i += 1;
	}	
}


sub read_hp_min
{
	my $fname = "hp_min.txt" ;
	open ( FILE,  $fname ) or
	die "Sorry, can't open file $fname \n";
	
	my $i    = 0;
	my @lines = <FILE>;
	foreach my $line (@lines)
	{
		chomp($line);
		my @lin_list = split(/[ ]+/,$line);
		
    $hp_min[$i] = $lin_list[0];
		
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
		
    $thickness[$i] = $lin_list[2];
		
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

sub read_hp_pars
{

	my $fname = "hp_pars.txt" ;
	
	open ( FILE,  $fname ) or
	die "Sorry, can't open file $fname \n";
	
	my $i    = 0;
	my @lines = <FILE>;
	foreach my $line (@lines)
	{
		chomp($line);
		my @lin_list = split(/[ ]+/,$line);
		
    $p1[$i] = $lin_list[1];
    $p2[$i] = $lin_list[2];
    $p3[$i] = $lin_list[3];
    $p4[$i] = $lin_list[4];
    $p5[$i] = $lin_list[5];

		#print " p1: ", $p1[$i], " p2: ", $p2[$i], " p3: ", $p3[$i], " p4: ", $p4[$i], " p5: ", $p5[$i], "\n"; 
		$i += 1;
	}
}


read_foci();
read_hp_pars();
read_hp_min();
read_x21y21();
read_thickness();
read_theta();


build_mirrors_frames();
#build_points();



















