#!/usr/bin/perl -w

# Written by Alexander Zenon Piaseczny
# Email: azp@jlab.org

use strict;
use POSIX;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope      = 'PCAL';
my $file          = 'PCAL.txt';
my $rmin          = 1;
my $rmax          = 1000000;
my %detector      = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

my $inches   = 2.54;
my $dlead = 2.2; #millimeters (mm)                                            
my $dscint = 10.0; #millimeters (mm)
my $d_Ti_O = 0.25; #millimeters (mm)
my $d_foam = 50.8; #millimeters (mm)
my $d_steel = 1.905; #millimeters (mm)
my $s_thickness_scint_strip = 45; # s stands for double
my $d_thickness_scint_strip = 90.5; # d stands for double
my $d_gaps = 0.1; #millimeters (mm)
my $N_gaps = 36;
         	         
my $width_pcal = 4328.7;    #millimeters (mm) #Side AB,BC
my $x_length_pcal = 3943.2; #millimeters (mm) #Side AC

my $alpha_angle_rad = acos($x_length_pcal/(2*$width_pcal)); #produces an angle in radians 
my $alpha_angle_deg = $alpha_angle_rad*180/$pi;             #produces an angle in degrees

my $gamma_angle_deg = 180 - 2*$alpha_angle_deg; #produces an angle in degrees
my $gamma_angle_rad = $gamma_angle_deg*$pi/180; #produces an angle in radians

my $opp_triangle_alpha = $width_pcal*sin($alpha_angle_rad);
my $height_pcal = $opp_triangle_alpha; #millimeters (mm)

my $thickness_scint_strip = 45; #millimeters (mm)
my $number_of_strips = $opp_triangle_alpha/$thickness_scint_strip; #For U_view

my $tantheta = tan($alpha_angle_rad);

my $nlayers = 15.0;		                             
my $PCAL_angle = 25.0; # "rotation"                                      
my $Ti_O_layer_thickness = 0.25; # 0.25 mm
my $number_of_Ti_O = 30; #  30 layers of Ti0
my $total_thickness = (($nlayers)*($dscint+$dlead) - $dlead) + ($number_of_Ti_O*$Ti_O_layer_thickness) + 28*$d_gaps ;   #15 scintillators layers, 14 lead layers, 30 TiO layers // without windows

my $L0 = 5103.2;                                             # length of perpendicular line at origin of local PCAL 								       mother volume that passes through the CLAS6 target.
my $L1 = 7217.23;                                            # length of perpendicular line at origin of local PCAL 								       mother volume that passes through the CLAS12 target.
my $MUoffset = 5000.0;                                       # the CLAS12 target is at +5m in the gemc coordinates.
my @beamVertexCut=(0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001, 0.001);

# PCAL Mother Dimensions (Utilizing the type: "G4Trap")
my $pDx1mom   = 0.00000001;  #GEANT4 will not accept a dimension of 'zero'
my $pDx3mom   = 0.00000001;
my $pDx2mom   = $x_length_pcal/2;
my $pDx4mom   = $x_length_pcal/2;
my $pDy1mom   = $height_pcal/2;
my $pDy2mom   = $height_pcal/2;
my $pDzmom    = ($total_thickness + 4*$d_steel + 2*$d_foam + 8*$d_gaps)/2.0; #with windows
my $pThetamom = 0.0;
my $pPhimom   = 0.0;
my $pAlp1mom  = 0.0;
my $pAlp2mom  = 0.0;

my $PCAL_anglerad = $PCAL_angle*$pi/180;
my $dm = $L0 + (yplus($nlayers) + yminus($nlayers))/(2*tan($PCAL_anglerad));

my $pos1 = 480.478; #z global coordinate position of EC in gemc
my $pos2 = 1.524; #PCAL is to be placed behind EC by this amount

my $PCAL_centerx = 0; 
my $PCAL_centery = $dm*sin($PCAL_anglerad); 
my $PCAL_centerz = ($dm*cos($PCAL_anglerad) + ($L1 - $dm)/cos($PCAL_anglerad) - $MUoffset) - ($pos1 + $pos2);

### PCAL Mother Volume ###
sub make_PCAL_mother
{
	$detector{"name"}        = "PCAL";
	$detector{"mother"}      = "sector";
	#$detector{"mother"}      = "root"; #root for 1 sector | sector for 6 sectors
	$detector{"description"} = "Preshower Calorimeter";
	#$detector{"pos"}         = "0*mm 0*mm 0*mm"; # centered in PCAL frame
	$detector{"pos"}         = "${PCAL_centerx}*mm ${PCAL_centery}*mm ${PCAL_centerz}*mm"; #centered in CLAS12 frame
	#$detector{"rotation"}    = "0*deg 0*deg 0*deg"; # no rotation
	$detector{"rotation"}    = "$PCAL_angle*deg 0*deg 0*deg"; # rotation in CLAS12 frame
	$detector{"color"}       = "ff1111"; # 33ffcc --> cyan
	$detector{"type"}        = "G4Trap";
	$detector{"dimensions"}  = "${pDzmom}*mm ${pThetamom}*deg ${pPhimom}*deg ${pDy1mom}*mm ${pDx1mom}*mm ${pDx2mom}*mm ${pAlp1mom}*deg ${pDy2mom}*mm ${pDx3mom}*mm ${pDx4mom}*mm ${pAlp2mom}*deg";
	$detector{"material"}    = "Air";
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
}

