#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'BaBar_solenoid';

my $envelope = "solid_$DetectorName";
my $file     = "solid_$DetectorName.txt";

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

#virtual volume
# sub make_detector
# {
#  $detector{"name"}        = "$DetectorName";
#  $detector{"mother"}      = "root";
#  $detector{"description"} = $detector{"name"} ;
#  $detector{"pos"}         = "0*cm 0*cm 0*cm";
#  $detector{"rotation"}    = "0*deg 0*deg 0*deg";
#  $detector{"color"}       = "ff0000";
#  $detector{"type"}        = "Tube";
#  my $Rin        = 0;
#  my $Rout       = 400;
#  my $Dz         = 400;
#  $detector{"dimensions"}  = "$Rin*cm $Rout*cm $Dz*cm 0*deg 360*deg";
#  $detector{"material"}    = "Vacuum";
#  $detector{"mfield"}      = "no";
#  $detector{"ncopy"}       = 1;
#  $detector{"pMany"}       = 1;
#  $detector{"exist"}       = 1;
#  $detector{"visible"}     = 0;
#  $detector{"style"}       = 1;
#  $detector{"sensitivity"} = "no";
#  $detector{"hit_type"}    = "";
#  $detector{"identifiers"} = $detector{"name"};
# 
#  print_det(\%detector, $file);
# }
# make_detector();

my $DetectorMother="root";

# C --     Solenoid coils/yoke
# C --     BaBar NPB 78, 1999: 
# C        Coil mean winding R=153 cm (room temp) ~ 152.2 cm cold
# C        Coil length 351.2 cm room, ~ 350 cm cold
# C        Cryostat: IR=142 cm, OR=177 cm, L=385 cm 
# C
# GPARVOL30  'SOLE'    0  'HALL'    0.    0.    0.    0  'TUBE'  3  1. 1. 1.
# GPARVOL31  'CRYO'  210  'SOLE'    0.    0.    0.    0  'TUBE'  3  142. 177.  192.5
# GPARVOL32  'CRYV'  221  'CRYO'    0.    0.    0.    0  'TUBE'  3  147. 172.  187.5
# GPARVOL33  'SCL1'  209  'CRYV'    0.    0.    0.    0  'TUBE'  3  152. 154.  175.0

sub make_detector_coil
{
 my $NUM  = 3;
 my @Rin  = (142.,147.,152.);
 my @Rout = (177.,172.,154.);
 my @Dz   = (192.5,187.5,175.);
 my @name = ("CRYO","CRYV","SCL1");
 my @mother = ("$DetectorMother","$DetectorName\_coil_CRYO","$DetectorName\_coil_CRYV");
 my @mat  = ("Iron","Air","Aluminum");
 my @color= ("ffffff","ff8000","003333");

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);
    $detector{"name"}        = "$DetectorName\_coil_$name[$n-1]";
    $detector{"mother"}      = "$mother[$n-1]";
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm 0*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color[$n-1]";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";
    $detector{"material"}   = $mat[$n-1];
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = $n;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = $detector{"name"};

    print_det(\%detector, $file);
 }
}
make_detector_coil();

# C --     BaBar barrel yoke simplified
# C
# GPARVOL41  'SY01'  210  'SOLE'    0.    0.    0.    0  'TUBE'  3  180.0 182.0  187.2
#C GPARVOL42  'SY02'  210  'SOLE'    0.    0.    0.    0  'TUBE'  3  185.2 189.0  187.2
# GPARVOL43  'SY03'  210  'SOLE'    0.    0.    0.    0  'TUBE'  3  195.6 199.6  187.2
# GPARVOL44  'SY04'  210  'SOLE'    0.    0.    0.    0  'TUBE'  3  206.0 210.0  187.2
# GPARVOL45  'SY05'  210  'SOLE'    0.    0.    0.    0  'TUBE'  3  216.4 220.4  187.2
# GPARVOL46  'SY06'  210  'SOLE'    0.    0.    0.    0  'TUBE'  3  226.8 230.8  187.2
# GPARVOL47  'SY07'  210  'SOLE'    0.    0.    0.    0  'TUBE'  3  237.0 246.0  187.2
# GPARVOL48  'SY08'  210  'SOLE'    0.    0.    0.    0  'TUBE'  3  255.6 264.6  187.2
# GPARVOL49  'SY09'  210  'SOLE'    0.    0.    0.    0  'TUBE'  3  275.0 290.0  187.2

