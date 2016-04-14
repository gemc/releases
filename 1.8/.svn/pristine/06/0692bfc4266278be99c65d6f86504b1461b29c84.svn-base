#!/usr/bin/perl

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;


my $envelope = 'FT_proto_v2';
my $file     = 'FT_proto_v2.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;



use Getopt::Long;
use Math::Trig;




###########################################################################################
###########################################################################################
# Define the relevant parameters of Calorimeter geometry
# the FT geometry will be defined starting from these parameters 
# and the position on the torus inner ring


###########################################################################################
# CALORIMETER
# Define the dimensions of the crystals

my $Cfront  = 100.0 ; # Position of the front face of the crystals
my $Cwidth  =  15.0 ; # Crystal width in mm (side of the squared front face)
my $Clength = 200.0 ; # Crystal length in mm
my $CShift  = -25.0 ; # Crystal length in mm

my $VM2000  = 0.130 ;   # Thickness of the VM2000 wrapping

my $AGap    = 0.170 ;   # Air Gap between Crystals, total wodth of crystal including wrapping and air gap is 15.3 mm

my $Flength =    10.0 ; # Length of the crystal front support
my $Fwidth  = $Cwidth ; # Width of the crystal front support

my $Wwidth  = $Cwidth+$VM2000 ;  #  width of the wrapping volume

my $Vwidth  = $Cwidth+$VM2000+$AGap ;  #  width of the crystal mother volume
my $Vlength = $Clength+$Flength;       # length of the crystal mother volume
my $Vfront  = $Cfront-$Flength;        # z position of the volume front face

# Number of crystals in horizontal and vertical directions
my $Nx = 4;
my $Ny = 4;
my $centX = ( int $Nx/2 )+0.5;
my $centY = ( int $Ny/2 )+0.5;


###########################################################################################
# BOX
my $FTbox_Z = 1000.;
my $FTbox_WD = 95.;
my $FTbox_LN = 205.;
my $FTbox_TN = 10.;
# INSULATION
my $FTins_WD = $FTbox_WD-$FTbox_TN;
my $FTins_LN = $FTbox_LN-$FTbox_TN;
my $FTins_TN = 50.;
# SPACE
my $FTspa_WD = $FTins_WD-$FTins_TN;
my $FTspa_LN = $FTins_LN-$FTins_TN;
# FRONT Plate
my $FTfro_WD = $FTins_WD;
my $FTfro_Z  = $FTbox_TN/2.-$FTbox_LN;
my $FTfro_TN = $FTbox_TN/2.;
my $FTfro_TNN = $FTbox_TN/2.+1.;
# FRONT WINDOW
my $FTwin_WD = 35.;
my $FTwin_TN = 0.05;
my $FTwin_Z  = $FTwin_TN-$FTbox_LN;



###########################################################################################
# FLUX DETECTOR
my $Flux_TN = 1./2.;           # flux detector half thickness
my $Flux_Z =  $CShift+$Vlength/2.+$Flux_TN;  #ho eliminato la variabile Vfront

###########################################################################################
# SENSORS
my $Slength =    8.0 ; # Length of the sensor "box"
my $Swidth  = $Cwidth ; # Width of the sensor "box"
my $S_Z     = $Flux_Z + $Flux_TN + $Slength/2.; 


###########################################################################################
# BACK COPPER PLATE
my $Bdisk_TN = 1.5; # half thickness of the copper back box
my $Bdisk_Z  = $S_Z + $Slength/2. + $Bdisk_TN + 0.1;

my $Bwidth = $Vwidth * $Nx /2.; # half dimension 

###########################################################################################
# BACK PLATE -> Space for preamps
my $BPlate_TN = 25.; # half thickness of the copper back disk 
my $BPlate_Z  = $Bdisk_Z + $Bdisk_TN + $BPlate_TN + 0.1;

###########################################################################################
# BACK MTB -> Space for motherboard
my $Bmtb_TN = 1.; # half thickness of the back motherboard disk 
my $Bmtb_Z  = $BPlate_Z + $BPlate_TN + $Bmtb_TN + 0.1;

###########################################################################################
# FRONT COPPER PLATE
my $Fdisk_TN =   1.; # half thickness of the copper front box supporting the crystal assemblies
my $Fdisk_Z  = $CShift - $Vlength/2. - $Fdisk_TN - 0.1; 

###########################################################################################
# LED Monitoring System
my $Llength = 5.0 ; 
my $Lwidth  = $Bwidth;
my $L_Z     = $Fdisk_Z - $Fdisk_TN - $Flux_TN*2. -$Llength - 0.1; 

