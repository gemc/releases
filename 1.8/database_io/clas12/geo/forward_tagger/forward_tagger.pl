#!/usr/bin/perl

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use Getopt::Long;
use Math::Trig;


my $config_file = 'ft.config';

# Load configuration
#my %configuration = load_configuration($config_file);

# Load parameters from mysql database
#my %parameters    = download_parameters(%configuration);

# Assign paramters to local variables
#my $SteelFrameLength = $parameters{"SteelFrameLength"};




my $envelope = 'FT';
my $file     = 'FT.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;



use Getopt::Long;
use Math::Trig;


###########################################################################################
### Torus geo and info
my $inches = 25.4;
my $SteelFrameLength = 94.29*$inches/2.0;   # 1/2 length
my $col              = 'ffff9b';
my $TorusZpos= 151.855*$inches;                 # center of the torus position
my $ipipe_ir = 2.42*$inches;
my $ipipe_or = 2.50*$inches;
my $ipipe_le = 93.5*$inches/2.0;
sub make_ipipe
{
 $detector{"name"}        = "torus_inner_pipe";
 $detector{"mother"}      = "root";
 $detector{"description"} = "FT Beam Line";
 $detector{"pos"}         = "0.0*cm 0.0*cm $TorusZpos*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff8883";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$ipipe_ir*mm $ipipe_or*mm $ipipe_le*mm 0*deg 360*deg";
 $detector{"material"}    = "StainlessSteel";
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


# Front and back Plates
my $face_plate_IR = 1.56*$inches + .1;  # Allow microgap to avoid overlaps
my $face_plate_OR = 7.64*$inches - .1;
my $face_plate_LE = 1.18*$inches/2.0;
my $fp_zpos       = $TorusZpos - $SteelFrameLength - 0.1; # Allow microgap to avoid overlaps
my $bp_zpos       = $TorusZpos + $SteelFrameLength + 0.1;
sub make_face_plate
{
 $detector{"name"}        = "Torus_front_plate";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Torus Front Plate";
 $detector{"pos"}         = "0.0*cm 0.0*cm $fp_zpos*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $col;
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$face_plate_IR*mm $face_plate_OR*mm $face_plate_LE*mm  0.0*deg 360.0*deg";
 $detector{"material"}    = "StainlessSteel";
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
sub make_face_plate2
{
 $detector{"name"}        = "Torus_back_plate";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Torus Back Plate";
 $detector{"pos"}         = "0.0*cm 0.0*cm $bp_zpos*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = $col;
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$face_plate_IR*mm $face_plate_OR*mm $face_plate_LE*mm  0.0*deg 360.0*deg";
 $detector{"material"}    = "StainlessSteel";
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





###########################################################################################
###########################################################################################
# Define the relevant parameters of Calorimeter geometry
# the FT geometry will be defined starting from these parameters 
# and the position on the torus inner ring


###########################################################################################
# CALORIMETER
# Define the dimensions of the crystals

my $Cfront  = 1886.0 ; # Position of the front face of the crystals
my $Cwidth  =   15.0 ; # Crystal width in mm (side of the squared front face)
my $Clength =  200.0 ; # Crystal length in mm

my $VM2000  = 0.130 ;   # Thickness of the VM2000 wrapping

my $AGap    = 0.170 ;   # Air Gap between Crystals, total wodth of crystal including wrapping and air gap is 15.3 mm

my $Flength =    10.0 ; # Length of the crystal front support
my $Fwidth  = $Cwidth ; # Width of the crystal front support

my $Wwidth  = $Cwidth+$VM2000 ;  #  width of the wrapping volume

my $Vwidth  = $Cwidth+$VM2000+$AGap ;  #  width of the crystal mother volume, total wodth of crystal including wrapping and air gap is 15.3 mm
my $Vlength = $Clength+$Flength;       # length of the crystal mother volume
my $Vfront  = $Cfront-$Flength;        # z position of the volume front face

# Number of crystals in horizontal and vertical directions
my $Nx = 22;
my $Ny = 22;
my $centX = ( int $Nx/2 )+0.5;
my $centY = ( int $Ny/2 )+0.5;


my $BL_IR=30.;
my $BL_TN=10.;

###########################################################################################
# FLUX DETECTOR
my $Flux_TN = 1./2.;           # flux detector half thickness
my $Flux_IR = 55.;             # inner radius
my $Flux_OR = 178.5;           # outer radius
my $Flux_Z =  $Vfront+$Vlength+$Flux_TN; 

###########################################################################################
# SENSORS
my $Slength =    8.0 ; # Length of the sensor "box"
my $Swidth  = $Cwidth ; # Width of the sensor "box"
my $S_Z     = $Flux_Z + $Flux_TN + $Slength/2.; 

###########################################################################################
# BACK COPPER PLATE
my $Bdisk_TN = 5.; # half thickness of the copper back disk 
my $Bdisk_IR = $Flux_IR;
my $Bdisk_OR = $Flux_OR;
my $Bdisk_Z  = $S_Z + $Slength/2. + $Bdisk_TN + 0.1;

###########################################################################################
# BACK PLATE -> Space for preamps
my $BPlate_TN = 25.; # half thickness of the copper back disk 
my $BPlate_IR = $Bdisk_IR;
my $BPlate_OR = $Bdisk_OR;
my $BPlate_Z  = $Bdisk_Z + $Bdisk_TN + $BPlate_TN + 0.1;

###########################################################################################
# BACK MTB -> Space for motherboard
my $Bmtb_TN = 1.; # half thickness of the copper back disk 
my $Bmtb_IR = $BPlate_IR;
my $Bmtb_OR = $BPlate_OR;
my $Bmtb_Z  = $BPlate_Z + $BPlate_TN + $Bmtb_TN + 0.1;

###########################################################################################
# FRONT COPPER PLATE
my $Fdisk_TN =   1.; # half thickness of the copper front disk supporting the crystal assemblies
my $Fdisk_IR = $Flux_IR;
my $Fdisk_OR = $Flux_OR;
my $Fdisk_Z  = $Vfront - $Fdisk_TN - 0.1;

###########################################################################################
# INNER COPPER TUBE
my $Idisk_LT = ($Bmtb_Z+$Bmtb_TN -$Fdisk_Z + $Fdisk_TN)/2. -0.1; # length of the inner copper tube 
my $Idisk_OR = $Fdisk_IR;
my $Idisk_IR = $Fdisk_IR-4.;
my $Idisk_Z  = ($Bmtb_Z+$Bmtb_TN+$Fdisk_Z-$Fdisk_TN)/2.;


###########################################################################################
# OUTER COPPER TUBE
my $Odisk_LT = ($Bmtb_Z+$Bmtb_TN -$Fdisk_Z + $Fdisk_TN)/2. -0.1; # length of the outer copper tube 
my $Odisk_IR = $Fdisk_OR;
my $Odisk_OR = $Fdisk_OR+2.;
my $Odisk_Z  = $Idisk_Z;

############################################################################################
## FRONT PLATE 
#my $FPlate_TN = 25.; # half thickness of the copper back disk 
#my $FPlate_IR = $BL_IR+$BL_TN;
#my $FPlate_OR = $Flux_OR;
#my $FPlate_Z  = $Fdisk_Z - $Fdisk_TN - $FPlate_TN - 0.1;

###########################################################################################
# BACK INSULATION
my $B_Ins_TN = 50./2.; 
my $B_Ins_OR = $Odisk_OR ;
my $B_Ins_IR = $Idisk_IR ;
my $B_Ins_Z  = $Bmtb_Z + $Bmtb_TN + $B_Ins_TN + 0.1;

###########################################################################################
# FRONT INSULATION
my $F_Ins_TN = 50./2.; 
my $F_Ins_OR = $B_Ins_OR ;
my $F_Ins_IR = $B_Ins_IR ;
my $F_Ins_Z  = $Fdisk_Z - $Fdisk_TN - $F_Ins_TN - 0.1;

###########################################################################################
# INNER INSULATION
my $I_Ins_LT = ($B_Ins_Z+$B_Ins_TN -$F_Ins_Z + $F_Ins_TN)/2.; 
my $I_Ins_OR =  $B_Ins_IR - 0.1;
my $I_Ins_IR =  $BL_IR + $BL_TN + 1.;
my $I_Ins_Z  = ($B_Ins_Z+$B_Ins_TN +$F_Ins_Z - $F_Ins_TN)/2.;

###########################################################################################
# OUTER INSULATION
my $O_Ins_LT = ($B_Ins_Z+$B_Ins_TN -$F_Ins_Z + $F_Ins_TN)/2.; 
my $O_Ins_IR =  $B_Ins_OR + 0.1;
my $O_Ins_OR =  $O_Ins_IR + 50.;
my $O_Ins_Z  = ($B_Ins_Z+$B_Ins_TN +$F_Ins_Z - $F_Ins_TN)/2.;

###########################################################################################
# HODOSCOPE
my $VETO_TN = 10./2.;# scintillator half thickness
my $VETO_OR = 178.5;  # outer radius
my $VETO_IR = 60.;   # inner radius
my $VETO_Z  = $F_Ins_Z - $F_Ins_TN - $VETO_TN - 0.1;

###########################################################################################
# FT BEAMLINE (BLINE)
# define main parameters of the segment of beamline going through the FT
my $BLine_IR = $BL_IR;          # inner radius
my $BLine_MR = $BL_IR + $BL_TN; # radius in the calorimeter section
#my $BLine_OR = 75.; #          # radius of portion shielding innermost crystals
my $BLine_OR = 59.; #          # radius of portion shielding innermost crystals
my $BLine_FR = 59.;            # radius in the front part, connecting to moller shield
my $BLine_BG = 1810.;          # z location of the beginning of the beamline (to be matched to moller shield)


###########################################################################################




###########################################################################################
# Define FT Mother Volume
my $torus_z    = 2663.; # position of the front face of the Torus ring (set the limit in z)
my $nplanes_FT = 4;
my @z_plane_FT = ($BLine_BG, 2250., 2250., $torus_z);
my @oradius_FT = (     235.,  235.,  149.,     149.);
my @iradius_FT = (       0.,    0.,    0.,       0.);

sub make_FT
{
 $detector{"name"}        = $envelope;
 $detector{"mother"}      = "root";
 $detector{"description"} = "Forward Tagger";
 $detector{"pos"}         = "0.*mm 0.*mm 0.*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "1437f4";
 $detector{"type"}        = "Polycone";

 my $dimen = "0.0*deg 360*deg $nplanes_FT";
 for(my $i = 0; $i <$nplanes_FT ; $i++)
{
    $dimen = $dimen ." 0.0*mm";
}
 for(my $i = 0; $i <$nplanes_FT ; $i++)
{
    $dimen = $dimen ." $oradius_FT[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_FT ; $i++)
{
    $dimen = $dimen ." $z_plane_FT[$i]*mm";
}
 $detector{"dimensions"} = $dimen;
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


###########################################################################################
# Build Crystal Volume and Assemble calorimeter

if( ( $Nx % 2 ) != 0 || ( $Nx % 2 ) != 0 )
{
 print STDERR  "I only want to work with even numbers ... \nExiting \n";
 die -1;
}


# Loop over all crystals and define their positions
sub make_Crystals
{
 my $locX=0.;
 my $locY=0.;
 my $locZ=0.;
 my $dX=0.;
 my $dY=0.;
 my $dZ=0.;
 for ( my $iX = 1; $iX <= $Nx; $iX++ )
 {
       for ( my $iY = 1; $iY <= $Ny; $iY++ )
       {
          $locX=($iX-$centX)*$Vwidth;
          $locY=($iY-$centY)*$Vwidth;
          my $locR=sqrt($locX*$locX+$locY*$locY);
          if($locR>60. && $locR<$Vwidth*11)
          {
                 # crystal mother volume
                 $detector{"name"}        = "FT_CR_Volume_" . $iX . "_" . $iY ;
                 $detector{"mother"}      = $envelope;
                 $detector{"description"} = "FT Crystal mother volume (h:" . $iX . ", v:" . $iY . ")";
                 $locZ=$Vfront+$Vlength/2.;
                 $detector{"pos"}         = "$locX*mm $locY*mm $locZ*mm";
                 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
                 $detector{"color"}       = "838EDE";
                 $detector{"type"}        = "Box" ;
                 $dX=$Vwidth/2.0;
                 $dY=$Vwidth/2.0;
                 $dZ=$Vlength/2.0;
                 $detector{"dimensions"}  = "$dX*mm $dY*mm $dZ*mm";
                 $detector{"material"}    = "Air";
                 $detector{"mfield"}      = "no" ;
                 $detector{"ncopy"}       = "1" ;
                 $detector{"pMany"}       = "1" ;
                 $detector{"exist"}       = "1" ;
                 $detector{"visible"}     = "1" ;
                 $detector{"style"}       = "0" ;
                 $detector{"sensitivity"} = "no"; 
                 $detector{"hit_type"}    = "";
                 $detector{"identifiers"} = "";
                 print_det(\%detector, $file);

                  # APD housing
                 $detector{"name"}        = "FT_CR_APD_" . $iX . "_" . $iY ;
                 $detector{"mother"}      =  $envelope;
                 $detector{"description"} = "FT Crystal APD (h:" . $iX . ", v:" . $iY . ")";
                 $locZ=$S_Z;
                 $detector{"pos"}         = "$locX*mm $locY*mm $locZ*mm";
                 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
                 $detector{"color"}       = "99CC66";
                 $detector{"type"}        = "Box" ;
                 $dX=$Swidth/2.0;
                 $dY=$Swidth/2.0;
                 $dZ=$Slength/2.0;
                 $detector{"dimensions"}  = "$dX*mm $dY*mm $dZ*mm";
                 $detector{"material"}    = "Peek";
                 $detector{"mfield"}      = "no" ;
                 $detector{"ncopy"}       = "1" ;
                 $detector{"pMany"}       = "1" ;
                 $detector{"exist"}       = "1" ;
                 $detector{"visible"}     = "1" ;
                 $detector{"style"}       = "1" ;
                 $detector{"sensitivity"} = "no"; 
                 $detector{"hit_type"}    = "";
                 $detector{"identifiers"} = "";
                 print_det(\%detector, $file);

                 # Wrapping Volume;
                 $detector{"name"}        = "FT_CR_WR_" . $iX . "_" . $iY ;
                 $detector{"mother"}      = "FT_CR_Volume_" . $iX . "_" . $iY ;
                 $detector{"description"} = "FT Wrapping (h:" . $iX . ", v:" . $iY . ")";
                 $locX=0.;
                 $locY=0.;
                 $locZ=0.;
                 $detector{"pos"}         = "$locX*mm $locY*mm $locZ*mm";
                 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
                 $detector{"color"}       = "838EDE";
                 $detector{"type"}        = "Box" ;
                 $dX=$Wwidth/2.0;
                 $dY=$Wwidth/2.0;
                 $dZ=$Vlength/2.0;
                 $detector{"dimensions"}  = "$dX*mm $dY*mm $dZ*mm";
                 $detector{"material"}    = "MMMylar";
                 $detector{"mfield"}      = "no" ;
                 $detector{"ncopy"}       = "1" ;
                 $detector{"pMany"}       = "1" ;
                 $detector{"exist"}       = "1" ;
                 $detector{"visible"}     = "1" ;
                 $detector{"style"}       = "1" ;
                 $detector{"sensitivity"} = "no"; 
                 $detector{"hit_type"}    = "";
                 $detector{"identifiers"} = "";
                 print_det(\%detector, $file);

                 # PbWO4 Crystal;
                 $detector{"name"}        = "FT_CR_" . $iX . "_" . $iY ;
                 $detector{"mother"}      = "FT_CR_WR_" . $iX . "_" . $iY ;
                 $detector{"description"} = "FT Crystal (h:" . $iX . ", v:" . $iY . ")";
                 $locX=0.;
                 $locY=0.;
                 $locZ=$Flength/2.;
                 $detector{"pos"}         = "$locX*mm $locY*mm $locZ*mm";
                 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
                 $detector{"color"}       = "836FFF";
                 $detector{"type"}        = "Box" ;
                 $dX=$Cwidth/2.0;
                 $dY=$Cwidth/2.0;
                 $dZ=$Clength/2.0;
                 $detector{"dimensions"}  = "$dX*mm $dY*mm $dZ*mm";
                 $detector{"material"}    = "LeadTungsten";
                 $detector{"mfield"}      = "no" ;
                 $detector{"ncopy"}       = "1" ;
                 $detector{"pMany"}       = "1" ;
                 $detector{"exist"}       = "1" ;
                 $detector{"visible"}     = "1" ;
                 $detector{"style"}       = "1" ;
                 $detector{"sensitivity"} = "IC"; 
                 $detector{"hit_type"}    = "FT";
                 $detector{"identifiers"} = "ih manual $iX iv manual $iY";
                 print_det(\%detector, $file);

                  # LED housing
                 $detector{"name"}        = "FT_CR_LED_" . $iX . "_" . $iY ;
                 $detector{"mother"}      = "FT_CR_WR_" . $iX . "_" . $iY ;
                 $detector{"description"} = "FT Crystal LED (h:" . $iX . ", v:" . $iY . ")";
                 $locX=0.;
                 $locY=0.;
                 $locZ=-$Vlength/2.+$Flength/2.;
                 $detector{"pos"}         = "$locX*mm $locY*mm $locZ*mm";
                 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
                 $detector{"color"}       = "EEC900";
                 $detector{"type"}        = "Box" ;
                 $dX=$Fwidth/2.0;
                 $dY=$Fwidth/2.0;
                 $dZ=$Flength/2.0;
                 $detector{"dimensions"}  = "$dX*mm $dY*mm $dZ*mm";
                 $detector{"material"}    = "Peek";
                 $detector{"mfield"}      = "no" ;
                 $detector{"ncopy"}       = "1" ;
                 $detector{"pMany"}       = "1" ;
                 $detector{"exist"}       = "1" ;
                 $detector{"visible"}     = "1" ;
                 $detector{"style"}       = "1" ;
                 $detector{"sensitivity"} = "no"; 
                 $detector{"hit_type"}    = "";
                 $detector{"identifiers"} = "";
                 print_det(\%detector, $file);

          }
       }
 }
}


###########################################################################################
# Define the Flux Detector on the back og the crystals
sub make_FT_Flux
{
 $detector{"name"}        = "FT_Flux";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Flux";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Flux_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "aa0088";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$Flux_IR*mm $Flux_OR*mm $Flux_TN*mm 0.*deg 360.*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"}  = "FLUX";
 $detector{"hit_type"}     = "FLUX";
 $detector{"identifiers"}  = "id manual 3";
 print_det(\%detector, $file);
}


###########################################################################################
# Define the Copper Disk in front of the Crystals
sub make_FT_Back_Copper
{
 $detector{"name"}        = "FT_Back_Copper";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Back_Copper";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Bdisk_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6600";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$Bdisk_IR*mm $Bdisk_OR*mm $Bdisk_TN*mm 0.*deg 360.*deg";
 $detector{"material"}    = "Copper";
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

###########################################################################################
# Define the Space for the Preamps on the back
sub make_FT_Back_Plate
{
 $detector{"name"}        = "FT_Back_Plate";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Back_Plate";
 $detector{"pos"}         = "0.0*cm 0.0*cm $BPlate_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "7F9A65";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$BPlate_IR*mm $BPlate_OR*mm $BPlate_TN*mm 0.*deg 360.*deg";
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

###########################################################################################
# Define the Space for the MotherBoard
sub make_FT_Back_MTB
{
 $detector{"name"}        = "FT_Back_MTB";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Back_MTB";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Bmtb_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0B3B0B";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$Bmtb_IR*mm $Bmtb_OR*mm $Bmtb_TN*mm 0.*deg 360.*deg";
 $detector{"material"}    = "PCBoardM";
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

###########################################################################################
# Define the Copper Disk in front of the Crystals
sub make_FT_Front_Copper
{
 $detector{"name"}        = "FT_Front_Copper";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Front_Copper";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Fdisk_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6600";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$Fdisk_IR*mm $Fdisk_OR*mm $Fdisk_TN*mm 0.*deg 360.*deg";
 $detector{"material"}    = "Copper";
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

###########################################################################################
# Define the Inner Copper Tube
sub make_FT_Inner_Copper
{
 $detector{"name"}        = "FT_Inner_Copper";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Inner_Copper";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Idisk_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6600";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$Idisk_IR*mm $Idisk_OR*mm $Idisk_LT*mm 0.*deg 360.*deg";
 $detector{"material"}    = "Copper";
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

###########################################################################################
# Define the Outer Copper Tube
sub make_FT_Outer_Copper
{
 $detector{"name"}        = "FT_Outer_Copper";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Outer_Copper";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Odisk_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6600";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$Odisk_IR*mm $Odisk_OR*mm $Odisk_LT*mm 0.*deg 360.*deg";
 $detector{"material"}    = "Copper";
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

###########################################################################################
# Define the Space for the Insulation on the back
sub make_FT_Back_Ins
{
 $detector{"name"}        = "FT_Back_Ins";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Back_Insulation";
 $detector{"pos"}         = "0.0*cm 0.0*cm $B_Ins_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "F5F6CE";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$B_Ins_IR*mm $B_Ins_OR*mm $B_Ins_TN*mm 0.*deg 360.*deg";
 $detector{"material"}    = "FTinsfoam";
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

###########################################################################################
# Define the Space for the Insulation on the front
sub make_FT_Front_Ins
{
 $detector{"name"}        = "FT_Front_Ins";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Front_Insulation";
 $detector{"pos"}         = "0.0*cm 0.0*cm $F_Ins_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "F5F6CE";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$F_Ins_IR*mm $F_Ins_OR*mm $F_Ins_TN*mm 0.*deg 360.*deg";
 $detector{"material"}    = "FTinsfoam";
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

###########################################################################################
# Define the Inner Copper Tube
sub make_FT_Inner_Ins
{
 $detector{"name"}        = "FT_Inner_Ins";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Inner_Ins";
 $detector{"pos"}         = "0.0*cm 0.0*cm $I_Ins_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "F5F6CE";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$I_Ins_IR*mm $I_Ins_OR*mm $I_Ins_LT*mm 0.*deg 360.*deg";
 $detector{"material"}    = "FTinsfoam";
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

###########################################################################################
# Define the Inner Copper Tube
sub make_FT_Outer_Ins
{
 $detector{"name"}        = "FT_Outer_Ins";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Outer_Ins";
 $detector{"pos"}         = "0.0*cm 0.0*cm $O_Ins_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "F5F6CE";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$O_Ins_IR*mm $O_Ins_OR*mm $O_Ins_LT*mm 0.*deg 360.*deg";
 $detector{"material"}    = "FTinsfoam";
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

###########################################################################################
# Define the Veto Counter
# P15 tile: 15x15x15
my $p15_WW=15./2.;
my $p15_WT=$VETO_TN;
#
my $p30_WW=30./2.;
my $p30_WT=$VETO_TN;
#
my $p15_SW=14.8/2.;
my $p15_ST=$VETO_TN-0.1;
#
my $p30_SW=29.8/2.;
my $p30_ST=$VETO_TN-0.1;
#
my $p15_N = 11;
my @p15_X = (  7.5,  22.5,  37.5,  52.5,  52.5,  67.5,  67.5,  67.5,  67.5,  97.5, 127.5);
my @p15_Y = ( 67.5,  67.5,  67.5,  52.5,  67.5,   7.5,  22.5,  37.5,  52.5, 127.5,  97.5);
#
my $p30_N = 18;
my @p30_X = (  15.,  15.,  15.,  45.,  45.,  45.,  75.,  75.,  75.,  90.,  90., 105., 105., 120., 120., 135., 150., 150.);
my @p30_Y = (  90., 120., 150.,  90., 120., 150.,  75., 105., 135.,  15.,  45.,  75., 105.,  15.,  45.,  75.,  15.,  45.);
my @q_X = (1., -1., -1.,  1.);
my @q_Y = (1.,  1., -1., -1.);

sub make_FTH
{
 $detector{"name"}        = "FTH";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Scintillation Hodoscope";
 $detector{"pos"}         = "0.0*cm 0.0*cm $VETO_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "3399FF";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$VETO_IR*mm $VETO_OR*mm $VETO_TN*mm 0.*deg 360.*deg";
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
 
 my $p_X=0.;
 my $p_Y=0.;
 my $p_i=0;
 for ( my $q = 0; $q < 4; $q++ ) {
   for ( my $i = 0; $i < $p15_N; $i++ ) {
        $p_i=($q+1)*100+$i;
	$p_X = $p15_X[$i]*$q_X[$q];
	$p_Y = $p15_Y[$i]*$q_Y[$q];
	if ( $q==0 && $i==0) {
	# define tile mother volume
	    $detector{"name"}        = "FTH_P15";
	    $detector{"mother"}      = "FTH";
	    $detector{"description"} = "FTH P15";
	    $detector{"pos"}         = "$p_X*mm $p_Y*mm 0.*mm";
	    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
	    $detector{"color"}       = "3399FF";
	    $detector{"type"}        = "Box";
	    $detector{"dimensions"}  = "$p15_WW*mm $p15_WW*mm $p15_WT*mm";
	    $detector{"material"}    = "MMMylar";
	    $detector{"mfield"}      = "no";
	    $detector{"ncopy"}       = $p_i;
	    $detector{"pMany"}       = 1;
	    $detector{"exist"}       = 1;
	    $detector{"visible"}     = 1;
	    $detector{"style"}       = 1;
	    $detector{"sensitivity"} = "no";
	    $detector{"hit_type"}    = "";
	    $detector{"identifiers"} = "";
	    print_det(\%detector, $file);
	    
	    $detector{"name"}        = "FTH_P15_Tile";
	    $detector{"mother"}      = "FTH_P15";
	    $detector{"description"} = "FTH P15 Tile";
	    $detector{"pos"}         = "0.*mm 0.*mm 0.*mm";
	    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
	    $detector{"color"}       = "BCA9F5";
	    $detector{"type"}        = "Box";
	    $detector{"dimensions"}  = "$p15_SW*mm $p15_SW*mm $p15_ST*mm";
	    $detector{"material"}    = "Scintillator";
	    $detector{"mfield"}      = "no";
	    $detector{"ncopy"}       = 1;
	    $detector{"pMany"}       = 1;
	    $detector{"exist"}       = 1;
	    $detector{"visible"}     = 1;
	    $detector{"style"}       = 1;
	    $detector{"sensitivity"} = "FTH";
	    $detector{"hit_type"}    = "FTH";
	    $detector{"identifiers"} = "FTH_P15 ncopy 0 layer manual 0";
	    print_det(\%detector, $file);
	}
	else {
	    $detector{"name"}        = "FTH_P15_".$p_i;
	    $detector{"mother"}      = "FTH";
	    $detector{"description"} = "FTH P15 id=".$p_i;
	    $detector{"pos"}         = "$p_X*mm $p_Y*mm 0.*mm";
	    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
	    $detector{"color"}       = "3399FF";
	    $detector{"type"}        = "CopyOf FTH_P15";
	    $detector{"dimensions"}  = "0.*mm";
	    $detector{"material"}    = "MMMylar";
	    $detector{"mfield"}      = "no";
	    $detector{"ncopy"}       = $p_i;
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
      for ( my $i = 0; $i < $p30_N; $i++ ) {
        $p_i=($q+1)*100+(11+$i);
	$p_X = $p30_X[$i]*$q_X[$q];
	$p_Y = $p30_Y[$i]*$q_Y[$q];
	if ( $q==0 && $i==0) {
	    $detector{"name"}        = "FTH_P30";
	    $detector{"mother"}      = "FTH";
	    $detector{"description"} = "FTH P30";
	    $detector{"pos"}         = "$p_X*mm $p_Y*mm 0.*mm";
	    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
	    $detector{"color"}       = "0431B4";
	    $detector{"type"}        = "Box";
	    $detector{"dimensions"}  = "$p30_WW*mm $p30_WW*mm $p30_WT*mm";
	    $detector{"material"}    = "MMMylar";
	    $detector{"mfield"}      = "no";
	    $detector{"ncopy"}       = $p_i;
	    $detector{"pMany"}       = 1;
	    $detector{"exist"}       = 1;
	    $detector{"visible"}     = 1;
	    $detector{"style"}       = 1;
	    $detector{"sensitivity"} = "no";
	    $detector{"hit_type"}    = "";
	    $detector{"identifiers"} = "";
	    print_det(\%detector, $file);

	    $detector{"name"}        = "FTH_P30_Tile";
	    $detector{"mother"}      = "FTH_P30";
	    $detector{"description"} = "FTH P30 Tile";
	    $detector{"pos"}         = "0.*mm 0.*mm 0.*mm";
	    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
	    $detector{"color"}       = "BCA9F5";
	    $detector{"type"}        = "Box";
	    $detector{"dimensions"}  = "$p30_SW*mm $p30_SW*mm $p30_ST*mm";
	    $detector{"material"}    = "Scintillator";
	    $detector{"mfield"}      = "no";
	    $detector{"ncopy"}       = 1;
	    $detector{"pMany"}       = 1;
	    $detector{"exist"}       = 1;
	    $detector{"visible"}     = 1;
	    $detector{"style"}       = 1;
	    $detector{"sensitivity"} = "FTH";
	    $detector{"hit_type"}    = "FTH";
	    $detector{"identifiers"} = "FTH_P30 ncopy 0 layer manual 0";
	    print_det(\%detector, $file);
	}
	else {
	    $detector{"name"}        = "FTH_P30_".$p_i;
	    $detector{"mother"}      = "FTH";
	    $detector{"description"} = "FTH P30 id=".$p_i;
	    $detector{"pos"}         = "$p_X*mm $p_Y*mm 0.*mm";
	    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
	    $detector{"color"}       = "0431B4";
	    $detector{"type"}        = "CopyOf FTH_P30";
	    $detector{"dimensions"}  = "0.*mm";
	    $detector{"material"}    = "MMMylar";
	    $detector{"mfield"}      = "no";
	    $detector{"ncopy"}       = $p_i;
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
   }
}

###########################################################################################
# Define the Calorimeter Tube  
my $BLine_Z1  = $B_Ins_Z+$B_Ins_TN;  
my $BLine_Z2  = $F_Ins_Z - $F_Ins_TN-0.1;  
my $BLine_Z3  = $VETO_Z  + $VETO_TN +0.1;
my $BLine_Z4  = $BLine_BG;
my $nplanes_BLine = 6;
my @z_plane_BLine = ( $BLine_Z4, $BLine_Z3, $BLine_Z3, $BLine_Z2, $BLine_Z2, $BLine_Z1);  
my @oradius_BLine = ( $BLine_FR, $BLine_FR, $BLine_OR, $BLine_OR, $BLine_MR, $BLine_MR);  
my @iradius_BLine = ( $BLine_IR, $BLine_IR, $BLine_IR, $BLine_IR, $BLine_IR, $BLine_IR);  
sub make_FT_BLine
{
 $detector{"name"}        = "FT_BLine";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Beam Line";
 $detector{"pos"}         = "0.0*cm 0.0*cm 0.0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ccff00";
 $detector{"type"}        = "Polycone";
 my $dimen = "0.0*deg 360*deg $nplanes_BLine";
 for(my $i = 0; $i <$nplanes_BLine ; $i++)
{
    $dimen = $dimen ." $iradius_BLine[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_BLine ; $i++)
{
    $dimen = $dimen ." $oradius_BLine[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_BLine ; $i++)
{
    $dimen = $dimen ." $z_plane_BLine[$i]*mm";
}
 $detector{"dimensions"}  = $dimen;
 $detector{"material"}    = "Tungsten";
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

###########################################################################################
# Define the tube between Calorimeter and Torus Inner Ring
#my $Tube_IR         =  56.0;
#my $Tube_OR         =  89.0;
my $Tube_IR         =  $BL_IR;
my $Tube_OR         =  75.0;
my $Tube_LT         = 366.0;
my $back_flange_OR  = 126.0;
my $front_flange_OR = 148.0;
my $flange_TN       =  15.0;

# define positions based on z of torus inner ring front face
my $Tube_end  = $torus_z-0.1;    # leave 0.1 mm to avoid overlaps
my $Tube_z1   = $Tube_end - $flange_TN;
my $Tube_z2   = $Tube_z1 - $Tube_LT;
my $Tube_beg  = $Tube_z2 - $flange_TN;

my $nplanes_Tube = 6;
my @z_plane_Tube = (        $Tube_beg,         $Tube_z2, $Tube_z2, $Tube_z1,        $Tube_z1,       $Tube_end);
my @oradius_Tube = ( $front_flange_OR, $front_flange_OR, $Tube_OR, $Tube_OR, $back_flange_OR, $back_flange_OR);
my @iradius_Tube = (         $Tube_IR,         $Tube_IR, $Tube_IR, $Tube_IR,        $Tube_IR,        $Tube_IR);

sub make_FT_2_Torus_Tube
{
 $detector{"name"}        = "FT_2_Torus_Tube";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Tube from FT to Torus";
 $detector{"pos"}         = "0.0*cm 0.0*cm 0.0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "99cc00";
 $detector{"type"}        = "Polycone";
 my $dimen = "0.0*deg 360*deg $nplanes_Tube";
 for(my $i = 0; $i <$nplanes_Tube ; $i++)
{
    $dimen = $dimen ." $iradius_Tube[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_Tube ; $i++)
{
    $dimen = $dimen ." $oradius_Tube[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_Tube ; $i++)
{
    $dimen = $dimen ." $z_plane_Tube[$i]*mm";
}
 $detector{"dimensions"}  = $dimen;
 $detector{"material"}    = "Tungsten";
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


###########################################################################################
# Define the Flange on the back of the FT
my $Flange_IR  =  $BL_IR;
my $Flange_FR  = $B_Ins_OR+0.1;
my $Flange_MR  =  77.0;
my $Flange_OR  =  89.0;
my $Flange_DR  = 212.0;
my $Flange_CR  = $Odisk_OR+0.1;
my $Flange_LT  = 122.9;
my $Flange_T1  =  10.0;
my $Flange_T2  =  35.0;

my $Flange_beg  = $B_Ins_Z - $B_Ins_TN -50. ;
my $Flange_z4   = $B_Ins_Z - $B_Ins_TN;
my $Flange_z3   = $B_Ins_Z + $B_Ins_TN + 0.1;
my $Flange_z2   = $Flange_z3 + $Flange_T2;
my $Flange_end  = $Tube_beg -0.1;    # leave 0.5 mm to avoid overlaps
my $Flange_z1   = $Flange_end - $Flange_T1;

#my $Flange_GR= ($Flange_DR-$Flange_CR)*($Flange_z4-$Flange_beg)/($Flange_z3-$Flange_beg)+$Flange_CR;
#my $nplanes_Flange = 10;
#my @z_plane_Flange = ( $Flange_beg,  $Flange_z4,  $Flange_z4, $Flange_z3, $Flange_z3, $Flange_z2, $Flange_z2, $Flange_z1, $Flange_z1, $Flange_end);
#my @oradius_Flange = (  $Flange_CR,  $Flange_GR,  $Flange_GR, $Flange_DR, $Flange_DR, $Flange_DR, $Flange_MR, $Flange_MR, $Flange_OR,  $Flange_OR);
#my @iradius_Flange = (  $Flange_CR,  $Flange_CR,  $Flange_FR, $Flange_FR, $Flange_IR, $Flange_IR, $Flange_IR, $Flange_IR, $Flange_IR,  $Flange_IR);
my $Flange_GR= ($Flange_DR-$Flange_CR)*($Flange_z4-$Flange_beg)/($Flange_z3-$Flange_beg)+$Flange_CR;
my $nplanes_Flange = 6;
my @z_plane_Flange = ( $Flange_z3, $Flange_z2, $Flange_z2, $Flange_z1, $Flange_z1, $Flange_end);
my @oradius_Flange = ( $Flange_DR, $Flange_DR, $Flange_MR, $Flange_MR, $Flange_OR,  $Flange_OR);
my @iradius_Flange = ( $Flange_IR, $Flange_IR, $Flange_IR, $Flange_IR, $Flange_IR,  $Flange_IR);

sub make_FT_Flange
{
 $detector{"name"}        = "FT_Flange";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Flange on the back of the FT";
 $detector{"pos"}         = "0.0*cm 0.0*cm 0.0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ccff00";
 $detector{"type"}        = "Polycone";

 my $dimen = "0.0*deg 360*deg $nplanes_Flange";
 for(my $i = 0; $i <$nplanes_Flange ; $i++)
{
    $dimen = $dimen ." $iradius_Flange[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_Flange ; $i++)
{
    $dimen = $dimen ." $oradius_Flange[$i]*mm";
}
 for(my $i = 0; $i <$nplanes_Flange ; $i++)
{
    $dimen = $dimen ." $z_plane_Flange[$i]*mm";
}
 $detector{"dimensions"}  = $dimen;
 $detector{"material"}    = "Tungsten";
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



###########################################################################################
# Define Aluminum Beam Pipe and Vacuum
my $AL_BLine_TN=1.0;
my $AL_BLine_IR=27.;
my $AL_BLine_OR=$AL_BLine_IR+$AL_BLine_TN;
my $AL_BLine_LT=($Tube_end-$BLine_BG)/2.;
my $AL_BLine_Z =($Tube_end+$BLine_BG)/2.;

sub make_FT_AL_BLine_and_Vacuum
{
 $detector{"name"}        = "FT_AL_BLine";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Aluminum Beam Line";
 $detector{"pos"}         = "0.0*cm 0.0*cm $AL_BLine_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "F2F2F2";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$AL_BLine_IR*mm $AL_BLine_OR*mm $AL_BLine_LT*mm 0.*deg 360.*deg";
 $detector{"material"}    = "Aluminum";
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

 $detector{"name"}        = "FT_AL_BLine_Vacuum";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT Aluminum Beam Line Vacuum";
 $detector{"pos"}         = "0.0*cm 0.0*cm $AL_BLine_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "F2F2F2";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$0.0*mm $AL_BLine_IR*mm $AL_BLine_LT*mm 0.*deg 360.*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 0;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
 print_det(\%detector, $file);


}


#make_ipipe();
#make_face_plate();
#make_face_plate2();

make_FT();
make_Crystals();
make_FT_Flux();
make_FT_Back_Copper();
make_FT_Back_Plate();
make_FT_Back_MTB();
make_FT_Front_Copper();
make_FT_Inner_Copper();
make_FT_Outer_Copper();
make_FT_Back_Ins();
make_FT_Front_Ins();
make_FT_Inner_Ins();
make_FT_Outer_Ins();
#make_FT_Front_Plate();
make_FTH();
make_FT_BLine();
make_FT_2_Torus_Tube();
make_FT_Flange();
make_FT_AL_BLine_and_Vacuum();
















