#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

my $envelope = 'FTOF';
my $file     = 'FTOF.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


use Getopt::Long;
use Math::Trig;

sub sq   { $_[0] * $_[0] }

# All dimensions in mm

# Panel 1a is the old TOF, on the back
# Panel 1b is the new TOF, on the front
# Panel 2  is the new TOF, panel 2

my $inches     = 25.4;
my $mothergap  = 4.0;   # Gap between panels mother volumes and daughters

my $panel1a_width = 150.0;
my $panel1a_thick =  50.8;
my $panel1a_npadd =  23;
my @panel1a_xpos  = (1);
my @panel1a_zpos  = (1);
my @panel1a_leng  = (1);
my @panel1a_name  = ("a");


my $panel1b_width =  60.0;
my $panel1b_thick =  60.0;
my $panel1b_npadd =  58;
my @panel1b_xpos  = (1);
my @panel1b_zpos  = (1);
my @panel1b_leng  = (1);
my @panel1b_name  = ("a");

my $panel2_width = 220.0;
my $panel2_thick =  50.8;
my $panel2_npadd =  5;
my @panel2_xpos  = (1);
my @panel2_zpos  = (1);
my @panel2_leng  = (1);
my @panel2_name  = ("a");


sub read_geometry
{
	# Panel 1a
	my  $file = 'panel1a.txt';
	open(FILE, $file);
	my @lines = <FILE>;
	close(FILE);
	
	foreach my $line (@lines)
	{
		if ($line !~ /#/)
		{
			chomp($line);
			my @numbers = split(/[ \t]+/,$line);
			my ($indx, $xpos, $zpos, $length) = @numbers;
			my $paddle = cnumber($indx-1, 10);
			
			if($indx == 1)
			{
				$panel1a_name[0]  = "panel1a_paddle_$paddle";
				$panel1a_xpos[0]  = $xpos*$inches;
				$panel1a_zpos[0]  = $zpos*$inches;
				$panel1a_leng[0]  = $length*$inches;
			}
			else
			{
				push(@panel1a_name, "panel1a_paddle_$paddle");
				push(@panel1a_xpos, $xpos*$inches);
				push(@panel1a_zpos, $zpos*$inches);
				push(@panel1a_leng, $length*$inches);
			}
			# print $panel1a_name[$indx-1]."\t".$panel1a_xpos[$indx-1]."\t".$panel1a_zpos[$indx-1]."\t".$panel1a_leng[$indx-1]."\n";
		}
	}
	
	# Panel 1b
	$file = 'panel1b.txt';
	open(FILE, $file);
	@lines = <FILE>;
	close(FILE);
	
	foreach my $line (@lines)
	{
		if ($line !~ /#/)
		{
			chomp($line);
			my @numbers = split(/[ \t]+/,$line);
			my ($indx, $xpos, $tmp, $zpos, $length, $tmp2) = @numbers;
			$tmp = $tmp2;
			my $paddle = cnumber($indx-1, 10);
			
			my $llength = $length*$inches + 114.0;   # acceptance correction 4/9/2008:  paddles are longer by 11.4 cm
			if($indx < 6)
			{
				$llength += 66.0;                      # acceptance correction 4/23/2008: first 5 paddles are longer by 6.6 cm
			}
			
			if($indx == 1)
			{
				$panel1b_name[0]  = "panel1b_paddle_$paddle";
				$panel1b_xpos[0]  = $xpos*$inches;
				$panel1b_zpos[0]  = $zpos*$inches;
				$panel1b_leng[0]  = $llength;
			}
			else
			{
				push(@panel1b_name, "panel1b_paddle_$paddle");
				push(@panel1b_xpos, $xpos*$inches);
				push(@panel1b_zpos, $zpos*$inches);
				push(@panel1b_leng, $llength);
			}
			 print "ASD ".$panel1b_name[$indx-1]."\t".$panel1b_xpos[$indx-1]."\t".$panel1b_zpos[$indx-1]."\t".$panel1b_leng[$indx-1]."\n";
		}
	}
	
	#  4/9/2008 Correction: even panels length correction
	for(my $n=1; $n<$panel1b_npadd ; $n++)
	{
		if ($n%2==0)
		{
			$panel1b_leng[$n-1] = ($panel1b_leng[$n-1] + $panel1b_leng[$n])/2.0;
		}
	}
	$panel1b_leng[$panel1b_npadd-1] = $panel1b_leng[$panel1b_npadd-1] + ($panel1b_leng[$panel1b_npadd-2] - $panel1b_leng[$panel1b_npadd-3]);
	



	# Panel 2
	$file = 'panel2.txt';
	open(FILE, $file);
	@lines = <FILE>;
	close(FILE);
	
	foreach my $line (@lines)
	{
		if ($line !~ /#/)
		{
			chomp($line);
			my @numbers = split(/[ \t]+/,$line);
			my ($indx, $xpos, $zpos, $length) = @numbers;
			my $paddle = cnumber($indx-1, 10);
			
			if($indx == 1)
			{
				$panel2_name[0]  = "panel2_paddle_$paddle";
				$panel2_xpos[0]  = $xpos*$inches;
				$panel2_zpos[0]  = $zpos*$inches;
				$panel2_leng[0]  = $length*$inches;
			}
			else
			{
				push(@panel2_name, "panel2_paddle_$paddle");
				push(@panel2_xpos, $xpos*$inches);
				push(@panel2_zpos, $zpos*$inches);
				push(@panel2_leng, $length*$inches);
			}
			# print $panel2_name[$indx-1]."\t".$panel2_xpos[$indx-1]."\t".$panel2_zpos[$indx-1]."\t".$panel2_leng[$indx-1]."\n";
		}
	}
	
}



#
#    ^ z
#    |
#    |
#    ----> x
#   /
#  y
#
# -----------------------
#  \                   /
#   \                 /
#    \               /  dz
#     \             /
#      \-----------/
#           dx

read_geometry();

my $panel1a_mother_dy = $panel1a_thick/2.0 + $mothergap;
my $panel1b_mother_dy = $panel1b_thick/2.0 + $mothergap;
my $panel2_mother_dy  = $panel2_thick/2.0  + $mothergap;

my $panel1a_mother_dx1 = $panel1a_leng[1]/2.0  + $mothergap;
my $panel1b_mother_dx1 = $panel1b_leng[1]/2.0  + $mothergap;
my $panel2_mother_dx1  = $panel2_leng[1]/2.0   + $mothergap;

my $panel1a_mother_dx2 = $panel1a_leng[-1]/2.0 + ($panel1a_leng[-1] - $panel1a_leng[-2])/2.0 + $mothergap;
my $panel1b_mother_dx2 = $panel1b_leng[-1]/2.0 + ($panel1b_leng[-1] - $panel1b_leng[-2])/2.0 + $mothergap;
my $panel2_mother_dx2  = $panel2_leng[-1]/2.0  + ($panel2_leng[-1]  - $panel2_leng[-2])/2.0  + $mothergap;

my $panel1a_dz = sqrt( sq($panel1a_zpos[0] - $panel1a_zpos[-1]) + sq($panel1a_xpos[-1] - $panel1a_xpos[0]) )/2.0  ;
my $panel1b_dz = sqrt( sq($panel1b_zpos[0] - $panel1b_zpos[-1]) + sq($panel1b_xpos[-1] - $panel1b_xpos[0]) )/2.0  ;
my $panel2_dz  = sqrt( sq($panel2_zpos[0]  - $panel2_zpos[-1])  + sq($panel2_xpos[-1]  - $panel2_xpos[0])  )/2.0  ;

my $panel1a_mother_dz = $panel1a_dz + $panel1a_width/2.0 + $mothergap ;
my $panel1b_mother_dz = $panel1b_dz + $panel1b_width/2.0 + $mothergap ;
my $panel2_mother_dz  = $panel2_dz  + $panel2_width/2.0  + $mothergap ;

my $TILT_1 = 90.0 - atan( ($panel1a_xpos[-1] - $panel1a_xpos[0])/($panel1a_zpos[0] - $panel1a_zpos[-1])  )*180.0/$pi;
my $TILT_2 = 90.0 - atan( ($panel2_xpos[-1]  - $panel2_xpos[0]) /($panel2_zpos[0]  - $panel2_zpos[-1])   )*180.0/$pi;

my $panel1a_pos_y = $panel1a_xpos[0] + $panel1a_dz*sin(rad(90 - $TILT_1)) ;
my $panel1b_pos_y = $panel1b_xpos[0] + $panel1b_dz*sin(rad(90 - $TILT_1)) ;
my $panel2_pos_y  = $panel2_xpos[0]  + $panel2_dz*sin( rad(90 - $TILT_2)) ;

my $panel1a_pos_z = $panel1a_zpos[0] - $panel1a_dz*cos(rad(90 - $TILT_1)) - 5000.0;  # sector is placed at 5m
my $panel1b_pos_z = $panel1b_zpos[0] - $panel1b_dz*cos(rad(90 - $TILT_1)) - 5000.0;  # sector is placed at 5m
my $panel2_pos_z  = $panel2_zpos[0]  - $panel2_dz*cos( rad(90 - $TILT_2)) - 5000.0;  # sector is placed at 5m


sub build_panel1a_mother
{
	my $tilt  = $TILT_1+90;
	
	# names
	$detector{"name"}        = "FTOF_Panel_1a";
	$detector{"mother"}      = "sector";
	$detector{"description"} = "Outer TOF - Panel 1a";
	$detector{"pos"}         = "0*cm $panel1a_pos_y*mm $panel1a_pos_z*mm";
	$detector{"rotation"}    = "$tilt*deg 0*deg 0*deg";
	$detector{"color"}       = "ff11aa5";
	$detector{"type"}        = "Trd";
	$detector{"dimensions"}  = "$panel1a_mother_dx1*mm $panel1a_mother_dx2*mm $panel1a_mother_dy*mm $panel1a_mother_dy*mm $panel1a_mother_dz*mm";
	$detector{"material"}    = "Air";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 0;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";

	print_det(\%detector, $file);
}



sub build_panel1b_mother
{
	my $tilt      = $TILT_1+90;
	
	$detector{"name"}        = "FTOF_Panel_1b";
	$detector{"mother"}      = "sector";
	$detector{"description"} = "Outer TOF - Panel 1b";
	$detector{"pos"}         = "0*cm $panel1b_pos_y*mm $panel1b_pos_z*mm";
	$detector{"rotation"}    = "$tilt*deg 0*deg 0*deg";
	$detector{"color"}       = "11ff555";
	$detector{"type"}        = "Trd";	
	$detector{"dimensions"}  = "$panel1b_mother_dx1*mm $panel1b_mother_dx2*mm $panel1b_mother_dy*mm $panel1b_mother_dy*mm $panel1b_mother_dz*mm";
	$detector{"material"}    = "Air";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 0;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	
	print_det(\%detector, $file);
}

sub build_panel2_mother
{
	my $tilt      = $TILT_2+90;
	
	$detector{"name"}        = "FTOF_Panel_2";
	$detector{"mother"}      = "sector";
	$detector{"description"} = "Outer TOF - Panel 2";
	$detector{"pos"}         = "0*cm $panel2_pos_y*mm $panel2_pos_z*mm";
	$detector{"rotation"}    = "$tilt*deg 0*deg 0*deg";
	$detector{"color"}       = "11ff555";
	$detector{"type"}        = "Trd";	
	$detector{"dimensions"}  = "$panel2_mother_dx1*mm $panel2_mother_dx2*mm $panel2_mother_dy*mm $panel2_mother_dy*mm $panel2_mother_dz*mm";
	$detector{"material"}    = "Air";
	$detector{"mfield"}      = "no";
	$detector{"ncopy"}       = "1";
	$detector{"pMany"}       = 1;
	$detector{"exist"}       = 1;
	$detector{"visible"}     = 0;
	$detector{"style"}       = 0;
	$detector{"sensitivity"} = "no";
	$detector{"hit_type"}    = "";
	$detector{"identifiers"} = "";
	
	print_det(\%detector, $file);
}

sub build_panel1a_kids
{

	for(my $n=1; $n<=$panel1a_npadd; $n++)
	{
		my $zpos   = sqrt( sq($panel1a_xpos[$n-1] - $panel1a_xpos[0]) + sq($panel1a_zpos[0] - $panel1a_zpos[$n-1]) ) - $panel1a_dz ;
		my $length = $panel1a_leng[$n-1]/2.0;
		my $width  = $panel1a_width/2.0;
		my $thick  = $panel1a_thick/2.0;
		
		$detector{"name"}         = $panel1a_name[$n-1];
		$detector{"mother"}       = "FTOF_Panel_1a";
		$detector{"description"}  = "paddle $n - Panel 1a";
		$detector{"pos"}          = "0*cm 0*mm $zpos*mm";
		$detector{"rotation"}     = "0*deg 0*deg 0*deg";
		$detector{"color"}        = "ff11aa";
		$detector{"type"}         = "Box";
		$detector{"dimensions"}   = "$length*mm $thick*mm $width*mm";
		$detector{"material"}     = "Scintillator";
		$detector{"mfield"}       = "no";
		$detector{"pMany"}        = 1;
		$detector{"exist"}        = 1;
		$detector{"visible"}      = 1;
		$detector{"style"}        = 1;
		$detector{"sensitivity"}  = "FTOF_1a";
		$detector{"hit_type"}     = "FTOF_1a";
		$detector{"identifiers"}  = "sector ncopy 0 paddle manual $n";
		print_det(\%detector, $file);
	}
}


sub build_panel1b_kids
{

	for(my $n=1; $n<=$panel1b_npadd; $n++)
	{
		my $zpos   = sqrt( sq($panel1b_xpos[$n-1] - $panel1b_xpos[0]) + sq($panel1b_zpos[0] - $panel1b_zpos[$n-1]) ) - $panel1b_dz ;
		my $length = $panel1b_leng[$n-1]/2.0;
		my $width  = $panel1b_width/2.0;
		my $thick  = $panel1b_thick/2.0;
		
		$detector{"name"}        = $panel1b_name[$n-1];
		$detector{"mother"}      = "FTOF_Panel_1b";
		$detector{"description"} = "paddle $n - Panel 1b";
		$detector{"pos"}         = "0*cm 0*mm $zpos*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
		$detector{"color"}       = "11bb55";
		$detector{"type"}       = "Box";
		$detector{"dimensions"}  = "$length*mm $thick*mm $width*mm";
		$detector{"material"}    = "Scintillator";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = "1";
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "FTOF_1b";
		$detector{"hit_type"}    = "FTOF_1b";
		$detector{"identifiers"} = "sector ncopy 0 paddle manual $n";
		print_det(\%detector, $file);
		
		print $panel1b_name[$n-1]."   length: ".$panel1b_leng[$n-1]."\n";
		
	}
}

sub build_panel2_kids
{

	for(my $n=1; $n<=$panel2_npadd; $n++)
	{
		my $zpos   = sqrt( sq($panel2_xpos[$n-1] - $panel2_xpos[0]) + sq($panel2_zpos[0] - $panel2_zpos[$n-1]) ) - $panel2_dz ;
		my $length = $panel2_leng[$n-1]/2.0;
		my $width  = $panel2_width/2.0;
		my $thick  = $panel2_thick/2.0;
		
		$detector{"name"}        = $panel2_name[$n-1];
		$detector{"mother"}      = "FTOF_Panel_2";
		$detector{"description"} = "paddle $n - Panel 2";
		$detector{"pos"}         = "0*cm 0*mm $zpos*mm";
		$detector{"rotation"}    = "0*deg 0*deg 0*deg";
		$detector{"color"}       = "119999";
		$detector{"type"}        = "Box";
		$detector{"dimensions"}  = "$length*mm $thick*mm $width*mm";
		$detector{"material"}    = "Scintillator";
		$detector{"mfield"}      = "no";
		$detector{"ncopy"}       = "1";
		$detector{"pMany"}       = 1;
		$detector{"exist"}       = 1;
		$detector{"visible"}     = 1;
		$detector{"style"}       = 1;
		$detector{"sensitivity"} = "FTOF_2b";
		$detector{"hit_type"}    = "FTOF_2b";
		$detector{"identifiers"} = "sector ncopy 0 paddle manual $n";
		print_det(\%detector, $file);
	}
}

build_panel1a_mother();
build_panel1a_kids();
build_panel1b_mother();
build_panel1b_kids();
build_panel2_mother();
build_panel2_kids();



