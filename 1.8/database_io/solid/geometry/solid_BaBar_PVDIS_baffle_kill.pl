#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'BaBar_PVDIS_baffle_kill';

my $envelope = "solid_$DetectorName";
my $file     = "solid_$DetectorName.txt";

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

my $DetectorMother="root";

#6 plates, 9cm thick,every 30cm, 30 slits per plate, 20 blocks per slit

my $color_baffle="00C0C0";

my $material_baffle_within="Air";
my $material_baffle="Kryptonite";
my $sensitivity_baffle="no";
my $hit_baffle="";

# In PVDIS PAC34 proposal, page 35 (http://hallaweb.jlab.org/collab/PAC/PAC34/PR-09-012-pvdis.pdf). It's mentioned that the baffle position is 30,60,90,120,150,180cm relative to BaBar solenoid coil center at 0. But it's actually relative to the target center which is at 10cm as seen on the Fig 3.3 on page 31.
# Later on, it seems Eugene has further tweaked them to 30,58,86,114,142,170. refer to http://hallaweb.jlab.org/12GeV/SoLID/download/sim/geant3/solid_comgeant_pvdis/pvdis_02_01_p_14_01/fort.22

my $targetoff=10; # target offset in cm

 my $Nplate  = 6;
 my @PlateZ  = (30+$targetoff,58+$targetoff,86+$targetoff,114+$targetoff,142+$targetoff,170+$targetoff);
 my $Dz   = 9.0/2.;

