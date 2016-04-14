#!/usr/bin/perl -w
 
use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

use geo qw($pi);

# All dimensions in mm

my $envelope = 'FST';
my $file     = 'FST.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();          # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

# General description
my @radius             = ( 17.0,   17.0,  17.0 );  # Transverse Position Start of Modulesq
my @starting_point     = (190.1,  210.1, 230.1 );  # Z starting_point of the sensors

my $nsegments          = 15;                  # Number of segments in each layer
my $dtheta             = 360.0/$nsegments;     # Delta theta
my $starting_theta     = $dtheta/2.0;          # Starting angle of the first segment.

#######################
# Dimensions:
# Each segment is a Trd
#######################

# For N=14:
my $rohacell_x1        = 8.379;     # Rohacell trd x at -dz
my $rohacell_x2        = 104.228;   # Rohacell trd x at +dz
my $rohacell_z         = 209.971;   # Rohacell trd 2xdz

my $silicon_x1         = 8.379;     # Silicon trd x at -dz
my $silicon_x2         = 85.512;    # Silicon trd x at +dz
my $silicon_z          = 168.971;   # Silicon trd 2xdz

my $wirebond1_length   = 27.112;    # Wirebond1 length (subtract 2mm from module width at that point)
my $wirebond2_length   = 83.512;    # Wirebond2 length (subtract 2mm from module width at that point)
my $wirebond_heigth    = 4.50;      # Wirebond heigth
my $wirebond1_r        = 45.419;    # Middle Transverse position for Wirebond1 from start of module
my $wirebond2_r        = 168.971;   # Middle Transverse position for Wirebond2 from start of module
my $pcboard_length     = 84.00;     # PC Board length
my $pcboard_height     = 37.00;     # PC Board height
my $chip_length        = 8.0;       # chip lenght
my $chip_height        = 5.0;       # chip height
my $chip_displacement  = 8.0;       # chip displacement from center
my $support_side       = 5.0;       # Central Support is 5mm
my $support_hole       = 1.0;       # Support Hole


# For N=15:
$rohacell_x1        = 7.57 - 3.06;
#$rohacell_x1       = 7.783 - 0.300;       # Rohacell trd x at -dz, reduced to make a gap between sectors for the support structure
$rohacell_x2        = 78.84 - 4.56;
#$rohacell_x2       = 92.600 - 0.300;      # Rohacell trd 2xdz reduced to make a gap between sectors for the support structure
$rohacell_z	        = 164.00;              # Rohacell heigth  dz 

$silicon_x1         = 7.57 - 3.06;
#$silicon_x1        = 7.783 - 0.300;        # Silicon trd x at -dz
$silicon_x2         = 78.58 - 4.56;
#$silicon_x2        = 79.615 - 0.300;       # Silicon trd x at +dz
$silicon_z          = 164.0;                # Silicon trd 2xdz

$wirebond1_length      = 16.05;       # Wirebond1 length (subtract 2mm from module width at that point)
$wirebond2_length      = 74.02;       # Wirebond2 length (subtract 2mm from module width at that point)
$wirebond_heigth       = 4.500;       # Wirebond heigth
$wirebond1_r           = 42.95;       # Middle Transverse position for Wirebond1 from start of module
$wirebond2_r           = 163.50;      # Middle Transverse position for Wirebond2 from start of module
$pcboard_length        = 74.02;       # PC Board length. It is the same thing as HTM and Hybrid, we consider it to be one big PC board.It doesn't cover Si anyway and made fromthe same material.
$pcboard_height        = 41.00;       # PC Board height
my $copper_tab_length  = 45.00;       # copper cooling tab length
my $copper_tab_heigth  = 11.00;       # copper cooling tb heigth
$chip_length           = 8.000;       # chip length
$chip_height           = 5.000;       # chip height
$chip_displacement     = 8.000;       # chip displacement from center

my $silicon_width      = 0.300;       # Silicon sensor width
my $rohacell_width     = 2.000;       # Rohacell width 
my $carbon_fiber_width = 0.250;       # Carbon fiber width
my $epoxy_width        = 0.085;       # Epoxy glue width
my $epoxy_small_width  = 0.041;       # Kapton Epoxy glue width
my $pcboard_width      = 0.380;       # PC Board width
my $chip_width         = 0.500;       # chip width
my $wirebond_width     = 0.300;       # Wirebond width
my $kapton_width       = 0.025;       # Kapton width
my $copper_hole_width  = 10.00;       # Width of a hole in copper cooling box
################################
#Check the name of kapton in G4#
################################

# G4 materials
my $silicon_material      = 'G4_Si';
my $rohacell_material     = 'Rohacell';
my $carbon_fiber_material = 'CarbonFiber';
my $epoxy_material        = 'Epoxy';
my $pcboard_material      = 'PCBoardM';
my $chip_material         = 'PCBoardM';
my $wirebond_material     = 'svtwirebond';
my $kapton_material       = 'Kapton';
my $copper_material	  = 'G4_Cu';
my $plastic_material      = 'Noryl';  

