#!/usr/bin/perl -w

# all dimensions in mm

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

# All dimensions in mm

my $envelope = 'eg1_dvcs_beamline';
my $file     = 'eg1_dvcs_beamline.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


# All dimensions in cm


my $beamline_z  = -30;  # Overall start of beamline
my $HB_IR       = 4.0/2.0;
my $IC_IR       = 1.0/2.0;
my $IC_z_pos    = 30;
my $IC_length   = 20;
my $HB_length   = 72.1;





###################################################
# Helium Polyvone from Target, in and out of the IC 
###################################################

my $nplanes = 6;

# Numbers coming from ROOT macro
# Corner:            1                2                   3                    4                                  5                       6
my @zplane   = (     0.0     ,     $IC_z_pos   ,  $IC_z_pos + 0.1  ,  $IC_z_pos +  $IC_length  ,   $IC_z_pos +  $IC_length + 0.1 ,  $HB_length    );
my @oradius  = (   $HB_IR    ,      $HB_IR     ,        $IC_IR     ,    $IC_IR                 ,            $HB_IR               ,    $HB_IR      );
my @iradius  = (        0    ,           0     ,             0     ,       0                   ,                0                ,      0         );

sub make_helium_bag
{

 $detector{"name"}        = "eg1_helium_bag";
 $detector{"mother"}      = "root";
 $detector{"description"} = "eg1-dvcs helium bag";
 $detector{"pos"}         = "0*mm 0.0*mm $beamline_z*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "661111";
 $detector{"type"}        = "Polycone";

 my $dimen = "0.0*deg 360*deg $nplanes";
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $iradius[$i]*cm";
 }
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $oradius[$i]*cm";
 }
  for(my $i = 0; $i <$nplanes ; $i++)
  {
    $dimen = $dimen ." $zplane[$i]*cm";
  }
 $detector{"dimensions"}  = $dimen;
 $detector{"material"}    = "G4_He";
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




# Downstream vacuum pipe
my $air_gap   = 4.64;
my $vp_IR     = 4.75;
my $vp_OR     = $vp_IR + 0.6;
my $vp_length = 500;

sub make_down_vacuum_pipe
{

  my $zpos = $beamline_z + $HB_length + $air_gap + $vp_length + 0.1;  # allow 1mm for all the vacuum windows 

	my $pir = $vp_IR + 0.1;
  $detector{"name"}        = "eg1_vacpipe";
  $detector{"mother"}      = "root";
  $detector{"description"} = "eg1-dvcs downstream vacuum pipe";
  $detector{"pos"}         = "0*mm 0.0*mm $zpos*cm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "88aabb";
  $detector{"type"}        = "Tube";
  $detector{"dimensions"}  = "$pir*cm $vp_OR*cm $vp_length*cm 0*deg 360*deg";
  $detector{"material"}    = "G4_Al";
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

  my $pvlength              = $vp_length;
  $detector{"name"}        = "eg1_vacpipe_vac";
  $detector{"mother"}      = "root";
  $detector{"description"} = "eg1-dvcs vacuum in the downstream vacuum pipe";
  $detector{"pos"}         = "0*mm 0.0*mm $zpos*cm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "aaeefff";
  $detector{"type"}        = "Tube";
  $detector{"dimensions"}  = "0*cm $vp_IR*cm $pvlength*cm 0*deg 360*deg";
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



# Vacuum Windows

sub make_windows
{
  my $zpos1  = $beamline_z - 0.1;
  my $thick1 = 0.0015/2; # 15 microns in cm
  $detector{"name"}        = "eg1_vacwindow1";
  $detector{"mother"}      = "root";
  $detector{"description"} = "eg1-dvcs downstream vacuum pipe";
  $detector{"pos"}         = "0*mm 0.0*mm $zpos1*cm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "000000";
  $detector{"type"}        = "Tube";
  $detector{"dimensions"}  = "0*cm $vp_OR*cm $thick1*cm 0*deg 360*deg";
  $detector{"material"}    = "G4_Al";
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
  
  my $zpos2  = $beamline_z + $HB_length + 0.1;
  my $thick2 = 0.0015/2; # 15 microns in cm
  $detector{"name"}        = "eg1_vacwindow2";
  $detector{"mother"}      = "root";
  $detector{"description"} = "eg1-dvcs downstream vacuum pipe";
  $detector{"pos"}         = "0*mm 0.0*mm $zpos2*cm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "000000";
  $detector{"type"}        = "Tube";
  $detector{"dimensions"}  = "0*cm $vp_OR*cm $thick2*cm 0*deg 360*deg";
  $detector{"material"}    = "G4_Al";
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
  
  my $zpos3  = $beamline_z + $HB_length + $air_gap - 0.1;
  my $thick3 = 0.0071/2; # 71 microns in cm
  $detector{"name"}        = "eg1_vacwindow3";
  $detector{"mother"}      = "root";
  $detector{"description"} = "eg1-dvcs downstream vacuum pipe";
  $detector{"pos"}         = "0*mm 0.0*mm $zpos3*cm";
  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
  $detector{"color"}       = "000000";
  $detector{"type"}        = "Tube";
  $detector{"dimensions"}  = "0*cm $vp_OR*cm $thick3*cm 0*deg 360*deg";
  $detector{"material"}    = "G4_Al";
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

make_helium_bag();
make_down_vacuum_pipe();
make_windows();










