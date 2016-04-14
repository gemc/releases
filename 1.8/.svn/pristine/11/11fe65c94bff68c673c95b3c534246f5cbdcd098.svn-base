#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

use geo qw($pi);

# Load files containing the values of the parameters 
my $config_file = 'FTM.config';

# Load configuration
my %configuration = load_configuration($config_file);

# Load parameters from mysql database
my %parameters    = download_parameters(%configuration);


# All dimensions in mm

my $envelope = 'FTM';
my $file     = 'FTM.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();          # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

my @starting_point =();

my $ftm_ir 		= $parameters{"FTT_M_mothervol_InnerRadius"};
my $ftm_or 		= $parameters{"FTT_M_mothervol_OutRadius"};
my $nlayer		= $parameters{"FTT_M_nlayer"};
$starting_point[0] 	= $parameters{"FTT_M_zpos_layer1"};
$starting_point[1] 	= $parameters{"FTT_M_zpos_layer2"};
my $InnerRadius 	= $parameters{"FTT_M_InnerRadius"};
my $OuterRadius 	= $parameters{"FTT_M_OuterRadius"};
my $Epoxy_Dz 		= 0.5*$parameters{"FTT_M_Epoxy_Dz"};
my $PCB_Dz 		= 0.5*$parameters{"FTT_M_PCB_Dz"};
my $Strips_Dz 		= 0.5*$parameters{"FTT_M_Strips_Dz"};
my $Gas1_Dz 		= 0.5*$parameters{"FTT_M_Gas1_Dz"};
my $Mesh_Dz 		= 0.5*$parameters{"FTT_M_Mesh_Dz"};
my $Gas2_Dz 		= 0.5*$parameters{"FTT_M_Gas2_Dz"};
my $Drift_Dz 		= 0.5*$parameters{"FTT_M_Drift_Dz"};


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


# FTM is a Tube containing all SLs
my $ftm_dz = ($starting_point[1] - $starting_point[0])/2.0 + $Epoxy_Dz*2.0 + $PCB_Dz*4.0 + $Strips_Dz*4.0 + $Gas1_Dz*4.0 + $Mesh_Dz*4.0 + $Gas2_Dz*4.0 + $Drift_Dz*4.0+1.0;

my $ftm_starting = ($starting_point[1] + $starting_point[0])/2.0;
make_ftm();

sub make_ftm
{
    my $zpos      = $ftm_starting;
    
    $detector{"name"}        = $envelope;
    $detector{"mother"}      = "root";
    $detector{"description"} = "Forward Tagger Micromegas";
    
    # names
    my $name        = $envelope;
    my $mother      = "root";
    my $description = "Forward Tagger Micromegas";
    $detector{"pos"}         = "0*mm 0*mm $zpos*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = "aaaaff";
    $detector{"type"}        = "Tube";
    $detector{"dimensions"}  = "$ftm_ir*mm $ftm_or*mm $ftm_dz*mm 0*deg 360*deg";
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
   
       place_epoxy($l);

# X layer type
       place_pcboard($l,1);
       place_strips($l,1);
       place_gas1($l,1);
       place_mesh($l,1);
       place_gas2($l,1);
       place_drift($l,1);

# Y layer type
       place_pcboard($l,2);
       place_strips($l,2);
       place_gas1($l,2);
       place_mesh($l,2);
       place_gas2($l,2);
       place_drift($l,2);
    
}