### Lead Layers ###	
sub make_lead
{
	for(my $i = 1.0, my $j = 0, my $z = 1; $i < $nlayers, $z <= 27; $i++, $j++, $z+=2)
	{ 
		my $x0lead = 0.0; 
    		my $y0lead = $beamVertexCut[$i-2]/2;
    		my $z0lead = -$total_thickness/2 + ($i*2*$d_Ti_O) + ($i*$dscint) + ($i + $j)*($dlead/2) + $z*$d_gaps; 

    		my $pDz = $dlead/2.0;
    		my $pDy1 = $pDy1mom;
    		my $pDy2 = $pDy2mom;
    		my $pDx1 = $pDx1mom;
    		my $pDx3 = $pDx3mom;
    		my $pDx2 = $pDx2mom;
    		my $pDx4 = $pDx4mom;
    		my $pTheta = $pThetamom;  
    		my $pPhi   = $pThetamom;  
    		my $pAlp1  = $pThetamom;  
    		my $pAlp2  = $pThetamom;  

    		$detector{"name"}        = "PCAL_Lead_Layer_${i}";
    		$detector{"mother"}      = "PCAL";
    		$detector{"description"} = "Preshower Calorimeter lead layer ${i}";
    		$detector{"pos"}         = "${x0lead}*mm ${y0lead}*mm ${z0lead}*mm";
    		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
    		$detector{"color"}       = "66ff33";
    		$detector{"type"}        = "G4Trap";
    		$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg  ${pDy1}*mm ${pDx1}*mm  ${pDx2}*mm  ${pAlp1}*deg  ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
   		$detector{"material"}    = "Lead";
    		$detector{"mfield"}      = "no";
    		$detector{"ncopy"}       = $i;
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

### U Layers ###
sub make_U_mother
{
	for(my $k = 1.0, my $z = 0; $k <= $nlayers, $z <= 24; $k+=3, $z+=6)
	{
		my $x_scint = 0.0;
		my $y_scint = 0.0;
		my $z_scint = -$total_thickness/2 + ($k + ($k - 1))*($d_Ti_O) + ($k + ($k - 1))*($dscint/2) + ($k - 1)*$dlead + $z*$d_gaps;
		
		my $pDz = ($dscint + 2*$d_Ti_O)/2.0;
    		my $pDy1 = $height_pcal/2;
    		my $pDy2 = $height_pcal/2;
    		my $pDx1 = 0.00000001;
    		my $pDx3 = 0.00000001;
   		my $pDx2 = $x_length_pcal/2;
    		my $pDx4 = $x_length_pcal/2;
    		my $pTheta = 0.0;
    		my $pPhi   = 0.0;
    		my $pAlp1  = 0.0;
    		my $pAlp2  = 0.0;	

		$detector{"name"}        = "U-view-scintillator ${k}";
		$detector{"mother"}      = "PCAL";
		$detector{"description"} = "Preshower Calorimeter";
 		$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
 		$detector{"color"}       = "ff6633";
 		$detector{"type"}        = "G4Trap";
		$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm  ${pDx2}*mm  ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
		$detector{"material"}    = "G4_TITANIUM_DIOXIDE"; 
 		$detector{"mfield"}      = "no";
 		$detector{"ncopy"}       = $k;
 		$detector{"pMany"}       = 1;
 		$detector{"exist"}       = 1;
 		$detector{"visible"}     = 1;
 		$detector{"style"}       = 0;
 		$detector{"sensitivity"} = "no";
 		$detector{"hit_type"}    = "";
 		$detector{"identifiers"} = "";

		print_det(\%detector, $file);
	}
}

### U DOUBLE Strips ###
sub make_U_double_strips 
{
	my $view = 1;  #All U scintillator layers will be assigned as 1
	my $strip_no = 0;
	my $PMT_id_number;
	my $hack = 0; 
	my $layer; # 1 U, 1 V, and 1 W per layer # 5 layers in total
	my $strip;
	my $number_of_singles = 52;
	my $number_of_doubles = 16;

	for(my $k = 1.0; $k <= $nlayers; $k+=3, $hack+=2)
	{
		for(my $a = 0, my $strip = 68; $a < 16, $strip >= 53; $a++, $strip--) 
		{	
			$layer = $k - $hack;
			$strip_no++;
		
			my $active_height = $number_of_singles*$s_thickness_scint_strip + $number_of_singles*(2*$d_Ti_O) + $number_of_doubles*$d_thickness_scint_strip + ($number_of_doubles-1)*(2*$d_Ti_O);
			my $gap_height = $height_pcal - $active_height; 			


			my $x_scint = 0.0;
			my $y_scint = $pDy1mom - ($d_thickness_scint_strip/2) - $a*(2*$d_Ti_O) - $a*$d_thickness_scint_strip;
			my $z_scint = 0;

			my $pDz = $dscint/2.0;
    			my $pDy1 = ($d_thickness_scint_strip)/2.0;
    			my $pDy2 = ($d_thickness_scint_strip)/2.0;

			my $pDx2 = $height_pcal/tan($alpha_angle_rad) - $a*$d_thickness_scint_strip/tan($alpha_angle_rad) - $a*(2*$d_Ti_O)/tan($alpha_angle_rad);  
			my $pDx4 = $height_pcal/tan($alpha_angle_rad) - $a*$d_thickness_scint_strip/tan($alpha_angle_rad) - $a*(2*$d_Ti_O)/tan($alpha_angle_rad);
			my $pDx1 = $height_pcal/tan($alpha_angle_rad) - ($a+1)*$d_thickness_scint_strip/tan($alpha_angle_rad) - $a*(2*$d_Ti_O)/tan($alpha_angle_rad);
			my $pDx3 = $height_pcal/tan($alpha_angle_rad) - ($a+1)*$d_thickness_scint_strip/tan($alpha_angle_rad) - $a*(2*$d_Ti_O)/tan($alpha_angle_rad);
	
    			my $pTheta = 0.0;
    			my $pPhi   = 0.0;
    			my $pAlp1  = 0.0;
    			my $pAlp2  = 0.0;	

			$detector{"name"}        = "U-view_double_strip ${layer} ${strip}";  
 			$detector{"mother"}      = "U-view-scintillator ${k}";
 			$detector{"description"} = "Preshower Calorimeter scintillator layer";
 			$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
 			$detector{"color"}       = "ff6633";
 			$detector{"type"}        = "G4Trap";
			$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm  ${pDx2}*mm  ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
			$detector{"material"}    = "Scintillator";
 			$detector{"mfield"}      = "no";
 			$detector{"ncopy"}       = $strip_no;
 			$detector{"pMany"}       = 1;
 			$detector{"exist"}       = 1;
 			$detector{"visible"}     = 1;
 			$detector{"style"}       = 0; # 0 for wireframe | # 1 for solid frame
 			$detector{"sensitivity"} = "PCAL";
 			$detector{"hit_type"}    = "PCAL";
 			$detector{"identifiers"} = "sector ncopy 0 layer manual 1 view manual $view strip manual $strip";
			print_det(\%detector, $file);
		}
	}
}


### U Single Strips ###
sub make_U_single_strips 
{
	my $view = 1;  #All U scintillator layers will be assigned as 1
	my $strip_no = 0; 
	my $PMT_id_number;
	my $hack = 0; 
	my $layer; # 1 U, 1 V, and 1 W per layer # 5 layers in total
	my $number_of_singles = 52;
	my $number_of_doubles = 16;
	
	for(my $k = 1.0; $k <= $nlayers; $k+=3, $hack+=2)
	{
		
		for(my $j = 0.00000001, my $strip = 1, my $b = 0, my $increment = 0; $strip < 53, $j < 52; $strip++, $j++, $b+=2, $increment++)  
		{	
			$layer = $k - $hack;
			$strip_no++;

			my $active_height = $number_of_singles*$s_thickness_scint_strip + $number_of_singles*(2*$d_Ti_O) + $number_of_doubles*$d_thickness_scint_strip + ($number_of_doubles-1)*(2*$d_Ti_O);
			my $gap_height = $height_pcal - $active_height;
						
			my $x_scint = 0.0;
			my $y_scint = (-$pDy1mom + $gap_height)+ (($s_thickness_scint_strip)/2.0) + ($j*$thickness_scint_strip) + $b*$d_Ti_O;
			my $z_scint = 0;
			
			my $offset = 0.5;
						
			my $pDz = $dscint/2.0;
    			my $pDy1 = ($s_thickness_scint_strip)/2.0;
    			my $pDy2 = ($s_thickness_scint_strip)/2.0;


			my $pDx1 = $gap_height*tan($gamma_angle_rad/2.0) + $j*$s_thickness_scint_strip*tan($gamma_angle_rad/2.0) + $increment*$offset*tan($gamma_angle_rad/2.0); 
    			my $pDx3 = $gap_height*tan($gamma_angle_rad/2.0) + $j*$s_thickness_scint_strip*tan($gamma_angle_rad/2.0) + $increment*$offset*tan($gamma_angle_rad/2.0);
   			my $pDx2 = $gap_height*tan($gamma_angle_rad/2.0) + ($j+1)*$s_thickness_scint_strip*tan($gamma_angle_rad/2.0) + $increment*$offset*tan($gamma_angle_rad/2.0);
    			my $pDx4 = $gap_height*tan($gamma_angle_rad/2.0) + ($j+1)*$s_thickness_scint_strip*tan($gamma_angle_rad/2.0) + $increment*$offset*tan($gamma_angle_rad/2.0);

    			my $pTheta = 0.0;
    			my $pPhi   = 0.0;
    			my $pAlp1  = 0.0;
    			my $pAlp2  = 0.0;	
			 
			$detector{"name"}        = "U-view_single_strip ${layer} ${strip}";  
 			$detector{"mother"}      = "U-view-scintillator ${k}";
 			$detector{"description"} = "Preshower Calorimeter scintillator layer";
 			$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
 			$detector{"color"}       = "ff6633";
 			$detector{"type"}        = "G4Trap";
			$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm  ${pDx2}*mm  ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
			$detector{"material"}    = "Scintillator";
 			$detector{"mfield"}      = "no";
 			$detector{"ncopy"}       = $strip_no;
 			$detector{"pMany"}       = 1;
 			$detector{"exist"}       = 1;
 			$detector{"visible"}     = 1;
 			$detector{"style"}       = 0; # 0 for wireframe | # 1 for solid frame
 			$detector{"sensitivity"} = "PCAL";
 			$detector{"hit_type"}    = "PCAL";
			$detector{"identifiers"} = "sector ncopy 0 layer manual 1 view manual $view strip manual $strip";		
			print_det(\%detector, $file);
		}
	}
}

### U Zero Strips --> are in-active triangular pieces at the apex of the U mother volume triangles###
sub make_U_zero_strips 
{
	my $view = 1;  #All U scintillator layers will be assigned as 1
	my $strip_no = 0; 
	my $PMT_id_number;
	my $hack = 0; 
	my $layer; # 1 U, 1 V, and 1 W per layer # 5 layers in total
	my $number_of_singles = 52;
	my $number_of_doubles = 16;
	my $strip = 0;
	
	for(my $k = 1.0; $k <= $nlayers; $k+=3, $hack+=2)
	{
			$layer = $k - $hack;
		
			my $active_height = $number_of_singles*$s_thickness_scint_strip + $number_of_singles*(2*$d_Ti_O) + $number_of_doubles*$d_thickness_scint_strip + ($number_of_doubles-1)*(2*$d_Ti_O);
			my $gap_height = $height_pcal - $active_height;

			my $x_scint = 0.0;
			my $y_scint = -$pDy1mom + $gap_height/2;
			my $z_scint = 0;

			my $pDz = $dscint/2.0;
    			my $pDy1 = $gap_height/2;
    			my $pDy2 = $gap_height/2;

			my $pDx1 = 0.00000001; 
    			my $pDx3 = 0.00000001;
   			my $pDx2 = $gap_height*tan($gamma_angle_rad/2.0);
    			my $pDx4 = $gap_height*tan($gamma_angle_rad/2.0);

    			my $pTheta = 0.0;
    			my $pPhi   = 0.0;
    			my $pAlp1  = 0.0;
    			my $pAlp2  = 0.0;	
			 
			$detector{"name"}        = "U-view_single_strip ${layer} ${strip}";  
 			$detector{"mother"}      = "U-view-scintillator ${k}";
 			$detector{"description"} = "Preshower Calorimeter scintillator layer";
 			$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 			$detector{"rotation"}    = "0*deg 0*deg 0*deg";
 			$detector{"color"}       = "ff6633";
 			$detector{"type"}        = "G4Trap";
			$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm  ${pDx2}*mm  ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
			$detector{"material"}    = "Scintillator";
 			$detector{"mfield"}      = "no";
 			$detector{"ncopy"}       = 1;
			$detector{"pMany"}       = 1;
 			$detector{"exist"}       = 1;
 			$detector{"visible"}     = 1;
 			$detector{"style"}       = 1; # 0 for wireframe | # 1 for solid frame
 			$detector{"sensitivity"} = "no";
 			$detector{"hit_type"}    = "";
			$detector{"identifiers"} = "";	
			print_det(\%detector, $file);
		}
}





#Symmetric geometry for the V,W strips:

#            ____________________        ___
#	   / |	                 | \	  |             		      
#	  /  |	   	         |  \ 	  | --> $thickness_scint_strip = 4.5*cm		               
#	 / 1 |	   	         | 2 \ 	  |			 
#     	/t___|___________________|___t\  _|_   
#								                 	
# t = theta angle							| y'
#Looking at one PCAL sector from the target;                            |    coordinate axes; origin is at the geometric
#z-axis is pointing out of the screen                            _______|    center of the trapezoid
#           							 x'
#Anti-Symmetric geometry for the V,W strips:

#            ____________________          ___
#	   / |	                 |   \	    |             		      
#	  /  |	   	         |    \     | --> $thickness_scint_strip = 4.5*cm		               
#	 / 1 |	   	         |  2  \    |			 
#     	/a___|___________________|_____g\  _|_   
#								                 	
#g = gamma angle (aka "apex angle")
#a = alpha angle

my $adj_triangle_alpha1 = $thickness_scint_strip/tan($alpha_angle_rad); #The cut for triangle 1 via alpha, anti-symmetric
my $adj_triangle_gamma2 = $thickness_scint_strip/tan($gamma_angle_rad); #The cut for triangle 2 via gamma, anti-symmetric

my $pDx1 = $width_pcal;
my $pDx2 = $width_pcal - ($adj_triangle_alpha1 + $adj_triangle_gamma2);

my $diff_btw_pDx1_and_pDx2 = $pDx1 - $pDx2;     #The difference between pDx1 and pDx2 in millimeters (mm)
my $symmetric_cuts = $diff_btw_pDx1_and_pDx2/2; #The symmetric cuts in millimeters (mm)

my $symmetric_angle_rad = atan($thickness_scint_strip/$symmetric_cuts); #The symmetric angle in radians
my $symmetric_angle_deg = $symmetric_angle_rad*180/$pi;                 #The symmetric angle in degrees 

#For the isoceles triangle whose dimensions are: pDx1 = pDx3 = width_pcal, pDx2 = pDx4 = 0.00000001 
my $height_v  = ($width_pcal/2)*tan($symmetric_angle_rad);

my $number_of_strips_V_W = $height_v/$thickness_scint_strip; 

my $fake_right_triangle_height = $thickness_scint_strip*19.5; #Read 'PCAL' documentation for why 19.5 is used
my $fake_opp = $fake_right_triangle_height;
my $new_gamma_hyp = $fake_opp/sin($gamma_angle_rad);
my $new_gamma_adj = cos($gamma_angle_rad/2)*$new_gamma_hyp;
my $y_shift = $new_gamma_adj;
my $y_correction_factor = 0.109; # millimeters

my $shifting_angle_rad = atan( (1/tan($gamma_angle_rad)) - (1/tan($symmetric_angle_rad)) );
my $shifting_angle_deg = $shifting_angle_rad*180/$pi;

### V Layers ###
sub make_V_mother 
{
	for(my $k = 2.0, my $z = 2; $k <= $nlayers, $z <= 26; $k+=3, $z+=6)
	{
		my $pDx1mom   = $width_pcal/2;
		my $pDx3mom   = $width_pcal/2;
		my $pDx2mom   = 0.00000001;
		my $pDx4mom   = 0.00000001;
		my $pDy1mom   = $height_v/2; 
		my $pDy2mom   = $height_v/2;
		my $pDzmom = ($dscint + 2*$d_Ti_O)/2.0;
		my $pThetamom = 0;
		my $pPhimom   = $pThetamom;
		my $pAlp1mom  = -1*$shifting_angle_deg;   
		my $pAlp2mom  = $pAlp1mom;

		my $x_scint = -$x_length_pcal/8;
		my $y_scint = $y_shift + $y_correction_factor; #This translates into: 963.287241326841 mm + .109 mm;
		my $z_scint = -$total_thickness/2 + ($k + ($k - 1))*($d_Ti_O) + ($k + ($k - 1))*($dscint/2) + ($k - 1)*$dlead + $z*$d_gaps;
		
		$detector{"name"}        = "V-view-scintillator ${k}";
		$detector{"mother"}      = "PCAL";
		$detector{"description"} = "Preshower Calorimeter";
		$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
		$detector{"rotation"}    = "0*deg 180*deg ${alpha_angle_deg}*deg";
		$detector{"color"}       = "33ffcc";
		$detector{"type"}        = "G4Trap";
		$detector{"dimensions"}  = "${pDzmom}*mm ${pThetamom}*deg ${pPhimom}*deg ${pDy1mom}*mm ${pDx1mom}*mm ${pDx2mom}*mm ${pAlp1mom}*deg ${ pDy2mom}*mm ${pDx3mom}*mm ${pDx4mom}*mm ${pAlp2mom}*deg";
		$detector{"material"}    = "G4_TITANIUM_DIOXIDE";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = $k;
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 0;
		$detector{"sensitivity"} = "no"; 
		$detector{"hit_type"}    = "";   
		$detector{"identifiers"} = ""; 
	
		print_det(\%detector, $file);
	}
}

### V Double Strips ###
sub make_V_double_strips 
{
	my $view = 2;  #All V scintillator layers will be assigned as 2
	my $strip_no = 0;
	my $PMT_id_number;
	my $hack;
	my $layer; # 1 U, 1 V, and 1 W per layer # 5 layers in total 
	my $cut;
	my $strip;
	my $number_of_singles = 47;
	my $number_of_doubles = 15;

	for (my $k = 2.0, my $hack = 1.0; $k <= $nlayers; $k+=3, $hack+=2)
	{
		for(my $b = 0, my $j = 0.00000001 ,my $a = 0, my $strip = 1; $j < 16, $a < 16, $strip <= 15; $b+=2, $j++, $a++, $strip++) 
		{	
			$layer = $k - $hack;
			$strip_no++;

			my $active_height = $number_of_singles*$s_thickness_scint_strip + $number_of_singles*(2*$d_Ti_O) + $number_of_doubles*$d_thickness_scint_strip + ($number_of_doubles-1)*(2*$d_Ti_O);
			my $gap_height = $height_v - $active_height;

			my $x_scint = -($height_v*tan($shifting_angle_rad))/2 + ($d_thickness_scint_strip*tan($shifting_angle_rad))/2 + $b*((2*$d_Ti_O)*tan($shifting_angle_rad))/2 + $b*($d_thickness_scint_strip*tan($shifting_angle_rad))/2 + $gap_height*tan($shifting_angle_rad);
			my $y_scint = $height_v/2 - $gap_height - $d_thickness_scint_strip/2 - $a*(2*$d_Ti_O) - $a*$d_thickness_scint_strip; 
			my $z_scint = 0;
			
			my $pDx2 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) +  $j*($d_thickness_scint_strip/tan($alpha_angle_rad) + $d_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx4 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) +  $j*($d_thickness_scint_strip/tan($alpha_angle_rad) + $d_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx1 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) + ($j+1)*($d_thickness_scint_strip/tan($alpha_angle_rad) + $d_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx3 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) + ($j+1)*($d_thickness_scint_strip/tan($alpha_angle_rad) + $d_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			
			my $pDy1 = ($d_thickness_scint_strip)/2;
    			my $pDy2 = ($d_thickness_scint_strip)/2;
			my $pDz = $dscint/2;
    			my $pTheta = 0;
    			my $pPhi   = 0;
			my $pAlp1 = -1*$shifting_angle_deg;  
    			my $pAlp2  = $pAlp1; 

			$detector{"name"}        = "V-view_double_strip ${layer} ${strip}";
			$detector{"mother"}      = "V-view-scintillator ${k}";
 			$detector{"description"} = "Preshower Calorimeter scintillator layer";
 			$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 			$detector{"rotation"}    = "0*deg 0*deg 0*deg";  
 			$detector{"color"}       = "6600ff";
 			$detector{"type"}        = "G4Trap";
			$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm ${pDx4}*mm ${pAlp2}*deg";
			$detector{"material"}    = "Scintillator";
 			$detector{"mfield"}      = "no";
 			$detector{"ncopy"}       = $strip_no; 
 			$detector{"pMany"}       = 1;
 			$detector{"exist"}       = 1;
 			$detector{"visible"}     = 1;
 			$detector{"style"}       = 0; # 0 for wireframe | # 1 for solid frame
 			$detector{"sensitivity"} = "PCAL";
 			$detector{"hit_type"}    = "PCAL";
 			$detector{"identifiers"} = "sector ncopy 0 layer manual 1 view manual $view strip manual $strip";
			print_det(\%detector, $file);
		}
	}
}

### V Single Strips ###
sub make_V_single_strips 
{
	my $view = 2;  #All V scintillator layers will be assigned as 2
	my $strip_no = 0;
	my $PMT_id_number;
	my $hack;
	my $layer; # 1 U, 1 V, and 1 W per layer # 5 layers in total
	my $cut;
	my $strip;
	my $number_of_singles = 47;
	my $number_of_doubles = 15;
	
	for (my $k = 2.0, my $hack = 1.0; $k <= $nlayers; $k+=3, $hack+=2)
	{
		for(my $b = 60, my $a = 0, my $strip = 16; $a < 47, $strip <= 62; $b+=2, $a++, $strip++) 
		{	
			$layer = $k - $hack;
			$strip_no++;

			my $active_height = $number_of_singles*$s_thickness_scint_strip + $number_of_singles*(2*$d_Ti_O) + $number_of_doubles*$d_thickness_scint_strip + ($number_of_doubles-1)*(2*$d_Ti_O);
			my $gap_height = $height_v - $active_height;

### The last value of b from the V double strip for loop above is 28.
### Had there been another double strip, b would be 30.
### Instead of another strip, we have a single strip.
### Since the single strips have a thickness of 45 mm, simply double 30 and you have 60.
			
			my $x_scint = -($height_v*tan($shifting_angle_rad))/2 + ($s_thickness_scint_strip*tan($shifting_angle_rad))/2 + $b*((2*$d_Ti_O)*tan($shifting_angle_rad))/2 + $b*($s_thickness_scint_strip*tan($shifting_angle_rad))/2 + $gap_height*tan($shifting_angle_rad);
			
			my $y_scint = ($height_v/2 - $gap_height - 15*$d_thickness_scint_strip - 15*(2*$d_Ti_O)) - $s_thickness_scint_strip/2 - $a*$s_thickness_scint_strip -$a*(2*$d_Ti_O); 
 			my $z_scint = 0;

			my $end_of_double_strips = (15*$d_thickness_scint_strip + 15*(2*$d_Ti_O))*(1/tan($alpha_angle_rad) + 1/tan($gamma_angle_rad)) + $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad);

			my $pDx2 = $end_of_double_strips/2 + ( $a*($s_thickness_scint_strip/tan($alpha_angle_rad) + $s_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx4 = $end_of_double_strips/2 + ( $a*($s_thickness_scint_strip/tan($alpha_angle_rad) + $s_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx1 = $end_of_double_strips/2 + ( ($a+1)*($s_thickness_scint_strip/tan($alpha_angle_rad) + $s_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx3 = $end_of_double_strips/2 + ( ($a+1)*($s_thickness_scint_strip/tan($alpha_angle_rad) + $s_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			
			my $pDy1 = ($s_thickness_scint_strip)/2;
    			my $pDy2 = ($s_thickness_scint_strip)/2;
			my $pDz = $dscint/2;
    			my $pTheta = 0;
    			my $pPhi   = 0;
    			my $pAlp1 = -1*$shifting_angle_deg;  
    			my $pAlp2  = $pAlp1; 

			$detector{"name"}        = "V-view_single_strip ${layer} ${strip}";
			$detector{"mother"}      = "V-view-scintillator ${k}";
 			$detector{"description"} = "Preshower Calorimeter scintillator layer";
 			$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 			$detector{"rotation"}    = "0*deg 0*deg 0*deg";  
 			$detector{"color"}       = "6600ff";
 			$detector{"type"}        = "G4Trap";
			$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm ${pDx4}*mm ${pAlp2}*deg";
			$detector{"material"}    = "Scintillator";
 			$detector{"mfield"}      = "no";
 			$detector{"ncopy"}       = $strip_no; 
 			$detector{"pMany"}       = 1;
 			$detector{"exist"}       = 1;
 			$detector{"visible"}     = 1;
 			$detector{"style"}       = 0; # 0 for wireframe | # 1 for solid frame
 			$detector{"sensitivity"} = "PCAL";
 			$detector{"hit_type"}    = "PCAL";
			$detector{"identifiers"} = "sector ncopy 0 layer manual 1 view manual $view strip manual $strip";
 			print_det(\%detector, $file);
		}
	}
}

### V Zero Strips --> are in-active triangular pieces at the apex of the V mother volume triangles###
sub make_V_zero_strips 
{
	my $view = 2;  #All V scintillator layers will be assigned as 2
	my $strip_no = 0;
	my $PMT_id_number;
	my $hack;
	my $layer; # 1 U, 1 V, and 1 W per layer # 5 layers in total
	my $cut;
	my $strip = 0;
	my $number_of_singles = 47;
	my $number_of_doubles = 15;
	
	for (my $k = 2.0, my $hack = 1.0; $k <= $nlayers; $k+=3, $hack+=2)
	{
			$layer = $k - $hack;

			my $active_height = $number_of_singles*$s_thickness_scint_strip + $number_of_singles*(2*$d_Ti_O) + $number_of_doubles*$d_thickness_scint_strip + ($number_of_doubles-1)*(2*$d_Ti_O);
			my $gap_height = $height_v - $active_height;

			
			my $x_scint = -($height_v*tan($shifting_angle_rad))/2 + $gap_height*tan($shifting_angle_rad)/2;
			
			my $y_scint = $height_v/2 - $gap_height/2;  
 			my $z_scint = 0;

			my $pDx2 = 0.00000001;
			my $pDx4 = 0.00000001;
			my $pDx1 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) )/2;
			my $pDx3 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) )/2;
			
			my $pDy1 = $gap_height/2;
    			my $pDy2 = $gap_height/2;
			my $pDz = $dscint/2;
    			my $pTheta = 0;
    			my $pPhi   = 0;
    			my $pAlp1 = -1*$shifting_angle_deg;  
    			my $pAlp2  = $pAlp1; 

			$detector{"name"}        = "V-view_single_strip ${layer} ${strip}";
			$detector{"mother"}      = "V-view-scintillator ${k}";
 			$detector{"description"} = "Preshower Calorimeter scintillator layer";
 			$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 			$detector{"rotation"}    = "0*deg 0*deg 0*deg";  
 			$detector{"color"}       = "6600ff";
 			$detector{"type"}        = "G4Trap";
			$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm ${pDx4}*mm ${pAlp2}*deg";
			$detector{"material"}    = "Scintillator";
 			$detector{"mfield"}      = "no";
 			$detector{"ncopy"}       = 1; 
 			$detector{"pMany"}       = 1;
 			$detector{"exist"}       = 1;
 			$detector{"visible"}     = 1;
 			$detector{"style"}       = 1; # 0 for wireframe | # 1 for solid frame
 			$detector{"sensitivity"} = "no";
 			$detector{"hit_type"}    = "";
			$detector{"identifiers"} = "";
 			print_det(\%detector, $file);
		}
}



### W Layers ###
sub make_W_mother
{	
	for(my $k = 3.0, my $z = 4; $k <= $nlayers, $z <= 28; $k+=3, $z+=6)
	{
		my $pDx1mom   = $width_pcal/2;
		my $pDx3mom   = $width_pcal/2;
		my $pDx2mom   = 0.00000001;
		my $pDx4mom   = 0.00000001;
		my $pDy1mom   = $height_v/2; 
		my $pDy2mom   = $height_v/2;
		my $pDzmom = ($dscint + 2*$d_Ti_O)/2.0;
		my $pThetamom = 0;
		my $pPhimom   = $pThetamom;
		my $pAlp1mom  = -1*$shifting_angle_deg;   
		my $pAlp2mom  = $pAlp1mom;

		my $x_scint = $x_length_pcal/8;
		my $y_scint = $y_shift + $y_correction_factor; #This translates into: 963.287241326841 mm + .109 mm;
		my $z_scint = -$total_thickness/2 + ($k + ($k - 1))*($d_Ti_O) + ($k + ($k - 1))*($dscint/2) + ($k - 1)*$dlead + $z*$d_gaps;

		$detector{"name"}        = "W-view-scintillator ${k}";
		$detector{"mother"}      = "PCAL";
		$detector{"description"} = "Preshower Calorimeter";
		$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
		$detector{"rotation"}    = "0*deg 0*deg ${alpha_angle_deg}*deg";
		$detector{"color"}       = "33ffcc";
		$detector{"type"}        = "G4Trap";
		$detector{"dimensions"}  = "${pDzmom}*mm ${pThetamom}*deg ${pPhimom}*deg ${pDy1mom}*mm ${pDx1mom}*mm ${pDx2mom}*mm ${pAlp1mom}*deg ${ pDy2mom}*mm ${pDx3mom}*mm ${pDx4mom}*mm ${pAlp2mom}*deg";
		$detector{"material"}    = "G4_TITANIUM_DIOXIDE";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = $k;
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 0;
		$detector{"sensitivity"} = "no"; 
		$detector{"hit_type"}    = "";   
		$detector{"identifiers"} = ""; 
	
		print_det(\%detector, $file);
	}
}

### W Double Strips ###
sub make_W_double_strips 
{
	my $view = 3;  #All V scintillator layers will be assigned as 2
	my $strip_no = 0;
	my $PMT_id_number;
	my $hack;
	my $layer; # 1 U, 1 V, and 1 W per layer # 5 layers in total 	
	my $cut;
	my $strip;
	my $number_of_singles = 47;
	my $number_of_doubles = 15;
	    
	for (my $k = 3, my $hack = 2.0; $k <= $nlayers; $k+=3, $hack+=2)
	{
		for(my $b = 0, my $j = 0.00000001 ,my $a = 0, my $strip = 1; $j < 16, $a < 16, $strip <= 15; $b+=2, $j++, $a++, $strip++) 
		{	
			$layer = $k - $hack;
			$strip_no++;

			my $active_height = $number_of_singles*$s_thickness_scint_strip + $number_of_singles*(2*$d_Ti_O) + $number_of_doubles*$d_thickness_scint_strip + ($number_of_doubles-1)*(2*$d_Ti_O);
			my $gap_height = $height_v - $active_height;

			my $x_scint = -($height_v*tan($shifting_angle_rad))/2 + ($d_thickness_scint_strip*tan($shifting_angle_rad))/2 + $b*((2*$d_Ti_O)*tan($shifting_angle_rad))/2 + $b*($d_thickness_scint_strip*tan($shifting_angle_rad))/2 + $gap_height*tan($shifting_angle_rad);
			my $y_scint = $height_v/2 - $gap_height - $d_thickness_scint_strip/2 - $a*(2*$d_Ti_O) - $a*$d_thickness_scint_strip; 
			my $z_scint = 0;
			
			my $pDx2 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) +  $j*($d_thickness_scint_strip/tan($alpha_angle_rad) + $d_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx4 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) +  $j*($d_thickness_scint_strip/tan($alpha_angle_rad) + $d_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx1 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) + ($j+1)*($d_thickness_scint_strip/tan($alpha_angle_rad) + $d_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx3 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) + ($j+1)*($d_thickness_scint_strip/tan($alpha_angle_rad) + $d_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;

			my $pDy1 = ($d_thickness_scint_strip)/2;
    			my $pDy2 = ($d_thickness_scint_strip)/2;
			my $pDz = $dscint/2;
    			my $pTheta = 0;
    			my $pPhi   = 0;
			my $pAlp1 = -1*$shifting_angle_deg;  
    			my $pAlp2  = $pAlp1; 

			$detector{"name"}        = "W-view_double_strip ${layer} ${strip}";
			$detector{"mother"}      = "W-view-scintillator ${k}";
 			$detector{"description"} = "Preshower Calorimeter scintillator layer";
 			$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 			$detector{"rotation"}    = "0*deg 0*deg 0*deg";  
 			$detector{"color"}       = "6600ff";
 			$detector{"type"}        = "G4Trap";
			$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm ${pDx4}*mm ${pAlp2}*deg";
			$detector{"material"}    = "Scintillator";
 			$detector{"mfield"}      = "no";
 			$detector{"ncopy"}       = $strip_no; 
 			$detector{"pMany"}       = 1;
 			$detector{"exist"}       = 1;
 			$detector{"visible"}     = 1;
 			$detector{"style"}       = 0; # 0 for wireframe | # 1 for solid frame
 			$detector{"sensitivity"} = "PCAL";
 			$detector{"hit_type"}    = "PCAL";
 			$detector{"identifiers"} = "sector ncopy 0 layer manual 1 view manual $view strip manual $strip";
 			print_det(\%detector, $file);
		}
	}
}


### W Single Strips ###
sub make_W_single_strips 
{
	my $view = 3;  #All V scintillator layers will be assigned as 2
	my $strip_no = 0;
	my $PMT_id_number;
	my $hack;
	my $layer; # 1 U, 1 V, and 1 W per layer # 5 layers in total
	my $cut;
	my $strip;
	my $number_of_singles = 47;
	my $number_of_doubles = 15;

	for (my $k = 3, my $hack = 2.0; $k <= $nlayers; $k+=3, $hack+=2)
	{
		for(my $b = 60, my $a = 0, my $strip = 16; $a < 47, $strip <= 62; $b+=2, $a++, $strip++) 
		{	
			$layer = $k - $hack;
			$strip_no++;

			my $active_height = $number_of_singles*$s_thickness_scint_strip + $number_of_singles*(2*$d_Ti_O) + $number_of_doubles*$d_thickness_scint_strip + ($number_of_doubles-1)*(2*$d_Ti_O);
			my $gap_height = $height_v - $active_height;

### The last value of b from the V double strip for loop above is 28.
### Had there been another double strip, b would be 30.
### Instead of another strip, we have a single strip.
### Since the single strips have a thickness of 45 mm, simply double 30 and you have 60.

			my $x_scint = -($height_v*tan($shifting_angle_rad))/2 + ($s_thickness_scint_strip*tan($shifting_angle_rad))/2 + $b*((2*$d_Ti_O)*tan($shifting_angle_rad))/2 + $b*($s_thickness_scint_strip*tan($shifting_angle_rad))/2 + $gap_height*tan($shifting_angle_rad);
			my $y_scint = ($height_v/2 - $gap_height - 15*$d_thickness_scint_strip - 15*(2*$d_Ti_O)) - $s_thickness_scint_strip/2 - $a*$s_thickness_scint_strip -$a*(2*$d_Ti_O);
 			my $z_scint = 0;

			my $end_of_double_strips = (15*$d_thickness_scint_strip + 15*(2*$d_Ti_O))*(1/tan($alpha_angle_rad) + 1/tan($gamma_angle_rad)) + $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad);

			my $pDx2 = $end_of_double_strips/2 + ( $a*($s_thickness_scint_strip/tan($alpha_angle_rad) + $s_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx4 = $end_of_double_strips/2 + ( $a*($s_thickness_scint_strip/tan($alpha_angle_rad) + $s_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx1 = $end_of_double_strips/2 + ( ($a+1)*($s_thickness_scint_strip/tan($alpha_angle_rad) + $s_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
			my $pDx3 = $end_of_double_strips/2 + ( ($a+1)*($s_thickness_scint_strip/tan($alpha_angle_rad) + $s_thickness_scint_strip/tan($gamma_angle_rad)) + $a*((2*$d_Ti_O)/tan($alpha_angle_rad) + (2*$d_Ti_O)/tan($gamma_angle_rad)) )/2;
						
			my $pDy1 = ($s_thickness_scint_strip)/2;
    			my $pDy2 = ($s_thickness_scint_strip)/2;
			my $pDz = $dscint/2;
    			my $pTheta = 0;
    			my $pPhi   = 0;
    			my $pAlp1 = -1*$shifting_angle_deg;  
    			my $pAlp2  = $pAlp1; 

			$detector{"name"}        = "W-view_single_strip ${layer} ${strip}";
			$detector{"mother"}      = "W-view-scintillator ${k}";
 			$detector{"description"} = "Preshower Calorimeter scintillator layer";
 			$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 			$detector{"rotation"}    = "0*deg 0*deg 0*deg";  
 			$detector{"color"}       = "6600ff";
 			$detector{"type"}        = "G4Trap";
			$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm ${pDx4}*mm ${pAlp2}*deg";
			$detector{"material"}    = "Scintillator";
 			$detector{"mfield"}      = "no";
 			$detector{"ncopy"}       = $strip_no; 
 			$detector{"pMany"}       = 1;
 			$detector{"exist"}       = 1;
 			$detector{"visible"}     = 1;
 			$detector{"style"}       = 0; # 0 for wireframe | # 1 for solid frame
 			$detector{"sensitivity"} = "PCAL";
 			$detector{"hit_type"}    = "PCAL";
			$detector{"identifiers"} = "sector ncopy 0 layer manual 1 view manual $view strip manual $strip";
 			print_det(\%detector, $file);
		}
	}
}

### W Zero Strips --> are in-active triangular pieces at the apex of the W mother volume triangles###
sub make_W_zero_strips 
{
	my $view = 3;  #All V scintillator layers will be assigned as 2
	my $strip_no = 0;
	my $PMT_id_number;
	my $hack;
	my $layer; # 1 U, 1 V, and 1 W per layer # 5 layers in total
	my $cut;
	my $strip = 0;
	my $number_of_singles = 47;
	my $number_of_doubles = 15;
	
	for (my $k = 3, my $hack = 2.0; $k <= $nlayers; $k+=3, $hack+=2)
	{
			$layer = $k - $hack;

			my $active_height = $number_of_singles*$s_thickness_scint_strip + $number_of_singles*(2*$d_Ti_O) + $number_of_doubles*$d_thickness_scint_strip + ($number_of_doubles-1)*(2*$d_Ti_O);
			my $gap_height = $height_v - $active_height;

			
			my $x_scint = -($height_v*tan($shifting_angle_rad))/2 + $gap_height*tan($shifting_angle_rad)/2;
			
			my $y_scint = $height_v/2 - $gap_height/2;  
 			my $z_scint = 0;

			my $pDx2 = 0.00000001;
			my $pDx4 = 0.00000001;
			my $pDx1 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) )/2;
			my $pDx3 = ( $gap_height/tan($alpha_angle_rad) + $gap_height/tan($gamma_angle_rad) )/2;
			
			my $pDy1 = $gap_height/2;
    			my $pDy2 = $gap_height/2;
			my $pDz = $dscint/2;
    			my $pTheta = 0;
    			my $pPhi   = 0;
    			my $pAlp1 = -1*$shifting_angle_deg;  
    			my $pAlp2  = $pAlp1; 

			$detector{"name"}        = "W-view_single_strip ${layer} ${strip}";
			$detector{"mother"}      = "W-view-scintillator ${k}";
 			$detector{"description"} = "Preshower Calorimeter scintillator layer";
 			$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 			$detector{"rotation"}    = "0*deg 0*deg 0*deg";  
 			$detector{"color"}       = "6600ff";
 			$detector{"type"}        = "G4Trap";
			$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm ${pDx4}*mm ${pAlp2}*deg";
			$detector{"material"}    = "Scintillator";
 			$detector{"mfield"}      = "no";
 			$detector{"ncopy"}       = 1; 
 			$detector{"pMany"}       = 1;
 			$detector{"exist"}       = 1;
 			$detector{"visible"}     = 1;
 			$detector{"style"}       = 1; # 0 for wireframe | # 1 for solid frame
 			$detector{"sensitivity"} = "no";
 			$detector{"hit_type"}    = "";
			$detector{"identifiers"} = "";
 			print_det(\%detector, $file);
		}
}

### Front Stainless Steel Window ###
sub make_front_steel
{
	for(my $k = 1.0, my $z = 1; $k <= 2, $z <=3; $k++, $z+=2)
	{

		my $x_scint = 0.0;
		my $y_scint = 0.0;
		my $z_scint = -$total_thickness/2 - $z*$d_gaps - $k*$d_steel/2 - ($k-1)*$d_foam - ($k-1)*$d_steel/2;
		
		my $pDz = $d_steel/2.0;
    		my $pDy1 = $height_pcal/2;
    		my $pDy2 = $height_pcal/2;
    		my $pDx1 = 0.00000001;
    		my $pDx3 = 0.00000001;
   		my $pDx2 = $x_length_pcal/2;
    		my $pDx4 = $x_length_pcal/2;
    		my $pTheta = 0.0;
    		my $pPhi   = 0.0;
    		my $pAlp1  = 0.0;
    		my $pAlp2  = 0.0;	

		$detector{"name"}        = "Stainless Steel Front ${k}";
		$detector{"mother"}      = "PCAL";
		$detector{"description"} = "Front Window";
 		$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
 		$detector{"color"}       = "D4E3EE";
 		$detector{"type"}        = "G4Trap";
		$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm  ${pDx2}*mm  ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
		$detector{"material"}    = "StainlessSteel";
 		$detector{"mfield"}      = "no";
 		$detector{"ncopy"}       = $k;
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

### Back Stainless Steel Window ###
sub make_back_steel
{
	for(my $k = 1.0, my $z = 1; $k <= 2, $z <=3; $k++, $z+=2)
	{

		my $x_scint = 0.0;
		my $y_scint = 0.0;
		my $z_scint = $total_thickness/2 + $z*$d_gaps + $k*$d_steel/2 + ($k-1)*$d_foam + ($k-1)*$d_steel/2;


		my $pDz = $d_steel/2.0;
    		my $pDy1 = $height_pcal/2;
    		my $pDy2 = $height_pcal/2;
    		my $pDx1 = 0.00000001;
    		my $pDx3 = 0.00000001;
   		my $pDx2 = $x_length_pcal/2;
    		my $pDx4 = $x_length_pcal/2;
    		my $pTheta = 0.0;
    		my $pPhi   = 0.0;
    		my $pAlp1  = 0.0;
    		my $pAlp2  = 0.0;	

		$detector{"name"}        = "Stainless Steel Back ${k}";
		$detector{"mother"}      = "PCAL";
		$detector{"description"} = "Back Window";
 		$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
 		$detector{"color"}       = "D4E3EE";
 		$detector{"type"}        = "G4Trap";
		$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm  ${pDx2}*mm  ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
		$detector{"material"}    = "StainlessSteel";
 		$detector{"mfield"}      = "no";
 		$detector{"ncopy"}       = $k;
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

### Front Last-a-Foam Window ###
sub make_front_foam
{
		my $x_scint = 0.0;
		my $y_scint = 0.0;
		my $z_scint = -$total_thickness/2 - 2*$d_gaps - $d_steel - $d_foam/2;
		
		my $pDz = $d_foam/2.0;
    		my $pDy1 = $height_pcal/2;
    		my $pDy2 = $height_pcal/2;
    		my $pDx1 = 0.00000001;
    		my $pDx3 = 0.00000001;
   		my $pDx2 = $x_length_pcal/2;
    		my $pDx4 = $x_length_pcal/2;
    		my $pTheta = 0.0;
    		my $pPhi   = 0.0;
    		my $pAlp1  = 0.0;
    		my $pAlp2  = 0.0;	

		$detector{"name"}        = "Last-a-Foam Front";
		$detector{"mother"}      = "PCAL";
		$detector{"description"} = "Front Foam";
 		$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
 		$detector{"color"}       = "EED18C";
 		$detector{"type"}        = "G4Trap";
		$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm  ${pDx2}*mm  ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
		$detector{"material"}    = "LastaFoam";
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

### Back Last-a-Foam Window ###
sub make_back_foam
{
		my $x_scint = 0.0;
		my $y_scint = 0.0;
		my $z_scint = $total_thickness/2 + 2*$d_gaps + $d_steel + $d_foam/2;

		my $pDz = $d_foam/2.0;
    		my $pDy1 = $height_pcal/2;
    		my $pDy2 = $height_pcal/2;
    		my $pDx1 = 0.00000001;
    		my $pDx3 = 0.00000001;
   		my $pDx2 = $x_length_pcal/2;
    		my $pDx4 = $x_length_pcal/2;
    		my $pTheta = 0.0;
    		my $pPhi   = 0.0;
    		my $pAlp1  = 0.0;
    		my $pAlp2  = 0.0;	

		$detector{"name"}        = "Last-a-Foam Back";
		$detector{"mother"}      = "PCAL";
		$detector{"description"} = "Back Foam";
 		$detector{"pos"}         = "${x_scint}*mm ${y_scint}*mm ${z_scint}*mm";
 		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
 		$detector{"color"}       = "EED18C";
 		$detector{"type"}        = "G4Trap";
		$detector{"dimensions"}  = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm  ${pDx2}*mm  ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
		$detector{"material"}    = "LastaFoam";  
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


#SUB-ROUTINES

sub yplus 
{
    # calculates the top of the triangular active area of the PCAL (at large scattering angle)
    my $layer = $_[0];
    my $yplus = 1899.56 + 4.5419*($layer - 1);
    return $yplus;
}

sub yminus 
{
    # calculates the beam-side vertex of the triangular active area of the PCAL (at small scattering angle)
    my $layer = $_[0];
    my $yminus = -1829.74 - 4.3708*($layer - 1);
    return $yminus;
}

#BUILDS THE GEOMETRY

make_PCAL_mother(); 
make_lead(); 

make_U_mother();
make_U_double_strips();
make_U_single_strips();
make_U_zero_strips();
 
make_V_mother();
make_V_double_strips(); 
make_V_single_strips(); 
make_V_zero_strips(); 

make_W_mother();
make_W_double_strips();
make_W_single_strips();
make_W_zero_strips();

make_front_steel(); 
make_back_steel();

make_front_foam();
make_back_foam();
