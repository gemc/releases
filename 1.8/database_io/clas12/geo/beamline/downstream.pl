#!/usr/bin/perl -w

# all dimensions in mm

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

# All dimensions in mm

my $envelope = 'downstream_torus';
my $file     = 'downstream_torus.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


# Downstream beamline is a 4cm thick pipe of lead, with OD = 350 mm

my $inches   = 25.4;

# Torus numbers:
my $TorusZpos        = 151.855*$inches;                 # center of the torus position
my $SteelFrameLength = 94.*$inches/2.0;                 # 1/2 length
my $bp_zpos          = $TorusZpos + $SteelFrameLength ; # back plate z position
my $face_plate_LE    = 1.0*$inches/2.0;

my $thickness = 40.0;
my $dpipe_OR  = 350.0/2.0;
my $dpipe_IR  = $dpipe_OR - $thickness;
my $dpipe_le  = 1000.0;    # 2 meters total length
my $dpipe_sp  = 60.0;      # 3 cm space between pipe and torus

my $lead_shield_thickness = 25.0;

my $pipe_zpos =  $bp_zpos + $dpipe_le + $dpipe_sp + $lead_shield_thickness;


##############################
# LEAD PIPE - after Torus Ring
##############################

sub make_shield_pipe
{

 $detector{"name"}         = "sst_shieldpipe_after_torus";
 $detector{"mother"}       = "root";
 $detector{"description"}  = "Pipe after Torus Ring";
 $detector{"pos"}          = "0*mm 0.0*mm $pipe_zpos*mm";
 $detector{"rotation"}     = "0*deg 0*deg 0*deg";
 $detector{"color"}        = "993333";
 $detector{"type"}         = "Tube";
 $detector{"dimensions"}   = "$dpipe_IR*mm $dpipe_OR*mm $dpipe_le*mm 0.0*deg 360*deg";
 $detector{"material"}     = "StainlessSteel";
 $detector{"mfield"}       = "no";
 $detector{"ncopy"}        = 1;
 $detector{"pMany"}        = 1;
 $detector{"exist"}        = 1;
 $detector{"visible"}      = 1;
 $detector{"style"}        = 1;
 $detector{"sensitivity"}  = "no";
 $detector{"hit_type"}     = "";
 $detector{"identifiers"}  = "";

 print_det(\%detector, $file);
}


################################
# LEAD SHIELD - after Torus Ring
################################

my $nplanes = 4;
my $ColdHubIR  =  62.0 ;     # Warm bore tube ID is 124 as from DK drawing

# Numbers coming from ROOT macro
# Corner:            1              2            3             4
my @zplane   = (     0.0    ,     $lead_shield_thickness   ,    $lead_shield_thickness + 0.1     ,   300.0     );
my @oradius  = (   170.0    ,     170.0   ,     110.0    ,   110.0     );
my @iradius  = ( $ColdHubIR ,  $ColdHubIR ,   $ColdHubIR ,  $ColdHubIR );
my $zstart   = $bp_zpos + 1.0;

sub make_lead_shield
{

 $detector{"name"}        = "nose_shield";
 $detector{"mother"}      = "root";
 $detector{"description"} = "Lead Shielding - Torus to Lead Pipe";
 $detector{"pos"}         = "0*mm 0.0*mm $zstart*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "0000ff";
 $detector{"type"}      = "Polycone";

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
 $detector{"material"}    = "G4_Pb";
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






#########################################
# Vacuum Pipe: inside and after the torus
#########################################
my $TIR      = 37.6;                    # Torus ID is 75.2 mm
my $pthick   = 20.0;                    # Shield Pipe thickness through the Torus Ring
my $bthick   = 2.0;                     # Beamline Pipe thickness through the Torus Ring
my $gap      = 0.1;                     # gap between Torus ring and vacuum pipe
my $vpipe_le = 6000;                    # 6 meters long

my $pipe_back_shift = 39.6;             # to meet the moeller absorber


#my $vpipe_z  = $TorusZpos + $vpipe_le - $SteelFrameLength - $pipe_back_shift;  # z position - to meet the moeller absorber
#my $vpipe_OR = $TIR -  $gap;            #
my $vpipe_z  = $TorusZpos + $vpipe_le - $SteelFrameLength;  # z position - to meet the moeller absorber

my $spipe_OR = 123.8/2. - 0.5;    #  OR of shielding  - 1/2 mm clearing
my $spipe_IR = $spipe_OR - $pthick;     #  OR of aluminum pipe
my $vpipe_OR = $spipe_IR - $bthick;     #  OR of vacuum

sub make_vacuum_pipe
{

 $detector{"name"}         = "beamline_pipe_shielding";
 $detector{"mother"}       = "root";
 $detector{"description"}  = "Pipe after Torus Ring";
 $detector{"pos"}          = "0*mm 0.0*mm $vpipe_z*mm";
 $detector{"rotation"}     = "0*deg 0*deg 0*deg";
 $detector{"color"}        = "999966";
 $detector{"type"}         = "Tube";
 $detector{"dimensions"}   = "0*mm $spipe_OR*mm $vpipe_le*mm 0.0*deg 360*deg";
 $detector{"material"}     = "G4_W";
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

 # Alimunum inside
 $detector{"name"}         = "al_beampipe_pipe";
 $detector{"mother"}       = "beamline_pipe_shielding";
 $detector{"description"}  = "Aluminum Pipe after Torus Ring";
 $detector{"pos"}          = "0*mm 0.0*mm 0*mm";
 $detector{"rotation"}     = "0*deg 0*deg 0*deg";
 $detector{"color"}        = "87AFC7";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}   = "0*mm $spipe_IR*mm $vpipe_le*mm 0.0*deg 360*deg";
 $detector{"material"}     = "Aluminum";
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

 
 # Vacuum inside
 $detector{"name"}         = "vacuum_beampipe_pipe";
 $detector{"mother"}       = "al_beampipe_pipe";
 $detector{"description"}  = "Vacuum Pipe after Torus Ring";
 $detector{"pos"}          = "0*mm 0.0*mm 0*mm";
 $detector{"rotation"}     = "0*deg 0*deg 0*deg";
 $detector{"color"}        = "aaffff";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}   = "0*mm $vpipe_OR*mm $vpipe_le*mm 0.0*deg 360*deg";
 $detector{"material"}     = "Vacuum";
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



make_shield_pipe();
make_lead_shield();
make_vacuum_pipe();