sub place_epoxy
{
    my $l    = shift;
    my $layer_no       = $l + 1;
    
    my $z          = - $ftm_starting + $starting_point[$l];
    my $vname      = "FTM_Epoxy";
    my $descriptio = "Epoxy, Layer $layer_no";
    
	# names
	my $r         = 0.000;
	my $PDz       = $Epoxy_Dz;
	my $PSPhi     = 0.0;
	my $PDPhi     = 360.000;
	
	$detector{"name"}        = "$vname$layer_no";
	$detector{"mother"}      = $envelope;
	$detector{"description"} = "$descriptio";
	$detector{"pos"}         = "0.000*mm 0.000*mm $z*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $epoxy_color;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$InnerRadius*mm $OuterRadius*mm $PDz*mm $PSPhi*deg $PDPhi*deg";
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
    my $layer_no   = $l + 1;
    my $z          = 0;
    my $vname      = 0;
    my $descriptio = 0;
    my $PSPhi     = 0.0;

    if($type == 1)
    {
	$z           =   - $ftm_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz;
	$vname       = "FTM_PCBoard_X_L";
	$descriptio  = "PC Board X, Layer $layer_no";
    }
    
    if($type == 2) 
    {
	$z           =   - $ftm_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz;
	$vname       = "FTM_PCBoard_Y_L";
	$descriptio  = "PC Board Y, Layer $layer_no";
    }
    
	# names
	my $r         = 0.000;
	my $PDz       = $PCB_Dz;
	my $PDPhi     = 360.000;
	
	$detector{"name"}        = "$vname$layer_no";
	$detector{"mother"}      =  $envelope;
	$detector{"description"} = "$descriptio";
	$detector{"pos"}         = "0.000*mm 0.000*mm $z*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $pcboard_color;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$InnerRadius*mm $OuterRadius*mm $PDz*mm $PSPhi*deg $PDPhi*deg";
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
    my $PSPhi     = 0.0;

    if($type == 1)
    {
	$z           =   - $ftm_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz*2. - $Strips_Dz;
	$vname       = "FTM_Strips_X_L";
	$descriptio  = "Strips X, Layer $layer_no";
    }
    
    if($type == 2) 
    {
	$z           =   - $ftm_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz*2. + $Strips_Dz;
	$vname       = "FTM_Strips_Y_L";
	$descriptio  = "Strips Y, Layer $layer_no";
    }
    
	# names
	my $r         = 0.000;
	my $PDz       = $Strips_Dz;
	my $PDPhi     = 360.000;
	
	$detector{"name"}        = "$vname$layer_no";
	$detector{"mother"}      =  $envelope;
	$detector{"description"} = "$descriptio";
	$detector{"pos"}         = "0.000*mm 0.000*mm $z*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $strips_color;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$InnerRadius*mm $OuterRadius*mm $PDz*mm $PSPhi*deg $PDPhi*deg";
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
    my $PSPhi     = 0.0;
    
    if($type == 1)
    {
	$z           =   - $ftm_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz*2. - $Strips_Dz*2. - $Gas1_Dz;
	$vname       = "FTM_Gas1_X_L";
	$descriptio  = "Gas1 X, Layer $layer_no";
    }
    
    if($type == 2) 
    {
	$z           =   - $ftm_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz*2. + $Strips_Dz*2. + $Gas1_Dz;
	$vname       = "FTM_Gas1_Y_L";
	$descriptio  = "Gas1 Y, Layer $layer_no";
    }
    
	# names
	my $r         = 0.000;
	my $PDz       = $Gas1_Dz;
	my $PDPhi     = 360.000;
	
	$detector{"name"}        = "$vname$layer_no";
	$detector{"mother"}      =  $envelope;
	$detector{"description"} = "$descriptio";
	$detector{"pos"}         = "0.000*mm 0.000*mm $z*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $gas_color;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$InnerRadius*mm $OuterRadius*mm $PDz*mm $PSPhi*deg $PDPhi*deg";
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
    my $PSPhi     = 0.0;
  
    if($type == 1)
    {  
	$z           =   - $ftm_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz*2. - $Strips_Dz*2. - $Gas1_Dz*2. - $Mesh_Dz;
	$vname       = "FTM_Mesh_X_L";
	$descriptio  = "Mesh X, Layer $layer_no";
    }  

    if($type == 2)
    {  
	$z           =   - $ftm_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz*2. + $Strips_Dz*2. + $Gas1_Dz*2. + $Mesh_Dz;
	$vname       = "FTM_Mesh_Y_L";
	$descriptio  = "Mesh Y, Layer $layer_no";
    }
	# names
	my $r         = 0.000;
	my $PDz       = $Mesh_Dz;
	my $PDPhi     = 360.000;
	
	$detector{"name"}        = "$vname$layer_no";
	$detector{"mother"}      =  $envelope;
	$detector{"description"} = "$descriptio";
	$detector{"pos"}         = "0.000*mm 0.000*mm $z*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $mesh_color;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$InnerRadius*mm $OuterRadius*mm $PDz*mm $PSPhi*deg $PDPhi*deg";
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
    my $PSPhi     = 0.0;
    
    if($type == 1)
    {
	$z           =   - $ftm_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz*2. - $Strips_Dz*2. - $Gas1_Dz*2. - $Mesh_Dz*2. - $Gas2_Dz;
	$vname       = "FTM_Gas2_X_L";
	$descriptio  = "Gas2 X, Layer $layer_no";
    }
    
    if($type == 2) 
    {
	$z           =   - $ftm_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz*2. + $Strips_Dz*2. + $Gas1_Dz*2. + $Mesh_Dz*2. + $Gas2_Dz;
	$vname       = "FTM_Gas2_Y_L";
	$descriptio  = "Gas2 Y, Layer $layer_no";
    }
    
	# names
	my $r         = 0.000;
	my $PDz       = $Gas2_Dz;
	my $PDPhi     = 360.000;

	$detector{"name"}        = "$vname$layer_no";
	$detector{"mother"}      = $envelope;
	$detector{"description"} = "$descriptio";
	$detector{"pos"}         = "0.000*mm 0.000*mm $z*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $gas_color;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$InnerRadius*mm $OuterRadius*mm $PDz*mm $PSPhi*deg $PDPhi*deg";
	$detector{"material"}    =  $gas_material;
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "FTM";
	$detector{"hit_type"}    = "FTM";
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
    my $PSPhi     = 0.0;
      
    
    if($type == 1)
    {
	$z           =   - $ftm_starting + $starting_point[$l] - $Epoxy_Dz - $PCB_Dz*2. - $Strips_Dz*2. - $Gas1_Dz*2. - $Mesh_Dz*2. - $Gas2_Dz*2. - $Drift_Dz;
	$vname       = "FTM_Drift_X_L";
	$descriptio  = "Drift X, Layer $layer_no";
    }

    if($type == 2)
    {
	$z           =   - $ftm_starting + $starting_point[$l] + $Epoxy_Dz + $PCB_Dz*2. + $Strips_Dz*2. + $Gas1_Dz*2. + $Mesh_Dz*2. + $Gas2_Dz*2. + $Drift_Dz;
	$vname       = "FTM_Drift_Y_L";
	$descriptio  = "Drift Y, Layer $layer_no";
    }

	# names
	my $r         = 0.000;
	my $PDz       = $Drift_Dz;
	my $PDPhi     = 360.000;
	
	$detector{"name"}        = "$vname$layer_no";
	$detector{"mother"}      =  $envelope;
	$detector{"description"} = "$descriptio";
	$detector{"pos"}         = "0.000*mm 0.000*mm $z*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $drift_color;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$InnerRadius*mm $OuterRadius*mm $PDz*mm $PSPhi*deg $PDPhi*deg";
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

