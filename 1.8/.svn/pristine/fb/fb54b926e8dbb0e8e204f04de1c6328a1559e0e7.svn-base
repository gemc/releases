#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'ctof_LG';
my $file     = 'ctof_LG.txt';

my $nomakesum = 0;
if($ARGV[0] == 1)
{
  $nomakesum = 1;
} # if first argument is 1, place all solids (no sum, used for lack of opengl visualization)


my $rmin      = 1;
my $rmax      = 1000000;


my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

# All dimension in mm
my $inches = 25.4;


my $CompMaterial = "Component";
if($nomakesum == 1)
{
	$CompMaterial = "OptScint";
}

my $lgcolor = "aaffaa";


# The reference frame will be LG2 - all pieces will be placed in respect to this volume
# LG2 starts rotated 90 degrees around y - so x becomes z

# Common dimensions:
my $radius   = 1.0*$inches;   # Radius common to all light guides
my $lg2_posy = 917.3;
#my $lg2_posy = 661.226; I think this is wrong
my $lg2_posz = 802.826;


# LG2
my $lg2_torus_radius = 7.0*$inches;
my $lg2_span         = 134.0  ;
my $lg2_start_phi    = -134.0 + 85.0;

# LG1
my $lg1_length  = 10.6*$inches;           # Semilength
my $lg1_rot     = 90-5;                   # rotation
my $lg1_posy    = 1096.196 - $lg2_posy + 21.7;
my $lg1_posz    = 550.502  - $lg2_posz;

# LG3
my $lg3_length  = 304.81252 + 40.0;                # Semilength - corrected from the drawings
my $lg3_rotx    = 90;                              # x LG3 relative to LG2
my $lg3_rot     = -41.0 - 5.0;                     # rotation around x
my $lg3_posy    = 561.780 - $lg2_posy ;            # y LG3 relative to LG2 - corrected from the drawings
my $lg3_posz    = 689.427 - $lg2_posz;             # z LG3 relative to LG2 - corrected from the drawings



