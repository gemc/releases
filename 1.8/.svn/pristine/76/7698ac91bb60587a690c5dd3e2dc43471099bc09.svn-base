#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'PMTajrp';
my $file     = 'PMTajrp.txt';

print "FILE: ",  $file."\n";

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector

$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

my @colors_even = ( "f09000", "0000a0", "a00000", "a0a0a0" );

# for all detectors, need to define: name, mother, description, pos, rot, col, type, dimensions, material, magfield, ncopy, pmany, exist, visible, style, sensitivity, hitType, identifiers

$detector{"mfield"}      = "no";
$detector{"ncopy"}       = 1;
$detector{"pMany"}       = 1;
$detector{"exist"}       = 1;
$detector{"visible"}     = 1;
$detector{"style"}       = 1;
$detector{"sensitivity"} = "no";
$detector{"hit_type"}    = "";
$detector{"identifiers"} = "";

# set sensible defaults for the above, remaining definitions needed are name, mother, description, pos, rot, col, type, dimensions, material

############ 48 PMTs ###################

my $pi = 3.14159265359;

my $sectorphideg = 60.0;
my $sectorphirad = $sectorphideg * $pi/180.0;

my $PMTradius = 55.0; # 127 mm = 5 inches, but active photocathode diameter is only 110 mm
my $PMTlength = 3.0; # use constant length for the PMTs, in contrast to Nate's formulation, which I don't understand, this is approximate length
my $PMTdz = $PMTlength/2.0;

############## 48 Winston Cones ##############

my $WCr1 = 55.0; # in mm, radius at z1 (inner shell)
my $WCr2 = 74.1426; # in mm, radius at z2 (inner shell)
my $WCz1 = 233.0; # in mm, z of bottom of Winston cone
my $WCz2 = 423.5; # in mm, z of top of Winston cone

my $WCdz = 0.5*($WCz2 - $WCz1); # for a G4paraboloid dz is defined as half-width along z

my $WCdzd = $WCdz + 30.0;

#### equation for paraboloid: 

my $WCk2 = ($WCr1**2 + $WCr2**2)/2.0;
my $WCk1 = ($WCr2**2 - $WCr1**2)/(2.0*$WCdz);
 
my $WCr1d = sqrt( $WCk2 - $WCdzd * $WCk1 );
my $WCr2d = sqrt( $WCk2 + $WCdzd * $WCk1 );

print "(dzd, r1d, r2d)=(" . $WCdzd . ", " . $WCr1d . ", " . $WCr2d . ")\n";

my @focalpointsleft = ( [417.483, 1558.067, -62.047], [462.948, 1727.744, 163.333], [492.379, 1837.584, 425.482], [503.907, 1880.607, 707.739] );

my @focalpointsright = ( [-417.483, 1558.067, -62.047], [-462.948, 1727.744, 163.333], [-492.379, 1837.584, 425.482], [-503.907, 1880.607, 707.739] );

my @directionanglesleftdeg = ( [85.2787, 72.1106, 161.4570], 
			       [81.6072, 56.9940, 145.6710], 
			       [78.6436, 42.7025, 130.4645], 
			       [76.5506, 29.7704, 116.0198] );
my @directionanglesrightdeg = ( [94.7213, 72.1106, 161.4570], 
				[98.3928, 56.9940, 145.6710],
				[101.3564, 42.7025, 130.4645],
				[103.4494, 29.7704, 116.0198] );

# GOAL: position the PMTs such that the photocathodes are located at the focal points and they point in the direction defined by the angles above. 

# for a vector given by (nx, ny, nz), the cosine of its angle with respect to any given axis is, by definition
# cos( theta_x ) = nx / sqrt(nx^2 + ny^2 + nz^2)
# cos( theta_y ) = ny / sqrt(nx^2 + ny^2 + nz^2)
# cos( theta_z ) = nz / sqrt(nx^2 + ny^2 + nz^2)

# if we know theta_x,y,z, then each element of the vector is proportional to cos(theta_x,y,z), we just need to normalize so that we have a unit vector:



