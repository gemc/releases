#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

use geo qw($pi);

# Load files containing the values of the parameters 
my $config_file = 'FMT.config';

# Load configuration
my %configuration = load_configuration($config_file);

# Load parameters from mysql database
my %parameters    = download_parameters(%configuration);


# All dimensions in mm

my $envelope = 'FMT';
my $file     = 'FMT.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();          # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

my @starting_point =();

my $fmt_ir 		= $parameters{"FMT_mothervol_InnerRadius"};
my $fmt_or 		= $parameters{"FMT_mothervol_OutRadius"};
my $nlayer		= $parameters{"FMT_nlayer"};
$starting_point[0] 	= $parameters{"FMT_zpos_layer1"};
$starting_point[1] 	= $parameters{"FMT_zpos_layer2"};
$starting_point[2] 	= $parameters{"FMT_zpos_layer3"};
my $Det_RMin 	        = $parameters{"FMT_DetInnerRadius"};
my $Det_RMax 	        = $parameters{"FMT_DetOuterRadius"};
my $Act_RMin 	        = $parameters{"FMT_ActInnerRadius"};
my $Act_RMax 	        = $parameters{"FMT_ActOuterRadius"};
my $Epoxy_Dz 		= 0.5*$parameters{"FMT_Epoxy_Dz"}; # half width
my $PCB_Dz 		= 0.5*$parameters{"FMT_PCB_Dz"}; # half width
my $Strips_Dz 		= 0.5*$parameters{"FMT_Strips_Dz"}; # half width
my $Gas1_Dz 		= 0.5*$parameters{"FMT_Gas1_Dz"}; # half width
my $Mesh_Dz 		= 0.5*$parameters{"FMT_Mesh_Dz"}; # half width
my $Gas2_Dz 		= 0.5*$parameters{"FMT_Gas2_Dz"}; # half width
my $Drift_Dz 		= 0.5*$parameters{"FMT_Drift_Dz"}; # half width

# G4 materials
my $epoxy_material   = 'Epoxy';
my $pcboard_material = 'Epoxy';
my $strips_material  = 'MMStrips';
my $gas_material     = 'MMGas';
my $mesh_material    = 'MMMesh';
my $drift_material   = 'MMMylar';


# G4 colors
my $epoxy_color      = 'e200e1';
my $pcboard_color    = '0000ff';
my $strips_color     = '353540';
my $gas_color        = 'e10000';
my $mesh_color       = '252020';
my $drift_color      = 'fff600';

$pi = 3.141592653589793238;

# FMT is a Tube containing all SLs

my $fmt_dz = ($starting_point[2] - $starting_point[0])/2.0 + 8.0;

my $fmt_starting = $starting_point[1];
make_fmt();