######################$Pdisk_X#####################################################################
# COPPER PLATEs
# UP COPPER BOX
my $Pdisk_TN  = 1.;
my $Plength   = ($Bdisk_Z+ $Bdisk_TN - $Fdisk_Z + $Fdisk_TN)/2.;
my $Pdisk_Z   = ($Bdisk_Z+ $Bdisk_TN + $Fdisk_Z - $Fdisk_TN)/2.;
my $UP_Y = $Bwidth + $Pdisk_TN + 0.1;  # y position
# DOWN COPPER BOX
my $DOWN_Y = -$Bwidth - $Pdisk_TN - 0.1;  #y position

###########################################################################################
#FRONT FLUX DETECTOR
my $Flux_Front_1_Z = $FTbox_Z-$FTbox_LN-50.; 
my $Flux_Front_2_Z = $Fdisk_Z - $Fdisk_TN - $Flux_TN; 



############################################################################################
## FRONT PLATE 
#my $FPlate_TN = 25.; # half thickness of the copper back disk 
#my $FPlate_IR = $BL_IR+$BL_TN;
#my $FPlate_OR = $Flux_OR;
#my $FPlate_Z  = $Fdisk_Z - $Fdisk_TN - $FPlate_TN - 0.1;

###########################################################################################
# HODOSCOPE
my $VETO_TN = 10./2.;# scintillator half thickness
my $VETO_WD = $Bwidth;  # outer radius
my $VETO_Z  = $FTbox_Z-$FTbox_LN-$VETO_TN- 3.;

###########################################################################################
# XY
my $XY_TN = 10./2.;# scintillator half thickness
my $XY_WD = $Bwidth;  # outer radius
my $XY_Z  = $VETO_Z-$VETO_TN-$XY_TN- 3.;


###########################################################################################
###########################################################################################