my @unitvectorsleft = ( [ cos($directionanglesleftdeg[0][0]*$pi/180.0), cos($directionanglesleftdeg[0][1]*$pi/180.0), cos($directionanglesleftdeg[0][2]*$pi/180.0) ] ,  
			[ cos($directionanglesleftdeg[1][0]*$pi/180.0), cos($directionanglesleftdeg[1][1]*$pi/180.0), cos($directionanglesleftdeg[1][2]*$pi/180.0) ] ,
			[ cos($directionanglesleftdeg[2][0]*$pi/180.0), cos($directionanglesleftdeg[2][1]*$pi/180.0), cos($directionanglesleftdeg[2][2]*$pi/180.0) ] ,
			[ cos($directionanglesleftdeg[3][0]*$pi/180.0), cos($directionanglesleftdeg[3][1]*$pi/180.0), cos($directionanglesleftdeg[3][2]*$pi/180.0) ] );

for( my $i=0; $i<4; $i++ ){
    my $sumsq = 0.0;
    for( my $j=0; $j<3; $j++ ){
	$sumsq += $unitvectorsleft[$i][$j]**2;
    }
    for( my $j=0; $j<3; $j++ ){
	$unitvectorsleft[$i][$j] *= (1.0/sqrt($sumsq));
	print "$unitvectorsleft[$i][$j]" . ", ";
    }
    print "\n";
}

my @unitvectorsright = ( [ cos($directionanglesrightdeg[0][0]*$pi/180.0), cos($directionanglesrightdeg[0][1]*$pi/180.0), cos($directionanglesrightdeg[0][2]*$pi/180.0) ] ,  
			 [ cos($directionanglesrightdeg[1][0]*$pi/180.0), cos($directionanglesrightdeg[1][1]*$pi/180.0), cos($directionanglesrightdeg[1][2]*$pi/180.0) ] ,
			 [ cos($directionanglesrightdeg[2][0]*$pi/180.0), cos($directionanglesrightdeg[2][1]*$pi/180.0), cos($directionanglesrightdeg[2][2]*$pi/180.0) ] ,
			 [ cos($directionanglesrightdeg[3][0]*$pi/180.0), cos($directionanglesrightdeg[3][1]*$pi/180.0), cos($directionanglesrightdeg[3][2]*$pi/180.0) ] );
    

for( my $i=0; $i<4; $i++ ){
    my $sumsq = 0.0;
    for( my $j=0; $j<3; $j++ ){
	$sumsq += $unitvectorsright[$i][$j]**2;
    }
    for( my $j=0; $j<3; $j++ ){
	$unitvectorsright[$i][$j] *= (1.0/sqrt($sumsq));
	print "$unitvectorsright[$i][$j]" . ", ";
    }
    print "\n";
}

# define the positions of the PMTs: position the PMT so that one end (the photocathode) is positioned at the focal point of 
# the associated mirror: In practice this means we have to shift the pmt center by half its length along its orientation vector:

my @PMTposleft = ( [$focalpointsleft[0][0]+$unitvectorsleft[0][0]*$PMTlength/2.0, 
		    $focalpointsleft[0][1]+$unitvectorsleft[0][1]*$PMTlength/2.0,
		    $focalpointsleft[0][2]+$unitvectorsleft[0][2]*$PMTlength/2.0],
		   [$focalpointsleft[1][0]+$unitvectorsleft[1][0]*$PMTlength/2.0, 
		    $focalpointsleft[1][1]+$unitvectorsleft[1][1]*$PMTlength/2.0,
		    $focalpointsleft[1][2]+$unitvectorsleft[1][2]*$PMTlength/2.0],
		   [$focalpointsleft[2][0]+$unitvectorsleft[2][0]*$PMTlength/2.0, 
		    $focalpointsleft[2][1]+$unitvectorsleft[2][1]*$PMTlength/2.0,
		    $focalpointsleft[2][2]+$unitvectorsleft[2][2]*$PMTlength/2.0],
		   [$focalpointsleft[3][0]+$unitvectorsleft[3][0]*$PMTlength/2.0, 
		    $focalpointsleft[3][1]+$unitvectorsleft[3][1]*$PMTlength/2.0,
		    $focalpointsleft[3][2]+$unitvectorsleft[3][2]*$PMTlength/2.0] );

