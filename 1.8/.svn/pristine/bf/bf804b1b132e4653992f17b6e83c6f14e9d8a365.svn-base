#!/usr/bin/perl -w

# Perl sctipt used to generate RICH.txt file that is an input to the 
# shell script go_table which puts the RICH geometry in the mysql database 
# for gemc to use.

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use Getopt::Long;
use Math::Trig;


my $config_file = 'rich.config';

# Load configuration
my %configuration = load_configuration($config_file); 

# Load parameters from mysql database
my %parameters    = download_parameters(%configuration);

# Assign paramters to local variables
my $RichHall_z = $parameters{"RichHall_z"};



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


######################################################
#        
#  ________ x2 _________  
# \                    /  
#  \                  /   
#   \                /   
#    \              /      y1
#     \            /
#      \          /
#       \__ x1 __/            
#       
#####################################################


# RICH half length (G4Trap)
#my $RichHall_z    = 620; # Thick radiator for ring focalization studies
my $RichHall_th   = -5;
my $RichHall_ph   = 90;

my $RichHall_x1   = 140.000;
my $RichHall_x2   = 1568.09;
my $RichHall_x3   = 167.272;
my $RichHall_x4   = 1868.03;
my $RichHall_y1   = 1446.89;
my $RichHall_y2   = 1723.17;

my $RichHall_Alp1 =0;
my $RichHall_Alp2 =0;

my $RichPosX = 0;
my $RichPosY = 1743.31;
my $RichPosZ = 233.730;

my $RotPhi = 25.;
my $RotThe = 0.;
my $RotPsi = 0.;

my $AA = 2*$RichHall_y1/($RichHall_x1-$RichHall_x2);
my $BB =  $RichHall_y1*($RichHall_x1+$RichHall_x2)/($RichHall_x1-$RichHall_x2);
my $CC = 2*$RichHall_y2/($RichHall_x3-$RichHall_x4);
my $DD =  $RichHall_y2*($RichHall_x3+$RichHall_x4)/($RichHall_x3-$RichHall_x4);

print "slopes $AA $BB\n";


#PLANEMIRROR half length (G4Trap)
my $PlanemirrorHall_z    = 1.0;
my $PlanemirrorHall_th   = -5.;
my $PlanemirrorHall_ph   = 90.;
my $PlanemirrorHall_y1   = $RichHall_y1;
my $PlanemirrorHall_x1   = ($BB + $PlanemirrorHall_y1)/$AA;
my $PlanemirrorHall_x2   = ($BB - $PlanemirrorHall_y1)/$AA;
my $PlanemirrorHall_Alp1 = 0;
my $PlanemirrorHall_y2   = $PlanemirrorHall_y1;
my $PlanemirrorHall_x3   = $PlanemirrorHall_x1;
my $PlanemirrorHall_x4   = $PlanemirrorHall_x2;
my $PlanemirrorHall_Alp2 = 0;
my $PlanemirrorPosX = 0.;
my $PlanemirrorPosZ = $PlanemirrorHall_z-$RichHall_z;
my $PlanemirrorPosY = $PlanemirrorPosZ *  tan($RichHall_th/57.3);


#RADIATOR half length (G4Trap)
#my $RadiHall_z    = 5.0;
#my $RadiHall_z    = 10.0;
my $RadiHall_z    = 15.0;   # standard
#my $RadiHall_z    = 100.0;   # Thick radiator for ring focalization studies
my $RadiHall_th   = -5.;
my $RadiHall_ph   = 90.;
my $RadiHall_y1   = $RichHall_y1;
my $RadiHall_x1   = ($BB + $RadiHall_y1)/$AA;
my $RadiHall_x2   = ($BB - $RadiHall_y1)/$AA;
my $RadiHall_Alp1 = 0;
my $RadiHall_y2   = $RadiHall_y1;
my $RadiHall_x3   = $RadiHall_x1;
my $RadiHall_x4   = $RadiHall_x2;
my $RadiHall_Alp2 = 0;
my $RadiPosX = 0.;
my $RadiPosZ = $PlanemirrorPosZ + $PlanemirrorHall_z + $RadiHall_z;
my $RadiPosY = $RadiPosZ *  tan($RichHall_th/57.3);
#my $RadiPosY = 0.;