###########################################################################################
# Define FT Mother Volume
#my $torus_z    = 2663.; # position of the front face of the Torus ring (set the limit in z)
#my $nplanes_FT = 4;
#my @z_plane_FT = ($BLine_BG, 2250., 2250., $torus_z);
#my @oradius_FT = (     230.,  230.,  149.,     149.);
#my @iradius_FT = (       0.,    0.,    0.,       0.);
sub make_FT
{
 $detector{"name"}        = $envelope;
 $detector{"mother"}      = "root";
 $detector{"description"} = "Forward Tagger";
 $detector{"pos"}         = "0.*mm 0.*mm $FTbox_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0404B4";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$FTbox_WD*mm $FTbox_WD*mm $FTbox_LN*mm";
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

sub make_FT_Box
{
 $detector{"name"}        = "aa_FT_Box";
 $detector{"mother"}      = "$envelope";
 $detector{"description"} = "Forward Tagger Box Part";
 $detector{"pos"}         = "0.*mm 0.*mm 0.*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "000000";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$FTbox_WD*mm $FTbox_WD*mm $FTbox_LN*mm";
 $detector{"material"}    = "Teflon";
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
 
 $detector{"name"}        = "ab_FT_Insulation";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Forward Tagger Insulation Part";
 $detector{"pos"}         = "0.*mm 0.*mm 0.*m";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "F5F6CE";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$FTins_WD*mm $FTins_WD*mm $FTins_LN*mm";
 $detector{"material"}    = "FTinsfoam";
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

 $detector{"name"}        = "ac_FT_Box";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "FT_A_Box - FT_B_Insulation";
 $detector{"pos"}         = "0*mm 0.0*cm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "000000";
 $detector{"type"}        = "Operation: aa_FT_Box - ab_FT_Insulation";
 $detector{"material"}    = "Teflon";
 $detector{"material"}    = "Component";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = "1";
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
 print_det(\%detector, $file);
 
 $detector{"name"}        = "ad_FT_Front";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Forward Tagger Front Part";
 $detector{"pos"}         = "0.*mm 0.*mm $FTfro_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "BDBDBD";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$FTfro_WD*mm $FTfro_WD*mm $FTfro_TN*mm";
 $detector{"material"}    = "Aluminum";
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
 
 $detector{"name"}        = "FT_Box";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "ac_FT_Box - ad_FT_Front";
 $detector{"pos"}         = "0*mm 0.0*cm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "666666";
 $detector{"type"}        = "Operation: ac_FT_Box - ad_FT_Front";
 $detector{"material"}    = "Teflon";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = "1";
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
 print_det(\%detector, $file);
  
 $detector{"name"}        = "ae_FT_Front";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Forward Tagger Window Part";
 $detector{"pos"}         = "0.*mm 0.*mm 0.*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "BDBDBD";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$FTfro_WD*mm $FTfro_WD*mm $FTfro_TN*mm";
 $detector{"material"}    = "Aluminum";
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
 
 $detector{"name"}        = "ae_FT_Hole";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Forward Tagger Hole Part";
 $detector{"pos"}         = "0.*mm 0.*mm 0.*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CEF6F5";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$FTwin_WD*mm $FTwin_WD*mm $FTfro_TNN*mm";
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
 
 $detector{"name"}        = "FT_Front";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "ad_FT_Front - ae_FT_Hole";
 $detector{"pos"}         = "0*mm 0.0*cm $FTfro_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "E6E6E6";
 $detector{"type"}        = "Operation: ad_FT_Front - ae_FT_Hole";
 $detector{"material"}    = "Aluminum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = "1";
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
 print_det(\%detector, $file);
 
 $detector{"name"}        = "FT_Window";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Forward Tagger Window";
 $detector{"pos"}         = "0.*mm 0.*mm $FTwin_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "B45F04";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$FTwin_WD*mm $FTwin_WD*mm $FTwin_TN*mm";
 $detector{"material"}    = "Kapton";
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
 
 $detector{"name"}        = "ag_FT_Space";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Forward Tagger Space Part";
 $detector{"pos"}         = "0.*mm 0.*mm 0.*m";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CEECF5";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$FTspa_WD*mm $FTspa_WD*mm $FTspa_LN*mm";
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
 
 $detector{"name"}        = "FT_Insulation";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "ab_FT_Insulation - ag_FT_Space";
 $detector{"pos"}         = "0*mm 0.0*cm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "F1F8E0";
 $detector{"type"}        = "Operation: ab_FT_Insulation - ag_FT_Space";
 $detector{"material"}    = "FTinsfoam";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = "1";
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
 print_det(\%detector, $file);
 
 $detector{"name"}        = "FT_Space";
 $detector{"mother"}      = $envelope;
 $detector{"description"} = "Forward Tagger Space";
 $detector{"pos"}         = "0.*mm 0.*mm 0.*m";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CEF6F5";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$FTspa_WD*mm $FTspa_WD*mm $FTspa_LN*mm";
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
# Build Crystal Volume and Assemble calorimeter

if( ( $Nx % 2 ) != 0 || ( $Ny % 2 ) != 0 )
{
 print STDERR  "I only want to work with even numbers ... \nExiting \n";
 die -1;
}

my %Slot ;
my %Chan ;


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
                 # crystal mother volume
                 $detector{"name"}        = "FT_CR_Volume_" . $iX . "_" . $iY ;
                 $detector{"mother"}      = "FT_Space";
                 $detector{"description"} = "FT Crystal mother volume (h:" . $iX . ", v:" . $iY . ")";
                 $locZ=$CShift;
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
                 $detector{"style"}       = "1" ;
                 $detector{"sensitivity"} = "no"; 
                 $detector{"hit_type"}    = "";
                 $detector{"identifiers"} = "";
                 print_det(\%detector, $file);

                  # APD housing
                 $detector{"name"}        = "FT_CR_APD_" . $iX . "_" . $iY ;
                 $detector{"mother"}      = "FT_Space";
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


###########################################################################################
# Define the Copper Disk in front of the Crystals
sub make_FT_Back_Copper
{
 $detector{"name"}        = "FT_Back_Copper";
 $detector{"mother"}      =  "FT_Space";
 $detector{"description"} = "FT Back_Copper";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Bdisk_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6600";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$Bwidth*mm $Bwidth*mm $Bdisk_TN*mm";
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
 $detector{"mother"}      = "FT_Space";
 $detector{"description"} = "FT Back_Plate";
 $detector{"pos"}         = "0.0*cm 0.0*cm $BPlate_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "7F9A65";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$Bwidth*mm $Bwidth*mm $BPlate_TN*mm";
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
 $detector{"mother"}      = "FT_Space";
 $detector{"description"} = "FT Back_MTB";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Bmtb_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0B3B0B";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$Bwidth*mm $Bwidth*mm $Bmtb_TN*mm";
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
 $detector{"mother"}      = "FT_Space";
 $detector{"description"} = "FT Front_Copper";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Fdisk_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6600";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$Bwidth*mm $Bwidth*mm $Fdisk_TN*mm";
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
# Define the CLED monitoring system volume
sub make_FT_LED_system
{
 $detector{"name"}        = "FT_LED_system";
 $detector{"mother"}      = "FT_Space";
 $detector{"description"} = "FT LED system";
 $detector{"pos"}         = "0.0*cm 0.0*cm $L_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "707070 ";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$Lwidth*mm $Lwidth*mm $Llength*mm";
 $detector{"material"}    = "Teflon";
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
# Define the Flux Detector on the front of the crystals
sub make_FT_Flux_Front_1
{
 $detector{"name"}        = "FT_Flux_Front_1";
 $detector{"mother"}      = "root";
 $detector{"description"} = "FT Flux 1";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Flux_Front_1_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "aa0088";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$Bwidth*mm $Bwidth*mm $Flux_TN*mm";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"}  = "FLUX";
 $detector{"hit_type"}     = "FLUX";
 $detector{"identifiers"}  = "id manual 0";
 print_det(\%detector, $file);
}

sub make_FT_Flux_Front_2
{
 $detector{"name"}        = "FT_Flux_Front_2";
 $detector{"mother"}      = "FT_Space";
 $detector{"description"} = "FT Flux 2";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Flux_Front_2_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "aa0088";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$Bwidth*mm $Bwidth*mm $Flux_TN*mm";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"}  = "FLUX";
 $detector{"hit_type"}     = "FLUX";
 $detector{"identifiers"}  = "id manual 1";
 print_det(\%detector, $file);
}

sub make_FT_Flux_Back
{
 $detector{"name"}        = "FT_Flux_Back";
 $detector{"mother"}      = "FT_Space";
 $detector{"description"} = "FT Flux";
 $detector{"pos"}         = "0.0*cm 0.0*cm $Flux_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "aa0088";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$Bwidth*mm $Bwidth*mm $Flux_TN*mm";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"}  = "FLUX";
 $detector{"hit_type"}     = "FLUX";
 $detector{"identifiers"}  = "id manual 2";
 print_det(\%detector, $file);
}


###########################################################################################
sub make_FT_UP_Copper
{
 $detector{"name"}        = "FT_UP_Copper";
 $detector{"mother"}      = "FT_Space";
 $detector{"description"} = "FT Front_Copper";
 $detector{"pos"}         = "0.0*cm $UP_Y*mm $Pdisk_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6600";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$Bwidth*mm $Pdisk_TN*mm $Plength*mm";
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
sub make_FT_DOWN_Copper
{
 $detector{"name"}        = "FT_DOWN_Copper";
 $detector{"mother"}      = "FT_Space";
 $detector{"description"} = "FT Front_Copper";
 $detector{"pos"}         = "0.0*cm $DOWN_Y*mm $Pdisk_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "CC6600";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$Bwidth*mm $Pdisk_TN*mm $Plength*mm";
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


sub make_Tagger
{
 $detector{"name"}        = "FT_proto_tagger";
 $detector{"mother"}      = "root";
 $detector{"description"} = "FT proto Tagger";
 $detector{"pos"}         = "0.*mm 0.*mm 30.*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "BCA9F5";
 $detector{"type"}        = "Box";
 $detector{"dimensions"} = "40.*mm 40.*mm 10.*mm";
 $detector{"material"}    = "Scintillator";
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
sub make_FT_Veto_Counter
{
 $detector{"name"}        = "FT_Veto_Counter";
 $detector{"mother"}      = "root";
 $detector{"description"} = "FT Veto Counter";
 $detector{"pos"}         = "0.0*cm 0.0*cm $VETO_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "3399FF";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$VETO_WD*mm $VETO_WD*mm $VETO_TN*mm";
 $detector{"material"}    = "Scintillator";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "raw";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "";
 print_det(\%detector, $file);
}

###########################################################################################
# Define the XY Detector
sub make_FT_XY
{
 $detector{"name"}        = "FT_XY";
 $detector{"mother"}      = "root";
 $detector{"description"} = "FT XY";
 $detector{"pos"}         = "0.0*cm 0.0*cm $XY_Z*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "C8FE2E";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$XY_WD*mm $XY_WD*mm $XY_TN*mm";
 $detector{"material"}    = "Scintillator";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "raw";
 $detector{"hit_type"}    = "raw";
 $detector{"identifiers"} = "";
 print_det(\%detector, $file);
}





make_FT();
make_FT_Box();

make_Crystals();
make_FT_Back_Copper();
make_FT_Back_Plate();
make_FT_Front_Copper();
make_FT_LED_system();
make_FT_Flux_Front_1();
make_FT_Flux_Front_2();
make_FT_Flux_Back();
make_FT_UP_Copper();
make_FT_DOWN_Copper();
make_FT_Veto_Counter();
make_FT_XY();

















