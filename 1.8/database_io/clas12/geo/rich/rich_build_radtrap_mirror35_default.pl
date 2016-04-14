#!/usr/bin/perl -w

# Perl sctipt used to generate RICH.txt file that is an input to the 
# shell script go_table which puts the RICH geometry in the mysql database 
# for gemc to use.

use strict;
use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);


my $envelope = 'RICH';
my $file     = 'RICH.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

#################################################################
# All dimensions in mm
# check component colors
#################################################################

my $RAD=180/3.1415927;

######################################################
#  RICH BOX:  detector mother volume
#  (G4Trap Volume)
######################################################
#                 x2 
#  __________|___________  
# \          |          /  
#  \      dy1|         /   
#   \        |B = barycenter        
#    --------|-------/      
#  yb \      |      /
#      \     |     /  alfa = opening angle
#       \___ |____/_)____            
#     y0 \   | x1/      
#         \  |  /
#          \ | /
#           \|/
#            C = center
#####################################################


my $RichBox_dz    = 525;        # half depth
my $RichBox_th   = -6.6338;     # central axis inclination
my $RichBox_ph   = 90;          # central axis inclination is a rotation around x axis

my $RichBox_dx1   = 161.658;     # half width entrance window close to beam pipe 
my $RichBox_dx2   = 1810.67;     # half width entrance window maximum radius
my $RichBox_dx3   = 193.181;     # half width rear window close to beam pipe 
my $RichBox_dx4   = 2163.75;     # half width rear window maximum radius

my $RichBox_dy1   = 1575.72;     # half heigth entrance window
my $RichBox_dy2   = 1882.98;     # half heigth rear window

my $RichBox_alp1 = 0;           # rotation entrance window
my $RichBox_alp2 = 0;           # rotation rear window

my $RichBox_x = 0;
my $RichBox_y = 1874.64;
my $RichBox_z = 646.46;

my $RichBox_the = 25.;
my $RichBox_phi = 0.;
my $RichBox_psi = 0.;