my @PMTposright = ( [$focalpointsright[0][0]+$unitvectorsright[0][0]*$PMTlength/2.0, 
		     $focalpointsright[0][1]+$unitvectorsright[0][1]*$PMTlength/2.0,
		     $focalpointsright[0][2]+$unitvectorsright[0][2]*$PMTlength/2.0],
		    [$focalpointsright[1][0]+$unitvectorsright[1][0]*$PMTlength/2.0, 
		     $focalpointsright[1][1]+$unitvectorsright[1][1]*$PMTlength/2.0,
		     $focalpointsright[1][2]+$unitvectorsright[1][2]*$PMTlength/2.0],
		    [$focalpointsright[2][0]+$unitvectorsright[2][0]*$PMTlength/2.0, 
		     $focalpointsright[2][1]+$unitvectorsright[2][1]*$PMTlength/2.0,
		     $focalpointsright[2][2]+$unitvectorsright[2][2]*$PMTlength/2.0],
		    [$focalpointsright[3][0]+$unitvectorsright[3][0]*$PMTlength/2.0, 
		     $focalpointsright[3][1]+$unitvectorsright[3][1]*$PMTlength/2.0,
		     $focalpointsright[3][2]+$unitvectorsright[3][2]*$PMTlength/2.0] );

# define the positions of the winston cones: position the WC so that the bottom is at the position of the PMT photocathode: In practice this means that we have to shift the WC position by minus half its length along the PMT orientation vector:

my @WCposleft = ( [$focalpointsleft[0][0]-$unitvectorsleft[0][0]*$WCdz, 
		    $focalpointsleft[0][1]-$unitvectorsleft[0][1]*$WCdz,
		    $focalpointsleft[0][2]-$unitvectorsleft[0][2]*$WCdz],
		   [$focalpointsleft[1][0]-$unitvectorsleft[1][0]*$WCdz, 
		    $focalpointsleft[1][1]-$unitvectorsleft[1][1]*$WCdz,
		    $focalpointsleft[1][2]-$unitvectorsleft[1][2]*$WCdz],
		   [$focalpointsleft[2][0]-$unitvectorsleft[2][0]*$WCdz, 
		    $focalpointsleft[2][1]-$unitvectorsleft[2][1]*$WCdz,
		    $focalpointsleft[2][2]-$unitvectorsleft[2][2]*$WCdz],
		   [$focalpointsleft[3][0]-$unitvectorsleft[3][0]*$WCdz, 
		    $focalpointsleft[3][1]-$unitvectorsleft[3][1]*$WCdz,
		    $focalpointsleft[3][2]-$unitvectorsleft[3][2]*$WCdz] );

my @WCposright = ( [$focalpointsright[0][0]-$unitvectorsright[0][0]*$WCdz, 
		     $focalpointsright[0][1]-$unitvectorsright[0][1]*$WCdz,
		     $focalpointsright[0][2]-$unitvectorsright[0][2]*$WCdz],
		    [$focalpointsright[1][0]-$unitvectorsright[1][0]*$WCdz, 
		     $focalpointsright[1][1]-$unitvectorsright[1][1]*$WCdz,
		     $focalpointsright[1][2]-$unitvectorsright[1][2]*$WCdz],
		    [$focalpointsright[2][0]-$unitvectorsright[2][0]*$WCdz, 
		     $focalpointsright[2][1]-$unitvectorsright[2][1]*$WCdz,
		     $focalpointsright[2][2]-$unitvectorsright[2][2]*$WCdz],
		    [$focalpointsright[3][0]-$unitvectorsright[3][0]*$WCdz, 
		     $focalpointsright[3][1]-$unitvectorsright[3][1]*$WCdz,
		     $focalpointsright[3][2]-$unitvectorsright[3][2]*$WCdz] );

