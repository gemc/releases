#!/usr/bin/perl -w
#
# The LTCC sector 1 is a box centered at 0,0 
# the sides are planes that are cut out from the main box

#use strict;
use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);
use Getopt::Long;
use Math::Trig;

# local quantities.

my $envelope = 'LTCC';
my $file     = 'LTCC.txt'; 
my $rmin = 1;
my $rmax = 1000000;

#
#  large angle side(top) -->  /\
#                             \ \
#      Side view               \ \
#                               \ \
#                                \ \
#                                 \_\   <-- small angle vertex(bottom)
#  target  |
# 
# We are using the Hall B coordinate system with the origin at the target center.

my $inches = 25.4;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

# Mother Volume - description of parameters for Geant4 G4Trap volume.
#
# pDx1 	  Half x length of the side at y=-pDy1 of the face at -pDz
# pDx2 	  Half x length of the side at y=+pDy1 of the face at -pDz
# pDz 	  Half z length
# pTheta  Polar angle of the line joining the centres of the faces at -/+pDz
# pPhimom Azimuthal angle of the line joining the centre of the face at -pDz to the centre of the face at +pDz
# pDy1 	  Half y length at -pDz
# pDy2 	  Half y length at +pDz
# pDx3 	  Half x length of the side at y=-pDy2 of the face at +pDz
# pDx4 	  Half x length of the side at y=+pDy2 of the face at +pDz
# pAlp1   Angle with respect to the y axis from the centre of the side (lower endcap)
# pAlp2   Angle with respect to the y axis from the centre of the side (upper endcap)
# 
# Note on pAlph1/2: the two angles have to be the same due to the planarity condition. 
#
# all numbers are in mm or deg as specified in the $detector{"dimensions"} statement.

# The bottom of the CC will be pdx1, pdx2, the top will be pdx3, pdx4




# From the top:
#
#            b     | d  |
#   --------------------
#   \         |        /
#		 \        |       /
#	 	  \       |      /
#		 	 \    h |     / c
#			  \     |    /
#				 \    |   /
#				  --------
#					   a
#
# The downstream and upstream plates in the trapezoid are parallel
#
# From the side
# 
#         DC  |  c  | DC 
#        -----------------
#        |   /       \	 |
#        |  /         \  |
#        | /           \ |
#        ----------------  
#       c (downstream)   
#
#  Top View:                   | DB         
#        --------------------------- Top Right Angle
#        \                     |   /
#         \               DC   |  /
#          \                   | /
#           ---------------------
#
# Choose DC = 0 because the front and top planes in G4Trap are not independent.
# Just subtract a box at 45 degrees from the top

