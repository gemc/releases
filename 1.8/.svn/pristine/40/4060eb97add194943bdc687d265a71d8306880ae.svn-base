#!/usr/bin/perl -w
use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'torus_thickWH';
my $file     = 'torus_thickWH.txt';

my $rmin = 1;
my $rmax = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;




# set flag to decide whether to add the big outer torus rings or not (0=NO, 1=YES)
my $add_torus_ORing=0;


# all dimensions in mm, deg

# Need to reorganize/add air_coils here

my $inches = 25.4;

my $ColdHubLength       =  194.81/2.0;  # 1/2 length
my $TorusLength         = 2158.75/2.0;      # 1/2 length of torus, including plates
my $upstream_plate_LE   = 1.25*$inches/2.0;  # based on information from M. Zarecky (Dec 2014)
my $downstream_plate_LE = 1.75*$inches/2.0;  # based on information from M. Zarecky (Dec 2014)

my $col              = 'ffff9b';
my $TorusZpos        = 151.855*$inches;                 # center of the torus position





my $copper_shield_thickness = 0.3;   # thickness of disk (2) in drawings, 3mm

#my $ishield_ir = 146.06/2.;	   # based on information from D. Kashy. Sildes with dimensions
#my $ishield_or = 152.4/2.;	   # taken from new drawing sent by L. Quettier (April 2010)
my $ishield_ir = 143.06/2.;	   # based on information from D. Kashy. Sildes with dimensions
my $ishield_or = 155.4/2.;	   # taken from new drawing sent by L. Quettier (April 2010)

my $warm_bore_shield_upstream_add   = 4.07;
my $warm_bore_shield_downstream_add = 2.41;
my $warm_bore_shield_le = $ColdHubLength + $warm_bore_shield_upstream_add/2.0 + $warm_bore_shield_downstream_add/2.0;     # from M. Zarecky drawings

my $warm_bore_tube_upstream_add   = 3.47;
my $warm_bore_tube_downstream_add = 2.86;
# This should be exactly $TorusLength
my $warm_bore_tube_le = $warm_bore_shield_le + $warm_bore_tube_upstream_add/2.0 + $warm_bore_tube_downstream_add/2.0 + $upstream_plate_LE/10.0 + $downstream_plate_LE/10.0 + $copper_shield_thickness;     # from M. Zarecky drawings


sub make_bore_tube_shield
{
	my $z = $TorusZpos/10 + $warm_bore_tube_upstream_add - $warm_bore_tube_downstream_add;

	$detector{"name"}        = "torus_copper_bore_tube_shield";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Copper Center Shield Tube";
	$detector{"pos"}         = "0*mm 0.0*cm $z*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "BC5904";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$ishield_ir*mm $ishield_or*mm $warm_bore_shield_le*cm 0*deg 360*deg";
	$detector{"material"}    = "Copper";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}


my $ipipe_ir = 123.8/2.;             # taken from new drawing sent by L. Quettier (April 2010)
my $ipipe_or = 127.0/2.;             # taken from new drawing sent by L. Quettier (April 2010)


sub make_warm_bore_tube
{
	my $z = $TorusZpos/10 ;
	
	$detector{"name"}        = "torus_warm_bore_tube";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Stainless Steel Inner Pipe";
	$detector{"pos"}         = "0*mm 0.0*cm $z*cm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ff8883";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$ipipe_ir*mm $ipipe_or*mm $warm_bore_tube_le*cm 0*deg 360*deg";
	$detector{"material"}    = "StainlessSteel";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}





# Parallelepiped Coils 1
my $PC1_dx    = $TorusLength - $upstream_plate_LE - $downstream_plate_LE - 10 ;   # This part will end on the z-axis
my $PC1_dy    = 47.59;                      # SteelFrame 1/2 Thickness: Steel plates are 6mm thick
my $PC1_dz    = 1800.0;                     # length from beampipe
my $PC1_angle = -25.0;
my $PC1_zpos = 78.0;