sub make_WC_shell{
    # the "inner" paraboloid is to be subtracted from outer, this means it is positioned *relative* to "outer":

    $detector{"visible"} = 1;

    $detector{"name"}      = $_[0] . "inner";
    $detector{"mother"}    = "HTCC";
    $detector{"description"} = $_[1] . "inner";
#    $detector{"pos"} = $_[2];
#    $detector{"rotation"} = $_[3];
    $detector{"pos"} = "0*mm 0*mm 0*mm";
    $detector{"rotation"} = "0*deg 0*deg 0*deg";
    $detector{"col"} = "558844";
    $detector{"type"} = "Paraboloid";
    my $sdz = sprintf("%12.8g",$WCdzd);
    my $sr1 = sprintf("%12.8g",$WCr1d);
    my $sr2 = sprintf("%12.8g",$WCr2d);
    my $swcinnerdim = $sdz . "*mm " . $sr1 . "*mm " . $sr2 . "*mm";
    $detector{"dimensions"} = $swcinnerdim;
    $detector{"material"} = "Component";

    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = "";
    
    print_det(\%detector, $file);

    $detector{"name"}      = $_[0] . "outer";
    $detector{"mother"}    = "HTCC";
    $detector{"description"} = $_[1] . "outer";
    $detector{"pos"} = $_[2];
    $detector{"rotation"} = $_[3];
#    $detector{"pos"} = "0*mm 0*mm 0*mm";
#    $detector{"rotation"} = "0*deg 0*deg 0*deg";
    $detector{"col"} = "558844";
    $detector{"type"} = "Paraboloid";
    
    my $r1outer = $WCr1 + 1.0;
    my $r2outer = $WCr2 + 1.0;

    $sdz = sprintf("%12.8g",$WCdz);
    $sr1 = sprintf("%12.8g",$r1outer);
    $sr2 = sprintf("%12.8g",$r2outer);
    my $swcouterdim = $sdz . "*mm " . $sr1 . "*mm " . $sr2 . "*mm";
    
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = "";

    $detector{"dimensions"} = $swcouterdim;
    $detector{"material"} = "Component";

    print_det(\%detector, $file);

    $detector{"name"}      = $_[0] . "shell";
    $detector{"mother"}    = "HTCC";
    $detector{"description"} = $_[1] . "shell";
    $detector{"pos"} = $_[2];
    $detector{"rotation"} = $_[3];
#    $detector{"pos"} = "0*mm 0*mm 0*mm";
#    $detector{"rotation"} = "0*deg 0*deg 0*deg";
    $detector{"color"} = "$_[4]";
    $detector{"type"} = "Operation: $_[0]outer - $_[0]inner";
    
    $detector{"sensitivity"} = "Mirrors";
    $detector{"hit_type"}    = "Mirrors";

    $detector{"dimensions"} = "0";
    $detector{"material"} = "G4_Al";
#    $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: HTCC";
    $detector{"identifiers"} = "Mirror WithSurface: 0 WithBorderVolume: MirrorSkin 0 WithMaterial: HTCC_ECI_WC";

    print_det(\%detector, $file);
    
}


