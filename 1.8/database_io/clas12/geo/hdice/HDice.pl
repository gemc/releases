#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'HDice';
my $file     = 'HDice.txt';


my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

# All dimension in cm
# half length for box,tube,etc
my $inches   = 2.54;
my $scale = 0.403;
# downstream part of In-Beam Cryostat
my $mleng = $scale*198;
my $mleng2 = $mleng/2;

# Mother Volume
sub make_mother
{
 my $rad = $scale*25;
 my $zoff = -15.*$scale-5/2.;
 print("HD_IBM position $zoff \n");
 $detector{"name"}        = "HD_IBM";
 $detector{"mother"}      = "root";
 $detector{"description"} = "HDice In Beam Cryostat";
 $detector{"pos"}         = "0*cm 0.*cm $zoff*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Tube";
# $detector{"dimensions"}  = "0*cm $rad*cm $scale*425*cm 0*deg 360*deg";
 $detector{"dimensions"}  = "0*cm $rad*cm $mleng2*cm 0*deg 360*deg";
 $detector{"material"}    = "Air";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 0;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";

 print("HD_IBM 0*cm $rad*cm $scale*425*cm 0*deg 360*deg \n");

 print_det(\%detector, $file);
}

make_mother();

# outer vacuum can (#01-22-03xx)
sub make_ovc
{
 my $vthick = 0.095;
 my $vthick2 = 0.095/2;
 my $orad = $scale*16.5;
 my $irad = $orad - $vthick;

# upstream part 3xthicker
 my $lengu2 = $scale*41/2.0; 
 my $zposu = $lengu2 - $mleng2;
 my $oradu = $irad + $vthick*2;
 $detector{"name"}        = "HD_OVC_upstream";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice Outer Vacuum Can upstream";
 $detector{"pos"}         = "0*cm 0.0*cm $zposu*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "353540";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$irad*cm $oradu*cm $lengu2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

 my $leng2 = $scale*144.5/2.0;
 my $zpos = $zposu + $lengu2 + $leng2;
 $detector{"name"}        = "HD_OVC";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice Outer Vacuum Can";
 $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "353540";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$irad*cm $orad*cm $leng2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

# backup coils (on OVC)
 my $cleng2 = $scale*118/2.0; 
 my $corad = $orad + 0.1;
 my $zposc = $lengu2*2 +$cleng2 - $mleng2; 
 $detector{"name"}        = "HD_backup_coils";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice backup coils";
 $detector{"pos"}         = "0*cm 0.0*cm $zposc*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "772200";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$orad*cm $corad*cm $cleng2*cm 0*deg 360*deg";
 $detector{"material"}    = "G4_Cu";
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

#downstream end: disk
 my $zdpos = $zpos + $leng2 - $vthick2;
 $detector{"name"}        = "HD_OVC_endcap";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice Outer Vacuum Can downstream end cap";
 $detector{"pos"}         = "0*cm 0.0*cm $zdpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "353540";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0*cm $irad*cm $vthick2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

#downstream cone (foam)
 my $caprad = $orad - $scale*3;
 my $capleng2 = $scale*10.7/2.0;
 my $capzpos = $scale*92.5;
 my $capirad = $scale*3;
 $detector{"name"}        = "HD_OVC_foam";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice foam at downstream end";
 $detector{"pos"}         = "0*cm 0.0*cm $capzpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "e10000";
 $detector{"type"}        = "Cons";
 $detector{"dimensions"}  = "$caprad*cm $orad*cm 0*cm $capirad*cm $capleng2*cm 0*deg 360*deg";
 $detector{"material"}    = "Rohacell";
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


# 80K shield (#01-22-03xx)
sub make_80Kshield
{
 my $vthick = 0.095;
 my $vthick2 = 0.095/2;
 my $orad = $scale*12.5;
 my $irad = $orad - $vthick;
 my $leng2 = $scale*185/2.0;
 my $zpos = $leng2 - $mleng2;
 $detector{"name"}        = "HD_80Kshield";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice 80K shield";
 $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "e200e1";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$irad*cm $orad*cm $leng2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

#upstream part: double layer
 my $oradu = $orad + $vthick*2;
 my $lengu2 = $scale*101/2.0;
 my $zposu = $lengu2 - $mleng2;
 $detector{"name"}        = "HD_80Kshield_upstream";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice 80K shield upstream double layer";
 $detector{"pos"}         = "0*cm 0.0*cm $zposu*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "e200e1";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$orad*cm $oradu*cm $lengu2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

#downstream endcap: disk
 my $zdpos = $zpos + $leng2 - $vthick2;
 $detector{"name"}        = "HD_80Kshield_endcap";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice 80K shield endcap";
 $detector{"pos"}         = "0*cm 0.0*cm $zdpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "e200e1";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0*cm $irad*cm $vthick2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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


# 4K shield (#01-22-03xx)
sub make_4Kshield
{
 my $vthick = 0.095;
 my $vthick2 = 0.095/2;
 my $orad = $scale*11.5;
 my $irad = $orad - $vthick;
 my $leng2 = $scale*174.5/2.0;
 my $zpos = $leng2 - $mleng2;
 $detector{"name"}        = "HD_4Kshield";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice 4K shield";
 $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0000e1";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$irad*cm $orad*cm $leng2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

#upstream part: double layer
 my $oradu = $orad + $vthick*2;
 my $lengu2 = $scale*69/2.0;
 my $zposu = $lengu2 - $mleng2;
 $detector{"name"}        = "HD_4Kshield_upstream";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice 4K shield upstream double layer";
 $detector{"pos"}         = "0*cm 0.0*cm $zposu*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0000e1";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$orad*cm $oradu*cm $lengu2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

#downstream endcap: disk
 my $zdpos = $zpos + $leng2 - $vthick2;
 $detector{"name"}        = "HD_4Kshield_endcap";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice 4K shield endcap";
 $detector{"pos"}         = "0*cm 0.0*cm $zdpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0000e1";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0*cm $irad*cm $vthick2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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


# 1K shield (#01-22-03xx)
sub make_1Kshield
{
 my $vthick = 0.095;
 my $vthick2 = 0.095/2;
 my $orad = $scale*10.5;
 my $irad = $orad - $vthick;
 my $leng2 = $scale*174.0/2.0;
 my $zpos = $leng2 - $mleng2;
 $detector{"name"}        = "HD_1Kshield";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice 1K shield";
 $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0000ff";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$irad*cm $orad*cm $leng2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = "";

 print("HD_1Kshield $irad*cm $orad*cm $leng2*cm 0*deg 360*deg \n");

 print_det(\%detector, $file);

#upstream part: double layer
 my $oradu = $orad + $vthick*2;
 my $lengu2 = $scale*69/2.0;
 my $zposu = $lengu2 - $mleng2;
 $detector{"name"}        = "HD_1Kshield_upstream";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice 1K shield upstream double layer";
 $detector{"pos"}         = "0*cm 0.0*cm $zposu*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0000ff";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$orad*cm $oradu*cm $lengu2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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


sub make_target_holder
{
 my $vthick = 0.095;
 my $vthick2 = 0.095/2;
 my $orad = $scale*2.5;
 my $irad = $orad - $vthick;
 print("Raggio holder $irad $orad \n");
 my $leng2 = $scale*30/2.0;
 my $zpos = $scale*27;
 $detector{"name"}        = "HD_target_holder";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice target holder";
 $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$irad*cm $orad*cm $leng2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

# endcap
 my $zpose = $zpos + $leng2 - $vthick2;
 $detector{"name"}        = "HD_target_holder_endcap";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice target holder endcap";
 $detector{"pos"}         = "0*cm 0.0*cm $zpose*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0*cm $irad*cm $vthick2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

# conical part (upstream of target)
 my $orad1 = $scale*4.8;
 my $orad2 = $scale*5;
 my $lengc2 = $scale*3/2.0;
 my $zposc = $zpos - $leng2 - $lengc2;
 $detector{"name"}        = "HD_target_holder_cone";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice target holder (conical part)";
 $detector{"pos"}         = "0*cm 0.0*cm $zposc*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Cons";
 $detector{"dimensions"}  = "$orad1*cm $orad2*cm $irad*cm $orad*cm $lengc2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

#upstream portion
 my $lengu2 = $scale*107/2.0;
 my $zposu = $lengu2 - $mleng2;
 $detector{"name"}        = "HD_target_holder_upstream";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice target holder (upstream part)";
 $detector{"pos"}         = "0*cm 0.0*cm $zposu*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$orad1*cm $orad2*cm $lengu2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

#mixing chamber
 my $oradm = $scale*8;
 my $iradm = $scale*6.5;
 my $lengm2 = $scale*34/2.0;
 my $zposm = $scale*3 - $lengm2;
 $detector{"name"}        = "HD_mixing_chamber";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice mixing chamber";
 $detector{"pos"}         = "0*cm 0.0*cm $zposm*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$iradm*cm $oradm*cm $lengm2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

#heating coils (rings)
 for(my $n=1; $n<=10; $n++)
 {
     my $cnum = cnumber($n-1,10);
     my $cthick = $scale*1.1;
     my $zcpos = $n*$scale*4.5 - $scale*1.1 - $mleng/2;
     $detector{"name"}        = "HD_heating_coil_$cnum";
     $detector{"mother"}      = "HD_IBM";
     $detector{"description"} = "HDice heating coil $cnum";
     $detector{"pos"}         = "0*cm 0.0*cm $zcpos*cm";
     $detector{"rotation"}    = "0*deg 0*deg 0*deg";
     $detector{"color"}       = "252020";
     $detector{"type"}        = "Tube";
     $detector{"dimensions"}  = "$orad2*cm $iradm*cm $cthick*cm 0*deg 360*deg";
#     $detector{"material"}    = "StainlessSteel";
     $detector{"material"}    = "Aluminum";
     $detector{"mfield"}      = "no";
     $detector{"ncopy"}       = $n;
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


sub make_coil_cage
{
 my $orad = $scale*5.8;
 my $irad = $scale*5.2;
 print("Raggio NMR   $irad $orad \n");
 my $leng2 = 40./2.;
 my $zpos = +15.*$scale+5/2.;
# my $irad = $scale*4.8;
# my $leng2 = $scale*17.5/2.0;
# my $zpos = $scale*12 + $leng2;
 $detector{"name"}        = "HD_NMR_coil_cage";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice NRM coil birdcage";
 $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "fff600";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$irad*cm $orad*cm $leng2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "G4_Cu";
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

#conical sections
# my $radc1 = $scale*7;
# my $radc2 = $scale*8;
# my $lengc2 = $scale*5/2.0;
# my $zposc = $zpos + $leng2 + $lengc2;
# $detector{"name"}        = "HD_NMR_coil_cone1";
# $detector{"mother"}      = "HD_IBM";
# $detector{"description"} = "HDice NRM coil birdcage downstream cone";
# $detector{"pos"}         = "0*cm 0.0*cm $zposc*cm";
# $detector{"rotation"}    = "0*deg 0*deg 0*deg";
# $detector{"color"}       = "fff600";
# $detector{"type"}        = "Cons";
# $detector{"dimensions"}  = "$irad*cm $orad*cm $radc1*cm $radc2*cm $lengc2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
# $detector{"mfield"}      = "no";
# $detector{"ncopy"}       = 1;
# $detector{"pMany"}       = 1;
# $detector{"exist"}       = 1;
# $detector{"visible"}     = 1;
# $detector{"style"}       = 0;
# $detector{"sensitivity"} = "no";
# $detector{"hit_type"}    = "";
# $detector{"identifiers"} = "";

# print_det(\%detector, $file);

# my $zposa = $zpos - $leng2 - $lengc2;
# $detector{"name"}        = "HD_NMR_coil_cone2";
# $detector{"mother"}      = "HD_IBM";
# $detector{"description"} = "HDice NRM coil birdcage upstream cone";
# $detector{"pos"}         = "0*cm 0.0*cm $zposa*cm";
# $detector{"rotation"}    = "0*deg 0*deg 0*deg";
# $detector{"color"}       = "fff600";
# $detector{"type"}        = "Cons";
# $detector{"dimensions"}  = "$radc1*cm $radc2*cm $irad*cm $orad*cm $lengc2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
# $detector{"mfield"}      = "no";
# $detector{"ncopy"}       = 1;
# $detector{"pMany"}       = 1;
# $detector{"exist"}       = 1;
# $detector{"visible"}     = 1;
# $detector{"style"}       = 0;
# $detector{"sensitivity"} = "no";
# $detector{"hit_type"}    = "";
# $detector{"identifiers"} = "";

# print_det(\%detector, $file);

}  


sub make_hd_target
{
 my $leng2 = 5.0/2.0;
 my $thick2 = 0.03;
# my $rad = $scale*2.3;
# try to avoid overlaps
 my $rad = $scale*2.1;
 my $orad = $thick2*2 + $rad;
 print("Raggio cell  $rad $orad \n");
 my $zpos = $scale*15 + $leng2;
 $detector{"name"}        = "HDice_target_cell";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice target cell";
 $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "00ff00";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$rad*cm $orad*cm $leng2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
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

 my $zposc = $zpos + $leng2 + $thick2;
 $detector{"name"}        = "HDice_target_cellcap1";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice target cell downstream endcap";
 $detector{"pos"}         = "0*cm 0.0*cm $zposc*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "00ff00";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0*cm $orad*cm $thick2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

 my $zpose = $zpos - $leng2 - $thick2;
 $detector{"name"}        = "HDice_target_cellcap2";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice target cell upstream endcap";
 $detector{"pos"}         = "0*cm 0.0*cm $zpose*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "00ff00";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0*cm $orad*cm $thick2*cm 0*deg 360*deg";
# $detector{"material"}    = "StainlessSteel";
 $detector{"material"}    = "Aluminum";
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

 $detector{"name"}        = "HDice_target";
 $detector{"mother"}      = "HD_IBM";
 $detector{"description"} = "HDice target";
 $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "00c000";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "0*cm $rad*cm $leng2*cm 0*deg 360*deg";
 $detector{"material"}    = "G4_lH2";
# $detector{"mfield"}      = "uniformX5T";
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


#Compensating coil
sub make_control_coil
 {
# my $leng2 = 5.0/2.0;
# my $zpos = $scale*15 + $leng2;
 my $zpos = 0;

# 70 degree acceptance solenoid
# my $xleng2 = 7.6/2.;  
# 60 degree acceptance solenoid
 my $xleng2 = 6.1;      
 my $xirad = 10.5;
 my $xorad = 13.5;
 $detector{"name"}        = "Control_coils";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Compensating coils";
 $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "772200";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$xirad*cm $xorad*cm $xleng2*cm 0*deg 360*deg";
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


#Helmoltz coil
sub make_helmoltz_coil
 {
 my $zpos = 5.0;
 my $xleng2 = 3./2.;   
 my $xirad =  7.5;
 my $xorad = 10.5;
 $detector{"name"}        = "Helmoltz_coil1";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Compensating Helmoltz coils";
 $detector{"pos"}         = "0*cm 0.0*cm $zpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "772200";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$xirad*cm $xorad*cm $xleng2*cm 0*deg 360*deg";
 $detector{"material"}    = "Kryptonite";
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

 $detector{"name"}        = "Helmoltz_coil2";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Compensating Helmoltz coils";
 $detector{"pos"}         = "0*cm 0.0*cm -$zpos*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "772200";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$xirad*cm $xorad*cm $xleng2*cm 0*deg 360*deg";
 $detector{"material"}    = "Kryptonite";
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

make_ovc();
make_80Kshield();
make_4Kshield();
make_1Kshield();
make_target_holder();
make_coil_cage();
make_hd_target();
make_control_coil();
#make_helmoltz_coil();