sub build_mother()
{
	my $depth = 59.21*$inches/2;

	# downstream:
	my $a_d =  11.78*$inches/2;        # bottom of the CC, downstream
	my $b_d = 165.94*$inches/2;        # top of the CC, downstream
	my $h_d = 141.87*$inches/2;
	my $d_d = $b_d - $a_d;                 
	my $c_d = sqrt($d_d*$d_d+$h_d*$h_d);
	
	# upstream:
	my $DC    = 0;
	my $a_u =  11.78*$inches/2-50;      # bottom of the CC, downstream
	my $h_u = (141.87 - $DC)*$inches/2;
	#my $angle_top_right = atan(2*$h_d/($d_d));
	#print tan($angle_top_right), " " , 2*$h_d/($d_d), "\n";
	my $DB = $DC/(2*$h_d/($d_d));
	my $b_u = (165.94-2*$DB)*$inches/2-50;        # top of the CC, downstream
	my $d_u = $b_u - $a_u;     
	my $c_u = sqrt($d_u*$d_u+$h_u*$h_u);
	
	
	my $pDx1   = $a_d;      
	my $pDx2   = $b_d;       
	my $pDz    = $depth;          
	my $pTheta = 0;                                        
	my $pPhi   = 0;                     
	my $pDy1   = $c_d;                   	
	my $pDy2   = $c_u;                   
	my $pDx3   = $a_u;                  
	my $pDx4   = $b_u;                  
	my $pAlp1  = 0;                      
	my $pAlp2  = 0;                      


	# generate  mother volume wireframe box, and write to a file. 
	$detector{"name"}        = "aLTCC_Trap";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Light Threshold Cerenkov Counter";
	$detector{"pos"}         = "0*mm 0*mm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "G4Trap";
	$detector{"dimensions"}  = "$pDz*mm $pTheta*deg $pPhi*deg $pDy1*mm $pDx1*mm $pDx2*mm $pAlp1*deg $pDy2*mm $pDx3*mm $pDx4*mm $pAlp2*deg";
	$detector{"material"}    = "Air";
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
	
	# Subtract box at 45ish degrees from the top
	# The upper coordinate is at:
	# x = 0
	# y = $c_d 
	# z = depth/2  
	
	my $y_upper = $c_d;
	my $z_upper = $depth;
	
	my $box_x   = 3000.0;
	my $box_y   =  600.0;
	my $box_z   = 3000.0;
	
	
	# box angle on the top is 45 - 25
	my $box_angle    = -20*$pi/180.0;
	my $absbox_angle =  20*$pi/180.0;
		
	my $y_box_p =  $y_upper - ($box_z*sin($absbox_angle) - $box_y*cos($absbox_angle));
	my $z_box_p = -$z_upper + ($box_z*cos($absbox_angle) + $box_y*sin($absbox_angle));
	
	$detector{"name"}        = "bLTCC_inclined_box";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Box to subtract from LTCC";
	$detector{"pos"}         = "0*mm $y_box_p*mm $z_box_p*mm";
	$detector{"rotation"}    = "$box_angle*rad 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$box_x*mm $box_y*mm $box_z*mm";
	$detector{"material"}    = "Air";
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


	
	# Trap - Box
	# generate  mother volume wireframe box, and write to a file. 
	$detector{"name"}        = "cLTCC_Trap_minus_TopBox";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Trap minus Top Box ";
	$detector{"pos"}         = "0*mm 0*mm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Operation:  aLTCC_Trap - bLTCC_inclined_box";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Air";
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
	
	
	
	
	# Subtract tube 
	my $R  = 130.50*$inches;
	my $DZ = 180.00*$inches;
	
	my $zpos = 3500;
	my $ypos  = -23.36*$inches;
	
	$detector{"name"}        = "dLTCC_Tube";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Tube to subtract from LTCC ";
	$detector{"pos"}         = "0*mm $ypos*mm $zpos*mm";
	$detector{"rotation"}    = "0*deg 90*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "0*mm $R*mm $DZ 0*deg 360*deg";
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
	
	
	# Trap - Box - Tube
	# generate  mother volume wireframe box, and write to a file. 
	$detector{"name"}        = "eLTCC_Trap_minus_TopBox_minus_Tube";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Trap minus Top Box minus Tube";
	$detector{"pos"}         = "0*mm 0*mm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Operation:  cLTCC_Trap_minus_TopBox - dLTCC_Tube";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Air";
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
	



	# Subtract box at 25ish degrees from the bottom
	# The upper coordinate is at:
	# x = 0
	# y = -$c_d 
	# z = depth/2  
	
	$y_upper = -$c_d;
	$z_upper = $depth;
	
	$box_x   = 3000.0;
	$box_y   =  600.0;
	$box_z   = 3000.0;
	
	$box_angle    =  25*$pi/180.0;
	$absbox_angle =  25*$pi/180.0;
		
	$y_box_p =  $y_upper + ($box_z*sin($absbox_angle) - $box_y*cos($absbox_angle));
	$z_box_p = -$z_upper + ($box_z*cos($absbox_angle) + $box_y*sin($absbox_angle));
	
	$detector{"name"}        = "fLTCC_inclined_box2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Box to subtract from LTCC";
	$detector{"pos"}         = "0*mm $y_box_p*mm $z_box_p*mm";
	$detector{"rotation"}    = "$box_angle*rad 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$box_x*mm $box_y*mm $box_z*mm";
	$detector{"material"}    = "Air";
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


	# Trap - Box - Tube - Box 2
	# generate  mother volume wireframe box, and write to a file. 
	$detector{"name"}        = "gLTCC";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Trap minus Top Box minus Tube minus Bottom Box";
	$detector{"pos"}         = "0*mm 0*mm 2000*mm";
	$detector{"rotation"}    = "0*deg 180*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Operation:  eLTCC_Trap_minus_TopBox_minus_Tube - fLTCC_inclined_box2";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "CCGas";
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

build_mother();