sub make_detector_yoke
{
 my $NUM  = 8;
 my @Rin  = (180.0,195.6,206.0,216.4,226.8,237.0,255.6,275.0);
 my @Rout = (186.0,199.6,210.0,220.4,230.8,246.0,264.6,290.0);
 my $Dz   = 187.2;
 my @name = ("SY01","SY02","SY03","SY04","SY05","SY06","SY07","SY08","SY09");
 my $color= "F63BFF";

 for(my $n=1; $n<=$NUM; $n++)
 {
#     my $pnumber     = cnumber($n-1, 10);

    $detector{"name"}        = "$DetectorName\_yoke_$name[$n-1]";
    $detector{"mother"}      = "$DetectorMother";
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm 0*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz*cm 0*deg 360*deg";
    $detector{"material"}   = "Iron";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = $n;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = $detector{"name"};

    print_det(\%detector, $file);
 }
}
make_detector_yoke();

# C --    Downstream part        (new)
# C
# GPARVOL51  'SYD1'  210  'SOLE'    0.    0.    0.    0  'PCON'  18 0.  360. 5. 
#             192.5 210.0 240.0  197.5 188.0 240.0  197.5 152.0 240.0  207.0 152.0 240.0  222. 166.0 188.0
# GPARVOL52  'SYD2'  210  'SOLE'    0.    0.    0.    0  'PCON'  15 0.  360. 4. 
#             192.5 240.0 290.0  207.0 240.0 290.0  207.0 257.0 290.0  222.0 265.0 290.0
# GPARVOL53  'SYD3'  210  'SOLE'    0.    0.  301.    0  'TUBE'  3  270.0 290.0   79.0
# GPARVOL54  'SYD4'  210  'SOLE'    0.    0.    0.    0  'PCON'  21 0.  360. 6. 
#             200.0  22.0  58.0  280.0  30.0  89.0  380.0  30.0 128.0  380.0  30.0 290.0  400.0  30.0 290.0  
#             420.0  30.0 120.0

# GPARVOL53  'SYD3'  296  'SOLE'    0.    0.  331.    0  'TUBE'  3  270.0 290.0   109.0
# GPARVOL54  'SYD4'  296  'SOLE'    0.    0.    0.    0  'PCON'  21 0.  360. 6. 
#             260.0  22.0  70.0  340.0  30.0  94.0  440.0  30.0 118.0  440.0  30.0 290.0  460.0  30.0 290.0  
#             480.0  30.0 120.0

#SIDIS need yoke_downstream SYD3 and SYD4 to be 60cm longer

 my $color_yoke= "F63BFF";

sub make_solenoid_yoke_downstream1
{
 $detector{"name"}        = "$DetectorName\_yoke_downstream1";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_yoke";
 $detector{"type"}        = "Polycone";
 my $phiStart    = 0;
 my $phiTotal    = 360;
 my $numZPlanes  = 5;
 $detector{"dimensions"}  = "$phiStart*deg $phiTotal*deg $numZPlanes 210.0*cm 188.0*cm 152.0*cm 152.0*cm 166.0*cm 240.0*cm 240.0*cm 240.0*cm 240.0*cm 188.0*cm 192.5*cm 197.5*cm 197.5*cm 207.0*cm 222.0*cm";
 $detector{"material"}    = "Iron";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = $detector{"name"};

 print_det(\%detector, $file);
}
make_solenoid_yoke_downstream1();