#QUARTZ Window half length (G4Trap)
#my $QuarHall_z    = 15.0;
#my $QuarHall_th   = 0.;
#my $QuarHall_ph   = 0.;
#my $QuarHall_y1   = 810.0;
#my $QuarHall_x1   = ($BB + $QuarHall_y1)/$AA - 100;
#my $QuarHall_x2   = ($BB - $QuarHall_y1)/$AA - 100;
#my $QuarHall_Alp1 = 0;
#my $QuarHall_y2   = $QuarHall_y1;
#my $QuarHall_x3   = $QuarHall_x1;
#my $QuarHall_x4   = $QuarHall_x2;
#my $QuarHall_Alp2 = 0;
#my $QuarPosX = 0.;
#my $QuarPosY = 0.;
#my $QuarPosZ = $RadiPosZ + $RadiHall_z + $QuarHall_z;


#Gap half length (G4Trap)
#my $GapHall_z    = 500.0;
my $GapHall_z    = $RichHall_z-$PlanemirrorHall_z-$RadiHall_z-0.5; # Thick radiator for ring focalization studies
my $GapHall_th   = -5.;
my $GapHall_ph   = 90.;
my $GapHall_y1   = $RichHall_y1; 
my $GapHall_x1   = ($BB + $GapHall_y1)/$AA;
my $GapHall_x2   = ($BB - $GapHall_y1)/$AA;
my $GapHall_Alp1 = 0;
my $GapHall_y2   =  $RichHall_y2;
my $GapHall_x3   =  ($DD + $GapHall_y2)/$CC;
my $GapHall_x4   =  ($DD - $GapHall_y2)/$CC;
my $GapHall_Alp2 = 0;
my $GapPosX = 0;
my $GapPosZ = $RadiPosZ + $RadiHall_z + $GapHall_z;
my $GapPosY = $GapPosZ *  tan($RichHall_th/57.3);



#Detec half length (Box)
#my $DetecX = 574.;
#my $DetecY = 2295.9;
#my $DetecZ = 1.0;
#my $DetecPosX = 0;
#my $DetecPosY = 0;
#my $DetecPosZ = $GapPosZ + $GapHall_z + $DetecZ;
#Detec half length (Trap)
my $DetecHall_z    = 5.0;
my $DetecHall_th   = -5.;
my $DetecHall_ph   = 90.;
#my $DetecHall_y1   = $RichHall_y1+250;
#my $DetecHall_x1   = ($BB + $DetecHall_y1)/$AA+150;
#my $DetecHall_x2   = ($BB - $DetecHall_y1)/$AA+150;
my $DetecHall_y1   = 500;
my $DetecHall_x1   = 150;
my $DetecHall_x2   = 650;
my $DetecHall_y2   = $DetecHall_y1;
my $DetecHall_x3   = $DetecHall_x1;
my $DetecHall_x4   = $DetecHall_x2;
my $DetecHall_Alp1 = 0;
my $DetecHall_Alp2 = 0;
my $DetecPosX = 0.;
my $DetecPosZ = $GapPosZ + $GapHall_z + $DetecHall_z;
#my $DetecPosY = $DetecPosZ *  tan($RichHall_th/57.3);
my $DetecPosY = -1250;


##Pad half length (Box)
#my $PadX = 5;
#my $PadY = 5;
#my $PadX = 7;
#my $PadY = 7;
my $PadX = 25;
my $PadY = 25;
my $PadZ = 0.5;
#my $PAD_XSPACE = 1.0;
#my $PAD_YSPACE = 1.0;
my $PAD_XSPACE = 0.1;
my $PAD_YSPACE = 0.1;
my $PadPosZ = $GapPosZ + $GapHall_z + $PadZ;