sub make_baffle_plate_inner
{
 my @Rin  = (3.89,14.,19.,23.9,28.9,33.8);
 my @Rout = (3.9,15.3,26.6,37.9,49.2,60.4);

 for(my $n=1; $n<=$Nplate; $n++)
 {
    my $n_c     = cnumber($n-1, 1);
    $detector{"name"}        = "$DetectorName\_plateinner$n_c";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $PlateZ[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color_baffle";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz*cm 0*deg 360*deg";
    $detector{"material"}   = "$material_baffle";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "$sensitivity_baffle";
    $detector{"hit_type"}    = "$hit_baffle";
    $detector{"identifiers"} = "";

    print_det(\%detector, $file);
 }
}
make_baffle_plate_inner();

sub make_baffle_plate_outer
{
 my @Rin  = (34.8,54.3,73.9,93.4,112.8,132.1);
my @Rout = (140,140,140,140,140,140); #coil edge is at 142cm

 for(my $n=1; $n<=$Nplate; $n++)
 {
    my $n_c     = cnumber($n-1, 1);
    $detector{"name"}        = "$DetectorName\_plateouter$n_c";
    $detector{"mother"}      = "$DetectorMother" ;
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $PlateZ[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "$color_baffle";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz*cm 0*deg 360*deg";
    $detector{"material"}   = "$material_baffle";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 1;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "$sensitivity_baffle";
    $detector{"hit_type"}    = "$hit_baffle";
    $detector{"identifiers"} = "";
    print_det(\%detector, $file);
 }
}
make_baffle_plate_outer();

sub make_baffle_plate   #viutral container for baffle plate
{
 my @Rin = (3.9,15.3,26.6,37.9,49.2,60.4);
 my @Rout  = (34.7,54.3,73.8,93.3,112.8,132.0);

 for(my $n=1; $n<=$Nplate; $n++)
 {
    my $n_c     = cnumber($n-1, 1);
    $detector{"name"}        = "$DetectorName\_plate$n_c";
    $detector{"mother"}      = "$DetectorMother";
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $PlateZ[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = "000000";
    $detector{"type"}       = "Tube";
    $detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz*cm 0*deg 360*deg";
    $detector{"material"}   = "$material_baffle_within";
    $detector{"mfield"}     = "no";
    $detector{"ncopy"}      = 1;
    $detector{"pMany"}       = 1;
    $detector{"exist"}       = 1;
    $detector{"visible"}     = 0;
    $detector{"style"}       = 1;
    $detector{"sensitivity"} = "no";
    $detector{"hit_type"}    = "";
    $detector{"identifiers"} = "";
    print_det(\%detector, $file);
 }
}
make_baffle_plate();

#making buffle blocks, palte by plate, slit by slit,block by block
sub make_baffle_blocks
{
my @x =( #Rin     Rout   SPhi    DPhi
#1 plate
[	 3.90 ,   5.44 ,  176.26 , 183.00 ,
	 5.44 ,   6.98 ,  176.44 , 182.13 ,
	 6.98 ,   8.52 ,  176.61 , 181.67 ,
	 8.52 ,  10.06 ,  176.75 , 181.78 ,
	10.06 ,  11.60 ,  176.89 , 181.90 ,
	11.60 ,  13.14 ,  177.03 , 182.01 ,
	13.14 ,  14.68 ,  177.18 , 182.12 ,
	14.68 ,  16.22 ,  177.32 , 182.24 ,
	16.22 ,  17.76 ,  177.46 , 182.35 ,
	17.76 ,  19.30 ,  177.60 , 182.46 ,
	19.30 ,  20.84 ,  177.74 , 182.58 ,
	20.84 ,  22.38 ,  177.88 , 182.69 ,
	22.38 ,  23.92 ,  178.02 , 182.80 ,
	23.92 ,  25.46 ,  178.16 , 182.92 ,
	25.46 ,  27.00 ,  178.30 , 183.03 ,
	27.00 ,  28.54 ,  178.44 , 183.15 ,
	28.54 ,  30.08 ,  178.58 , 183.26 ,
	30.08 ,  31.62 ,  178.72 , 183.37 ,
	31.62 ,  33.16 ,  178.86 , 183.49 ,
	33.16 ,  34.70 ,  179.00 , 183.60 	],
#2 plate
[	15.30 ,  17.25 ,  175.93 , 182.78 ,
	17.25 ,  19.20 ,  176.14 , 182.56 ,
	19.20 ,  21.15 ,  176.35 , 182.36 ,
	21.15 ,  23.10 ,  176.58 , 182.19 ,
	23.10 ,  25.05 ,  176.81 , 182.05 ,
	25.05 ,  27.00 ,  177.06 , 181.93 ,
	27.00 ,  28.95 ,  177.28 , 181.98 ,
	28.95 ,  30.90 ,  177.46 , 182.12 ,
	30.90 ,  32.85 ,  177.64 , 182.26 ,
	32.85 ,  34.80 ,  177.82 , 182.41 ,
	34.80 ,  36.75 ,  178.00 , 182.55 ,
	36.75 ,  38.70 ,  178.18 , 182.70 ,
	38.70 ,  40.65 ,  178.35 , 182.84 ,
	40.65 ,  42.60 ,  178.53 , 182.98 ,
	42.60 ,  44.55 ,  178.71 , 183.13 ,
	44.55 ,  46.50 ,  178.89 , 183.27 ,
	46.50 ,  48.45 ,  179.07 , 183.41 ,
	48.45 ,  50.40 ,  179.25 , 183.56 ,
	50.40 ,  52.35 ,  179.42 , 183.70 ,
	52.35 ,  54.30 ,  179.60 , 183.84 	],
#3 plate    
      [ 26.60 ,  28.96 ,  175.71 , 182.49 ,                    
	28.96 ,  31.32 ,  175.95 , 182.40 ,                   
	31.32 ,  33.68 ,  176.20 , 182.32 ,                   
	33.68 ,  36.04 ,  176.46 , 182.27 ,                   
	36.04 ,  38.40 ,  176.73 , 182.23 ,                   
	38.40 ,  40.76 ,  177.02 , 182.22 ,                   
	40.76 ,  43.12 ,  177.31 , 182.22 ,                   
	43.12 ,  45.48 ,  177.62 , 182.23 ,                   
	45.48 ,  47.84 ,  177.93 , 182.28 ,                   
	47.84 ,  50.20 ,  178.15 , 182.46 ,                   
	50.20 ,  52.56 ,  178.36 , 182.63 ,                   
	52.56 ,  54.92 ,  178.58 , 182.81 ,                   
	54.92 ,  57.28 ,  178.80 , 182.98 ,                   
	57.28 ,  59.64 ,  179.01 , 183.16 ,                   
	59.64 ,  62.00 ,  179.23 , 183.33 ,                   
	62.00 ,  64.36 ,  179.45 , 183.51 ,                   
	64.36 ,  66.72 ,  179.67 , 183.68 ,                   
	66.72 ,  69.08 ,  179.88 , 183.85 ,                   
	69.08 ,  71.44 ,  180.10 , 184.03 ,                   
	71.44 ,  73.80 ,  180.32 , 184.21	],                  
#4 plate
      [ 37.90  , 40.67  , 175.38 , 182.05 ,
	40.67  , 43.44  , 175.66 , 182.04 ,
	43.44  , 46.21  , 175.95 , 182.04 ,
	46.21  , 48.98  , 176.25 , 182.05 ,
	48.98  , 51.75  , 176.57 , 182.08 ,
	51.75  , 54.52  , 176.89 , 182.13 ,
	54.52  , 57.29  , 177.22 , 182.19 ,
	57.29  , 60.06  , 177.57 , 182.27 ,
	60.06  , 62.83  , 177.92 , 182.36 ,
	62.83  , 65.60  , 178.29 , 182.47 ,
	65.60  , 68.37  , 178.66 , 182.66 ,
	68.37  , 71.14  , 178.90 , 182.84 ,
	71.14  , 73.91  , 179.15 , 183.02 ,
	73.91  , 76.68  , 179.39 , 183.22 ,
	76.68  , 79.45  , 179.65 , 183.42 ,
	79.45  , 82.22  , 179.90 , 183.62 ,
	82.22  , 84.99  , 180.16 , 183.84 ,
	84.99  , 87.76  , 180.43 , 184.06 ,
	87.76  , 90.53  , 180.71 , 184.28 ,
	90.53  , 93.30  , 180.98 , 184.51	],
#5 plate
      [ 49.20  , 52.38  , 175.06 , 181.61 ,
	52.38  , 55.56  , 175.37 , 181.64 ,
	55.56  , 58.74  , 175.70 , 181.70 ,
	58.74  , 61.92  , 176.04 , 181.76 ,
	61.92  , 65.10  , 176.39 , 181.84 ,
	65.10  , 68.28  , 176.76 , 181.94 ,
	68.28  , 71.46  , 177.13 , 182.05 ,
	71.46  , 74.64  , 177.52 , 182.17 ,
	74.64  , 77.82  , 177.91 , 182.31 ,
	77.82  , 81.00  , 178.32 , 182.46 ,
	81.00  , 84.18  , 178.75 , 182.63 ,
	84.18  , 87.36  , 179.20 , 182.85 ,
	87.36  , 90.54  , 179.48 , 183.06 ,
	90.54  , 93.72  , 179.76 , 183.28 ,
	93.72  , 96.90  , 180.05 , 183.51 ,
	96.90  ,100.08  , 180.35 , 183.75 ,
	100.08 ,103.26  , 180.65 , 183.99 ,
	103.26 ,106.44  , 180.96 , 184.24 ,
	106.44 ,109.62  , 181.27 , 184.49 ,
	109.62 ,112.80  , 181.59 , 184.75	],
#6 plate
      [ 60.40  , 63.98  , 174.92 , 181.35 ,
	63.98  , 67.56  , 175.27 , 181.43 ,
	67.56  , 71.14  , 175.63 , 181.52 ,
	71.14  , 74.72  , 176.00 , 181.63 ,
	74.72  , 78.30  , 176.38 , 181.75 ,
	78.30  , 81.88  , 176.78 , 181.88 ,
	81.88  , 85.46  , 177.18 , 182.02 ,
	85.46  , 89.04  , 177.60 , 182.18 ,
	89.04  , 92.62  , 178.03 , 182.35 ,
	92.62  , 96.20  , 178.47 , 182.53 ,
	96.20  , 99.78  , 178.92 , 182.73 ,
	99.78  ,103.36  , 179.39 , 182.94 ,
	103.36 , 106.94 ,  179.88,  183.19,
	106.94 , 110.52 ,  180.20,  183.43,
	110.52 , 114.10 ,  180.52,  183.69,
	114.10 , 117.68 ,  180.84,  183.94,
	117.68 , 121.26 ,  181.17,  184.21,
	121.26 , 124.84 ,  181.51,  184.48,
	124.84 , 128.42 ,  181.86,  184.76,
	128.42 , 132.00 ,  182.21,  185.04	]
);

 my $Nslit  = 30;
 my $Nblock  = 20;
 my @offset =(-5.6, -4.4, -3.3, -2.1, -0.9, 0.1);  #according to Seamus, it's substraction 

 for(my $n=1; $n<=$Nplate; $n++){
	my $n_c     = cnumber($n-1, 1);
  for(my $i=1; $i<=$Nslit; $i++){  # making all slits
	my $slit_rotation = ($i-1)*12-$offset[$n-1]; #note the minus sign here
	my $i_c     = cnumber($i-1, 10);
	$detector{"name"}        = "$DetectorName\_plate$n_c.slit$i_c";
	$detector{"mother"}      = "$DetectorName\_plate$n_c";
	$detector{"description"} = $detector{"name"};
	$detector{"pos"}         = "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg $slit_rotation*deg";
	$detector{"color"}       = "000000";
	$detector{"type"}        = "Tube";
	my $Rin  = $x[$n-1][0];
	my $Rout = $x[$n-1][77];
	my $Sphi = $x[$n-1][2];
	my $Dphi = 12;
	$detector{"dimensions"}  = "$Rin*cm $Rout*cm $Dz*cm $Sphi*deg $Dphi*deg";
	$detector{"material"}    = "$material_baffle_within";
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
    
      for(my $j=1; $j<=$Nblock; $j++){ # making blocks within slits
	my $j_c     = cnumber($j-1, 10);
	$detector{"name"}        = "$DetectorName\_plate$n_c.slit$i_c.block$j_c";
	$detector{"mother"}      = "$DetectorName\_plate$n_c.slit$i_c";
	$detector{"description"} = $detector{"name"};
	$detector{"pos"}         = "0*cm 0*cm 0*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "$color_baffle";
	$detector{"type"}        = "Tube";
	my $Rin  = $x[$n-1][($j-1)*4+0];
	my $Rout = $x[$n-1][($j-1)*4+1];
	my $Sphi = $x[$n-1][($j-1)*4+2];
 	my $Dphi = $x[$n-1][($j-1)*4+3]-$x[$n-1][($j-1)*4+2];
	$detector{"dimensions"}  = "$Rin*cm $Rout*cm $Dz*cm $Sphi*deg $Dphi*deg";
	$detector{"material"}    = "$material_baffle";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = 1;
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "$sensitivity_baffle";
	$detector{"hit_type"}    = "$hit_baffle";
 	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
      }

    }
  }

#  for(my $n=1; $n<=$Nplate; $n++){
#   for(my $i=1; $i<=$Nslit; $i++){
#     for(my $j=1; $j<=$Nblock; $j++){# 
# 	my $n_c     = cnumber($n-1, 1);
# 	my $i_c     = cnumber($i-1, 10);
# 	my $j_c     = cnumber($j-1, 10);
# 
# 	$detector{"name"}        = "$DetectorName\_plate$n_c.slit$i_c.block$j_c";
# 	$detector{"mother"}      = "$DetectorName";
# 	$detector{"description"} = $detector{"name"};
# 	$detector{"pos"}         = "0*cm 0*cm $PlateZ[$n-1]*cm";
# 	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
# 	$detector{"color"}       = "$color_baffle";
# 	$detector{"type"}        = "Tube";
# 	my $Rin  = $x[$n-1][($j-1)*4+0];
# 	my $Rout = $x[$n-1][($j-1)*4+1];
# 	my $Sphi = $x[$n-1][($j-1)*4+2]+($i-1)*12;
#  	my $Dphi = $x[$n-1][($j-1)*4+3]-$x[$n-1][($j-1)*4+2];
# 	$detector{"dimensions"}  = "$Rin*cm $Rout*cm $PlateDz*cm $Sphi*deg $Dphi*deg";
# 	$detector{"material"}    = "$material_baffle";
# 	$detector{"mfield"}      = "no";
# 	$detector{"ncopy"}       = ($n-1)*$Nplate+($i-1)*$Nslit+$j;
# 	$detector{"pMany"}       = 1;
# 	$detector{"exist"}       = 1;
# 	$detector{"visible"}     = 1;
# 	$detector{"style"}       = 1;
# 	$detector{"sensitivity"} = "$hit_baffle";
# 	$detector{"hit_type"}    = "$hit_baffle";
#  	$detector{"identifiers"} = $detector{"name"};
# 
# 	print_det(\%detector, $file);
#      }
#    }
#  }
}
make_baffle_blocks();