sub make_LG1
{
 $detector{"name"}         = "aactoflg1";
 $detector{"mother"}       = "root";
 $detector{"description"}  = "Light Guide part 1";

 $detector{"pos"}        = "$lg1_posz*mm $lg1_posy*mm 0*mm";
 $detector{"rotation"}   = "90*deg $lg1_rot*deg 0*deg";
 $detector{"color"}      = $lgcolor;
 $detector{"type"}       = "Tube";
 $detector{"dimensions"} = "0.0*mm $radius*mm $lg1_length*mm 0*deg 360*deg";
 $detector{"material"}   = $CompMaterial;
 $detector{"mfield"}     = "no";
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


sub make_LG2
{
 $detector{"name"}        = "aactoflg2";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide part 2";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Torus";
 $detector{"dimensions"}  = "0.0*mm $radius*mm $lg2_torus_radius*mm $lg2_start_phi*deg $lg2_span*deg";
 $detector{"material"}    = $CompMaterial;
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


sub make_LG3
{
 $detector{"name"}        = "aactoflg3";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide part 3";
 $detector{"pos"}         = "$lg3_posz*mm  $lg3_posy*mm 0*mm ";
 $detector{"rotation"}    = "$lg3_rotx*deg $lg3_rot*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0.0*mm $radius*mm $lg3_length*mm 0*deg 360*deg";
 $detector{"material"}    = $CompMaterial;
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

# ########
# 4 is 1+2
# 5 is 4+3
##########
sub make_LG4
{
 $detector{"name"}        = "aactoflg4";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide 2 + 1";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Operation: aactoflg2 + aactoflg1";
 $detector{"dimensions"}  = "0.0*mm";
 $detector{"material"}    = $CompMaterial;
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

sub make_LG5
{
 $detector{"name"}        = "aactoflg5";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide 4 + 3";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Operation: aactoflg4 + aactoflg3";
 $detector{"dimensions"}  = "0.0*mm";
 $detector{"material"}    = $CompMaterial;
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





#################################################################
# Connector to the Scintillator
# The tube is at 0,0,0
# Have to rotate the boxes so that they relate to the new center
# Transformation:
# 1) Translation: to LG10 origin 
# 2) Rotation:
# z' =   z cos(theta) + x sin(theta)
# x' = - z sin(theta) + x cos(theta)
#################################################################

my $lgc1_length  = 96;
my $lgc1_angle   = 32;
my $lgc1_zcenter = 69.51;
my $lgc1_ycenter = 66.20;


my $lgc2_angle   = 41 - $lgc1_angle;
# 1) Translate
my $lgc2_zcenter = 31.52 - $lgc1_zcenter;
my $lgc2_ycenter = 86.06 - $lgc1_ycenter;
# 2) Rotate
my $lgc2_z       =    $lgc2_zcenter*cos(rad($lgc1_angle)) + $lgc2_ycenter*sin(rad($lgc1_angle));
my $lgc2_y       =   -$lgc2_zcenter*sin(rad($lgc1_angle)) + $lgc2_ycenter*cos(rad($lgc1_angle));


my $lgc3_angle   = 90 - $lgc1_angle;
# 1) Translate
my $lgc3_zcenter = -20 - $lgc1_zcenter;
my $lgc3_ycenter =  22 - $lgc1_ycenter;
# 2) Rotate
my $lgc3_z       =    $lgc3_zcenter*cos(rad($lgc1_angle)) + $lgc3_ycenter*sin(rad($lgc1_angle));
my $lgc3_y       =   -$lgc3_zcenter*sin(rad($lgc1_angle)) + $lgc3_ycenter*cos(rad($lgc1_angle));

my $lgc4_angle   = 0 - $lgc1_angle;
# 1) Translate
my $lgc4_zcenter =    0 - $lgc1_zcenter;
my $lgc4_ycenter =  -20 - $lgc1_ycenter;
# 2) Rotate
my $lgc4_z       =    $lgc4_zcenter*cos(rad($lgc1_angle)) + $lgc4_ycenter*sin(rad($lgc1_angle));
my $lgc4_y       =   -$lgc4_zcenter*sin(rad($lgc1_angle)) + $lgc4_ycenter*cos(rad($lgc1_angle));


sub make_LGc1
{
 $detector{"name"}        = "aactoflgc1";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide Connector - part1";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0.0*mm $radius $lgc1_length 0*deg 360*deg";
 $detector{"material"}    = $CompMaterial;
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

sub make_LGc2
{
 $detector{"name"}        = "aactoflgc2";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide Connector - part2";
 $detector{"pos"}         = "0*mm $lgc2_y*mm $lgc2_z*mm";
 $detector{"rotation"}    = "$lgc2_angle*deg 0*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "30.0*mm 20*mm 100*mm";
 $detector{"material"}    = $CompMaterial;
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


sub make_LGc3
{
 $detector{"name"}        = "aactoflgc3";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide Connector  - part 3";
 $detector{"pos"}         = "0*mm $lgc3_y*mm $lgc3_z*mm";
 $detector{"rotation"}    = "$lgc3_angle*deg 0*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "30.0*mm 20*mm 100*mm";
 $detector{"material"}    = $CompMaterial;
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



sub make_LGc4
{
 $detector{"name"}        = "aactoflgc4";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide Connector - part 4";
 $detector{"pos"}         = "0*mm $lgc4_y*mm $lgc4_z*mm";
 $detector{"rotation"}    = "$lgc4_angle*deg 0*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "30.0*mm 20*mm 100*mm";
 $detector{"material"}    = $CompMaterial;
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


# ##########
# 5 is 1 - 2
# 6 is 5 - 3
# 7 is 6 - 4
############
sub make_LGc5
{
 $detector{"name"}        = "aactoflgc5";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide Connector: 1 - 2";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Operation: aactoflgc1 - aactoflgc2";
 $detector{"dimensions"}  = "0.0*mm ";
 $detector{"material"}    = $CompMaterial;
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

sub make_LGc6
{
 $detector{"name"}        = "aactoflgc6";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide Connector: 5 - 3";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "$lgc1_angle*deg 0*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Operation: aactoflgc5 - aactoflgc3";
 $detector{"dimensions"}  = "0.0*mm ";
 $detector{"material"}    = $CompMaterial;
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

sub make_LGc7
{
 $detector{"name"}        = "aactoflgc7";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide Connector: 6 - 4";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Operation: aactoflgc6 - aactoflgc4";
 $detector{"dimensions"}  = "0.0*mm ";
 $detector{"material"}    = "OptScint";
 $detector{"material"}    = $CompMaterial;
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




# Side boxes
my $lg_sidebox_shift  = 40.3;
my $lg_sidebox_angley = 3.6;

# 1) Translate
my $lg_sidebox_zcenter = 110.90 - $lgc1_zcenter;
# 2) Rotate
my $lg_sidebox_z       =   $lg_sidebox_zcenter;
my $lg_sidebox_y       =   0;


sub make_LGsb1
{
 $detector{"name"}        = "aactoflgsb1";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide Connector: sidebox 1";
 $detector{"pos"}         = "$lg_sidebox_shift*mm   $lg_sidebox_y*mm $lg_sidebox_z*mm";
 $detector{"rotation"}    = "0*deg -$lg_sidebox_angley*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "20.0*mm 30*mm 200*mm";
 $detector{"material"}    = $CompMaterial;
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

sub make_LGsb2
{
 $detector{"name"}        = "aactoflgsb2";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide Connector: sidebox 2";
 $detector{"pos"}         = "-$lg_sidebox_shift*mm   $lg_sidebox_y*mm $lg_sidebox_z*mm";
 $detector{"rotation"}    = "0*deg $lg_sidebox_angley*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "20.0*mm 30*mm 200*mm";
 $detector{"material"}    = $CompMaterial;
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


# Notice only one "a" in front
sub make_LGc8
{
 $detector{"name"}        = "actoflgc8";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide Connector: 7 - sb1";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Operation: aactoflgc7 - aactoflgsb1";
 $detector{"dimensions"}  = "0.0*mm";
 $detector{"material"}    = $CompMaterial;
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


# pos in respect to part 1
my $lgc9_posy  =  317.32 - $lg2_posy - 33.0;   # y LGc9 relative to LG2
my $lgc9_posz  =  388.19 - $lg2_posz - 13.0;   # z LGc9 relative to LG2 
my $lgc9_roty  = -90 + 32;                    # rotation 
sub make_LGc9
{
 $detector{"name"}        = "actoflgc9";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Light Guide Connector: 8 - sb2";
 $detector{"pos"}         = "$lgc9_posz*mm $lgc9_posy*mm 0*mm";
 $detector{"rotation"}    = "90*deg $lgc9_roty*deg -90*deg";
 $detector{"color"}       = $lgcolor;
 $detector{"type"}        = "Operation: actoflgc8 - aactoflgsb2";
 $detector{"dimensions"}  = "0.0*mm";
 $detector{"material"}    = "OptScint";
 $detector{"material"}    = $CompMaterial;
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



##########################
# Now putting all together
##########################

# ########
# 4 is 1+2
# 5 is 4+3
##########

make_LG1();
make_LG2();
make_LG3();
if($nomakesum != 1)
{
 make_LG4();
 make_LG5();
}



# ##########
# 5 is 1 - 2
# 6 is 5 - 3
# 7 is 6 - 4
############
make_LGc1();
make_LGc2();
make_LGc3();
make_LGc4();

if($nomakesum != 1)
{
 make_LGc5();
 make_LGc6();
 make_LGc7();
}

make_LGsb1();
make_LGsb2();

if($nomakesum != 1)
{
  make_LGc8();
  make_LGc9();
}

# Unify everything
# Positioning all ight guides
my $LG_radius = $lg2_posy + 33.0;
my $LG_Z      = $lg2_posz + 35.0;
my $NUM_BARS  = 50;
my $theta0    = 360./$NUM_BARS; 
if($nomakesum != 1)
{
 make_LGall();
}

sub make_LGall
{
 for(my $n=1; $n <= $NUM_BARS; $n++) 
 {
    my $pnumber     = cnumber($n, 100);

    # names
    $detector{"name"}        = "ctof_LG_$pnumber";
    $detector{"mother"}      = "root" ;
    $detector{"description"} = "Light Guide $n";
    # positioning
    # The angle $theta is defined off the y-axis (going clockwise) so $x and $y are reversed 
    my $theta  = ($n-1)*$theta0 - $theta0/2.0;
    my $theta2 = 90 - $theta;
    my $x      = sprintf("%.3f", $LG_radius*sin(rad($theta)));
    my $y      = sprintf("%.3f", $LG_radius*cos(rad($theta)));
    my $z      = $LG_Z;
    $detector{"pos"}    = "$x*mm $y*mm $z*mm";
    $detector{"rotation"}   = "90*deg $theta2*deg 90*deg";
    $detector{"type"}        = "Operation: aactoflg5 + actoflgc9 ";
    $detector{"dimensions"}  = "0.0*mm ";
    $detector{"material"}    = "OptScint";
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $n;
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









