#!/usr/bin/perl -w


use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

use geo qw($pi);


my $envelope = 'moeller_shield_IC';
my $file     = 'moeller_shield_IC.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();          # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;




my $nplanes = 2;


# 1.2 deg inner cone
# 1.5 deg outer cone

# Corner:           1           2
my @iradiusv  = ( 0.0,        0.0      );
my @oradiusv  = (12.57/2.0,   68.1/2.0  );

my @iradius  = (  0.0,        0.0      );
my @oradius  = ( 15.71/2.0,  85.1/2.0  );
my @zplane   = (  0.0,       1325.0    );


my $zstart  = 300.00;       # z coordinate of shield start


sub make_moeller_shield
{
 $detector{"name"}        = "moeller_shield_IC1";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Moeller Shielding with IC installed - Inner Shield 1";
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
 $detector{"dimensions"}  = $dimen;
 $detector{"material"}    = "G4_W";
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

 #############################
 # Vacuum inside the shielding
 #############################

 $detector{"name"}        = "moeller_shield_IC1_vac";
 $detector{"mother"}      = "moeller_shield_IC1";
 $detector{"description"} = "Moeller Shielding Vacuum - Inner Shield 1";
 $detector{"pos"}         = "0*cm 0.0*cm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "00ffff";
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
    $dimen = $dimen ." $zplane[$i]*mm";
 }
 $detector{"dimensions"}  = $dimen;
 $detector{"material"}   = "Vacuum";
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



# 5.5 deg inner cone
# 6.0 deg outer cone


my $nplanes2 = 2;

# Corner:           1           2

my @iradius2  = ( 57.6/2.0,     312.0/2.0);
my @oradius2  = ( 62.83/2.0,        340.34/2.0 );
my @zplane2   = (  0.0,       1325.0 );

my $zstart2  = 300.00;       # z coordinate of shield start


sub make_moeller_shield2
{
 $detector{"name"}        = "moeller_shield_IC2";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Moeller Shielding with IC installed - Inner Shield 2";
 $detector{"pos"}       = "0*mm 0.0*mm $zstart2*mm";
 $detector{"rotation"}  = "0*deg 0*deg 0*deg";
 $detector{"color"}     = "0000ff";
 $detector{"type"}      = "Polycone";

 my $dimen = "0.0*deg 360*deg $nplanes";
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $iradius2[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $oradius2[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $zplane2[$i]*mm";
 }

 $detector{"dimensions"}  = $dimen;
 $detector{"material"}   = "G4_W";
 $detector{"mfield"}     = "no";
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


# Corner:           1           2
my @iradiusv3  = ( 0.0,        0.0    );
my @oradiusv3  = (50.0,       80.0    );

my @iradius3  = (  0.0,        0.0    );
my @oradius3  = ( 52.0,       82.0);
my @zplane3   = (  0.0,     1200.0    );

my $zstart3 = 980.0;

sub make_moeller_shield3
{
 $detector{"name"}        = "moeller_shield_IC3";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Moeller Shielding with IC installed - Inner Shield 3";
 $detector{"pos"}         = "0*mm 0.0*mm $zstart3*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0000ff";
 $detector{"type"}        = "Polycone";

 my $dimen = "0.0*deg 360*deg $nplanes";
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $iradius3[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $oradius3[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $zplane3[$i]*mm";
 }

 $detector{"dimensions"}  = $dimen;
 $detector{"material"}   = "G4_W";
 $detector{"mfield"}     = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 0;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";
 print_det(\%detector, $file);

 #############################
 # Vacuum inside the shielding
 #############################

 $detector{"name"}        = "moeller_shield_IC3_vac";
 $detector{"mother"}      = "moeller_shield_IC3";
 $detector{"description"} = "Moeller Shielding Vacuum - Inner Shield 3";
 $detector{"pos"}         = "0*cm 0.0*cm 0*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "00ffff";
 $detector{"type"}        = "Polycone";

 $dimen = "0.0*deg 360*deg $nplanes";
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $iradiusv3[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $oradiusv3[$i]*mm";
 }
 for(my $i = 0; $i <$nplanes ; $i++)
 {
    $dimen = $dimen ." $zplane3[$i]*mm";
 }

 $detector{"dimensions"}  = $dimen;
 $detector{"material"}   = "Vacuum";
 $detector{"mfield"}     = "no";
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



make_moeller_shield();
make_moeller_shield2();
# make_moeller_shield3();