sub make_fmt
{
    my $zpos      = $fmt_starting;
    
    $detector{"name"}        = $envelope;
    $detector{"mother"}      = "root";
    $detector{"description"} = "Forward Micromegas Vertex Tracker";
    
    # names
    my $name        = $envelope;
    my $mother      = "root";
    my $description = "Forward Micromegas Vertex Tracker";
    $detector{"pos"}         = "0*mm 0*mm $zpos*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = "aaaaff";
    $detector{"type"}        = "Tube";
    $detector{"dimensions"}  = "$fmt_ir*mm $fmt_or*mm $fmt_dz*mm 0*deg 360*deg";
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

for(my $l = 0; $l < $nlayer; $l++) 
{
    my $layer_no       = $l + 1;
    
    place_drift($l, 1);
    place_gas2($l, 1);
    place_mesh($l, 1);
    place_gas1($l, 1);
    place_strips($l, 1);
    place_pcboard($l, 1);
    place_epoxy($l);
    place_pcboard($l, 2);
    place_strips($l, 2);
    place_gas1($l, 2);
    place_mesh($l, 2);
    place_gas2($l, 2);
    place_drift($l, 2);
}

sub place_epoxy
{
    my $l    = shift; 
    my $layer_no       = $l + 1;
    
    my $z          = - $fmt_starting + $starting_point[$l];
    my $vname      = "FMT_Epoxy";
    my $descriptio = "Epoxy, Layer $layer_no, ";
    
    # names
    my $tpos      = "0*mm 0*mm";
    my $PRMin     = $Det_RMin;
    my $PRMax     = $Det_RMax;
    my $PDz       = $Epoxy_Dz;
	
    $detector{"name"}        = "$vname$layer_no";
    $detector{"mother"}      = $envelope;
    $detector{"description"} = "$descriptio";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $epoxy_color;
    $detector{"type"}        = "Tube";
    $detector{"dimensions"}  = "$PRMin*mm $PRMax*mm $PDz*mm 0*deg 360*deg";
    $detector{"material"}    = $epoxy_material;
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

sub place_pcboard
{
    my $l    = shift; 
    my $type = shift;
    my $layer_no       = $l + 1;
    my $z          = 0;
    my $vname      = 0;
    my $descriptio = 0;

    if($type == 1)
    {
	$z           =   - $fmt_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz;
	$vname       = "FMT_PCBoard_V_L";
	$descriptio  = "PC Board V, Layer $layer_no, ";
    }
    
    if($type == 2) 
    {
	$z           =   - $fmt_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz;
	$vname       = "FMT_PCBoard_W_L";
	$descriptio  = "PC Board W, Layer $layer_no, ";
    }
    
    # names
    my $tpos      = "0*mm 0*mm";
    my $PRMin     = $Det_RMin;
    my $PRMax     = $Det_RMax;
    my $PDz       = $PCB_Dz;
	
	$detector{"name"}        = "$vname$layer_no";
	$detector{"mother"}      =  $envelope;
	$detector{"description"} = "$descriptio";
	$detector{"pos"}         = "$tpos $z*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $pcboard_color;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$PRMin*mm $PRMax*mm $PDz*mm 0*deg 360*deg";
	$detector{"material"}    = $pcboard_material;
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

sub place_strips
{
    my $l    = shift; 
    my $type = shift;
    my $layer_no       = $l + 1;
    my $z          = 0;
    my $vname      = 0;
    my $descriptio = 0;

    if($type == 1)
    {
	$z           =   - $fmt_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz*2. - $Strips_Dz;
	$vname       = "FMT_Strips_V_L";
	$descriptio  = "Strips V, Layer $layer_no, ";
    }
    
    if($type == 2) 
    {
	$z           =   - $fmt_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz*2. + $Strips_Dz;
	$vname       = "FMT_Strips_W_L";
	$descriptio  = "Strips W, Layer $layer_no, ";
    }
    
	# names
	my $tpos       = "0*mm 0*mm";
	my $PRMin     = $Act_RMin;
	my $PRMax     = $Act_RMax;
	my $PDz       = $Strips_Dz;
	
	$detector{"name"}        = "$vname$layer_no";
	$detector{"mother"}      =  $envelope;
	$detector{"description"} = "$descriptio";
	$detector{"pos"}         = "$tpos $z*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $strips_color;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$PRMin*mm $PRMax*mm $PDz*mm 0*deg 360*deg";
	$detector{"material"}    = $strips_material;
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

sub place_gas1
{
    my $l    = shift; 
    my $type = shift;
    my $layer_no       = $l + 1;
    my $z          = 0;
    my $vname      = 0;
    my $descriptio = 0;
    
    if($type == 1)
    {
	$z           =   - $fmt_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz*2. - $Strips_Dz*2. - $Gas1_Dz;
	$vname       = "FMT_Gas1_V_L";
	$descriptio  = "Gas1 V, Layer $layer_no, ";
    }
    
    if($type == 2) 
    {
	$z           =   - $fmt_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz*2. + $Strips_Dz*2. + $Gas1_Dz;
	$vname       = "FMT_Gas1_W_L";
	$descriptio  = "Gas1 W, Layer $layer_no, ";
    }
    
    # names
	my $tpos       = "0*mm 0*mm";
	my $PRMin     = $Act_RMin;
	my $PRMax     = $Act_RMax;
	my $PDz       = $Gas1_Dz;
	
	$detector{"name"}        = "$vname$layer_no";
	$detector{"mother"}      =  $envelope;
	$detector{"description"} = "$descriptio";
	$detector{"pos"}         = "$tpos $z*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $gas_color;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$PRMin*mm $PRMax*mm $PDz*mm 0*deg 360*deg";
	$detector{"material"}    = $gas_material;
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

sub place_mesh
{
    my $l    = shift; 
    my $type = shift;
    my $layer_no       = $l + 1;
    my $z          = 0;
    my $vname      = 0;
    my $descriptio = 0;
    
    if($type == 1)
    {
	$z           =   - $fmt_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz*2. - $Strips_Dz*2. - $Gas1_Dz*2. - $Mesh_Dz;
	$vname       = "FMT_Mesh_V_L";
	$descriptio  = "Mesh V, Layer $layer_no, ";
    }
    
    if($type == 2) 
    {
	$z           =   - $fmt_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz*2. + $Strips_Dz*2. + $Gas1_Dz*2. + $Mesh_Dz;
	$vname       = "FMT_Mesh_W_L";
	$descriptio  = "Mesh W, Layer $layer_no, ";
    }
    
    # names
    my $tpos       = "0*mm 0*mm";
    my $PRMin     = $Act_RMin;
    my $PRMax     = $Act_RMax;
    my $PDz       = $Mesh_Dz;
    
    $detector{"name"}        = "$vname$layer_no";
    $detector{"mother"}      =  $envelope;
    $detector{"description"} = "$descriptio";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $mesh_color;
    $detector{"type"}        = "Tube";
    $detector{"dimensions"}  = "$PRMin*mm $PRMax*mm $PDz*mm 0*deg 360*deg";
    $detector{"material"}    = $mesh_material;
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

sub place_gas2
{
    my $l    = shift; 
    my $type = shift;
    my $layer_no       = $l + 1;
    my $z          = 0;
    my $vname      = 0;
    my $descriptio = 0;
    
    if($type == 1)
    {
	$z           =   - $fmt_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz*2. - $Strips_Dz*2. - $Gas1_Dz*2. - $Mesh_Dz*2. - $Gas2_Dz;
	$vname       = "FMT_Gas2_V_L";
	$descriptio  = "Gas2 V, Layer $layer_no, ";
    }
    
    if($type == 2) 
    {
	$z           =   - $fmt_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz*2. + $Strips_Dz*2. + $Gas1_Dz*2. + $Mesh_Dz*2. + $Gas2_Dz;
	$vname       = "FMT_Gas2_W_L";
	$descriptio  = "Gas2 W, Layer $layer_no, ";
    }
    
    # names
    my $tpos       = "0*mm 0*mm";
    my $PRMin     = $Act_RMin;
    my $PRMax     = $Act_RMax;
    my $PDz       = $Gas2_Dz;
    
    $detector{"name"}        = "$vname$layer_no";
    $detector{"mother"}      = $envelope;
    $detector{"description"} = "$descriptio";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $gas_color;
    $detector{"type"}        = "Tube";
    $detector{"dimensions"}  = "$PRMin*mm $PRMax*mm $PDz*mm 0*deg 360*deg";
    $detector{"material"}    =  $gas_material;
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "FMT";
    $detector{"hit_type"}    = "FMT";
    $detector{"identifiers"} ="superlayer manual $layer_no type manual $type segment manual $detector{'ncopy'} strip manual 1";
    
    print_det(\%detector, $file);
}

sub place_drift
{
    my $l    = shift; 
    my $type = shift;
    my $layer_no       = $l + 1;
    my $z          = 0;
    my $vname      = 0;
    my $descriptio = 0;
    
    if($type == 1)
    {
	$z           =   - $fmt_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz*2. - $Strips_Dz*2. - $Gas1_Dz*2. - $Mesh_Dz*2. - $Gas2_Dz*2. - $Drift_Dz;
	$vname       = "FMT_Drift_V_L";
	$descriptio  = "Drift V, Layer $layer_no, ";
    }
    
    if($type == 2) 
    {
	$z           =   - $fmt_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz*2. + $Strips_Dz*2. + $Gas1_Dz*2. + $Mesh_Dz*2. + $Gas2_Dz*2. + $Drift_Dz;
	$vname       = "FMT_Drift_W_L";
	$descriptio  = "Drift W, Layer $layer_no, ";
    }
    
    # names
    my $tpos       = "0*mm 0*mm";
    my $PRMin     = $Act_RMin;
    my $PRMax     = $Act_RMax;
    my $PDz       = $Drift_Dz;
    
    $detector{"name"}        = "$vname$layer_no";
    $detector{"mother"}      =  $envelope;
    $detector{"description"} = "$descriptio";
    $detector{"pos"}         = "$tpos $z*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $drift_color;
    $detector{"type"}        = "Tube";
    $detector{"dimensions"}  = "$PRMin*mm $PRMax*mm $PDz*mm 0*deg 360*deg";
    $detector{"material"}    = $drift_material;
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
