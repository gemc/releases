#!/usr/bin/perl -w

# Perl sctipt used to generate RICHBOX.txt file that is an input to the 
# shell script go_table which puts the RICH geometry in the mysql database 
# for gemc to use.

use strict;
use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);


my $envelope = 'RICHBOX';
my $file     = 'RICHBOX.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

#################################################################
# All dimensions in mm
# check component colors
#################################################################

# RICH half length (Box)
##my $RichX = 1247.7;
#my $RichX = 700.;
##my $RichY = 4690.8;
#my $RichY = 2345;
#my $RichZ = 518.5;

my $RichX = 10000;
my $RichY = 10000;
my $RichZ = 10000;

my $RichPosX = 0;
my $RichPosY = 0;
my $RichPosZ = 0;



#RADIATOR half length (Box)
##my $RadiX = 1016.7;
#my $RadiX = 600;
##my $RadiY = 927.124;
#my $RadiY = 464.;
#my $RadiZ = 15;
#my $RadiPosX = 0.;
#my $RadiPosY = 0.;
##my $RadiPosZ = ${RadiZ} - ${RichZ};
#my $RadiPosZ = 0;


my $RadiX = 600;
my $RadiY = 464.;
my $RadiZ = 20;
my $RadiPosX = 0.;
my $RadiPosY = 0.;
my $RadiPosZ = 2000;





#QUARTZ Window half length (Box)
#my $QuarX = 1026.7;
my $QuarX = 514.;
#my $QuarY = 937.124;
my $QuarY = 468.562;
my $QuarZ = 2.5;
my $QuarPosX = 0.;
my $QuarPosY = 0.;
my $QuarPosZ = $RadiPosZ + $RadiZ + $QuarZ;

#Gap half length (Box)
#my $GapX = 1157.7;
my $GapX = 578.7;
#my $GapY = 4600.8;
my $GapY = 3200.2;
my $GapZ = 400;
my $GapPosX = 0;
my $GapPosY = 0;
my $GapPosZ = $QuarPosZ + $QuarZ + $GapZ;

#Detec half length (Box)
#my $DetecX = 1148.7;
my $DetecX = 574.;
#my $DetecY = 4591.8;
my $DetecY = 2295.9;
my $DetecZ = 1.0;
my $DetecPosX = 0;
my $DetecPosY = 0;
my $DetecPosZ = $GapPosZ + $GapZ + $DetecZ;

##Pad half length (Box)
my $PadX = 5.;
my $PadY = 5.;
my $PadZ = 0.5;
my $PAD_XSPACE = 10.0;
my $PAD_YSPACE = 10.0;
my $X_START =  -110.;
my $Y_START =  -350.;
my $X_END   =   110.;
my $Y_END   =   350.;
my $x=$X_START + $PadX;
my $y=$Y_START + $PadY;
my $NUM_XPADS = 0;
my $NUM_YPADS = 0;

while(1)
{
  print "$x $X_END\n";
  if($x < $X_END)
  {
    $NUM_XPADS++;
    $x += 2*$PadX + $PAD_XSPACE;
  }
  else
  {
    last;
  }
}

while(1)
{
  #print "$y $Y_END\n";
  if($y < $Y_END)
  {
    $NUM_YPADS++;
    $y += 2*$PadY + $PAD_YSPACE;
  }
  else
  {
    last;
  }
}

print "$NUM_XPADS $NUM_YPADS\n";


my $PadPosX = $X_START + $PadX;
my $PadPosY = $Y_START + $PadY;
my $PadPosZ = $GapPosZ + $GapZ + $PadZ;

##Phcath half length (Box)
#my $PhcathX = 10.;
#my $PhcathY = 10.;
#my $PhcathZ = 1.0;
#my $PhcathPosX = ;
#my $PhcathPosY = ;
#my $PhcathPosZ = ;