sub make_PMT_ajrp
{
    my $phitemp;
    my $j;
    for( my $i = 0; $i<6; $i++)
    {
	$phitemp = $sectorphirad * $i ;
	
	print "Sector $i:\n";

	for( $j=0; $j<4; $j++)
	{
	    my @unitvectorleft_temp = ( $unitvectorsleft[$j][0] * cos( $phitemp ) - $unitvectorsleft[$j][1] * sin( $phitemp ), 
					$unitvectorsleft[$j][0] * sin( $phitemp ) + $unitvectorsleft[$j][1] * cos( $phitemp ),
					$unitvectorsleft[$j][2] );
	    my @unitvectorright_temp = ( $unitvectorsright[$j][0] * cos( $phitemp ) - $unitvectorsright[$j][1] * sin( $phitemp ), 
					 $unitvectorsright[$j][0] * sin( $phitemp ) + $unitvectorsright[$j][1] * cos( $phitemp ),
					 $unitvectorsright[$j][2] );
	    
	    
	    
	    my @posvectorleft_temp = ( $PMTposleft[$j][0] * cos( $phitemp ) - $PMTposleft[$j][1] * sin( $phitemp ),
				       $PMTposleft[$j][0] * sin( $phitemp ) + $PMTposleft[$j][1] * cos( $phitemp ),
				       $PMTposleft[$j][2] );
	    my @posvectorright_temp = ( $PMTposright[$j][0] * cos( $phitemp ) - $PMTposright[$j][1] * sin( $phitemp ),
					$PMTposright[$j][0] * sin( $phitemp ) + $PMTposright[$j][1] * cos( $phitemp ),
					$PMTposright[$j][2] );
	    if ( $j == 1 ){
		print "PMT $j sector $i left: (x,y,z)=(";
		foreach my $n (@posvectorleft_temp){
		    print "$n, ";
		}
		print "\n";
		
		print "PMT $j sector $i right: (x,y,z)=(";
		foreach my $n (@posvectorright_temp){
		    print "$n, ";
		}
		print "\n";
	    }

	    # first, we rotate clockwise about the x axis so that the z axis of the cylinder aligns with the projection of the PMT orientation vector onto the yz plane:
	    # the 

	    my $alpha_x_left = atan2( $unitvectorleft_temp[1], $unitvectorleft_temp[2] );
	    my $alpha_x_right = atan2( $unitvectorright_temp[1], $unitvectorright_temp[2] );

	    # second, we rotate counter-clockwise about the yprime axis by the angle alpha_yprime whose tangent is the x component divided by the radius in the y z plane:
	    
	    my $alpha_y_left = -atan2( $unitvectorleft_temp[0], sqrt( $unitvectorleft_temp[1]**2 + $unitvectorright_temp[2]**2 ) );
	    my $alpha_y_right = -atan2( $unitvectorright_temp[0], sqrt( $unitvectorright_temp[1]**2 + $unitvectorright_temp[2]**2 ) );
	
	    # we want the following formulation for pmt_index:
	    # pmt index = 1 .. 48
	    # 1,2,3,4 = theta index in increasing order of theta
	    # 1,..,12 = phi index in increasing order of phi
	    # first phi index 
	    
	    # the following expression evaluates to 4, 3, 2, 1, for j = 0, 1, 2, 3
	    my $theta_index = 4 - $j;
	    # left mirrors: sector goes 0..5
	    # the below expression evaluates to: 3, 5, 7, 9, 11, 1 (for the right mirrors, we will add one)
	    my $phi_index   = (2*$i + 3) % 12;   
	    my $pmt_index = $theta_index + 4 * ($phi_index - 1);
	   
	    # in this script, $phi_index = 12, 1 corresponds to sector 1, 2,3 corresponds to sector 2, etc.
	    # the "left" pmts in this script actually correspond to the "right" pmts within a sector
	    # for the "left" pmts, sector = ($i + 2)%6 
	    my $sector = ($i + 1) % 6 + 1; # for i = 0,1,2,3,4,5, this expression results in: 2, 3, 4, 5, 6, 1; boom! 
	    my $halfsector = 2;
    
	    my $mirrorindex = 2 * ( $theta_index - 1 ) + $halfsector;

	    $detector{"name"}            = "PMTmirror".$mirrorindex."sector".$sector."left";
	    $detector{"mother"}          = "HTCC";
	    $detector{"description"}     = "PMT $mirrorindex $sector left";

	    $detector{"visible"}  = 1;

	    my $xpos = $posvectorleft_temp[0];
	    my $ypos = $posvectorleft_temp[1];
	    my $zpos = $posvectorleft_temp[2];
	    
	    my $xrot = $alpha_x_left * 180.0/$pi;
	    my $yrot = $alpha_y_left * 180.0/$pi;
	    my $zrot = 0.0;

	    # control the numerical precision of output: if we have more than 60 characters, everything is screwed!

	    my $sxpos = sprintf("%15.8g",$xpos);
	    my $sypos = sprintf("%15.8g",$ypos);
	    my $szpos = sprintf("%15.8g",$zpos);

	    my $sxrot = sprintf("%15.8g",$xrot);
	    my $syrot = sprintf("%15.8g",$yrot);
	    my $szrot = sprintf("%15.8g",$zrot);

	    my $srot = $sxrot . "*deg " . $syrot . "*deg " . $szrot . "*deg"; 
	    my $spos = $sxpos . "*mm " . $sypos . "*mm " . $szpos . "*mm";
	    
	    $detector{"pos"}   = $spos;
	    $detector{"rotation"} = $srot;
	    #$detector{"color"} = "ee99ff";
	    $detector{"color"} = $colors_even[($j%2)];
            $detector{"type"} = "Tube";
	    
	    $detector{"sensitivity"} = "HTCC";
	    $detector{"hit_type"}    = "HTCC";

	    $detector{"dimensions"} = "0*mm $PMTradius*mm $PMTdz*mm 0*deg 360*deg";
	    $detector{"material"} = "HTCCPMTquartz";
	    
	    

	    $detector{"identifiers"} = "sector manual $sector ring manual $theta_index half manual $halfsector";
	    
	    print_det(\%detector, $file);

	    $phi_index += 1;

	    $pmt_index = $theta_index + 4 * ($phi_index - 1);	    

	    $sector = ($i + 2) % 6 + 1; # for i = 0,1,2,3,4,5, expr = 3, 4, 5, 6, 1, 2
	    $halfsector = 1;

	    $mirrorindex = 2 * ( $theta_index - 1 ) + $halfsector;

	    $detector{"name"}            = "PMTmirror".$mirrorindex."sector".$sector."right";
	    $detector{"mother"}          = "HTCC";
	    $detector{"description"}     = "PMT $mirrorindex $sector right";

	    $xpos = $posvectorright_temp[0];
	    $ypos = $posvectorright_temp[1];
	    $zpos = $posvectorright_temp[2];
	    
	    $xrot = $alpha_x_right * 180.0/$pi;
	    $yrot = $alpha_y_right * 180.0/$pi;
	    
	    $zrot = 0.0;

	    $sxpos = sprintf("%15.8g",$xpos);
	    $sypos = sprintf("%15.8g",$ypos);
	    $szpos = sprintf("%15.8g",$zpos);
	    
	    $sxrot = sprintf("%15.8g",$xrot);
	    $syrot = sprintf("%15.8g",$yrot);
	    $szrot = sprintf("%15.8g",$zrot);
	    
	    $srot = $sxrot . "*deg " . $syrot . "*deg " . $szrot . "*deg"; 
	    $spos = $sxpos . "*mm " . $sypos . "*mm " . $szpos . "*mm";

	    $detector{"pos"}   = $spos;
	    $detector{"rotation"} = $srot;
#	    $detector{"color"} = "ee99ff";
	    $detector{"color"} = $colors_even[($j%2)+2];
	    $detector{"type"} = "Tube";
	    
	    $detector{"sensitivity"} = "HTCC";
	    $detector{"hit_type"}    = "HTCC";

	    $detector{"dimensions"} = "0*mm $PMTradius*mm $PMTdz*mm 0*deg 360*deg";
	    $detector{"material"} = "HTCCPMTquartz";
	    
	    

	    $detector{"identifiers"} = "sector manual $sector ring manual $theta_index half manual $halfsector";
	    #$detector{"identifiers"} = "pmt manual $pmt_index itheta manual $theta_index iphi manual $phi_index";
#	    $detector{"identifiers"} = "id manual $pmt_index";
	    
	    print_det(\%detector, $file);

	    # Make Winston Cones: orientation vector is opposite to that of the PMT (I think):

	    for(my $m=0; $m<3; $m++){
		$unitvectorleft_temp[$m] *= -1.0;
		$unitvectorright_temp[$m] *= -1.0;
	    }

	    @posvectorleft_temp = ( $WCposleft[$j][0] * cos( $phitemp ) - $WCposleft[$j][1] * sin( $phitemp ),
				    $WCposleft[$j][0] * sin( $phitemp ) + $WCposleft[$j][1] * cos( $phitemp ),
				    $WCposleft[$j][2] );
	    @posvectorright_temp = ( $WCposright[$j][0] * cos( $phitemp ) - $WCposright[$j][1] * sin( $phitemp ),
				     $WCposright[$j][0] * sin( $phitemp ) + $WCposright[$j][1] * cos( $phitemp ),
				     $WCposright[$j][2] );


	    # first, we rotate clockwise about the x axis so that the z axis of the cylinder aligns with the projection of the PMT orientation vector onto the yz plane:
	    # the 
	    
	    $alpha_x_left = atan2( $unitvectorleft_temp[1], $unitvectorleft_temp[2] );
	    $alpha_x_right = atan2( $unitvectorright_temp[1], $unitvectorright_temp[2] );
	    
	    # second, we rotate counter-clockwise about the yprime axis by the angle alpha_yprime whose tangent is the x component divided by the radius in the y z plane:
	    
	    $alpha_y_left = -atan2( $unitvectorleft_temp[0], sqrt( $unitvectorleft_temp[1]**2 + $unitvectorright_temp[2]**2 ) );
	    $alpha_y_right = -atan2( $unitvectorright_temp[0], sqrt( $unitvectorright_temp[1]**2 + $unitvectorright_temp[2]**2 ) );

	    # Create the Winston Cone for the left mirror: 

	    $xpos = $posvectorleft_temp[0];
	    $ypos = $posvectorleft_temp[1];
	    $zpos = $posvectorleft_temp[2];

	    $sxpos = sprintf("%12.7g",$xpos);
	    $sypos = sprintf("%12.7g",$ypos);
	    $szpos = sprintf("%12.7g",$zpos);
	    
	    $spos = $sxpos . "*mm " . $sypos . "*mm " . $szpos . "*mm";

	    $xrot = $alpha_x_left * 180.0/$pi;
	    $yrot = $alpha_y_left * 180.0/$pi;
	    $zrot = 0.0;
	    $sxrot = sprintf("%12.7g",$xrot);
	    $syrot = sprintf("%12.7g",$yrot);
	    $szrot = sprintf("%12.7g",$zrot);

	    $srot = $sxrot . "*deg " . $syrot . "*deg " . $szrot . "*deg";
	    
	    my $WCname = "WCs$i" . "m$j" . "left";
	    my $WCdesc = "Winston Cone sector $i mirror $j left";

	    make_WC_shell( $WCname, $WCdesc, $spos, $srot, $colors_even[($j%2)] );

	    # Create the Winston Cone for the right mirror: 

	    $xpos = $posvectorright_temp[0];
	    $ypos = $posvectorright_temp[1];
	    $zpos = $posvectorright_temp[2];

	    $sxpos = sprintf("%12.7g",$xpos);
	    $sypos = sprintf("%12.7g",$ypos);
	    $szpos = sprintf("%12.7g",$zpos);
	    
	    $spos = $sxpos . "*mm " . $sypos . "*mm " . $szpos . "*mm";

	    $xrot = $alpha_x_right * 180.0/$pi;
	    $yrot = $alpha_y_right * 180.0/$pi;
	    $zrot = 0.0;
	    $sxrot = sprintf("%12.7g",$xrot);
	    $syrot = sprintf("%12.7g",$yrot);
	    $szrot = sprintf("%12.7g",$zrot);

	    $srot = $sxrot . "*deg " . $syrot . "*deg " . $szrot . "*deg";
	    
	    $WCname = "WCs$i" . "m$j" . "right";
	    $WCdesc = "Winston Cone sector $i mirror $j right";

	    make_WC_shell( $WCname, $WCdesc, $spos, $srot, $colors_even[2+($j%2)] );

	}
    }
}

make_PMT_ajrp();