# Inner Ring:
my $SteelPlateIR   =  7.64*$inches ;
my $SteelPlateOR   =  7.87*$inches ;
my $SpanAngleCoil  = atan($PC1_dy/($SteelPlateOR - 55.0))*180.0/$pi;
my $SpanAnglePlate = 35.00;



# Part 1: main Parallelepiped
sub make_part1
{
	$detector{"name"}        = "aaa_SteelFrame_part1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus SST Frame Component #1: parallelepiped part";
	$detector{"pos"}         = "0*mm 0.0*cm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ff88bb";
	$detector{"type"}        = "Parallelepiped";
	$detector{"dimensions"}  = "$PC1_dx*mm $PC1_dy*mm $PC1_dz*mm 0*deg $PC1_angle*deg 0*deg";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}


# Part 2: Box to subtract to part1: Hole near the Outer Ring
my $B1_dx    = $PC1_dx + 500.0;   # This will end on the z-axis
my $B1_dy    = $PC1_dy + 100;
my $B1_dz    = 600.0;
my $B1_posx  = -2300.0;
my $B1_posz  = $B1_dz + $PC1_dz - 1150.0;
my $B1_angle = +22.0;

sub make_part2
{
	$detector{"name"}        = "aaa_SteelFrame_part2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus SteelFrame Component #2: Box to subtract";
	$detector{"pos"}         = "$B1_posx*mm 0.0*cm $B1_posz*mm";
	$detector{"rotation"}    = "0*deg $B1_angle*deg 0*deg";
	$detector{"color"}       = "ff00ff";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$B1_dx*mm $B1_dy*mm $B1_dz*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}

