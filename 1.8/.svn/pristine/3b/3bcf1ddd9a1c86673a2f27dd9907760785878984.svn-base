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
my $RichHall_z    = 525;
my $RichHall_th   = -6.6338;
my $RichHall_ph   = 90;

my $RichHall_x1   = 161.658;
my $RichHall_x2   = 1810.67;
my $RichHall_x3   = 193.181;
my $RichHall_x4   = 2163.75;

my $RichHall_y1   = 1575.72;
my $RichHall_y2   = 1882.98;

my $rad_sep4   = 1000.;
my $rad_sep3   = 1300.;
my $rad_sep2   = 1600.;
my $rad_sep1   = 1900.;

my $Radi1Hall_z    = 50.0;  # 10cm
my $Radi2Hall_z    = 49.0;  # 8cm
my $Radi3Hall_z    = 30.0;  # 6cm
my $Radi4Hall_z    = 30.0;  # 4cm
my $Radi5Hall_z    = 30.0;  # 2cm

my $RichHall_Alp1 =0;
my $RichHall_Alp2 =0;

my $RichPosX = 0;
my $RichPosY = 1874.64;
my $RichPosZ = 646.46;

my $RotPhi = 25.;
my $RotThe = 0.;
my $RotPsi = 0.;

my $AA = 2*$RichHall_y1/($RichHall_x1-$RichHall_x2);
my $BB =  $RichHall_y1*($RichHall_x1+$RichHall_x2)/($RichHall_x1-$RichHall_x2);
my $BBOFF =  $BB + $RichHall_y1;
my $CC = 2*$RichHall_y2/($RichHall_x3-$RichHall_x4);
my $DD =  $RichHall_y2*($RichHall_x3+$RichHall_x4)/($RichHall_x3-$RichHall_x4);

print "slopes $AA $BB\n";