sub make_RICH
{
  $detector{"name"}        = "RICH";
  $detector{"mother"}      = "sector";
  $detector{"description"} = "RICH Detector";
  $detector{"pos"}         = "${RichBox_x}*mm ${RichBox_y}*mm ${RichBox_z}*mm";
  $detector{"rotation"}    = "$RichBox_the*deg $RichBox_phi*deg $RichBox_psi*deg";
  $detector{"color"}       = "af4035";
# $detector{"color"}       = "eeee00";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$RichBox_dz*mm $RichBox_th*deg $RichBox_ph*deg $RichBox_dy1*mm $RichBox_dx1*mm $RichBox_dx2*mm $RichBox_alp1*deg $RichBox_dy2*mm $RichBox_dx3*mm $RichBox_dx4*mm $RichBox_alp2*deg";
  $detector{"material"}    = "Methane";
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

######################################################
#  RICH GAP:  inner gap for components 
#  (G4Trap Volume)
######################################################

my $RichGap_dz    = $RichBox_dz-10.;        

my $RichGap_dx1   = 161.658-5.;     # half width entrance window close to beam pipe 
my $RichGap_dx2   = 1810.67-5.;     # half width entrance window maximum radius
my $RichGap_dx3   = 193.181-5.;     # half width rear window close to beam pipe 
#my $RichGap_dx4   = 2163.75-5.;     # half width rear window maximum radius

my $RichGap_dy1   = 1575.72-5.;     # half heigth entrance window
my $RichGap_dy2   = 1882.98-5.;     # half heigth rear window
my $RichGap_dx4   = $RichGap_dx3 + ($RichGap_dx2-$RichGap_dx1)*($RichGap_dy2/$RichGap_dy1) ;     # half width rear window maximum radius

sub make_RICH_GAP
{
  $detector{"name"}        = "RICH_GAP";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "RICH Gap";
  $detector{"pos"}         = "0*mm 0*mm 0*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "af4035";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$RichGap_dz*mm $RichBox_th*deg $RichBox_ph*deg $RichGap_dy1*mm $RichGap_dx1*mm $RichGap_dx2*mm $RichBox_alp1*deg $RichGap_dy2*mm $RichGap_dx3*mm $RichGap_dx4*mm $RichBox_alp2*deg";
  $detector{"material"}    = "Methane";
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

# reference points of entrance window 
my $RichGap_opa1  =  2*$RichGap_dy1/($RichGap_dx2-$RichGap_dx1);     # opening angle
my $RichGap_yc1   =  $RichGap_opa1*($RichGap_dx1+$RichGap_dx2)/2.;   # barycenter height with respect the center
my $RichGap_yb1   =  $RichGap_yc1 - $RichGap_dy1;                    # bottom level with respect the center
# rear window 
my $RichGap_opa2  =  2*$RichGap_dy2/($RichGap_dx4-$RichGap_dx3);     # rear window tg(alfa)
my $RichGap_yc2   =  $RichGap_opa2*($RichGap_dx3+$RichGap_dx4)/2.-$RichGap_dz*tan($RichBox_th/$RAD);   # barycenter height with respect the center
my $RichGap_yb2   =  $RichGap_yc2 - $RichGap_dy2;                    # bottom level with respect the center

print "Rich offsets  $RichGap_opa1 $RichGap_yc1 $RichGap_yb1 $RichBox_y \n";
print "Rich offsets  $RichGap_opa2 $RichGap_yc2 $RichGap_yb2 $RichBox_y\n";


######################################################
#  PREMIRROR:  plane mirror at the RICH entrance window
#  (G4Trap Volume)
######################################################

my $PreMirror_dz    = 1.0;
my $PreMirror_th   = -5.;
my $PreMirror_ph   = 90.;

my $PreMirror_dy1   = $RichGap_dy1;
my $PreMirror_dy2   = $PreMirror_dy1;

my $PreMirror_dx1   = ($RichGap_yc1 - $PreMirror_dy1)/$RichGap_opa1;
my $PreMirror_dx2   = ($RichGap_yc1 + $PreMirror_dy1)/$RichGap_opa1;
my $PreMirror_dx3   = $PreMirror_dx1;
my $PreMirror_dx4   = $PreMirror_dx2;

my $PreMirror_alp1 = 0;
my $PreMirror_alp2 = 0;

my $PreMirror_x = 0.;
my $PreMirror_z = $PreMirror_dz-$RichGap_dz;
my $PreMirror_y = $PreMirror_z *  tan($RichBox_th/$RAD);

sub make_PREMIRROR
{
  $detector{"name"}        = "PREMIRROR";
  $detector{"mother"}      = "RICH_GAP";
  $detector{"description"} = "Secondary mirror";
  $detector{"pos"}         = "${PreMirror_x}*mm ${PreMirror_y}*mm ${PreMirror_z}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       =  "99eeff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$PreMirror_dz*mm $PreMirror_th*deg $PreMirror_ph*deg $PreMirror_dy1*mm $PreMirror_dx1*mm $PreMirror_dx2*mm $PreMirror_alp1*deg $PreMirror_dy2*mm $PreMirror_dx3*mm $PreMirror_dx4*mm $PreMirror_alp2*deg";
  $detector{"material"}    = "Air_Opt";
  $detector{"mfield"}      = "no";
  $detector{"ncopy"}       = 1;
  $detector{"pMany"}       = 1;
  $detector{"exist"}       = 1;
  $detector{"visible"}     = 1;
  $detector{"style"}       = 1;
  $detector{"sensitivity"} = "no";#FLUX";
  $detector{"hit_type"}    = "";#FLUX";
  $detector{"identifiers"} = "";#Mirror WithSurface: 0 With Finish: 0 Refraction Index: 1000000 With Reflectivity:  1000000 With Efficiency:      0  WithBorderVolume: MirrorSkin";

  print_det(\%detector, $file);
}

######################################################
#  BOXMIRROR:  plane mirror enclosing the RICH gap
#  (Composite Volume)
######################################################

$detector{"mfield"}      = "no";
$detector{"ncopy"}       = 1;
$detector{"pMany"}       = 1;
$detector{"exist"}       = 1;
$detector{"visible"}     = 1;
$detector{"style"}       = 0;
$detector{"sensitivity"} = "no";
$detector{"hit_type"}    = "";
$detector{"identifiers"} = "";

sub make_rich_boxmirror_a
{
  $detector{"name"}        = "AAi_rich_boxmirror";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Box of mirrors";
  $detector{"pos"}         = "0*mm 0*mm 0*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "99eeff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$RichBox_dz*mm $RichBox_th*deg $RichBox_ph*deg $RichBox_dy1*mm $RichBox_dx1*mm $RichBox_dx2*mm $RichBox_alp1*deg $RichBox_dy2*mm $RichBox_dx3*mm $RichBox_dx4*mm $RichBox_alp2*deg";
#  $detector{"material"}    = "Methane";
  $detector{"material"}    = "Component";

  print_det(\%detector, $file);
}

sub make_rich_boxmirror_b
{
  $detector{"name"}        = "AAj_rich_boxmirror";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Box of mirrors";
  $detector{"pos"}         = "0*mm 0*mm 0*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "99eeff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$RichGap_dz*mm $RichBox_th*deg $RichBox_ph*deg $RichGap_dy1*mm $RichGap_dx1*mm $RichGap_dx2*mm $RichBox_alp1*deg $RichGap_dy2*mm $RichGap_dx3*mm $RichGap_dx4*mm $RichBox_alp2*deg";
#  $detector{"material"}    = "Methane";
  $detector{"material"}    = "Component";

  print_det(\%detector, $file);
}

sub make_rich_boxmirror
{
  $detector{"name"}        = "rich_boxmirror";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Box of mirrors";
  $detector{"pos"}         = "0*mm 0*mm 0*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "99eeff";
  $detector{"type"}        = "Operation: AAi_rich_boxmirror - AAj_rich_boxmirror";
  $detector{"dimensions"}  = "0";
  $detector{"material"}    = "Methane";
  $detector{"ncopy"}       = 1;
  $detector{"pMany"}       = 1;
  $detector{"exist"}       = 1;
  $detector{"visible"}     = 1;
  $detector{"style"}       = 0;
  $detector{"sensitivity"} = "no";#FLUX";
  $detector{"hit_type"}    = "";#FLUX";
  $detector{"identifiers"} = "";#Mirror WithSurface: 0 With Finish: 0 Refraction Index: 10000000 With Reflectivity:  1000000 With Efficiency:      0  WithBorderVolume: MirrorSkin";

  print_det(\%detector, $file);
}



######################################################
#  RADIATORs:  radiator wall separated into slices of
#              different thickness or refractive index
#  (G4Trap Volume)
######################################################
#  __________|____________ _ RichGap_y0 + 2*RichGap_dy1 
# \          | rad.5    /  
#  \---------|---------/ - - h4  
#   \--------|--------/ - -- h3
#    \-------|-------/ - - - h2 
#     \------|------/ - - -- h1
#      \     |rad.1/  
#       \___ |____/ _ _ _ _  RichGap_y0        
#
#####################################################


my $number_of_radiators= 5;

my @RadiSlice_h    = ( 0.0 , 1000.0 , 1300.0 ,  1600.0 , 1900.0 , 2*$RichGap_dy1); 
my @RadiSlice_dz   = ( 10.0 , 15.0 , 20.0 , 25.0 , 30.0 );

my $RadiSlice_th   = -5.;
my $RadiSlice_ph   = 90.;

my $RadiSlice_Alp1 = 0;
my $RadiSlice_Alp2 = 0;

sub make_RADIATOR
{
 for(my $m = 0; $m < $number_of_radiators; $m++)
   {
    my $n = $m+1;   

    my $RadiSlice_x1  = ($RadiSlice_h[$m] + $RichGap_yb1 )/$RichGap_opa1;
    my $RadiSlice_x2  = ($RadiSlice_h[$n] + $RichGap_yb1 )/$RichGap_opa1;
    my $RadiSlice_x3  = $RadiSlice_x1;
    my $RadiSlice_x4  = $RadiSlice_x2;

    my $RadiSlice_dy1  = ($RadiSlice_h[$n]-$RadiSlice_h[$m])/2.;
    my $RadiSlice_dy2  = $RadiSlice_dy1;

    my $RadiSlice_x = 0.;
    my $RadiSlice_z = $PreMirror_z + $PreMirror_dz + $RadiSlice_dz[$m];
    my $RadiSlice_y = $RadiSlice_z *  tan($RichBox_th/$RAD) + ($RadiSlice_h[$n]-$RadiSlice_dy1-$RichGap_dy1);
 
    $detector{"name"}        = "RADIATOR_$m";
    $detector{"mother"}      = "RICH_GAP";
    $detector{"description"} = "Aerogel Radiator";
    $detector{"pos"}         = "$RadiSlice_x*mm $RadiSlice_y*mm $RadiSlice_z*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = "111000";
    $detector{"type"}        = "G4Trap";
    $detector{"dimensions"}  = "$RadiSlice_dz[$m]*mm $RadiSlice_th*deg $RadiSlice_ph*deg $RadiSlice_dy1*mm $RadiSlice_x1*mm $RadiSlice_x2*mm $RadiSlice_Alp1*deg $RadiSlice_dy2*mm $RadiSlice_x3*mm $RadiSlice_x4*mm $RadiSlice_Alp2*deg";
    $detector{"material"}    = "RichAerogel5";
#   $detector{"material"}    = "Methane";
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
}


######################################################
#  DETECTOR:  plane of MA-PMTs
#  (Composite Volume)
######################################################

# H8500 
my $type=0;  

my $MAPMT_TYPEs = 4 ;
my @MAPMT_name      = ('H8500', 'H8500_03', 'R8900', 'R8900_C');
my @MAPMT_descr     = ('H8500', 'H8500_03', 'R8900', 'R8900_C');
my @MAPMT_color     = ('0000ee', '0000ee', 'ff44ff', 'ee99ff');

my @MAPMT_DX        = (52./2., 52./2., 25./2., 25./2.);
my @MAPMT_DY        = (52./2., 52./2., 25./2., 25./2.);
my @MAPMT_DZ        = (28./2., 28./2., 25./2., 25./2.);
my @MAPMT_DXSPACE    = (1.0/2., 0.0/2., 0.0/2., 0.0/2.);
my @MAPMT_DYSPACE    = (1.0/2., 0.0/2., 0.0/2., 0.0/2.);

my @PhCath_DX       = ((7*6.08+5.8)/2., 5.8/2., 5.5/2., 5.5/2.);
my @PhCath_DY       = ((7*6.08+5.8)/2., 5.8/2., 5.5/2., 5.5/2.);
my $PhCath_DZ       = 1.0;

my $PhWindow_DZ     = 1.5/2.;

my $MAPMT_Z = $RichGap_dz - $MAPMT_DZ[$type];

my $X_START  =  -$RichGap_dx4;
my $X_END    =   $RichGap_dx4;
my $Y_START  =  -$RichGap_dy2 + $MAPMT_Z * tan($RichBox_th/$RAD);
my $Y_END    =   $Y_START + 1200.;
print "MAPMTS limits $X_START $X_END $Y_START $Y_END $MAPMT_Z \n";


# Photon Detector Volume

my $MAX_NUM = 200;
my $iy=0;

sub make_MAPMT
{
  # be sure MAPMT is contained at the bottom ot the RICH Gap
  my $Bottom_opa = ($RichGap_dy2-$RichGap_dz*tan($RichBox_th/$RAD)-$RichGap_dy1)/2/$RichGap_dz;
  my $MAPMT_Y = $Y_START+$MAPMT_DY[$type]+2*$MAPMT_DZ[$type]*$Bottom_opa;
  
  for(my $n1=1; $n1<=$MAX_NUM; $n1++)
  {
    if($MAPMT_Y <  $Y_START+$MAPMT_DY[$type] || $MAPMT_Y >  $Y_END-$MAPMT_DY[$type]){next;}

    my $MAPMT_Xmi     = -($RichGap_yc2 + $MAPMT_Y - $MAPMT_DY[$type])/$RichGap_opa2;  #left line
    my $MAPMT_Xma     = ($RichGap_yc2 + $MAPMT_Y - $MAPMT_DY[$type])/$RichGap_opa2;  #right line
    my $MAPMT_Xnum    = ($MAPMT_Xma-$MAPMT_Xmi)/2/($MAPMT_DX[$type] + $MAPMT_DXSPACE[$type]);
    my $MAPMT_num     = int($MAPMT_Xnum);
    my $MAPMT_Xmargin = ($MAPMT_Xma-$MAPMT_Xmi)/2.-$MAPMT_num*($MAPMT_DX[$type] + $MAPMT_DXSPACE[$type]) + $MAPMT_DXSPACE[$type];
    my $MAPMT_X    = $MAPMT_Xmi + $MAPMT_Xmargin + $MAPMT_DX[$type];
#    my $MAPMT_X    = $MAPMT_Xmi+$MAPMT_DX[$type];
#    print "== $n1 $MAX_NUM SMAPMT_Y $Y_START $Y_END $MAPMT_Xnum $MAPMT_num \n";

    for(my $n2=1; $n2<=$MAX_NUM; $n2++)
    {

      if($MAPMT_X < $X_START + $MAPMT_DX[$type] || $MAPMT_X > $X_END - $MAPMT_DX[$type]
      || $MAPMT_X < $MAPMT_Xmi + $MAPMT_DX[$type] || $MAPMT_X > $MAPMT_Xma - $MAPMT_DX[$type]){next;}
#      print "==== $n2 $MAX_NUM $MAPMT_X $X_START $X_END $MAPMT_Xmi $MAPMT_Xma \n";

      my $padnumber            = $iy+1;
      $detector{"name"}        = "$MAPMT_name[$type]_$padnumber";
      $detector{"mother"}      = "RICH_GAP";
      $detector{"pos"}         = "${MAPMT_X}*mm ${MAPMT_Y}*mm ${MAPMT_Z}*mm";
      $detector{"rotation"}    = "0*deg 0*deg 0*deg";
      $detector{"color"}       = "$MAPMT_color[$type]";
      if($padnumber==1){
           $detector{"type"}        = "Box";
           $detector{"dimensions"}  = "$MAPMT_DX[$type]*mm $MAPMT_DY[$type]*mm $MAPMT_DZ[$type]*mm";
           print "Base MAPMT $iy $MAPMT_X $MAPMT_Y $iy $padnumber\n"; 
      }
      if($padnumber>1){
           $detector{"type"}        = "CopyOf $MAPMT_name[0]_1";
           $detector{"dimensions"}  = "0*mm";
           print "Copy MAPMT $iy $MAPMT_X $MAPMT_Y $iy $padnumber\n"; 
      }
      $detector{"description"} = "MAPMT $padnumber";
      $detector{"ncopy"}       = $padnumber;
#     $detector{"material"}    = "Glass";
      $detector{"material"}    = "Air_Opt";
      $detector{"mfield"}      = "no";
      $detector{"pMany"}       = 1;
      $detector{"exist"}       = 1;
      $detector{"visible"}     = 1;
      $detector{"style"}       = 0;
      $detector{"sensitivity"} = "no";
      $detector{"hit_type"}    = "";
      $detector{"identifiers"} = "";

      print_det(\%detector, $file);

      if($padnumber==1){
          print "---> Generate PhWindow for $MAPMT_name[$type]_$padnumber \n";

	        my $PhWindow_X = 0.0;
	        my $PhWindow_Y = 0.0;
	        my $PhWindow_Z = -$MAPMT_DZ[$type] + $PhWindow_DZ;

                $detector{"name"}        = "PhWindow";
                $detector{"mother"}      = "$MAPMT_name[$type]_$padnumber";
                $detector{"description"} = "PMT Glass window";
                $detector{"pos"}         = "$PhWindow_X*mm $PhWindow_Y*mm $PhWindow_Z*mm";
                $detector{"rotation"}    = "0.*deg 0.*deg 0.*deg";
		$detector{"color"}       = "004000";
                $detector{"type"}        = "Box";
                $detector{"dimensions"}  = "$MAPMT_DX[$type]*mm $MAPMT_DY[$type]*mm $PhWindow_DZ*mm";
                $detector{"material"}    = "Glass";
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
  

          print "---> Generate PhCathode for $MAPMT_name[$type]_$padnumber \n";
                my $PhCath_X   = 0;
                my $PhCath_Y   = 0;
                my $PhCath_Z   = $PhWindow_Z + $PhWindow_DZ + 2.*$PhCath_DZ;
  
                $detector{"name"}        = "PhCath";
                $detector{"mother"}      = "$MAPMT_name[$type]_$padnumber";
                $detector{"description"} = "Bialkali Photo Cathode";
                $detector{"pos"}         = "${PhCath_X}*mm ${PhCath_Y}*mm ${PhCath_Z}*mm";
                $detector{"rotation"}    = "0.*deg 0.*deg 0.*deg";
		#$detector{"color"}       = "${MAPMT_color[$type]}";
		$detector{"color"}       = "000200";
                $detector{"type"}        = "Box";
                $detector{"dimensions"}  = "$PhCath_DX[$type]*mm $PhCath_DY[$type]*mm $PhCath_DZ*mm";
                $detector{"material"}    = "Air_Opt";
                $detector{"mfield"}      = "no";
                $detector{"ncopy"}       = 1;
                $detector{"pMany"}       = 1;
                $detector{"exist"}       = 1;
                $detector{"visible"}     = 1;
                $detector{"style"}       = 1;
                $detector{"sensitivity"} = "RICH";
                $detector{"hit_type"}    = "RICH"; 
                $detector{"identifiers"} = "sector ncopy 0 pad manual $padnumber pixel manual 1";

                print_det(\%detector, $file);
  

          print "---> Generate PMT Socket for $MAPMT_name[$type]_$padnumber \n";
	 	my $PMTSocket_DZ = 1.0;

	        my $PMTSocket_X = 0.0;
	        my $PMTSocket_Y = 0.0;
	        my $PMTSocket_Z = 0.0;

	        $detector{"name"}        = "PMTSocket";
	        $detector{"mother"}      = "$MAPMT_name[$type]_$padnumber";
	        $detector{"description"} = "PMT Socket";
	        $detector{"pos"}         = "$PMTSocket_X*mm $PMTSocket_Y*mm $PMTSocket_Z*mm";
	        $detector{"rotation"}    = "0.*deg 0.*deg 0.*deg";
		$detector{"color"}       = "005000";
	        $detector{"type"}        = "Box";
	        $detector{"dimensions"}  = "$MAPMT_DX[$type]*mm $MAPMT_DY[$type]*mm $PMTSocket_DZ*mm";
	        $detector{"material"}    = "G4_Cu";
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

      $iy++;

      $MAPMT_X += 2*($MAPMT_DX[$type] + $MAPMT_DXSPACE[$type]);
    }
   $MAPMT_Y += 2*($MAPMT_DY[$type] + $MAPMT_DYSPACE[$type]);
  }
  print "$iy pads in total\n";
}


make_RICH();
make_RICH_GAP();
make_RADIATOR();
make_MAPMT();

######################################################
#  FOCUSING MIRROR:  elliptical mirror reflecting light back
#  (Composite Volume)
######################################################

# None of these components are sensitive.
#$detector{"mfield"}      = "no";
#$detector{"ncopy"}       = 1;
#$detector{"pMany"}       = 1;
#$detector{"exist"}       = 1;
$detector{"visible"}     = 1;
$detector{"style"}       = 1;
#$detector{"sensitivity"} = "no";
#$detector{"hit_type"}    = "";
#$detector{"identifiers"} = "";


my $number_of_mirrors = 2;
my $mthick  = 1.0;  # mirror is 1mm thick
my $rthick  = 1.0;  # radiator is 10 cm thick

# SEMI Axis
my @axisA   = ( 3700.000 + $mthick  , 3700.000  ,  1786.859   ,  1728.375  );  # Semiaxis A
my @axisB   = ( 3700.000 + $mthick  , 3700.000  ,  1786.859   ,  1728.375  );  # Semiaxis A
my @axisC   = ( 4400.000 + $mthick  , 4400.000  ,  1497.604   ,  1383.621  );  # Semiaxis C

my @axisAv  = ( $axisA[0] - $mthick ,  $axisA[1] - $rthick  ,   $axisA[2]  - $mthick ,  $axisA[3]- $mthick  );  # Semiaxis A thickness
my @axisBv  = ( $axisB[0] - $mthick ,  $axisB[1] - $rthick  ,   $axisB[2]  - $mthick ,  $axisB[3]- $mthick  );  # Semiaxis B thickness
my @axisCv  = ( $axisC[0] - $mthick ,  $axisC[1] - $rthick  ,   $axisC[2]  - $mthick ,  $axisC[3]- $mthick  );  # Semiaxis C thickness


# The first focal point is the target
# The second focal point position is given below (left mirror).
# For an ellipse, the distance between the two focal points is    d = 2 sqrt(a2-b2)
# http://en.wikipedia.org/wiki/Ellipse

# G4 colors
my @mirror_color      = ('99eeff', 'ee99ff', 'ff44ff', 'ffee55');
my @mirror_style      = (1, 0, 0, 0);

my $mirror_y0         = -319.06;
#my $mirror_z0         = -3811.5;
#my $mirror_z0        = -3751.5;    #base
my $mirror_z0        = -3765.5;    #base

sub make_rich_mirror_a
{
 for(my $m = 0; $m < $number_of_mirrors; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "AAl_rich_mirror$mind";
    $detector{"mother"}      = "RICH_GAP";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Ellipsoid part 1";
    $detector{"pos"}         = "0*mm 0*mm 0*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Ellipsoid";
    $detector{"dimensions"}  = "$axisA[$m]*mm $axisB[$m]*mm $axisC[$m]*mm 0*mm 0*mm";
#    $detector{"material"}    = "Methane";
    $detector{"material"}    = "Component";
    $detector{"identifiers"} = "";

    print_det(\%detector, $file);
 }
}

sub make_rich_mirror_b
{
 for(my $m = 0; $m < $number_of_mirrors; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "AAm_rich_mirror$mind";
    $detector{"mother"}      = "RICH_GAP";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Ellipsoid part 2";
    $detector{"pos"}         = "0*mm 0*mm 0*mm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Ellipsoid";
    $detector{"dimensions"}  = "$axisAv[$m]*mm $axisBv[$m]*mm $axisCv[$m]*mm 0*mm 0*mm";
#    $detector{"material"}    = "Methane";
    $detector{"material"}    = "Component";

    print_det(\%detector, $file);
 }
}

sub make_rich_mirror_c
{
 for(my $m = 0; $m < $number_of_mirrors; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "AAn_rich_mirror$mind";
    $detector{"mother"}      = "RICH_GAP";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Ellipsoid part1 - part2";
    $detector{"pos"}         = "0*mm $mirror_y0*mm $mirror_z0*mm"; 
    $detector{"rotation"}    = "-25*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Operation: AAl_rich_mirror$mind - AAm_rich_mirror$mind";
    $detector{"dimensions"}  = "0";
    $detector{"style"}       = "0";
#    $detector{"material"}    = "Methane";
    $detector{"material"}    = "Component";
    $detector{"identifiers"} = "";

    print_det(\%detector, $file);
 }
}


######################################################
#  RICH GEOMETRY:  dummy components for geometry cuts
#  (Various Volumes)
######################################################

sub make_rich_cutbox
{
 $detector{"name"}        = "AAo_rich_cutbox";
 $detector{"mother"}      = "RICH_GAP";
 $detector{"description"} = "Box used to cut the mirrors";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "10000*mm 10000*mm 10000*mm";
# $detector{"material"}    = "Methane";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);
}

my $CutGap_fr   =   0.69;

my $CutGap_th   =  0.0;
my $CutGap_ph   =  0.0;

my $CutGap_dy1  =  $RichGap_dy1*$CutGap_fr;
my $CutGap_dy2  =  $RichGap_dy2*$CutGap_fr;

my $CutGap_yc1  =  $RichGap_yb1+2*$RichGap_dy1-$CutGap_dy1;
my $CutGap_yc2  =  $RichGap_yb2+2*$RichGap_dy2-$CutGap_dy2;
my $CutGap_dx1  =  ($CutGap_yc1 - $CutGap_dy1)/$RichGap_opa1; 
my $CutGap_dx2  =  ($CutGap_yc1 + $CutGap_dy1)/$RichGap_opa1; 
my $CutGap_dx3  =  ($CutGap_yc2 - $CutGap_dy2)/$RichGap_opa2; 
my $CutGap_dx4  =  ($CutGap_yc2 + $CutGap_dy2)/$RichGap_opa2; 

my $CutGap_dz   =  $RichGap_dz-$RadiSlice_dz[4];

my $CutGap_y0   =  +($RichGap_dy1+$RichGap_dy2)/2.-($CutGap_dy1+$CutGap_dy2)/2.-$mirror_y0;
my $CutGap_z0   =  $RadiSlice_dz[4]-$mirror_z0;
my $CutGap_y    = cos(25./$RAD)*$CutGap_y0+sin(25./$RAD)*$CutGap_z0;
my $CutGap_z    = -sin(25./$RAD)*$CutGap_y0+cos(25./$RAD)*$CutGap_z0;

sub make_rich_cutgap
{
  $detector{"name"}        = "AAp_rich_cutgap";
  $detector{"mother"}      = "RICH_GAP";
  $detector{"description"} = "Box for cut";
  $detector{"pos"}         = "0*mm $CutGap_y*mm $CutGap_z*mm";
  $detector{"rotation"}    = "25*deg 0*deg 0*deg";
  $detector{"color"}       = "99eeff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$CutGap_dz*mm $CutGap_th*deg $CutGap_ph*deg $CutGap_dy1*mm $CutGap_dx1*mm $CutGap_dx2*mm $RichBox_alp1*deg $CutGap_dy2*mm $CutGap_dx3*mm $CutGap_dx4*mm $RichBox_alp2*deg";
#  $detector{"material"}    = "Methane";
  $detector{"material"}    = "Component";

  print_det(\%detector, $file);
}

my $CutDummy_y0   =  +($RichGap_dy1+$RichGap_dy2)/2.-($CutGap_dy1+$CutGap_dy2)/2.;
my $CutDummy_z0   =  $RadiSlice_dz[4];
sub make_rich_cutdummy
{
  $detector{"name"}        = "rich_cutdummy";
  $detector{"mother"}      = "RICH_GAP";
  $detector{"description"} = "Box for cut";
  $detector{"pos"}         = "0*mm $CutDummy_y0*mm $CutDummy_z0*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "008000";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$CutGap_dz*mm $CutGap_th*deg $CutGap_ph*deg $CutGap_dy1*mm $CutGap_dx1*mm $CutGap_dx2*mm $RichBox_alp1*deg $CutGap_dy2*mm $CutGap_dx3*mm $CutGap_dx4*mm $RichBox_alp2*deg";
  $detector{"material"}    = "Methane";
#  $detector{"material"}    = "Component";

  print_det(\%detector, $file);
}

sub make_rich_cut
{
  $detector{"name"}        = "AAq_rich_cut";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Open space for mirrors";
  $detector{"pos"}         = "0*mm 0*mm 0*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "99eeff";
  $detector{"type"}        = "Operation: AAo_rich_cutbox - AAp_rich_cutgap";
  $detector{"dimensions"}  = "0";
#  $detector{"material"}    = "Methane";
  $detector{"material"}    = "Component";

  print_det(\%detector, $file);
}


sub make_rich_mirror
{
    #for(my $m = 0; $m < $number_of_mirrors; $m++)
 for(my $m = 0; $m < 1; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "AAr_rich_mirror$mind";
    $detector{"mother"}      = "RICH_GAP";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Ellipsoid part1 - part2";
    $detector{"pos"}         = "0*mm $mirror_y0*mm $mirror_z0*mm";  # shift per zona morta
    $detector{"rotation"}    = "-25*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Operation: AAn_rich_mirror$mind - AAq_rich_cut";
    $detector{"dimensions"}  = "0";
    $detector{"material"}    = "Methane";
#    $detector{"material"}    = "Component";
    $detector{"ncopy"}       = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "no";#FLUX";
    $detector{"hit_type"}    = "";#FLUX";
    $detector{"identifiers"} = "";#Mirror WithSurface: 0 With Finish: 0 Refraction Index: 10000000 With Reflectivity:  1000000 With Efficiency:      0  WithBorderVolume: MirrorSkin";

    print_det(\%detector, $file);
  }
}


make_PREMIRROR();
#make_rich_boxmirror_a();
#make_rich_boxmirror_b();
#make_rich_boxmirror();
make_rich_mirror_a();
make_rich_mirror_b();
make_rich_mirror_c();
make_rich_cutbox();
make_rich_cutgap();
#make_rich_cutdummy();
make_rich_cut();
make_rich_mirror();