# Part 3 - Parallelepiped with top Hole: Part 2 - Part1
sub make_part3
{
	$detector{"name"}        = "aab_SteelFrame_part3";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus SteelFrame Component #3: aaa_SteelFrame_part1 - aaa_SteelFrame_part2";
	$detector{"pos"}         = "0*mm 0.0*cm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = "ffff66";
	$detector{"type"}        = "Operation: aaa_SteelFrame_part1 - aaa_SteelFrame_part2";
	$detector{"dimensions"}  = "0*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}


# Make all empty Coils (subtract air part), call them aac_SteelFrame_part$nindex
my $overlap = 15.00;
sub make_empty_coils
{
	for(my $n=0; $n<6; $n++)
	{
		my $nindex      = $n+1;
		my $R           = $SteelPlateOR + $PC1_dz - $overlap;
		$detector{"name"}        = "aac_SteelFrame_part$nindex";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Torus Component #$nindex:  aab_SteelFrame_part3 - aaa_TorusAir_part3";
		$detector{"pos"}         = Pos($R, $n);
		$detector{"rotation"}    = Rot($R, $n);
		$detector{"color"}       = $col;
		$detector{"type"}        = "Operation: aab_SteelFrame_part3 - aaa_TorusAir_part3";
		$detector{"dimensions"}  = "0*mm";
		$detector{"material"}    = "Air";
		$detector{"material"}    = "Component";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = "1";
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "no";
		$detector{"hit_type"}    = "";
		$detector{"identifiers"} = "";
		print_det(\%detector, $file);
	}
}

sub make_steel_plates
{
	for(my $n=0; $n<6; $n++)
	{
		my $nindex      = $n+1;
		my $R           = $SteelPlateOR ;
		my $start_phi   = -$SpanAnglePlate/2.0;
		my $length      =  $TorusLength - $upstream_plate_LE - $downstream_plate_LE;
		$detector{"name"}        = "aae_SteelPlate_part$nindex";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Steel Plate $nindex";
		$detector{"pos"}         = "0.0*cm 0.0*cm 0*cm";
		$detector{"rotation"}    = Rot2($R, $n);
		$detector{"color"}       = $col;
		$detector{"type"}        = "Tube";
		$detector{"dimensions"}  = "$SteelPlateIR*mm $SteelPlateOR*mm $length*mm $start_phi*deg $SpanAnglePlate*deg";
		$detector{"material"}    = "Air";
		$detector{"material"}    = "Component";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = "1";
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "no";
		$detector{"hit_type"}    = "";
		$detector{"identifiers"} = "";
		print_det(\%detector, $file);
	}
}





# Part4: mold first plate with first frame
sub make_part4
{
	$detector{"name"}        = "aaf_Steel_part01";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Steel Plate + Frame 1";
	$detector{"pos"}         = "0*mm 0.0*cm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $col;
	$detector{"type"}        = "Operation: aae_SteelPlate_part1 + aac_SteelFrame_part1";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}


# Part5: add in order frames and plates
sub make_part5
{
	my $index_frame = 6;
	my $index_plate = 2;
	for(my $n=1; $n<10+$add_torus_ORing; $n++)
	{
		my $zero        = "0";
		if($n > 8)
		{
			$zero     = "";
		}
		my $nindex      = $n+1;
		
		$detector{"name"}        = "aaf_Steel_part$zero$nindex";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Steel Part $nindex";
		$detector{"pos"}         = "0*mm 0.0*cm 0*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
		$detector{"color"}       = $col;
		
		if($n%2 == 1)
		{
			if($n == 9)
			{
				$zero     = "0";
			}
			$detector{"type"}  = "Operation: aaf_Steel_part$zero$n + aac_SteelFrame_part$index_frame";
			$index_frame--;
		}
		if($n%2 == 0)
		{
			$detector{"type"}  = "Operation: aaf_Steel_part$zero$n + aae_SteelPlate_part$index_plate";
			$index_plate++;
		}
		
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = "1";
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "no";
		$detector{"hit_type"}    = "";
		$detector{"identifiers"} = "";
		print_det(\%detector, $file);
	}
}
	
	
sub make_part6
{
	$detector{"name"}        = "torus_steel_frame";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Steel Part 11";
	$detector{"pos"}         = "0*mm 0.0*cm $TorusZpos*mm";
	$detector{"rotation"}    = "0*deg 180*deg 0*deg";
	$detector{"color"}       = $col;
	$detector{"type"}        = "Operation: aaf_Steel_part10 + aae_SteelPlate_part6";
	$detector{"material"}    = "StainlessSteel";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}


# Big Torus ring 1
my $O1CoilLength = 80.0;
my $O1CoilID     = 2600.0;
my $O1CoilOD     = 2770.0;
my $O1CoilZpos   = 2100.0;
sub make_ORing1
{
	$detector{"name"}        = "Torus_Outer_Ring1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Outer Ring1";
	$detector{"pos"}         = "0.0*cm 0.0*cm $O1CoilZpos*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $col;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$O1CoilID*mm $O1CoilOD*mm $O1CoilLength*mm  0.0*deg 360.0*deg";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}


sub make_sumor1
{
	$detector{"name"}        = "aag_Torus_part1";
	$detector{"mother"}      = "root";
	$detector{"description"} = "aaf_Steel_part11 + Torus_Outer_Ring1";
	$detector{"pos"}         = "0.0*cm 0.0*cm 0*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $col;
	$detector{"type"}        = "Operation: aaf_Steel_part11 + Torus_Outer_Ring1";
	$detector{"dimensions"}  = "0*mm";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}


# Big Torus ring 2
my $O2CoilLength = 130.0;
my $O2CoilID     = 3400.0;
my $O2CoilOD     = 3650.0;
my $O2CoilZpos   = 680.0;
sub make_ORing2
{
	$detector{"name"}        = "Torus_Outer_Ring2";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Outer Ring2";
	$detector{"pos"}         = "0.0*cm 0.0*cm $O2CoilZpos*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $col;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$O2CoilID*mm $O2CoilOD*mm $O2CoilLength*mm  0.0*deg 360.0*deg";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}


sub make_sumor2
{
	$detector{"name"}        = "torus_steel_frame";
	$detector{"mother"}      = "root";
	$detector{"description"} = "aag_Torus_part1 + Torus_Outer_Ring2";
	$detector{"pos"}         = "0.0*cm 0.0*cm $TorusZpos*mm";
	$detector{"rotation"}    = "0*deg 180*deg 0*deg";
	$detector{"type"}        = "Operation: aag_Torus_part1 + Torus_Outer_Ring2";
	$detector{"color"}       = $col;
	$detector{"dimensions"}  = "0*mm";
	$detector{"material"}    = "StainlessSteel";
	# $detector{"material"}    = "Component";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}


# Front and back Plates
my $face_plate_IR = 127./2. + .1;         # chosen to match Torus Inner Pipe defined above
my $face_plate_OR = 7.64*$inches - .1;
my $up_zpos       = $TorusZpos - $TorusLength + $upstream_plate_LE   - 0.1; # Allow microgap to avoid overlaps
my $do_zpos       = $TorusZpos + $TorusLength - $downstream_plate_LE + 0.1;

sub make_upstream_plate
{
	$detector{"name"}        = "torus_upstream_plate";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Front Plate";
	$detector{"pos"}         = "0.0*cm 0.0*cm $up_zpos*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $col;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$face_plate_IR*mm $face_plate_OR*mm $upstream_plate_LE*mm  0.0*deg 360.0*deg";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "StainlessSteel";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}

sub make_downstream_plate
{
	$detector{"name"}        = "torus_downstream_plate";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Torus Back Plate";
	$detector{"pos"}         = "0.0*cm 0.0*cm $do_zpos*mm";
	$detector{"rotation"}    = "0*deg 0*deg 0*deg";
	$detector{"color"}       = $col;
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "$face_plate_IR*mm $face_plate_OR*mm $downstream_plate_LE*mm  0.0*deg 360.0*deg";
	$detector{"material"}    = "Air";
	$detector{"material"}    = "StainlessSteel";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 1;
	$detector{"style"}       = 1;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	print_det(\%detector, $file);
}



sub make_w_shields
{
	for(my $n=0; $n<6; $n++)
	{
		my $nindex = $n+1;
		my $dx1    = 10.4/2.0;        # width at top,cm
		my $dx2    = 8.0/2.0;         # width at bottom, cm
		my $dy     = $ColdHubLength;  # length, cm
		my $dz     = 2.0/2.0; # heigth, cm
		
		
		my $R      = 10.5*$inches/2.0;
		my $theta  = ($n-1)*60;   # every 60 degrees
		my $theta2 = $theta + 90;
		my $x      = sprintf("%.3f", $R*cos(rad($theta)));
		my $y      = sprintf("%.3f", $R*sin(rad($theta)));
		my $z      = $TorusZpos;
		
		$detector{"name"}        = "cca_Wshield_part$nindex";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Additional shield piace by D.K. march 2014 $nindex";
		$detector{"pos"}         = "$x*mm $y*mm $z*mm";
		$detector{"rotation"}    = "90*deg $theta2*deg 0*deg";
		$detector{"color"}       = "0000ff";
		$detector{"type"}        = "Trd";
		$detector{"dimensions"}  = "$dx1*cm $dx2*cm $dy*cm $dy*cm $dz*cm";
		$detector{"material"}    = "G4_W";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = "1";
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "no";
		$detector{"hit_type"}    = "";
		$detector{"identifiers"} = "";
		print_det(\%detector, $file);
	}
}

my $shorterby         =  50.0/2.0;  # 1/2 length (cm)
my $thickerpartlength =  80.0/2.0;  # 1/2 length (cm)

sub make_w_shields2
{
	for(my $n=0; $n<6; $n++)
	{
		my $nindex = $n+1;
		my $dx1    = 10.4/2.0;        # width at top,cm
		my $dx2    = 8.0/2.0;         # width at bottom, cm
		my $dy     = $ColdHubLength-$shorterby;  # length, cm
		my $dz     = 2.0/2.0; # heigth, cm
		
		
		my $R      = 10.5*$inches/2.0;
		my $theta  = ($n-1)*60;   # every 60 degrees
		my $theta2 = $theta + 90;
		my $x      = sprintf("%.3f", $R*cos(rad($theta)));
		my $y      = sprintf("%.3f", $R*sin(rad($theta)));
		my $z      = $TorusZpos + $shorterby*10;
		
		$detector{"name"}        = "cca_Wshield_part$nindex";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Additional shield piace by D.K. march 2014 $nindex";
		$detector{"pos"}         = "$x*mm $y*mm $z*mm";
		$detector{"rotation"}    = "90*deg $theta2*deg 0*deg";
		$detector{"color"}       = "0000ff";
		$detector{"type"}        = "Trd";
		$detector{"dimensions"}  = "$dx1*cm $dx2*cm $dy*cm $dy*cm $dz*cm";
		$detector{"material"}    = "G4_W";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = "1";
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "no";
		$detector{"hit_type"}    = "";
		$detector{"identifiers"} = "";
		print_det(\%detector, $file);
	}
	
	for(my $n=0; $n<6; $n++)
	{
		my $nindex = $n+1;
		my $dx1    = 10.5/2.0;        # width at top,cm
		my $dx2    = 10.4/2.0;         # width at bottom, cm
		my $dy     = $thickerpartlength;  # length, cm
		my $dz     = 3.8/2.0; # heigth, cm
		
		
		my $R      = 10.5*$inches/2.0 + 10*$dz + 10.5;  # on top of the others  , 10 is the previous dz. +0.5 clearance
		my $theta  = ($n-1)*60;   # every 60 degrees
		my $theta2 = $theta + 90;
		my $x      = sprintf("%.3f", $R*cos(rad($theta)));
		my $y      = sprintf("%.3f", $R*sin(rad($theta)));
		my $z      = $TorusZpos + $ColdHubLength*10 - $thickerpartlength*10;
		
		$detector{"name"}        = "cca_Wshield2_part$nindex";
		$detector{"mother"}      = "root";
		$detector{"description"} = "Additional shield piace by D.K. march 2014 $nindex";
		$detector{"pos"}         = "$x*mm $y*mm $z*mm";
		$detector{"rotation"}    = "90*deg $theta2*deg 0*deg";
		$detector{"color"}       = "110088";
		$detector{"type"}        = "Trd";
		$detector{"dimensions"}  = "$dx1*cm $dx2*cm $dy*cm $dy*cm $dz*cm";
		$detector{"material"}    = "G4_W";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = "1";
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "no";
		$detector{"hit_type"}    = "";
		$detector{"identifiers"} = "";
		print_det(\%detector, $file);
	}
}


make_bore_tube_shield();
make_warm_bore_tube();
make_part1();
make_part2();
make_part3();
make_empty_coils();
make_steel_plates();
make_part4();
make_part5();

#make_w_shields();
#make_w_shields2();


if($add_torus_ORing == 0 )
{
   make_part6();
}
else
{
   make_ORing1();
   make_sumor1();
   make_ORing2();
   make_sumor2();
}
make_upstream_plate();
make_downstream_plate();


sub Pos
{
	my $R = shift;
	my $i = shift;
	my $z         = $PC1_zpos + $PC1_dz*tan(abs(rad($PC1_angle))) - 80.0;
	
	my $theta     = 30.0 + $i*60.0;
	my $x         = sprintf("%.3f", $R*cos(rad($theta)));
	my $y         = sprintf("%.3f", $R*sin(rad($theta)));
	return "$x*mm $y*mm $z*mm";
}


sub Rot
{
	my $R = shift;
	my $i = shift;
	
	my $theta     = 30.0 + $i*60.0;
	
	return "ordered: yxz -90*deg $theta*deg 0*deg";
}

sub Rot2
{
	my $R = shift;
	my $i = shift;
	
	my $theta     = $i*60.0;
	
	return "0*deg 0*deg $theta*deg";
}