sub make_solenoid_yoke_downstream2
{
 $detector{"name"}        = "$DetectorName\_yoke_downstream2";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_yoke";
 $detector{"type"}        = "Polycone";
 my $phiStart    = 0;
 my $phiTotal    = 360;
 my $numZPlanes  = 4;
 $detector{"dimensions"}  = "$phiStart*deg $phiTotal*deg $numZPlanes 240.0*cm 240.0*cm 257.0*cm 265.0*cm 290.0*cm 290.0*cm 290.0*cm 290.0*cm 192.5*cm 207.0*cm 207.0*cm 222.0*cm";
 $detector{"material"}    = "Iron";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = $detector{"name"};

 print_det(\%detector, $file);
}
make_solenoid_yoke_downstream2();

sub make_solenoid_yoke_downstream3
{
 $detector{"name"}        = "$DetectorName\_yoke_downstream3";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 331*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_yoke";
 $detector{"type"}        = "Tube";
 my $Rin        = 270;
 my $Rout       = 290;
 my $Dz         = 109;
 $detector{"dimensions"}  = "$Rin*cm $Rout*cm $Dz*cm 0*deg 360*deg";
 $detector{"material"}    = "Iron";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = $detector{"name"};

 print_det(\%detector, $file);
}
make_solenoid_yoke_downstream3();

sub make_solenoid_yoke_downstream4
{
 $detector{"name"}        = "$DetectorName\_yoke_downstream4";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_yoke";
 $detector{"type"}        = "Polycone";
 my $phiStart    = 0;
 my $phiTotal    = 360;
 my $numZPlanes  = 6;
 $detector{"dimensions"}  = "$phiStart*deg $phiTotal*deg $numZPlanes 22.0*cm 30.0*cm 30.0*cm 30.0*cm 30.0*cm 30.0*cm 70.0*cm 94.0*cm 118.0*cm 290.*cm 290.0*cm 120.0*cm 260.0*cm 340.0*cm 440.0*cm 440.0*cm 460.0*cm 480.0*cm";
 $detector{"material"}    = "Iron";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = $detector{"name"};

 print_det(\%detector, $file);
}
make_solenoid_yoke_downstream4();

# --    Upstream   part        (new)
#GPARVOL61  'SYU1'  296  'SOLE'    0.    0.    0.    0  'PCON'  18 0.  360. 5. 
#           -192.5 210.0 240.0 -197.5 188.0 240.0 -197.5 152.0 240.0 -207.0 152.0 240.0 -222. 166.0 188.0
#GPARVOL62  'SYU2'  296  'SOLE'    0.    0.    0.    0  'PCON'  15 0.  360. 4. 
#           -192.5 240.0 290.0 -207.0 240.0 290.0 -207.0 257.0 290.0 -222.0 265.0 290.0
#GPARVOL63  'SYU3'  296  'SOLE'    0.    0. -224.25  0  'TUBE'   3    265.0 290.0  2.25
#GPARVOL64  'SYU4'  296  'SOLE'    0.    0. -244.5   0  'CONE'   5  18.0  41.  290.   57.5 290.
#GPARVOL65  'SYU5'  296  'SOLE'    0.    0. -271.5   0  'CONE'   5   5.0  34.0 290.  39.0 290.
#GPARVOL66  'SYU6'  296  'SOLE'    0.    0. -280.5   0  'CONE'   5   2.0  31.5 290.  33.5 290.

