#!/usr/bin/perl -w


use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

use geo qw($pi);


my $envelope = 'moeller_shield';
my $file     = 'moeller_shield.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();          # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;




# all dimensions in mm

# Modified design, 5 degrees open angle at start, then match ID of Torus Ring 
# We want to detect 5 degrees particle at least.
# See the output of the ROOT macro absorber_dimensions.C for details

# The moeller shielding it's composed by three pieces:
# 1) LEAD STRUCTURE       - from FST to Torus Ring
# 2) STAINLESS STEEL PIPE - inside Torus Ring
# 3) SHIELD PIPE          - after Torus Ring

my $inches = 25.4;

my $TIR                   = 37.6;              # Torus ID is 75.2 mm
my $pthick                = 3.0;               # Pipe thickness through the Torus Ring
my $zstart                = 300.00;            # z coordinate of shield start
my $TOR                   = 150.0;             # Max Outer Radius allowed at max moeller sausage
my $length_at_TOR         = 1500.0;
my $TOR2                  = 100.0;             # Max Outer Radius allowed near Torus
my $moeller_shield_length = 2320.0;            # LEAD STRUCTURE total length
my $gap                   = 0.02;              # Gap between structures
my $InnerCoilLength       = 90.0*$inches/2.0;  # Torus Inner ring 1/2 length

my $shield_pipe_length    = 1500.0;            # 1/2 length
my $shield_pipe_IR        = 50.0;
my $shield_pipe_OR        = 200.0;

#########################################
# LEAD STRUCTURE - from FST to Torus Ring
#########################################

my $nplanes = 4;
my $min_abs = 1.0;    # Minimum Thickness of the Absorber at the entrance point

# Numbers coming from ROOT macro
# Corner:                1                   2         3 max R         4 torus1
my @zplane   = (  0.0            ,   170.0          ,   $length_at_TOR  ,   $moeller_shield_length    );
my @oradius  = ( 23.7            ,   37.9           ,   $TOR            ,   $TOR2                     );
my @zplanev  = (  0.0            ,   170.0          ,   $length_at_TOR  ,   $moeller_shield_length    );
my @oradiusv = ( 23.7 - $min_abs ,   $TIR - $pthick ,   $TIR - $pthick  ,   $TIR - $pthick            );

my @iradius   = (0,0,0,0);
my @iradiusv  = (0,0,0,0);

sub make_first_shield
{
 $detector{"name"}        = $envelope;
 $detector{"mother"}      = "root";
 $detector{"description"} = "Moeller Shielding";
 $detector{"pos"}         = "0*mm 0.0*mm $zstart*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0000ff";
 $detector{"type"}        = "Polycone";

 my $dimen = "0.0*deg 360*deg $nplanes";
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $iradius[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $oradius[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $zplane[$i]*mm";
 }
 $detector{"dimensions"} = 1;
 $detector{"material"}   = "Lead";
 $detector{"mfield"}     = "no";
 $detector{"ncopy"}      = "1";
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";

 print_det(\%detector, $file);



 #############################
 # Vacuum inside the shielding
 #############################

 $detector{"name"}        = "moeller_shield_vac";
 $detector{"mother"}      = "moeller_shield";
 $detector{"description"} = "Moeller Shielding Vacuum";
 $detector{"pos"}         = "0*cm 0.0*cm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "aaffff";
 $detector{"type"}        = "Polycone";

 $dimen = "0.0*deg 360*deg $nplanes";
 for(my $i = 0; $i <$nplanes ; $i++) 
 {
    $dimen = $dimen ." $iradiusv[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes ; $i++) 
 {
    $dimen = $dimen ." $oradiusv[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes ; $i++) 
 {
    $dimen = $dimen ." $zplanev[$i]*mm";
 }

 $detector{"material"}    = "Vacuum";
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


make_first_shield();