# Mother Volume
sub make_RICH
{
  $detector{"name"}        = "RICHBOX";
  $detector{"mother"}      = "root";
  $detector{"description"} = "RICH Detector";
  $detector{"pos"}         = "${RichPosX}*mm ${RichPosY}*mm ${RichPosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "ff1bb1";
  $detector{"type"}        = "Box";
  $detector{"dimensions"}  = "${RichX}*mm ${RichY}*mm ${RichZ}*mm";
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

# Radiator Volume
sub make_RADIATOR
{
  $detector{"name"}        = "RADIATOR";
  $detector{"mother"}      = "RICHBOX";
  $detector{"description"} = "Aerogel Radiator";
  $detector{"pos"}         = "${RadiPosX}*mm ${RadiPosY}*mm ${RadiPosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "ff1bb1";
  $detector{"type"}        = "Box";
  $detector{"dimensions"}  = "${RadiX}*mm ${RadiY}*mm ${RadiZ}*mm";
  $detector{"material"}    = "RichAerogel";
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
sub make_QUARTZ
{
  $detector{"name"}        = "QUARTZ";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Quartz Window";
  $detector{"pos"}         = "${QuarPosX}*mm ${QuarPosY}*mm ${QuarPosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "ff1bb1";
  $detector{"type"}        = "Box";
  $detector{"dimensions"}  = "${QuarX}*mm ${QuarY}*mm ${QuarZ}*mm";
  $detector{"material"}    = "Quartz";
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

# Gap Volume
sub make_GAP
{
  $detector{"name"}        = "GAP";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Methane Gap";
  $detector{"pos"}         = "${GapPosX}*mm ${GapPosY}*mm ${GapPosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "ff1bb1";
  $detector{"type"}        = "Box";
  $detector{"dimensions"}  = "${GapX}*mm ${GapY}*mm ${GapZ}*mm";
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

## Photon Detector Volume
#sub make_DETEC
#{
#  $detector{"name"}        = "DETEC";
#  $detector{"mother"}      = "RICH";
#  $detector{"description"} = "DETECTOR VOLUME";
#  $detector{"pos"}         = "${DetecPosX}*mm ${DetecPosY}*mm ${DetecPosZ}*mm";
#  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
#  $detector{"color"}       = "ff1bb1";
#  $detector{"type"}        = "Box";
#  $detector{"dimensions"}  = "${DetecX}*mm ${DetecY}*mm ${DetecZ}*mm";
#  $detector{"material"}    = "Air";
#  $detector{"mfield"}      = "no";
#  $detector{"ncopy"}       = 1;
#  $detector{"pMany"}       = 1;
#  $detector{"exist"}       = 1;
#  $detector{"visible"}     = 1;
#  $detector{"style"}       = 1;
#  $detector{"sensitivity"} = "RICH";
#  $detector{"hit_type"}    = "RICH";
#  $detector{"identifiers"} = "Photon Detector container";
#
#  print_det(\%detector, $file);
#}

# Photon Detector Volume
sub make_PAD
{
  $PadPosX = $X_START + $PadX;
  for(my $n1=1; $n1<=$NUM_XPADS; $n1++)
  {
    $PadPosY = $Y_START + $PadY;    
    for(my $n2=1; $n2<=$NUM_YPADS; $n2++)
    {
      my $k = ($n1-1)*$NUM_YPADS + $n2;       
      my $padnumber     = cnumber($k-1, 10);
      #print "$padnumber\n";
      $detector{"name"}        = "PAD_$padnumber";
      $detector{"mother"}      = "RICH";
      $detector{"description"} = "PAD $k";
      # positioning
      print "pad $padnumber position $PadPosX*mm $PadPosY*mm $PadPosZ*mm\n";
      $detector{"pos"}         = "${PadPosX}*mm ${PadPosY}*mm ${PadPosZ}*mm";
      $detector{"rotation"}    = "0*deg 0*deg 0*deg";
      $detector{"color"}       = "66bbff";
      $detector{"type"}        = "Box";
      $detector{"dimensions"}  = "$PadX*mm $PadY*mm $PadZ*mm";
      $detector{"material"}    = "Alumi";
      $detector{"mfield"}      = "no";
      $detector{"ncopy"}       = $k;
      $detector{"pMany"}       = 1;
      $detector{"exist"}       = 1;
      $detector{"visible"}     = 1;
      $detector{"style"}       = 1;
      $detector{"sensitivity"} = "RICH";
      $detector{"hit_type"}    = "RICH";
      $detector{"identifiers"} = "pad manual $k";

      print_det(\%detector, $file);
      $PadPosY += 2*$PadY + $PAD_YSPACE;
    }
    $PadPosX += 2*$PadX + $PAD_XSPACE;
  }
}

make_RICH();
make_RADIATOR();
#make_QUARTZ();
#make_GAP();
#make_PAD();