sub make_solenoid_yoke_upstream1
{
 $detector{"name"}        = "$DetectorName\_yoke_upstream1";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_yoke";
 $detector{"type"}        = "Polycone";
 my $phiStart    = 0;
 my $phiTotal    = 360;
 my $numZPlanes  = 5;
 $detector{"dimensions"}  = "$phiStart*deg $phiTotal*deg $numZPlanes 210.0*cm 188.0*cm 152.0*cm 152.0*cm 166.0*cm 240.0*cm 240.0*cm 240.0*cm 240.0*cm 188.0*cm -192.5*cm -197.5*cm -197.5*cm -207.0*cm -222.0*cm";
 $detector{"material"}    = "Iron";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = $detector{"name"};

 print_det(\%detector, $file);
}
make_solenoid_yoke_upstream1();

sub make_solenoid_yoke_upstream2
{
 $detector{"name"}        = "$DetectorName\_yoke_upstream2";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_yoke";
 $detector{"type"}        = "Polycone";
 my $phiStart    = 0;
 my $phiTotal    = 360;
 my $numZPlanes  = 4;
 $detector{"dimensions"}  = "$phiStart*deg $phiTotal*deg $numZPlanes 240.0*cm 240.0*cm 257.0*cm 265.0*cm 290.0*cm 290.0*cm 290.0*cm 290.0*cm -192.5*cm -207.0*cm -207.0*cm -222.0*cm";
 $detector{"material"}    = "Iron";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = $detector{"name"};

 print_det(\%detector, $file);
}
make_solenoid_yoke_upstream2();

sub make_solenoid_yoke_upstream3
{
 $detector{"name"}        = "$DetectorName\_yoke_upstream3";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -224.25*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_yoke";
 $detector{"type"}        = "Tube";
 my $Rin        = 265.0;
 my $Rout       = 290.0;
 my $Dz         = 2.25;
 $detector{"dimensions"}  = "$Rin*cm $Rout*cm $Dz*cm 0*deg 360*deg";
 $detector{"material"}    = "Iron";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = $detector{"name"};

 print_det(\%detector, $file);
}
make_solenoid_yoke_upstream3();

sub make_solenoid_yoke_upstream4
{
 $detector{"name"}        = "$DetectorName\_yoke_upstream4";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -244.5*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_yoke";
 $detector{"type"}        = "Cons";
 my $Rmin1 = 41.0;
 my $Rmax1 = 290.0;
 my $Rmin2 = 57.5;
 my $Rmax2 = 290.0;
 my $Dz    = 18.0;
 my $Sphi  = 0;
 my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Iron";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = $detector{"name"};

 print_det(\%detector, $file);
}
make_solenoid_yoke_upstream4();

sub make_solenoid_yoke_upstream5
{
 $detector{"name"}        = "$DetectorName\_yoke_upstream5";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -271.5*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_yoke";
 $detector{"type"}        = "Cons";
 my $Rmin1 = 34.0;
 my $Rmax1 = 290.0;
 my $Rmin2 = 39.0;
 my $Rmax2 = 290.0;
 my $Dz    = 5.0;
 my $Sphi  = 0;
 my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Iron";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = $detector{"name"};

 print_det(\%detector, $file);
}
make_solenoid_yoke_upstream5();

sub make_solenoid_yoke_upstream6
{
 $detector{"name"}        = "$DetectorName\_yoke_upstream6";
 $detector{"mother"}      = "$DetectorMother";
 $detector{"description"} = $detector{"name"};
 $detector{"pos"}         = "0*cm 0*cm -280.5*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "$color_yoke";
 $detector{"type"}        = "Cons";
 my $Rmin1 = 31.5;
 my $Rmax1 = 290.0;
 my $Rmin2 = 33.5;
 my $Rmax2 = 290.0;
 my $Dz    = 2.0;
 my $Sphi  = 0;
 my $Dphi  = 360;
 $detector{"dimensions"}  = "$Rmin1*cm $Rmax1*cm $Rmin2*cm $Rmax2*cm $Dz*cm $Sphi*deg $Dphi*deg";
 $detector{"material"}    = "Iron";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 1;
 $detector{"style"}       = 1;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = $detector{"name"};

 print_det(\%detector, $file);
}
make_solenoid_yoke_upstream6();