# Mother Volume
sub make_RICH
{
  $detector{"name"}        = "RICH";
  $detector{"mother"}      = "sector";
  $detector{"description"} = "RICH Detector";
  $detector{"pos"}         = "${RichPosX}*mm ${RichPosY}*mm ${RichPosZ}*mm";
  $detector{"rotation"}    = "$RotPhi*deg $RotThe*deg $RotPsi*deg";
  $detector{"color"}       = "af4035";
# $detector{"color"}       = "eeee00";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$RichHall_z*mm $RichHall_th*deg $RichHall_ph*deg $RichHall_y1*mm $RichHall_x1*mm $RichHall_x2*mm $RichHall_Alp1*deg $RichHall_y2*mm $RichHall_x3*mm $RichHall_x4*mm $RichHall_Alp2*deg";
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



#PREMIRROR half length (G4Trap)
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


#RADIATOR1 half length (G4Trap)
my $Radi1Hall_th   = -5.;
my $Radi1Hall_ph   = 90.;
my $Radi1Hall_y1   = (2*$RichHall_y1 - $rad_sep1)/2.;
my $Radi1Hall_x1   = ($BBOFF - $rad_sep1 )/$AA;
my $Radi1Hall_x2   = ($BBOFF - $rad_sep1 - 2*$Radi1Hall_y1)/$AA;
my $Radi1Hall_Alp1 = 0;
my $Radi1Hall_y2   = $Radi1Hall_y1;
my $Radi1Hall_x3   = $Radi1Hall_x1;
my $Radi1Hall_x4   = $Radi1Hall_x2;
my $Radi1Hall_Alp2 = 0;
my $Radi1PosX = 0.;
my $Radi1PosZ = $PlanemirrorPosZ + $PlanemirrorHall_z + $Radi1Hall_z;
my $Radi1PosY = $Radi1PosZ *  tan($RichHall_th/57.3) + ($rad_sep1+$Radi1Hall_y1-$RichHall_y1);
 
print "RADIATOR1  $Radi1PosY $Radi1Hall_y1 $Radi1Hall_x1 $Radi1Hall_x2 \n";

#RADIATOR2 half length (G4Trap)
my $Radi2Hall_th   = -5.;
my $Radi2Hall_ph   = 90.;
my $Radi2Hall_y1   = ($rad_sep1-$rad_sep2)/2.;
my $Radi2Hall_x1   = ($BBOFF - $rad_sep2 )/$AA;
my $Radi2Hall_x2   = ($BBOFF - $rad_sep2 - 2*$Radi2Hall_y1)/$AA;
my $Radi2Hall_Alp1 = 0;
my $Radi2Hall_y2   = $Radi2Hall_y1;
my $Radi2Hall_x3   = $Radi2Hall_x1;
my $Radi2Hall_x4   = $Radi2Hall_x2;
my $Radi2Hall_Alp2 = 0;
my $Radi2PosX = 0.;
my $Radi2PosZ = $PlanemirrorPosZ + $PlanemirrorHall_z + $Radi2Hall_z + 2*($Radi1Hall_z-$Radi2Hall_z);
my $Radi2PosY = $Radi2PosZ *  tan($RichHall_th/57.3) + ($rad_sep2+$Radi2Hall_y1-$RichHall_y1);

print "RADIATOR2  $Radi2PosY $Radi2Hall_y1 $Radi2Hall_x1 $Radi2Hall_x2\n";

#GAP2 half length (G4Trap)
my $Gap2Hall_z    = ($Radi1Hall_z-$Radi2Hall_z);
my $Gap2Hall_th   = -5.;
my $Gap2Hall_ph   = 90.;
my $Gap2Hall_y1   = $Radi2Hall_y1;
my $Gap2Hall_x1   = $Radi2Hall_x1;
my $Gap2Hall_x2   = $Radi2Hall_x2;
my $Gap2Hall_Alp1 = 0;
my $Gap2Hall_y2   = $Gap2Hall_y1;
my $Gap2Hall_x3   = $Gap2Hall_x1;
my $Gap2Hall_x4   = $Gap2Hall_x2;
my $Gap2Hall_Alp2 = 0;
my $Gap2PosX = 0.;
my $Gap2PosZ = $PlanemirrorPosZ + $PlanemirrorHall_z + $Gap2Hall_z;
my $Gap2PosY = $Radi2PosY;


#RADIATOR3 half length (G4Trap)
my $Radi3Hall_th   = -5.;
my $Radi3Hall_ph   = 90.;
my $Radi3Hall_y1   = ($rad_sep2-$rad_sep3)/2.;
my $Radi3Hall_x1   = ($BBOFF - $rad_sep3 )/$AA;
my $Radi3Hall_x2   = ($BBOFF - $rad_sep3 - 2*$Radi3Hall_y1)/$AA;
my $Radi3Hall_Alp1 = 0;
my $Radi3Hall_y2   = $Radi3Hall_y1;
my $Radi3Hall_x3   = $Radi3Hall_x1;
my $Radi3Hall_x4   = $Radi3Hall_x2;
my $Radi3Hall_Alp2 = 0;
my $Radi3PosX = 0.;
my $Radi3PosZ = $PlanemirrorPosZ + $PlanemirrorHall_z + $Radi3Hall_z + 2*($Radi1Hall_z-$Radi3Hall_z);
my $Radi3PosY = $Radi3PosZ *  tan($RichHall_th/57.3) + ($rad_sep3+$Radi3Hall_y1-$RichHall_y1);

print "RADIATOR3  $Radi3PosY $Radi3Hall_y1 $Radi3Hall_x1 $Radi3Hall_x2\n";

#GAP3 half length (G4Trap)
my $Gap3Hall_z    = ($Radi1Hall_z-$Radi3Hall_z);
my $Gap3Hall_th   = -5.;
my $Gap3Hall_ph   = 90.;
my $Gap3Hall_y1   = $Radi3Hall_y1;
my $Gap3Hall_x1   = $Radi3Hall_x1;
my $Gap3Hall_x2   = $Radi3Hall_x2;
my $Gap3Hall_Alp1 = 0;
my $Gap3Hall_y2   = $Gap3Hall_y1;
my $Gap3Hall_x3   = $Gap3Hall_x1;
my $Gap3Hall_x4   = $Gap3Hall_x2;
my $Gap3Hall_Alp2 = 0;
my $Gap3PosX = 0.;
my $Gap3PosZ = $PlanemirrorPosZ + $PlanemirrorHall_z + $Gap3Hall_z;
my $Gap3PosY = $Radi3PosY;

#RADIATOR4 half length (G4Trap)
my $Radi4Hall_th   = -5.;
my $Radi4Hall_ph   = 30.;
my $Radi4Hall_y1   = ($rad_sep3-$rad_sep4)/2.;
my $Radi4Hall_x1   = ($BBOFF - $rad_sep4 )/$AA;
my $Radi4Hall_x2   = ($BBOFF - $rad_sep4 - 2*$Radi4Hall_y1)/$AA;
my $Radi4Hall_Alp1 = 0;
my $Radi4Hall_y2   = $Radi4Hall_y1;
my $Radi4Hall_x3   = $Radi4Hall_x1;
my $Radi4Hall_x4   = $Radi4Hall_x2;
my $Radi4Hall_Alp2 = 0;
my $Radi4PosX = 0.;
my $Radi4PosZ = $PlanemirrorPosZ + $PlanemirrorHall_z + $Radi4Hall_z + 2*($Radi1Hall_z-$Radi4Hall_z);
my $Radi4PosY = $Radi4PosZ *  tan($RichHall_th/57.3) + ($rad_sep4+$Radi4Hall_y1-$RichHall_y1);

print "RADIATOR4  $Radi4PosY $Radi4Hall_y1 $Radi4Hall_x1 $Radi4Hall_x2\n";

#GAP4 half length (G4Trap)
my $Gap4Hall_z    = ($Radi1Hall_z-$Radi4Hall_z);
my $Gap4Hall_th   = -5.;
my $Gap4Hall_ph   = 90.;
my $Gap4Hall_y1   = $Radi4Hall_y1;
my $Gap4Hall_x1   = $Radi4Hall_x1;
my $Gap4Hall_x2   = $Radi4Hall_x2;
my $Gap4Hall_Alp1 = 0;
my $Gap4Hall_y2   = $Gap4Hall_y1;
my $Gap4Hall_x3   = $Gap4Hall_x1;
my $Gap4Hall_x4   = $Gap4Hall_x2;
my $Gap4Hall_Alp2 = 0;
my $Gap4PosX = 0.;
my $Gap4PosZ = $PlanemirrorPosZ + $PlanemirrorHall_z + $Gap4Hall_z;
my $Gap4PosY = $Radi4PosY;

#RADIATOR5 half length (G4Trap)
my $Radi5Hall_th   = -5.;
my $Radi5Hall_ph   = 90.;
my $Radi5Hall_y1   = $rad_sep4/2.;
my $Radi5Hall_x1   = ($BBOFF)/$AA;
my $Radi5Hall_x2   = ($BBOFF - 2*$Radi5Hall_y1)/$AA;
my $Radi5Hall_Alp1 = 0;
my $Radi5Hall_y2   = $Radi5Hall_y1;
my $Radi5Hall_x3   = $Radi5Hall_x1;
my $Radi5Hall_x4   = $Radi5Hall_x2;
my $Radi5Hall_Alp2 = 0;
my $Radi5PosX = 0.;
my $Radi5PosZ = $PlanemirrorPosZ + $PlanemirrorHall_z + $Radi5Hall_z + 2*($Radi1Hall_z-$Radi5Hall_z);
my $Radi5PosY = $Radi5PosZ *  tan($RichHall_th/57.3) + ($Radi5Hall_y1-$RichHall_y1);

print "RADIATOR5  $Radi5PosY $Radi5Hall_y1 $Radi5Hall_x1 $Radi5Hall_x2\n";

#GAP5 half length (G4Trap)
my $Gap5Hall_z    = ($Radi1Hall_z-$Radi5Hall_z);
my $Gap5Hall_th   = -5.;
my $Gap5Hall_ph   = 90.;
my $Gap5Hall_y1   = $Radi5Hall_y1;
my $Gap5Hall_x1   = $Radi5Hall_x1;
my $Gap5Hall_x2   = $Radi5Hall_x2;
my $Gap5Hall_Alp1 = 0;
my $Gap5Hall_y2   = $Gap5Hall_y1;
my $Gap5Hall_x3   = $Gap5Hall_x1;
my $Gap5Hall_x4   = $Gap5Hall_x2;
my $Gap5Hall_Alp2 = 0;
my $Gap5PosX = 0.;
my $Gap5PosZ = $PlanemirrorPosZ + $PlanemirrorHall_z + $Gap5Hall_z;
my $Gap5PosY = $Radi5PosY;


#Gap half length (G4Trap)
#my $GapHall_z    = 500.0;
my $GapHall_z    = $RichHall_z-$PlanemirrorHall_z-$Radi1Hall_z-0.5;
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
my $GapPosZ = $Radi1PosZ + $Radi1Hall_z + $GapHall_z;
#my $GapPosZ = $PlanemirrorPosZ + $GapHall_z;
my $GapPosY = $GapPosZ *  tan($RichHall_th/57.3);



# Beam pipe plate
sub make_pipe_plate
{
  $detector{"name"}        = "pipe_plate";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Plate to stop photons toward the beam-pipe / maybe can be upgraded to a mirror";
  $detector{"pos"}         = "0*mm -1732.35*mm 0*mm";
  $detector{"rotation"}    = "-22.3662*deg 0*deg 0*deg";
  $detector{"color"}       = "ffffff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$RichHall_z*mm 0*deg 0*deg 6.653*mm 160.503*mm 167.466*mm 0*deg 7.951*mm 191.801*mm 200.122*mm 0*deg";
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


# Beam pipe plate
sub make_back_plate
{
  $detector{"name"}        = "back_plate";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Plate to stop photons toward the beam-pipe / maybe can be upgraded to a mirror";
  $detector{"pos"}         = "0*mm -60.649*mm 530*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "ffffff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "5*mm 0*deg 0*deg 1882.98*mm 193.181*mm 2163.75*mm 0*deg 1885.91*mm 193.481*mm 2167.11*mm 0*deg";
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


# Radiator1 Volume
sub make_RADIATOR1
{
  $detector{"name"}        = "RADIATOR1";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Aerogel Radiator";
  $detector{"pos"}         = "${Radi1PosX}*mm ${Radi1PosY}*mm ${Radi1PosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "111000";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$Radi1Hall_z*mm $Radi1Hall_th*deg $Radi1Hall_ph*deg $Radi1Hall_y1*mm $Radi1Hall_x1*mm $Radi1Hall_x2*mm $Radi1Hall_Alp1*deg $Radi1Hall_y2*mm $Radi1Hall_x3*mm $Radi1Hall_x4*mm $Radi1Hall_Alp2*deg";
  $detector{"material"}    = "RichAerogel";
# $detector{"material"}    = "Methane";
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


# Radiator2 Volume
sub make_RADIATOR2
{
  $detector{"name"}        = "RADIATOR2";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Aerogel Radiator";
  $detector{"pos"}         = "${Radi2PosX}*mm ${Radi2PosY}*mm ${Radi2PosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "eeee00";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$Radi2Hall_z*mm $Radi2Hall_th*deg $Radi2Hall_ph*deg $Radi2Hall_y1*mm $Radi2Hall_x1*mm $Radi2Hall_x2*mm $Radi2Hall_Alp1*deg $Radi2Hall_y2*mm $Radi2Hall_x3*mm $Radi2Hall_x4*mm $Radi2Hall_Alp2*deg";
  $detector{"material"}    = "RichAerogel";
# $detector{"material"}    = "Methane";
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


# Radiator3 Volume
sub make_RADIATOR3
{
  $detector{"name"}        = "RADIATOR3";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Aerogel Radiator";
  $detector{"pos"}         = "${Radi3PosX}*mm ${Radi3PosY}*mm ${Radi3PosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "333000";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$Radi3Hall_z*mm $Radi3Hall_th*deg $Radi3Hall_ph*deg $Radi3Hall_y1*mm $Radi3Hall_x1*mm $Radi3Hall_x2*mm $Radi3Hall_Alp1*deg $Radi3Hall_y2*mm $Radi3Hall_x3*mm $Radi3Hall_x4*mm $Radi3Hall_Alp2*deg";
  $detector{"material"}    = "RichAerogel";
# $detector{"material"}    = "Methane";
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


# Radiator4 Volume
sub make_RADIATOR4
{
  $detector{"name"}        = "RADIATOR4";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Aerogel Radiator";
  $detector{"pos"}         = "${Radi4PosX}*mm ${Radi4PosY}*mm ${Radi4PosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "eeee00";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$Radi4Hall_z*mm $Radi4Hall_th*deg $Radi4Hall_ph*deg $Radi4Hall_y1*mm $Radi4Hall_x1*mm $Radi4Hall_x2*mm $Radi4Hall_Alp1*deg $Radi4Hall_y2*mm $Radi4Hall_x3*mm $Radi4Hall_x4*mm $Radi4Hall_Alp2*deg";
  $detector{"material"}    = "RichAerogel";
# $detector{"material"}    = "Methane";
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


# Radiator5 Volume
sub make_RADIATOR5
{
  $detector{"name"}        = "RADIATOR5";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Aerogel Radiator";
  $detector{"pos"}         = "${Radi5PosX}*mm ${Radi5PosY}*mm ${Radi5PosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "550000";
#  $detector{"color"}       = "eeee00";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$Radi5Hall_z*mm $Radi5Hall_th*deg $Radi5Hall_ph*deg $Radi5Hall_y1*mm $Radi5Hall_x1*mm $Radi5Hall_x2*mm $Radi5Hall_Alp1*deg $Radi5Hall_y2*mm $Radi5Hall_x3*mm $Radi5Hall_x4*mm $Radi5Hall_Alp2*deg";
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


sub make_PREMIRROR
{
  $detector{"name"}        = "PREMIRROR";
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
  $detector{"sensitivity"} = "FLUX";
  $detector{"hit_type"}    = "FLUX";
  $detector{"identifiers"} = "Mirror WithSurface: 0 With Finish: 0 Refraction Index: 1000000 With Reflectivity:  1000000 With Efficiency:      0  WithBorderVolume: MirrorSkin";

  print_det(\%detector, $file);
}


#POSTMIRROR half length (G4Trap)
my $PostmirrorHall_z    = 2.0;
my $PostmirrorHall_th   = -5.;
my $PostmirrorHall_ph   = 90.;
my $PostmirrorHall_y1   = 1200./2.;
my $PostmirrorHall_x1   = ($BBOFF)/$AA;
my $PostmirrorHall_x2   = ($BBOFF - 2*$PostmirrorHall_y1)/$AA;
my $PostmirrorHall_Alp1 = 0;
my $PostmirrorHall_y2   = $PostmirrorHall_y1;
my $PostmirrorHall_x3   = $PostmirrorHall_x1;
my $PostmirrorHall_x4   = $PostmirrorHall_x2;
my $PostmirrorHall_Alp2 = 0;
my $PostmirrorPosX = 0.;
my $PostmirrorPosZ = $PostmirrorHall_z*2.-$GapHall_z;
my $PostmirrorPosY = $PostmirrorPosZ *  tan($GapHall_th/57.3) + ($PostmirrorHall_y1-$GapHall_y1);
#my $Radi5PosY = $Radi5PosZ *  tan($RichHall_th/57.3) + ($Radi5Hall_y1-$RichHall_y1);

sub make_POSTMIRROR
{
  $detector{"name"}        = "POSTMIRROR";
  $detector{"mother"}      = "GAP";
  $detector{"description"} = "Semireflecting mirror";
  $detector{"pos"}         = "${PostmirrorPosX}*mm ${PostmirrorPosY}*mm ${PostmirrorPosZ}*mm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       =  "99eeff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$PostmirrorHall_z*mm $PostmirrorHall_th*deg $PostmirrorHall_ph*deg $PostmirrorHall_y1*mm $PostmirrorHall_x1*mm $PostmirrorHall_x2*mm $PostmirrorHall_Alp1*deg $PostmirrorHall_y2*mm $PostmirrorHall_x3*mm $PostmirrorHall_x4*mm $PostmirrorHall_Alp2*deg";
  $detector{"material"}    = "SemiMirror";
  $detector{"mfield"}      = "no";
  $detector{"ncopy"}       = 1;
  $detector{"pMany"}       = 1;
  $detector{"exist"}       = 1;
  $detector{"visible"}     = 1;
  $detector{"style"}       = 1;
  $detector{"sensitivity"} = "FLUX";
  $detector{"hit_type"}    = "FLUX";
  $detector{"identifiers"} = "Mirror WithSurface: 1 With Finish: 0 Refraction Index: 5000000 With Reflectivity:  1000000 With Efficiency:      0 WithBorderVolume: GAP";

  print_det(\%detector, $file);
}


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
  $detector{"visible"}     = 0;
  $detector{"style"}       = 1;
  $detector{"sensitivity"} = "no";
  $detector{"hit_type"}    = "";
  $detector{"identifiers"} = "";

  print_det(\%detector, $file);
}


# Gap2 Volume
sub make_GAP2
{
  $detector{"name"}        = "GAP2";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Methane Gap";
  $detector{"pos"}         = "${Gap2PosX}*mm ${Gap2PosY}*mm ${Gap2PosZ}*mm";
  $detector{"rotation"}    = "0.*deg 0.*deg 0.*deg";
  $detector{"color"}       = "ffffff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$Gap2Hall_z*mm $Gap2Hall_th*deg $Gap2Hall_ph*deg $Gap2Hall_y1*mm $Gap2Hall_x1*mm $Gap2Hall_x2*mm $Gap2Hall_Alp1*deg $Gap2Hall_y2*mm $Gap2Hall_x3*mm $Gap2Hall_x4*mm $Gap2Hall_Alp2*deg";
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

# Gap3 Volume
sub make_GAP3
{
  $detector{"name"}        = "GAP3";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Methane Gap";
  $detector{"pos"}         = "${Gap3PosX}*mm ${Gap3PosY}*mm ${Gap3PosZ}*mm";
  $detector{"rotation"}    = "0.*deg 0.*deg 0.*deg";
  $detector{"color"}       = "ffffff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$Gap3Hall_z*mm $Gap3Hall_th*deg $Gap3Hall_ph*deg $Gap3Hall_y1*mm $Gap3Hall_x1*mm $Gap3Hall_x2*mm $Gap3Hall_Alp1*deg $Gap3Hall_y2*mm $Gap3Hall_x3*mm $Gap3Hall_x4*mm $Gap3Hall_Alp2*deg";
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


# Gap4 Volume
sub make_GAP4
{
  $detector{"name"}        = "GAP4";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Methane Gap";
  $detector{"pos"}         = "${Gap4PosX}*mm ${Gap4PosY}*mm ${Gap4PosZ}*mm";
  $detector{"rotation"}    = "0.*deg 0.*deg 0.*deg";
  $detector{"color"}       = "ffffff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$Gap4Hall_z*mm $Gap4Hall_th*deg $Gap4Hall_ph*deg $Gap4Hall_y1*mm $Gap4Hall_x1*mm $Gap4Hall_x2*mm $Gap4Hall_Alp1*deg $Gap4Hall_y2*mm $Gap4Hall_x3*mm $Gap4Hall_x4*mm $Gap4Hall_Alp2*deg";
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


# Gap5 Volume
sub make_GAP5
{
  $detector{"name"}        = "GAP5";
  $detector{"mother"}      = "RICH";
  $detector{"description"} = "Methane Gap";
  $detector{"pos"}         = "${Gap5PosX}*mm ${Gap5PosY}*mm ${Gap5PosZ}*mm";
  $detector{"rotation"}    = "0.*deg 0.*deg 0.*deg";
  $detector{"color"}       = "ffffff";
  $detector{"type"}        = "G4Trap";
  $detector{"dimensions"}  = "$Gap5Hall_z*mm $Gap5Hall_th*deg $Gap5Hall_ph*deg $Gap5Hall_y1*mm $Gap5Hall_x1*mm $Gap5Hall_x2*mm $Gap5Hall_Alp1*deg $Gap5Hall_y2*mm $Gap5Hall_x3*mm $Gap5Hall_x4*mm $Gap5Hall_Alp2*deg";
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


##Pad half length (Box)
my $PadX = 25;
my $PadY = 25;
my $PadZ = 0.5;
my $PAD_XSPACE = 0.0;
my $PAD_YSPACE = 0.0;
my $PadPosZ = $GapPosZ + $GapHall_z + $PadZ;

my $X_START =  -$RichHall_x4;
my $X_END   =   $RichHall_x4;
my $Y_START =  -$RichHall_y2 + $PadPosZ * tan($RichHall_th/57.3) + 1.0;
my $Y_END   = $Y_START + 1200;

# limited to 20 degrees
#my $Y_END   =  $Y_START + 2450. - $PadPosZ * tan($RichHall_th/57.3); 
# limited to 30 degrees
#my $Y_END   =  $Y_START + 3000. - $PadPosZ * tan($RichHall_th/57.3); 
#my $Y_END   = $Y_START + 2. * $RichHall_y2;
my $Y_MIRROR= $Y_START + 950;
my $ttt = $PadPosZ * tan($RichHall_th/57.3);
print "Y limits  $ttt $RichHall_y2 --> $Y_END \n";


# Photon Detector Volume

my $MAX_NUM = 1000;
my $iy=0;

sub make_PAD
{
  my $PadPosY = $Y_START+$PadY;
  for(my $n1=1; $n1<=$MAX_NUM; $n1++)
  {
    if($PadPosY <  $Y_START+$PadY || $PadPosY >  $Y_END-$PadY){next;}

    my $PadPosX1 = ($PadPosY - $DD)/$CC;  #left line
    my $PadPosX2 = ($DD - $PadPosY)/$CC;  #right line
    my $PadPosX  = $PadPosX1+$PadX;

    for(my $n2=1; $n2<=$MAX_NUM; $n2++)
    {

      my $PadPosM3 = ($Y_MIRROR - $DD)/$CC;  
      my $PadPosM4 = ($DD - $Y_MIRROR)/$CC;  
      my $PadPosX3 = 2 * $PadPosM3 - $PadPosX1;
      my $PadPosX4 = 2 * $PadPosM4 - $PadPosX2;

      if($PadPosY <  $Y_START+$PadY || $PadPosY >  $Y_END-$PadY               #original
      || $PadPosX <  $X_START+$PadX || $PadPosX > $X_END-$PadX
      || $PadPosX <  $PadPosX1+$PadX || $PadPosX > $PadPosX2-$PadX){next;}
      print "Candidate PAD $iy $PadPosX $PadPosY \n"; 

#     if($PadPosY > $Y_MIRROR){
#       print "here we are: $n1 $PadPosY $DD $CC $Y_MIRROR \n";
#       print "here we are: $PadPosX $PadPosX1 $PadPosX2 $PadPosX3 $PadPosX4\n";
#       if($PadPosX < $PadPosX3 || $PadPosX > $PadPosX4)
#       {print "rejected\n"; next;}
#     }

      my $PadPosX01c  = $PadPosX + $PadX;
      my $PadPosX02c  = $PadPosX - $PadX;
      my $PadPosY01cL = $CC*$PadPosX01c + $DD;
      my $PadPosY02cL = -$CC*$PadPosX02c + $DD;
      my $PadPosY0c   = $PadPosY - $PadY;

      if($PadPosX<0) {if($PadPosY0c <= $PadPosY01cL) {next;}}
      if($PadPosX>0) {if($PadPosY0c <= $PadPosY02cL) {next;}}

#     print "position: $n1 $n2 $PadPosX $PadPosY $Y_MIRROR\n";

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
      $detector{"material"}    = "Methane";
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
      $iy++;

      $PadPosX += (2*$PadX + $PAD_XSPACE);
    }
   $PadPosY += (2*$PadY + $PAD_YSPACE);
  }
  print "$iy pads in total\n";
}


#PhotoCathode
#my $PhCathX = 3;
#my $PhCathY = 3;
my $PhCathX = 24;
my $PhCathY = 24;
my $PhCathZ = 0.1;
my $PhCathPosX = 0;
my $PhCathPosY = 0;
my $PhCathPosZ =  0;

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
# $detector{"material"}    = "Alumi";
  $detector{"material"}    = "Methane";
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


sub make_test_marker
{
 $detector{"name"}        = "test_marker";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Box used for test";
 $detector{"pos"}         = "-1952.47*mm -2119.47*mm 5787.65*mm"; 
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "50*mm 50*mm 50*mm";
 $detector{"material"}    = "Vacuum";
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;

 print_det(\%detector, $file);

}

sub make_test_box1
{
 $detector{"name"}        = "text_box1";
 $detector{"mother"}      = "sector";
 $detector{"description"} = "Box used for test";
# $detector{"pos"}         = "0*mm 0*mm 941.34"; 
 $detector{"pos"}         = "0*mm 0*mm 2099.88"; 
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Box";
# $detector{"dimensions"}  = "5*mm 3136.17*mm 1462.42";
 $detector{"dimensions"}  = "5*mm 3747.72*mm 1747.59";
 $detector{"material"}    = "Vacuum";
 $detector{"identifiers"} = "";

 print_det(\%detector, $file);

}


sub make_test_box2
{
 $detector{"name"}        = "text_box2";
 $detector{"mother"}      = "sector";
 $detector{"description"} = "Box used for test";
# $detector{"pos"}         = "0*mm 0*mm 941.34*mm"; 
 $detector{"pos"}         = "0*mm 0*mm 2099.88*mm"; 
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffeeff";
 $detector{"type"}        = "Box";
# $detector{"dimensions"}  = "30*mm 280*mm 130.566*mm";
 $detector{"dimensions"}  = "30*mm 334.6*mm 156.026*mm";
 $detector{"material"}    = "Vacuum";
 $detector{"identifiers"} = "";

 print_det(\%detector, $file);

}

make_RICH();
make_RADIATOR1();
make_RADIATOR2();
make_RADIATOR3();
make_RADIATOR4();
make_RADIATOR5();
make_GAP();
make_GAP2();
make_GAP3();
make_GAP4();
make_GAP5();
#make_PAD();
#make_PhCath();
#make_test_marker();
#make_test_box1();
#make_test_box2();
#make_pipe_plate();
#make_back_plate();




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


# MIRROR
# General description. Index = mirror, 4 mirrors total.

my $number_of_mirrors = 2;
my $mthick  = 1.0;  # mirror is 1mm thick
my $rthick  = 100.0;  # radiator is 10 cm thick

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

my @fc2x    = (  417.483    ,  417.483    ,  492.379     ,  503.907 );  # focal point 2 x position
my @fc2y    = ( 1558.067    , 1558.067    , 1837.584     , 1880.607 );  # focal point 2 y position
my @fc2z    = (  -62.047    ,  -62.047    ,  425.482     ,  707.739 );  # focal point 2 z position


my $nsegments = 12;


# G4 materials
my $mirror_material   = 'G4_Si';

# G4 colors
my @mirror_color      = ('99eeff', 'ee99ff', 'ff44ff', 'ffee55');
my @mirror_style      = (1, 0, 0, 0);


my $microgap_width = 0.01;




sub make_mirrors1a
{
 for(my $m = 0; $m < $number_of_mirrors; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "aaa_htcc_Mirror$mind";
    $detector{"mother"}      = "RICH";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Ellipsoid part 1";
    $detector{"pos"}         = "0*cm 0*cm 0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Ellipsoid";
    $detector{"dimensions"}  = "$axisA[$m]*mm $axisB[$m]*mm $axisC[$m]*mm 0*mm 0*mm";
    $detector{"material"}    = "Vacuum";
    $detector{"material"}    = "Component";
    $detector{"identifiers"} = "";

    print_det(\%detector, $file);
 }
}

sub make_mirrors1b
{
 for(my $m = 0; $m < $number_of_mirrors; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "aab_htcc_Mirror$mind";
    $detector{"mother"}      = "RICH";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Ellipsoid part 2";
    $detector{"pos"}         = "0*mm 0*cm 0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Ellipsoid";
    $detector{"dimensions"}  = "$axisAv[$m]*mm $axisBv[$m]*mm $axisCv[$m]*mm 0*mm 0*mm";
    $detector{"material"}    = "Vacuum";
    $detector{"material"}    = "Component";
    $detector{"identifiers"} = "";

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
    $detector{"identifiers"} = "";

    print_det(\%detector, $file);
 }
}


# Tube used for subtraction
my $tune_R         = 3800.0;
my $tube_z         = 5000.0;
 my $tube_start_phi = 120.0; # test1
 my $tube_phi_span  = 360.0 - 60.0;  # test1

sub make_sub_tube
{
 $detector{"name"}        = "aad_htcc_tube";
 $detector{"mother"}      = "RICH";
 $detector{"description"} = "Tube 1 used to cut the mirrors";
 $detector{"pos"}         = "0*mm 0*mm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0*mm $tune_R*mm $tube_z*mm $tube_start_phi*deg $tube_phi_span*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"material"}    = "Component";
 $detector{"identifiers"} = "";

 print_det(\%detector, $file);

}



sub make_mirrors1e
{
 for(my $m = 0; $m < $number_of_mirrors; $m++)
 {
    my $mind                 = $m + 1;
    $detector{"name"}        = "aae_htcc_Mirror$mind";
    $detector{"mother"}      = "RICH";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Half Ellipsoid";
    $detector{"pos"}         = "0*cm 0*cm 0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Operation: aac_htcc_Mirror$mind - aad_htcc_tube";
    $detector{"dimensions"}  = "0";
    $detector{"material"}    = "Vacuum";
    $detector{"material"}    = "Component";
    $detector{"identifiers"} = "";

    print_det(\%detector, $file);
 }
}



# Box used for subtraction
my $box_x = 3800.0;
my $box_y = 3800.0;
my $box_z = 5000.0;


sub make_sub_box1
{
 $detector{"name"}        = "aad_htcc_box1";
 $detector{"mother"}      = "RICH";
 $detector{"description"} = "Box 1 used to cut the mirrors in half";
# $detector{"pos"}         = "0*mm 0*mm 8989*mm";#old
 $detector{"pos"}         = "0*mm 0*mm 9058*mm";#new
# $detector{"pos"}         = "0*mm 0*mm 9100.06"; #test1
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
 $detector{"mother"}      = "RICH";
 $detector{"description"} = "Box 1 used to cut the mirrors in half";
#$detector{"pos"}         = "0*mm 0*mm -2972*mm";#old
 $detector{"pos"}         = "0*mm 0*mm -2800*mm";#new
#  $detector{"pos"}         = "0*mm 0*mm -3070*mm";# test1
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ffffff";
 $detector{"type"}        = "Box";
 $detector{"dimensions"}  = "$box_x*mm $box_y*mm $box_z*mm";
 $detector{"material"}    = "Vacuum";
 $detector{"material"}    = "Component";
 $detector{"identifiers"} = "";

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
    $detector{"identifiers"} = "";

    print_det(\%detector, $file);
 }
}


sub make_mirrors1g
  {
    for(my $m = 0; $m < 1; $m++)
      {
	my $mind                 = $m + 1;
    $detector{"name"}        = "aag_htcc_Mirror$mind";
    $detector{"mother"}      = "GAP";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Half Ellipsoid";
#   $detector{"pos"}         = "0*mm -319.061*mm -3751.54m";  # base
    $detector{"pos"}         = "0*mm -319.061*mm -3811.54m";  # shift per zona morta
    $detector{"rotation"}    = "-25*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Operation: aaf_htcc_Mirror$mind - aad_htcc_box2";
    $detector{"dimensions"}  = "0";
    $detector{"material"}    = "Methane";
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = $mirror_style[$m];
    $detector{"sensitivity"} = "FLUX";
    $detector{"hit_type"}    = "FLUX";
    $detector{"identifiers"} = "Mirror WithSurface: 0 With Finish: 0 Refraction Index: 10000000 With Reflectivity:  1000000 With Efficiency:      0  WithBorderVolume: MirrorSkin";

    print "FACCIO 1g identifiers\n";
    print_det(\%detector, $file);
 }
}


sub make_mirrors1h
  {
    for(my $m = 1; $m < 2 ; $m++)
      {
	my $mind                 = $m + 1;
    $detector{"name"}        = "aah_htcc_Mirror$mind";
    $detector{"mother"}      = "GAP";
    $detector{"description"} = "High Threshold Cerenkov Mirror $mind - Half Ellipsoid";
#   $detector{"pos"}         = "0*mm -319.061*mm -3751.54m";  # base
    $detector{"pos"}         = "0*mm -319.061*mm -3811.54m";  # shift per zona morta
    $detector{"rotation"}    = "-25*deg 0*deg 0*deg";
    $detector{"color"}       = $mirror_color[$m];
    $detector{"type"}        = "Operation: aaf_htcc_Mirror$mind - aad_htcc_box2";
    $detector{"dimensions"}  = "0";
    $detector{"material"}    = "RichAerogel";
    $detector{"mfield"}      = "no";
    $detector{"ncopy"}       = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = $mirror_style[$m];
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = "";

    print "FACCIO 1g identifiers\n";
    print_det(\%detector, $file);
 }
}


#make_PREMIRROR();
make_POSTMIRROR();
make_mirrors1a();
make_mirrors1b();
make_mirrors1c();
make_sub_tube();
make_mirrors1e();
make_sub_box1();
make_sub_box2();
make_mirrors1f();
make_mirrors1g();
#make_mirrors1h();