# G4 colors
my $silicon_color      = '353540';
my $rohacell_color     = 'e10000';
my $carbon_fiber_color = '252020';
my $epoxy_color        = 'e200e1';
my $pcboard_color      = '0000ff';
my $chip_color         = 'fff600';
my $wirebond_color     = 'a5af9a';
my $kapton_color       = '00C000';
my $copper_color       = '772200';

my $microgap_width = 0.0008;


sub pos_t
{
 my $R = shift;
 my $l = shift;
 my $s = shift;

 my $theta     = $starting_theta + $s*$dtheta ;
 my $x         = sprintf("%.3f", $R*cos(rad($theta)));
 my $y         = sprintf("%.3f", $R*sin(rad($theta)));
 return "$x*mm $y*mm";
}

sub rot
{
 my $R = shift;
 my $l = shift;
 my $s = shift;

 my $theta_rot = $starting_theta + $s*$dtheta - 90;

 return "90*deg $theta_rot*deg 0*deg";
}

sub rot_CU
{
 my $R = shift;
 my $l = shift;
 my $s = shift;

 my $theta_rot = $starting_theta + $s*$dtheta + 10.5;

 return "0*deg 0*deg $theta_rot*deg";
}

sub rot_hole
{
my $R = shift;
my $l = shift;
my $s = shift;

my $theta_rot = $starting_theta + $s*$dtheta + 7.0;

return "0*deg 0*deg $theta_rot*deg";
}

sub pos_t_chip
{
 my $R = shift;
 my $l = shift;
 my $t = shift;
 my $s = shift;

 my $dth   = asind($chip_displacement / $R);
 my $theta = 0;

 if($t == 1){ $theta  =  - $dth   + $starting_theta + $s*$dtheta; }
 if($t == 2){ $theta  =  + $dth   + $starting_theta + $s*$dtheta; }
 if($t == 3){ $theta  =  - 3*$dth + $starting_theta + $s*$dtheta; }
 if($t == 4){ $theta  =  + 3*$dth + $starting_theta + $s*$dtheta; }

 my $x         = sprintf("%.3f", $R*cos(rad($theta)));
 my $y         = sprintf("%.3f", $R*sin(rad($theta)));
 return "$x*mm $y*mm";
}


# FST is a Tube containing all SLs

my $fst_ir = 17.0;
my $fst_or = 300.0;        #just a size of fst tube, not the detector itself. sort of a random number, big enough to fit modules and support
my $fst_dz = ($starting_point[2] - $starting_point[0])/2.0 + 100.0;


my $fst_starting = $starting_point[1] + $silicon_width + $epoxy_width + $kapton_width + $epoxy_small_width + $carbon_fiber_width + $rohacell_width / 2.0 + 5*$microgap_width;
make_fst();