my $X_START =  -$RichHall_x4;
my $X_END   =   $RichHall_x4;
#my $X_START =  -$RichHall_x4+$PadX;
#my $X_END   =   $RichHall_x4+$PadX;
#my $X_START =  -$RichHall_x4+$PadX*2;
#my $X_END   =   $RichHall_x4+$PadX*2;
my $Y_START =  -$RichHall_y2 + $PadPosZ * tan($RichHall_th/57.3);
#my $Y_END   =   $PadPosZ * tan($RichHall_th/57.3);
#my $Y_END   =   $PadPosZ * (tan($RichHall_th/57.3)-tan(15./57.3));
my $Y_END   = $Y_START + 900;


#PhotoCathode
#my $PhCathX = 5;
#my $PhCathY = 5;
my $PhCathX = 20;
my $PhCathY = 20;
my $PhCathZ = 1.0;
my $PhCathPosX = 0;
my $PhCathPosY = 0;
my $PhCathPosZ =  $PadZ;



# Mother Volume
sub make_RICH
{
  $detector{"name"}        = "RICH";
  $detector{"mother"}      = "sector";
  $detector{"description"} = "RICH Detector";
  $detector{"pos"}         = "${RichPosX}*mm ${RichPosY}*mm ${RichPosZ}*mm";
  $detector{"rotation"}    = "$RotPhi*deg $RotThe*deg $RotPsi*deg";
  $detector{"color"}       = "af4035";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$RichHall_z*mm $RichHall_th*deg $RichHall_ph*deg $RichHall_y1*mm $RichHall_x1*mm $RichHall_x2*mm $RichHall_Alp1*deg $RichHall_y2*mm $RichHall_x3*mm $RichHall_x4*mm $RichHall_Alp2*deg";
  $detector{"material"}    = "Vacuum";
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




# Radiator Volume
sub make_RADIATOR
{
  $detector{"name"}        = "RADIATOR";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Aerogel Radiator";
  $detector{"pos"}         = "${RadiPosX}*mm ${RadiPosY}*mm ${RadiPosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "660000";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$RadiHall_z*mm $RadiHall_th*deg $RadiHall_ph*deg $RadiHall_y1*mm $RadiHall_x1*mm $RadiHall_x2*mm $RadiHall_Alp1*deg $RadiHall_y2*mm $RadiHall_x3*mm $RadiHall_x4*mm $RadiHall_Alp2*deg";
  $detector{"material"}    = "RichAerogel";
#  $detector{"material"}    = "C6F14";
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


# Radiator Volume
sub make_PLANEMIRROR
{
  $detector{"name"}        = "PLANEMIRROR";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Secondary mirror";
  $detector{"pos"}         = "${PlanemirrorPosX}*mm ${PlanemirrorPosY}*mm ${PlanemirrorPosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       =  "99eeff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$PlanemirrorHall_z*mm $PlanemirrorHall_th*deg $PlanemirrorHall_ph*deg $PlanemirrorHall_y1*mm $PlanemirrorHall_x1*mm $PlanemirrorHall_x2*mm $PlanemirrorHall_Alp1*deg $PlanemirrorHall_y2*mm $PlanemirrorHall_x3*mm $PlanemirrorHall_x4*mm $PlanemirrorHall_Alp2*deg";
  $detector{"material"}    = "Vacuum";
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




# Quartz Volume
#sub make_QUARTZ
#{
#  $detector{"name"}        = "QUARTZ";
#  $detector{"mother"}      = "RICH";
#  $detector{"description"} = "Quartz Window";
#  $detector{"pos"}         = "${QuarPosX}*mm ${QuarPosY}*mm ${QuarPosZ}*mm";
#  $detector{"rotation"}    = "0.*deg 0.*deg 0.*deg";
#  $detector{"color"}       = "008000";
#  $detector{"type"}        = "G4Trap";
#  $detector{"dimensions"}  = "$QuarHall_z*mm $QuarHall_th*deg $QuarHall_ph*deg $QuarHall_y1*mm $QuarHall_x1*mm $QuarHall_x2*mm $QuarHall_Alp1*deg $QuarHall_y2*mm $QuarHall_x3*mm $QuarHall_x4*mm $QuarHall_Alp2*deg";
# $detector{"material"}    = "Quartz";
# $detector{"material"}    = "Methane";
#  $detector{"mfield"}      = "no";
#  $detector{"ncopy"}       = 1;
#  $detector{"pMany"}       = 1;
#  $detector{"exist"}       = 1;
#  $detector{"visible"}     = 1;
#  $detector{"style"}       = 1;
#  $detector{"sensitivity"} = "no";
#  $detector{"hit_type"}    = "";
#  $detector{"identifiers"} = "";
#
#  print_det(\%detector, $file);
#}


# Gap Volume
sub make_GAP
{
  $detector{"name"}        = "GAP";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Methane Gap";
  $detector{"pos"}         = "${GapPosX}*mm ${GapPosY}*mm ${GapPosZ}*mm";
  $detector{"rotation"}    = "0.*deg 0.*deg 0.*deg";
  $detector{"color"}       = "eeee00";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$GapHall_z*mm $GapHall_th*deg $GapHall_ph*deg $GapHall_y1*mm $GapHall_x1*mm $GapHall_x2*mm $GapHall_Alp1*deg $GapHall_y2*mm $GapHall_x3*mm $GapHall_x4*mm $GapHall_Alp2*deg";
#  $detector{"material"}    = "Vacuum";
#  $detector{"material"}    = "Air";
  $detector{"material"}    = "Methane";
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


# DETEC Volume
sub make_DETEC
{
  $detector{"name"}        = "DETEC";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Dummy Photon Detector";
  $detector{"pos"}         = "${DetecPosX}*mm ${DetecPosY}*mm ${DetecPosZ}*mm";
  $detector{"rotation"}    = "0.*deg 0.*deg 0.*deg";
  $detector{"color"}       = "eeee00";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$DetecHall_z*mm $DetecHall_th*deg $DetecHall_ph*deg $DetecHall_y1*mm $DetecHall_x1*mm $DetecHall_x2*mm $DetecHall_Alp1*deg $DetecHall_y2*mm $DetecHall_x3*mm $DetecHall_x4*mm $DetecHall_Alp2*deg";
#  $detector{"material"}    = "Methane";
  $detector{"material"}    = "Alumi";
  $detector{"mfield"}      = "no";
  $detector{"ncopy"}       = 1;
  $detector{"pMany"}       = 1;
  $detector{"exist"}       = 1;
  $detector{"visible"}     = 1;
  $detector{"style"}       = 1;
  $detector{"sensitivity"} = "yes";
  $detector{"hit_type"}    = "RICH";
  $detector{"identifiers"} = "";

  print_det(\%detector, $file);
}


## Photon Detector Volume
#sub make_DETEC
#{
#  $detector{"name"}        = "DETEC";
#  $detector{"mother"}      = "RICH";
#  $detector{"description"} = "DETECTOR VOLUME";
#  $detector{"pos"}         = "${DetecPosX}*mm ${DetecPosY}*mm ${DetecPosZ}*mm";
#  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
#  $detector{"color"}       = "ff1bb1";
#  $detector{"type"}        = "G4Trap";
#  $detector{"type"}        = "Box";
#  $detector{"dimensions"}  = "${DetecX}*mm ${DetecY}*mm ${DetecZ}*mm";
#  $detector{"material"}    = "Air";
#  $detector{"mfield"}      = "no";
#  $detector{"ncopy"}       = 1;
#  $detector{"pMany"}       = 1;
#  $detector{"exist"}       = 1;
#  $detector{"visible"}     = 1;
#  $detector{"style"}       = 1;
#  $detector{"sensitivity"} = "yes";
#  $detector{"hit_type"}    = "RICH";
#  $detector{"identifiers"} = "";
#  print_det(\%detector, $file);
#}



# Photon Detector Volume

my $MAX_NUM = 1000;
my $iy=0;

sub make_PAD
{
  my $PadPosX = $X_START;

  for(my $n1=1; $n1<=$MAX_NUM; $n1++)
  {
    $PadPosX += (2*$PadX + $PAD_XSPACE);
    my $PadPosY = $Y_START;
    for(my $n2=1; $n2<=$MAX_NUM; $n2++)
    {
      $PadPosY += (2*$PadY + $PAD_YSPACE);
      my $PadPosX1 = ($PadPosY - $DD)/$CC;  #left line
      my $PadPosX2 = ($DD - $PadPosY)/$CC;  #right line
#     my $PadPosX1 = ($PadPosY - $DD)/$CC-$PadX;  #left line
#     my $PadPosX2 = ($DD - $PadPosY)/$CC-$PadX;  #right line
#     my $PadPosX1 = ($PadPosY - $DD)/$CC-$PadX*2;  #left line
#     my $PadPosX2 = ($DD - $PadPosY)/$CC-$PadX*2;  #right line

#      print "check : $PadPosY $Y_START  $PadPosY  $Y_END
#       $PadPosX  $X_START  $PadPosX  $X_END
#       $PadPosX  $PadPosX1  $PadPosX  $PadPosX2\n";

      if($PadPosY <= $Y_START || $PadPosY >= $Y_END
      || $PadPosX <= $X_START || $PadPosX >= $X_END
      || $PadPosX <= $PadPosX1 || $PadPosX >= $PadPosX2){next;}



      my $PadPosX01c  = $PadPosX - $PadX;
      my $PadPosY01cL = $CC*$PadPosX01c + $DD;
      my $PadPosX02c  = $PadPosX + $PadX;
      my $PadPosY02cL = -$CC*$PadPosX02c + $DD;
      my $PadPosY0c   = $PadPosY - $PadY;


     #G4cout<<"position: "<<ij<<"  "<<ik<<"  "<<PosVec0_x<<"  "<<PosVec0_y<<G4endl;
     #G4cout<<"position check: "<<ij<<"  "<<ik<<"  "<<PosVec0_y<<"  "<<
     #  PosVec0_y0c<<"  "<<PosVec0_y01cL<<" "<< PosVec0_y02cL  <<G4endl;

      if($PadPosX<0) {if($PadPosY0c <= $PadPosY01cL) {next;}}
      if($PadPosX>0) {if($PadPosY0c <= $PadPosY02cL) {next;}}


      print "position: $n1 $n2 $PadPosX $PadPosY\n";

      #my $padnumber     = cnumber($iy, 10);
      my $padnumber     = $iy+1;
      #print "$padnumber\n";
      $detector{"name"}        = "PAD_$padnumber";
      #$detector{"name"}        = "PAD";
      $detector{"mother"}      = "RICH";
      $detector{"description"} = "PAD $iy";
      # positioning
      #print "pad $padnumber position $PadPosX*mm $PadPosY*mm $PadPosZ*mm\n";
      $detector{"pos"}         = "${PadPosX}*mm ${PadPosY}*mm ${PadPosZ}*mm";
      $detector{"rotation"}    = "0*deg 0*deg 0*deg";
      $detector{"color"}       = "0000ee";
      $detector{"type"}        = "Box";
      $detector{"dimensions"}  = "$PadX*mm $PadY*mm $PadZ*mm";
#     $detector{"type"}        = "Tube";
#     $detector{"dimensions"}  = "$Rin*mm $Rout*mm $height*mm $startAngle*deg $spanningAngle*deg";
#     $detector{"material"}    = "Glass";
      $detector{"material"}    = "Vacuum";
      $detector{"mfield"}      = "no";
      $detector{"ncopy"}       = 1;#$iy;
      $detector{"pMany"}       = 1;
      $detector{"exist"}       = 1;
      $detector{"visible"}     = 1;
      $detector{"style"}       = 1;
      $detector{"sensitivity"} = "no";
      $detector{"hit_type"}    = "";
      #$detector{"sensitivity"} = "yes";
      #$detector{"hit_type"}    = "RICH";
      $detector{"identifiers"} = "";

      print_det(\%detector, $file);
      $iy++
    }
  }
  print "$iy pads in total\n";
}



sub make_PhCath
{
  my $ix=0;
  my $MAX_NUM2 = $iy;
  for(my $n1=1; $n1<=$MAX_NUM2; $n1++)
  {
  my $padnumber     = $ix+1;
  $detector{"name"}        = "PhCath_$padnumber";
  $detector{"mother"}      = "PAD_$padnumber";
#  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Bialkali Photo Cathode $ix";
  $detector{"pos"}         = "${PhCathPosX}*mm ${PhCathPosY}*mm ${PhCathPosZ}*mm";
  $detector{"rotation"}    = "0.*deg 0.*deg 0.*deg";
  $detector{"color"}       = "008000";
  #$detector{"type"}        = "Tube";
  #$detector{"dimensions"}  = "$Rin*mm $Rout*mm $heightPh*mm $startAngle*deg $spanningAngle*deg";
  $detector{"type"}        = "Box";
  $detector{"dimensions"}  = "$PhCathX*mm $PhCathY*mm $PhCathZ*mm";
  $detector{"material"}    = "Alumi";
# $detector{"material"}    = "Methane";
  $detector{"mfield"}      = "no";
  $detector{"ncopy"}       = 1;#$ix;
  $detector{"pMany"}       = 1;
  $detector{"exist"}       = 1;
  $detector{"visible"}     = 1;
  $detector{"style"}       = 1;
  $detector{"sensitivity"} = "RICH";
  $detector{"hit_type"}    = "RICH"; #should have the same name as Hit Process Routine
  #$detector{"sensitivity"} = "no";
  #$detector{"hit_type"}    = "";
  $detector{"identifiers"} = "sector ncopy 0 pad manual $ix";

  print_det(\%detector, $file);
       $ix++
  }
  print "$ix pads in total\n";

}



make_RICH();
make_PLANEMIRROR();
make_RADIATOR();
#make_QUARTZ();
make_GAP();
make_PAD();
make_PhCath();
#make_DETEC();



# None of these components are sensitive.
$detector{"mfield"}      = "no";
$detector{"ncopy"}       = 1;
$detector{"pMany"}       = 1;
$detector{"exist"}       = 1;
$detector{"visible"}     = 1;
$detector{"style"}       = 1;
$detector{"sensitivity"} = "no";
$detector{"hit_type"}    = "";
$detector{"identifiers"} = "";


# General description. Index = mirror, 4 mirrors total.

my $number_of_mirrors = 1;
my $mthick  = 1.0;  # mirrors are 1mm thick

# SEMI Axis
#my @axisA   = ( 2907.810    ,  1846.155   ,   1786.859   ,  1728.375  );  # Semiaxis A
#my @axisB   = ( 1728.673    ,  1612.998   ,   1497.604   ,  1383.621  );  # Semiaxis B
my @axisA   = ( 3700.000    ,  1846.155   ,   1786.859   ,  1728.375  );  # Semiaxis A
my @axisB   = ( $axisA[0]   ,  $axisA[1]  ,   $axisA[2]  ,  $axisA[3] );  # Semiaxis B - same as A, it's a ellipsoid of rotation
my @axisC   = ( 4400.000    ,  1612.998   ,   1497.604   ,  1383.621  );  # Semiaxis C

my @axisAv  = ( $axisA[0] - $mthick ,  $axisA[1] - $mthick  ,   $axisA[2]  - $mthick ,  $axisA[3]- $mthick  );  # Semiaxis A thickness
my @axisBv  = ( $axisB[0] - $mthick ,  $axisB[1] - $mthick  ,   $axisB[2]  - $mthick ,  $axisB[3]- $mthick  );  # Semiaxis B thickness
my @axisCv  = ( $axisC[0] - $mthick ,  $axisC[1] - $mthick  ,   $axisC[2]  - $mthick ,  $axisC[3]- $mthick  );  # Semiaxis C thickness


# The first focal point is the target
# The second focal point position is given below (left mirror).
# For an ellipse, the distance between the two focal points is    d = 2 sqrt(a2-b2)
# http://en.wikipedia.org/wiki/Ellipse

my @fc2x    = (  417.483    ,  462.948    ,  492.379     ,  503.907 );  # focal point 2 x position
my @fc2y    = ( 1558.067    , 1727.744    , 1837.584     , 1880.607 );  # focal point 2 y position
my @fc2z    = (  -62.047    ,  163.333    ,  425.482     ,  707.739 );  # focal point 2 z position


my $nsegments = 12;


# G4 materials
my $mirror_material   = 'G4_Si';

# G4 colors
my @mirror_color      = ('99eeff', 'ee99ff', 'ff44ff', 'ffee55');


my $microgap_width = 0.01;




sub make_mirrors1a
{
 for(my $m = 0; $m < $number_of_mirrors; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "aaa_htcc_Mirror$mind";
    $detector{"mother"}      = "RICH";
#   $detector{"mother"}      = "root";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Ellipsoid part 1";
    $detector{"pos"}         = "0*cm 0*cm 0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Ellipsoid";
    $detector{"dimensions"}  = "$axisA[$m]*mm $axisB[$m]*mm $axisC[$m]*mm 0*mm 0*mm";
    $detector{"material"}    = "Vacuum";
    $detector{"material"}    = "Component";

    print_det(\%detector, $file);
 }
#  print rad2deg(phi($fc2x[0], $fc2y[0], $fc2z[0]))."\n";
#  print rad2deg(theta($fc2x[0], $fc2y[0], $fc2z[0]));
}

sub make_mirrors1b
{
 for(my $m = 0; $m < $number_of_mirrors; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "aab_htcc_Mirror$mind";
#    $detector{"mother"}      = "root";
    $detector{"mother"}      = "RICH";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Ellipsoid part 2";
    $detector{"pos"}         = "0*mm 0*cm 0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Ellipsoid";
#    $detector{"dimensions"}  = "$axisA[$m]*mm $axisB[$m]*mm $axisC[$m]*mm 0*mm 0*mm";
    $detector{"dimensions"}  = "$axisAv[$m]*mm $axisBv[$m]*mm $axisCv[$m]*mm 0*mm 0*mm";
    $detector{"material"}    = "Vacuum";
    $detector{"material"}    = "Component";

    print_det(\%detector, $file);

 }
}

sub make_mirrors1c
{
 for(my $m = 0; $m < $number_of_mirrors; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "aac_htcc_Mirror$mind";
#    $detector{"mother"}      = "root";
    $detector{"mother"}      = "RICH";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Ellipsoid part1 - part2";
    $detector{"pos"}         = "0*cm 0*cm 0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Operation: aaa_htcc_Mirror$mind - aab_htcc_Mirror$mind";
    $detector{"dimensions"}  = "0";
    $detector{"material"}    = "Vacuum";
    $detector{"material"}    = "Component";

    print_det(\%detector, $file);
 }
}

make_mirrors1a();
make_mirrors1b();
make_mirrors1c();

# Tube used for subtraction
my $tune_R         = 3800.0;
my $tube_z         = 5000.0;
#y $tube_start_phi = 117.0;
#y $tube_phi_span  = 360.0 - 54.0;
 my $tube_start_phi = 121.0; # test1
 my $tube_phi_span  = 360.0 - 60.0;  # test1

sub make_sub_tube
{
 $detector{"name"}        = "aad_htcc_tube";
# $detector{"mother"}      = "root";
 $detector{"mother"}      = "RICH";
 $detector{"description"} = "Tube 1 used to cut the mirrors";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0*mm $tune_R*mm $tube_z*mm $tube_start_phi*deg $tube_phi_span*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);

}



sub make_mirrors1e
{
 for(my $m = 0; $m < $number_of_mirrors; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "aae_htcc_Mirror$mind";
#    $detector{"mother"}      = "root";
    $detector{"mother"}      = "RICH";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Half Ellipsoid";
    $detector{"pos"}         = "0*cm 0*cm 0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Operation: aac_htcc_Mirror$mind - aad_htcc_tube";
    $detector{"dimensions"}  = "0";
    $detector{"material"}    = "Vacuum";
    $detector{"material"}    = "Component";

    print_det(\%detector, $file);
 }
}


make_sub_tube();
make_mirrors1e();



# Box used for subtraction
my $box_x = 3800.0;
my $box_y = 3800.0;
my $box_z = 5000.0;


sub make_sub_box1
{
 $detector{"name"}        = "aad_htcc_box1";
# $detector{"mother"}      = "root";
 $detector{"mother"}      = "RICH";
 $detector{"description"} = "Box 1 used to cut the mirrors in half";
# $detector{"pos"}         = "0*mm 0*mm 8989*mm";#old
# $detector{"pos"}         = "0*mm 0*mm 9058*mm";#new
  $detector{"pos"}         = "0*mm 0*mm 9200*mm"; #test1
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$box_x*mm $box_y*mm $box_z*mm";
 $detector{"material"}    = "Vacuum";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);

}
sub make_sub_box2
{
 $detector{"name"}        = "aad_htcc_box2";
# $detector{"mother"}      = "root";
 $detector{"mother"}      = "RICH";
 $detector{"description"} = "Box 1 used to cut the mirrors in half";
#$detector{"pos"}         = "0*mm 0*mm -2972*mm";#old
# $detector{"pos"}         = "0*mm 0*mm -2800*mm";#new
  $detector{"pos"}         = "0*mm 0*mm -2300*mm";# test1
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$box_x*mm $box_y*mm $box_z*mm";
 $detector{"material"}    = "Vacuum";
 $detector{"material"}    = "Component";

 print_det(\%detector, $file);

}


sub make_mirrors1f
{
 for(my $m = 0; $m < $number_of_mirrors; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "aaf_htcc_Mirror$mind";
#    $detector{"mother"}      = "root";
    $detector{"mother"}      = "RICH";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Half Ellipsoid";
    $detector{"pos"}         = "0*cm 0*cm 0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Operation: aae_htcc_Mirror$mind - aad_htcc_box1";
    $detector{"dimensions"}  = "0";
    $detector{"material"}    = "Vacuum";
    $detector{"material"}    = "Component";

    print_det(\%detector, $file);
 }
}


sub make_mirrors1g
  {
    for(my $m = 0; $m < $number_of_mirrors; $m++)
      {
	my $mind                 = $m + 1;
    $detector{"name"}        = "aag_htcc_Mirror$mind";
#    $detector{"mother"}      = "root";
#    $detector{"mother"}      = "RICH";
    $detector{"mother"}      = "GAP";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Half Ellipsoid";
#   $detector{"pos"}         = "0*mm -318.7*mm -3744.3m"; #new
    $detector{"pos"}         = "0*mm 70*mm -3800.3m";  # test1
    $detector{"rotation"}    = "-25*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Operation: aaf_htcc_Mirror$mind - aad_htcc_box2";
    $detector{"dimensions"}  = "0";
    $detector{"material"}    = "Air";
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "RI";
    $detector{"identifiers"} = "";

    print_det(\%detector, $file);
 }
}


make_sub_box1();
make_sub_box2();
make_mirrors1f();
#make_mirrors1g();