sub make_fst
{
 my $zpos      = $fst_starting;

 $detector{"name"}        = $envelope;
 $detector{"mother"}      = "root";
 $detector{"description"} = "Forward Silicon Vertex Tracker";
 $detector{"pos"}         = "0*mm 0*mm $zpos*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "aaaaff";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$fst_ir*mm $fst_or*mm $fst_dz*mm 0*deg 360*deg";
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


#Support\cooling system is made of copper+plastic. 3 rings: between region 2 and 1, 1 and 0 and after 0 towards the target. First 2 rings are 18mm wide, the last one is 24 mm wide. Each ring contains 3 "regions": Plastic - copper - plastic. For convinience each region is a solid ring for now. First plastic ring inner radius is 222mm, outer radius is 226mm. Copper ring innner radius is 226mm, outer - 235mm. Second plastic ring inner radius is 235mm, outer - 238mm. Rohacell under electronics in each FST module is replaced with copper. It sticks out 11mm above the heigth of electronic. 

# Make the rings.Similar to FST regons.

# General description of the bottom plastic ring between region 3 and 2.

my $plastic_bottom_support_ir = 222.0;
my $plastic_bottom_support_or = 226.0;
my $plastic_bottom_support_width = 7.0;                # bottom plastic support ring width
my $fst_middle = $starting_point[1] + $rohacell_width / 2.0 - 1.0;

# Define the z position for the bottom three supports
my @zbpos;
$zbpos[0] = - $fst_middle - ($starting_point[1] - $starting_point[0])/2.0 + $starting_point[0];
$zbpos[1] = - $fst_middle + ($starting_point[1] - $starting_point[0])/2.0 + $starting_point[0];
$zbpos[2] = - $fst_middle + ($starting_point[2] - $starting_point[1])/2.0 + $starting_point[1]; 

# Make the bottom plastic support
make_plastic_support_bottom(1,$zbpos[0]);
make_plastic_support_bottom(2,$zbpos[1]);
make_plastic_support_bottom(3,$zbpos[2]);

# Define the z position for the top three supports
my @ztpos;
$ztpos[0] = - $fst_middle - ($starting_point[1] - $starting_point[0])/2.0 + $starting_point[0];
$ztpos[1] = - $fst_middle + ($starting_point[1] - $starting_point[0])/2.0 + $starting_point[0];
$ztpos[2] = - $fst_middle + ($starting_point[2] - $starting_point[1])/2.0 + $starting_point[1];

my $plastic_top_support_ir = 235.00;
my $plastic_top_support_or = 238.0;
my $plastic_top_support_width = 7.0;                # bottom plastic support ring width 



# Make the top plastic support
make_plastic_support_top(1,$ztpos[0]);
make_plastic_support_top(2,$ztpos[1]);
make_plastic_support_top(3,$ztpos[2]);

# Subroutine to build bottom support
sub make_plastic_support_bottom
{
 my ($id,$zposition) = @_;
 $detector{"name"}        = "plastic_bottom_support_$id";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Bottom Plastic Support ring $id";
 $detector{"pos"}         = "0*mm 0*mm $zposition*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "111111";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$plastic_bottom_support_ir*mm $plastic_bottom_support_or*mm $plastic_bottom_support_width*mm 0*deg 360*deg";
 $detector{"material"}    = $plastic_material;
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

#Subroutine to build top support

sub make_plastic_support_top
{
 my ($id,$zposition) = @_;
 $detector{"name"}        = "plastic_top_support_$id";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Top Plastic Support ring $id";
 $detector{"pos"}         = "0*mm 0*mm $zposition*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffff11";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$plastic_top_support_ir*mm $plastic_top_support_or*mm $plastic_top_support_width*mm 0*deg 360*deg";
 $detector{"material"}    = $plastic_material;
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


#Copper replacement of rohacell under a PC Board


sub place_copper_insert
{
 my $l          = shift;
 my $layer_no   = $l + 1;
 my $z          =   - $fst_starting + $starting_point[$l] + $silicon_width + $epoxy_width + $kapton_width + $epoxy_small_width + $carbon_fiber_width + $rohacell_width / 2.0 + 5*$microgap_width;;

 for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $r       = $radius[$l] + $silicon_z + $wirebond_heigth/2.0 + $pcboard_height / 2.0 + $microgap_width;
    my $tpos    = pos_t($r, $l, $s);
    my $Dx      = $pcboard_length / 2.0; #copper insert has the same dimensions 
    my $Dy      = $rohacell_width  / 2.0;
    my $Dz      = $pcboard_height / 2.0 ;

    $detector{"name"}        = "Copper_insert$layer_no\_Segment$snumber";
    $detector{"mother"}      = $envelope;
    $detector{"description"} = "Copper Insert Segment $snumber";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = rot($r, $l, $s);
    $detector{"color"}       =  $copper_color;
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$Dx*mm $Dy*mm $Dz*mm";
    $detector{"material"}    =  $copper_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
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

sub place_copper_tab
{
 my $l          = shift;
 my $layer_no   = $l + 1;
 my $z          =   - $fst_starting + $starting_point[$l] + $silicon_width + $epoxy_width + $kapton_width + $epoxy_small_width + $carbon_fiber_width + $rohacell_width / 2.0 + 5*$microgap_width;;

 for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $r       = $radius[$l] + $silicon_z + $wirebond_heigth / 2.0 + $pcboard_height + $copper_tab_heigth/2.0  + 2*$microgap_width;
    my $tpos    = pos_t($r, $l, $s);
    my $Dx      = $copper_tab_length/2.0;
    my $Dy      = $rohacell_width /2.0; #copper insert has the same width 
    my $Dz      = $copper_tab_heigth/2.0 ;

    $detector{"name"}        = "Copper_tab$layer_no\_Segment$snumber";
    $detector{"mother"}      = $envelope;
    $detector{"description"} = "Copper tab Segment $snumber";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = rot($r, $l, $s);
    $detector{"color"}       =  $copper_color;
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$Dx*mm $Dy*mm $Dz*mm";
    $detector{"material"}    =  $copper_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
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

#General description of copper cooling box
my $copper_cooling_box_ir = 226.5;
my $copper_cooling_box_or = 235.0;
my $copper_cooling_box_width = 7.0;                #Copper cooling box half width

my @zpos_cu;
 $zpos_cu[0] = - $fst_middle + ($starting_point[1] - $starting_point[0])/2.0 + $starting_point[0];
 $zpos_cu[1] = - $fst_middle + ($starting_point[1] - $starting_point[0])/2.0 + $starting_point[0];
 $zpos_cu[2] = - $fst_middle + ($starting_point[2] - $starting_point[1])/2.0 + $starting_point[1];

sub place_copper_cooling_box
{
 my ($l,$zpos_cu)          = @_;
 my $layer_no   = $l + 1;
 my $vname      = 0;
 for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $r       =  $plastic_bottom_support_or + ($copper_cooling_box_or - $copper_cooling_box_ir)/2 + $microgap_width;
    my $tpos    = pos_t($r, $l, $s);

 $detector{"name"}        = "$vname$layer_no\_Copper_cooling_box$snumber";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Copper Cooling Box Segment $snumber";
 $detector{"pos"}         = "0*mm 0*mm $zpos_cu*mm";
 $detector{"rotation"}    = rot_CU($r, $l, $s);
 $detector{"color"}       = "aa8888";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$copper_cooling_box_ir*mm $copper_cooling_box_or*mm $copper_cooling_box_width*mm 0*deg 21.0*deg";
 $detector{"material"}    = $copper_material;
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = $s + 1;
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

# Hole in copper cooling box

my @zpos_hole;

sub place_copper_hole
{
 my ($l,$zpos_hole)          = @_;
 my $layer_no   = $l + 1;
 my $vname      = 0;
 for(my $s = 0; $s < $nsegments ; $s++)

{
    
    my $snumber = cnumber($s, 10);
    my $r       =  $plastic_bottom_support_or + ($copper_cooling_box_or - $copper_cooling_box_ir)/2 + $microgap_width;
    my $tpos    = pos_t($r, $l, $s);

    $detector{"name"}        = "$vname$layer_no\_Copper_hole$snumber";
    $detector{"mother"}      = "$vname$layer_no\_Copper_cooling_box$snumber";
    $detector{"description"} = "Copper Hole Segment $snumber";
    $detector{"pos"}         = "0*mm 0*mm 0*mm";
    $detector{"rotation"}    = rot_hole($r, $l, $s);
    $detector{"color"}       = "aaaaaa";
    $detector{"type"}        = "Tube";
    $detector{"dimensions"}  = "$copper_cooling_box_ir*mm $copper_cooling_box_or*mm $copper_hole_width*mm 0*deg 11.0*deg";
    $detector{"material"}    = "Air";
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
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

for(my $l = 0; $l < 3; $l++) 
{
 my $layer_no       = $l + 1;

 place_chip($l, 1, 1);
 place_chip($l, 1, 2);
 place_chip($l, 1, 3);
 place_chip($l, 1, 4);
 place_wirebond($l, 1, 1);
 place_wirebond($l, 1, 2);
 place_pcboard($l, 1);
 place_silicon($l, 1);
 place_epoxy($l, 1);        #between upper Silicon1 and upper Kapton1
 place_kapton($l, 1);
 place_epoxy($l, 3);        #between upper Kapton1 and upper Carbon fiber1  SMALL
 place_carbon_fiber($l, 1);
 place_rohacell($l);
 place_copper_insert($l);   #copper insert under pcboard
 place_copper_tab($l);      #copper tab for cooling
 place_copper_cooling_box($l,$ztpos[$l]);    #copper box for coolig
 place_copper_hole($l,$ztpos[$l]);      
 place_carbon_fiber($l, 2);
 place_epoxy($l, 4);        #between lower Carbon fiber2 and lower Kapton2   SMALL
 place_kapton($l,2);
 place_epoxy($l, 2);        #between lower Kapton2 and lower Silicon2
 place_silicon($l, 2);
 place_pcboard($l, 2);
 place_wirebond($l, 2, 1);
 place_wirebond($l, 2, 2);
 place_chip($l, 2, 1);
 place_chip($l, 2, 2);
 place_chip($l, 2, 3);
 place_chip($l, 2, 4);

}

sub place_silicon
{
 my $l          = shift;
 my $type       = shift;
 my $layer_no   = $l + 1;
 my $z          = 0;
 my $vname      = 0;
 my $descriptio = 0;

 if($type == 1)      
 {
    $z          = - $fst_starting + $starting_point[$l] + $silicon_width/2.0; 
    $vname      = "FST_SiV_Layer";
    $descriptio = "Forward SVT, Silicon V, Layer $layer_no, ";
 }

 if($type == 2)     
 {
    $z          = - $fst_starting + $starting_point[$l] + 1.5*$silicon_width + 2*$epoxy_width + 2*$kapton_width + 2*$epoxy_small_width + 2*$carbon_fiber_width + $rohacell_width  + 10*$microgap_width; 
    $vname      = "FST_SiW_Layer";
    $descriptio = "Forward SVT, Silicon W, Layer $layer_no, ";
 }

 for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $r       = $radius[$l] + $silicon_z/2.0;
    my $tpos    = pos_t($r, $l, $s);
    my $Dx1     = $silicon_x1 / 2;
    my $Dx2     = $silicon_x2 / 2;
    my $Dy      = $silicon_width / 2;
    my $Dz      = $silicon_z / 2;

    $detector{"name"}        = "$vname$layer_no\_Segment$snumber";
    $detector{"mother"}      = $envelope;
    $detector{"description"} = "$descriptio  Segment $snumber";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = rot($r, $l, $s);
    $detector{"color"}       = $silicon_color;
    $detector{"type"}        = "Trd";
    $detector{"dimensions"}  = "$Dx1*mm $Dx2*mm $Dy*mm $Dy*mm $Dz*mm";
    $detector{"material"}    =  $silicon_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "FST";
    $detector{"hit_type"}    = "FST";
    $detector{"identifiers"} ="superlayer manual $layer_no type manual $type segment manual $detector{'ncopy'} strip manual 1";

    print_det(\%detector, $file);

 }
}

sub place_epoxy     
{ 
 my $l          = shift;
 my $type       = shift;
 my $layer_no   = $l + 1;
 my $z          = 0;
 my $vname      = 0;
 my $descriptio = 0;

 if($type == 1)     #between upper Silicon1 and upper Kapton1
 {
    $z          = - $fst_starting + $starting_point[$l] + $silicon_width + $epoxy_width / 2.0 + $microgap_width;
    $vname      = "FST_Epoxy_V1_Layer";
    $descriptio = "Epoxy V1, Layer $layer_no, ";
 }

 if($type == 3)     #between upper Kapton1 and upper Carbon fiber1    SMALL
 {
    $z          = - $fst_starting + $starting_point[$l] + $silicon_width + $epoxy_width + $kapton_width + $epoxy_small_width/2.0 + 3*$microgap_width;
    $vname      = "FST_Epoxy_V2_Layer";
    $descriptio = "Epoxy V2, Layer $layer_no, ";
 }

 if($type == 2)     #between lower Kapton2 and lower Silicon2
 { 
    $z          =  - $fst_starting + $starting_point[$l] + $silicon_width + 1.5*$epoxy_width + 2*$kapton_width + 2*$epoxy_small_width +  2.0*$carbon_fiber_width + $rohacell_width  + 9*$microgap_width;
    $vname      = "FST_Epoxy_W1_Layer";
    $descriptio = "Epoxy W1, Layer $layer_no, ";
 }

 if($type == 4)     #between lower Carbon fiber2 and lower Kapton2    SMALL
 {
    $z          =  - $fst_starting + $starting_point[$l] + $silicon_width + $epoxy_width + $kapton_width + 1.5*$epoxy_small_width + 2.0*$carbon_fiber_width + $rohacell_width  + 7*$microgap_width;
    $vname      = "FST_Epoxy_W2_Layer";
    $descriptio = "Epoxy W2, Layer $layer_no, ";
 }

 for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $r       = $radius[$l] + $rohacell_z/2.0;
    my $tpos    = pos_t($r, $l, $s);
    my $Dx1     = $rohacell_x1 / 2;
    my $Dx2     = $rohacell_x2 / 2;
    my $Dy = 0.; # Initialize
if (( $type == 1)||($type == 2)) {
    $Dy      = $epoxy_width / 2;
} else {
    $Dy        = $epoxy_small_width / 2;
}
#    print "Epoxy width used/2: $Dy\tType: $type\n";
    my $Dz      = $rohacell_z / 2;
#    print "Epoxy:\tdx1= $Dx1\tdx2=$Dx2\tdy=$Dy\tdz=$Dz\n";
    $detector{"name"}        = "$vname$layer_no\_Segment$snumber";
    $detector{"mother"}      =  $envelope;
    $detector{"description"} = "$descriptio Segment $snumber";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = rot($r, $l, $s);
    $detector{"color"}       = $epoxy_color;
    $detector{"type"}        = "Trd";
    $detector{"dimensions"}  = "$Dx1*mm $Dx2*mm $Dy*mm $Dy*mm $Dz*mm";
    $detector{"material"}    = $epoxy_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
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


sub place_kapton    #Place of the kapton
{
 my $l          = shift;
 my $type       = shift;
 my $layer_no   = $l + 1;
 my $z          = 0;
 my $vname      = 0;
 my $descriptio = 0;
 
if($type == 1)     #between upper epoxies
 {
    $z          = - $fst_starting + $starting_point[$l] + $silicon_width + $epoxy_width + $kapton_width/2 + 2*$microgap_width;
    $vname      = "FST_Kapton_V_Layer";
    $descriptio = "Kapton V, Layer $layer_no, ";
}

if($type == 2)     #between lower epoxies
 {
    $z          = - $fst_starting + $starting_point[$l] + $silicon_width + $epoxy_width + 1.5*$kapton_width + 2*$epoxy_small_width + $rohacell_width + 2*$carbon_fiber_width + 8*$microgap_width;
    $vname      = "FST_Kapton_W_Layer";
    $descriptio = "Kapton W, Layer $layer_no, ";
}

for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $r       = $radius[$l] + $rohacell_z/2.0;
    my $tpos    = pos_t($r, $l, $s);
    my $Dx1     = $rohacell_x1 / 2;
    my $Dx2     = $rohacell_x2 / 2;
    my $Dy      = $kapton_width / 2;
    my $Dz      = $rohacell_z / 2;

    #print "Kapton:\tdx1= $Dx1\tdx2=$Dx2\tdy=$Dy\tdz=$Dz\n";
    $detector{"name"}        = "$vname$layer_no\_Segment$snumber";
    $detector{"mother"}      =  $envelope;
    $detector{"description"} = "$descriptio Segment $snumber";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = rot($r, $l, $s);
    $detector{"color"}       = $kapton_color;
    $detector{"type"}        = "Trd";
    $detector{"dimensions"}  = "$Dx1*mm $Dx2*mm $Dy*mm $Dy*mm $Dz*mm";
    $detector{"material"}    = $kapton_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
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

sub place_carbon_fiber
{
 my $l          = shift;
 my $type       = shift;
 my $layer_no   = $l + 1;
 my $z          = 0;
 my $vname      = 0;
 my $descriptio = 0;

 if($type == 1)
 {
    $z           =  - $fst_starting + $starting_point[$l] + $silicon_width + $epoxy_width + $kapton_width + $epoxy_small_width + $carbon_fiber_width / 2.0 + 4.0*$microgap_width;
    $vname       = "FST_CarbonFiber_V_L";
    $descriptio  = "Epoxy V, Layer $layer_no, ";
 }

 if($type == 2)
 {
    $z           =  - $fst_starting + $starting_point[$l] + $silicon_width + $epoxy_width + $kapton_width + $epoxy_small_width + 1.5*$carbon_fiber_width + $rohacell_width  + 6.0*$microgap_width;
    $vname       = "FST_CarbonFiber_W_L";
    $descriptio  = "Epoxy W, Layer $layer_no, ";
 }

 for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $r       = $radius[$l] + $rohacell_z/2.0;
    my $tpos    = pos_t($r, $l, $s);
    my $Dx1     = $rohacell_x1 / 2;
    my $Dx2     = $rohacell_x2 / 2;
    my $Dy      = $carbon_fiber_width / 2;
    my $Dz      = $rohacell_z / 2;

    $detector{"name"}        = "$vname$layer_no\_Segment$snumber";
    $detector{"mother"}      = $envelope;
    $detector{"description"} = "$descriptio Segment $snumber";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = rot($r, $l, $s);
    $detector{"color"}       = $carbon_fiber_color;
    $detector{"type"}        = "Trd";
    $detector{"dimensions"}  = "$Dx1*mm $Dx2*mm $Dy*mm $Dy*mm $Dz*mm";
    $detector{"material"}    = $carbon_fiber_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
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

sub place_pcboard
{
 my $l          = shift;
 my $type       = shift;
 my $layer_no   = $l + 1;
 my $z          = 0;
 my $vname      = 0;
 my $descriptio = 0;

 if($type == 1)
 {
    $z           =   - $fst_starting + $starting_point[$l] - $pcboard_width / 2.0 - $microgap_width ;
    $vname       = "FST_PCBoard_V_L";
    $descriptio  = "PC Board V, Layer $layer_no, ";
 }

 if($type == 2)
 {
    $z           =   - $fst_starting + $starting_point[$l] + 2*$silicon_width + 2*$epoxy_width + 2*$kapton_width + 2*$epoxy_small_width +  2*$carbon_fiber_width + $rohacell_width  + $pcboard_width / 2.0 + 11.0*$microgap_width ; 
    $vname       = "FST_PCBoard_W_L";
    $descriptio  = "PC Board W, Layer $layer_no, ";
 }


 for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $r       = $radius[$l] + $silicon_z + $wirebond_heigth/2.0 + $pcboard_height / 2.0 + $microgap_width;
    my $tpos    = pos_t($r, $l, $s);
    my $Dx      = $pcboard_length / 2.0;
    my $Dy      = $pcboard_width  / 2.0;
    my $Dz      = $pcboard_height / 2.0 ;

    $detector{"name"}        = "$vname$layer_no\_Segment$snumber";
    $detector{"mother"}      = $envelope;
    $detector{"description"} = "$descriptio Segment $snumber";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = rot($r, $l, $s);
    $detector{"color"}       =  $pcboard_color;
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$Dx*mm $Dy*mm $Dz*mm";
    $detector{"material"}    =  $pcboard_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
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

sub place_rohacell
{
 my $l        = shift;
 my $layer_no = $l + 1;

 my $z =  - $fst_starting + $starting_point[$l] + $silicon_width + $epoxy_width + $kapton_width + $epoxy_small_width + $carbon_fiber_width + $rohacell_width / 2.0 + 5*$microgap_width;

 for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $r       = $radius[$l] + $rohacell_z/2.0;
    my $tpos    = pos_t($r, $l, $s);
    my $Dx1     = $rohacell_x1 / 2;
    my $Dx2     = $rohacell_x2 / 2;
    my $Dy      = $rohacell_width / 2;
    my $Dz      = $rohacell_z / 2;

   # print "Gondor:\tdx1= $Dx1\tdx2=$Dx2\tdy=$Dy\tdz=$Dz\n";

    $detector{"name"}        = "FST_Rohacell_L$layer_no\_Segment$snumber";
    $detector{"mother"}      = $envelope;
    $detector{"description"} = "Rohacell support, Layer $layer_no, Segment $snumber";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = rot($r, $l, $s);
    $detector{"color"}       = $rohacell_color;
    $detector{"type"}        = "Trd";
    $detector{"dimensions"}  = "$Dx1*mm $Dx2*mm $Dy*mm $Dy*mm $Dz*mm";
    $detector{"material"}    =  $rohacell_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
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


sub place_wirebond
{
 my $l          = shift;
 my $type       = shift;
 my $which      = shift;
 my $layer_no   = $l + 1;
 my $r          = 0;
 my $Dx         = 0;
 my $z          = 0;
 my $vname      = 0;
 my $descriptio = 0;

 if($type == 1)
 {
    $z          =   - $fst_starting + $starting_point[$l] - $pcboard_width  - $wirebond_width / 2.0 - $microgap_width ;
    $vname      = "FST_Wirebond_V_Layer";
    $descriptio = "Forward SVT, Wirebond V, Layer $layer_no, ";
 }

 if($type == 2)
 {
    $z          =  - $fst_starting + $starting_point[$l] + 2*$silicon_width +2*$epoxy_width + 2*$kapton_width + 2*$epoxy_small_width +  2*$carbon_fiber_width + $rohacell_width  + $pcboard_width + $wirebond_width / 2.0 + 11.0*$microgap_width ;  
    $vname      = "FST_Wirebond_W_Layer";
    $descriptio = "Forward SVT, Wirebond W, Layer $layer_no, ";
 }

 if($which == 1)
 {
    $r          = $radius[$l] + $wirebond1_r ;
    $Dx         = $wirebond1_length / 2.0;
 }

 if($which == 2)
 {
    $r          = $radius[$l] + $wirebond2_r ;
    $Dx         = $wirebond2_length / 2.0;
 }


 for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $Dy      = $wirebond_width  / 2.0;
    my $Dz      = $wirebond_heigth / 2.0;
    my $tpos    = pos_t($r, $l, $s);

    $detector{"name"}        = "$vname$layer_no\_Module$which\_Segment$snumber";
    $detector{"mother"}      =  $envelope;
    $detector{"description"} = "$descriptio Module $which Segment $snumber";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = rot($r, $l, $s);
    $detector{"color"}       = $wirebond_color;
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$Dx*mm $Dy*mm $Dz*mm";
    $detector{"material"}    = $silicon_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
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

sub place_chip
{
 my $l          = shift;
 my $type       = shift;
 my $which      = shift;
 my $layer_no   = $l + 1;
 my $z          = 0;
 my $vname      = 0;
 my $descriptio = 0;

 if($type == 1)
 {
    $z           =  - $fst_starting + $starting_point[$l] - $pcboard_width - $chip_width / 2.0 - 4.0*$microgap_width ;
    $vname       = "FST_chip_$which\_V_L";
    $descriptio  = "chip V, Layer $layer_no, ";
 }

 if($type == 2)
 {
    $z           =  - $fst_starting + $starting_point[$l] + 2*$silicon_width + 2*$epoxy_width + 2*$kapton_width + 2*$epoxy_small_width + 2*$carbon_fiber_width + $rohacell_width  + $pcboard_width + $chip_width / 2.0 + 11.0*$microgap_width ; 
    $vname       = "FST_chip_$which\_W_L";
    $descriptio  = "chip W, Layer $layer_no, ";
 }

 for(my $s = 0; $s < $nsegments ; $s++) 
 {

    my $snumber = cnumber($s, 10);
    my $Dx      = $chip_length / 2.0;
    my $Dy      = $chip_width  / 2.0;
    my $Dz      = $chip_height / 2.0 ;
    my $r       = 0;
    my $r1      = $radius[$l] + $silicon_z + $wirebond_heigth/2.0 + $chip_height / 2.0 + $microgap_width;
    if($which==1 || $which==2)
    {
       $r = sqrt($r1 * $r1 + $chip_displacement * $chip_displacement);
    }
    if($which==3 || $which==4)
    {
       $r = sqrt($r1 * $r1 + 9*$chip_displacement * $chip_displacement);
    }
    my $tpos    = pos_t_chip($r, $l, $which, $s);

    $detector{"name"}        = "$vname$layer_no\_Segment$snumber";
    $detector{"mother"}      = $envelope;
    $detector{"description"} = "$descriptio Segment $snumber";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = rot($r, $l, $s);
    $detector{"color"}       = $chip_color;
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$Dx*mm $Dy*mm $Dz*mm";
    $detector{"material"}    =  $pcboard_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
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

=for comment
sub place_support
{
 my $l          = shift;
 my $layer_no   = $l + 1;
 my $z          = $starting_point[$l] + $silicon_width + $epoxy_width + $carbon_fiber_width + $rohacell_width / 2.0 + 3*$microgap_width;
 my $vmname     = "Mother_for_Support_L";
 my $descriptio = "Mother Volume for Rohacell Central Support, Layer $layer_no, ";

 for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $Dx      = $support_side    / 2.0 ;
    my $Dy      = $rohacell_width  / 2.0 + 4*$carbon_fiber_width;
    my $Dz      = $support_side    / 2.0 ;
    my $r       = $radius[$l] - $support_side / 2.0 - $microgap_width;
    my $tpos    = pos_t($r, $l, $s);

    $detector{"name"}        = "$vmname$layer_no\_Segment$snumber";
    $detector{"mother"}      =  "root";
    $detector{"description"} = "$descriptio Segment $snumber";
    $detector{"pos"}         =  "$tpos $z*mm";
    $detector{"rotation"}    =  rot($r, $l, $s);
    $detector{"color"}       = $rohacell_color;
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$Dx*mm $Dy*mm $Dz*mm";
    $detector{"material"}    = "Air";
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = "";

    print_det(\%detector, $file);
 }

 my $vname    = "Rochell_Support_L";
 $descriptio  = "Rohacell Central Support, Layer $layer_no, ";

 for(my $s = 0; $s < $nsegments ; $s++) 
 {
    my $snumber = cnumber($s, 10);
    my $Dx      = $support_side   / 2.0;
    my $Dy      = $rohacell_width / 2.0;
    my $Dz      = $support_side   / 2.0 ;

    $detector{"name"}        = "$vname$layer_no\_Segment$snumber";
    $detector{"mother"}      = "$vmname$layer_no\_Segment$snumber";
    $detector{"description"} = "$descriptio Segment $snumber";
    $detector{"pos"}         = "0*mm 0*mm 0*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       =  $rohacell_color;
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$Dx*mm $Dy*mm $Dz*mm";
    $detector{"material"}    =  $rohacell_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = "";

    print_det(\%detector, $file);

 }


# $vname       = "Hole_Support_L";
 #$descriptio  = "Hole in Rohacell central support, Layer $layer_no, ";

 #for(my $s = 0; $s < $nsegments ; $s++) 
 #{
   # my $snumber = cnumber($s, 10);
   # my $Or      = $support_hole    ;
   # $detector{"rotation"}    =  "90*deg 0*deg 0*deg";
   # $detector{"color"}       =  "000000";
   # $detector{"type"}        = "Tube";
   # $detector{"dimensions"}  =  "0*mm $Or*mm $Dz*mm 0*deg 360*deg";
   # $detector{"exist"}       = 1;
   # $detector{"visible"}     = 1;
   # $detector{"style"}       = 1;
   # $detector{"sensitivity"} = "no";
   # $detector{"hit_type"}    = "";
   # $detector{"identifiers"} = "";

  #  print_det(\%detector, $file);
 #}

 $vname       = "CF_Support_W_L";
 $descriptio  = "Carbon Fiber W on central support, Layer $layer_no, ";

 for(my $s = 0; $s < $nsegments ; $s++)
 {
    my $snumber = cnumber($s, 10);
    my $Dx      = $support_side       / 2.0;
    my $Dy      = $carbon_fiber_width / 2.0;
    my $Dz      = $support_side       / 2.0 ;
    my $tpos    = - $rohacell_width/2 - $carbon_fiber_width/2.0 - $microgap_width;

    $detector{"name"}        = "$vname$layer_no\_Segment$snumber";
    $detector{"mother"}      = "$vmname$layer_no\_Segment$snumber";
    $detector{"description"} = "$descriptio Segment $snumber";
    $detector{"pos"}         = "0*mm $tpos*mm 0*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $carbon_fiber_color;
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "$Dx*mm $Dy*mm $Dz*mm";
    $detector{"material"}    = $carbon_fiber_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = $s + 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = "";

    print_det(\%detector, $file);
 }=cut
}









