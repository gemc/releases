#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $envelope = 'PMTnate';
my $file     = 'PMTnate.txt';

print "FILE: ",  $file."\n";

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

use Getopt::Long;
use Math::Trig;

$detector{"mfield"}      = "no";
$detector{"ncopy"}       = 1;
$detector{"pMany"}       = 1;
$detector{"exist"}       = 1;
$detector{"visible"}     = 1;
$detector{"style"}       = 1;
$detector{"sensitivity"} = "no";
$detector{"hit_type"}    = "";
$detector{"identifiers"} = "";

############ 48 PMTs ###################

my $PMTradius = 55.0; # 127 mm = 5 inches

my $scale = 15;

my @DV = ( [$scale*(1) , $scale*(3.73192) , $scale*(-11.5182)] , [$scale*(1) , $scale*(3.73181) , $scale*(-5.65746)] , [$scale*(1) , $scale*(3.73205) , $scale*(-3.29576)] , [$scale*(1) , $scale*(3.73202) , $scale*(-1.88609)] ); # ( @DV1 , @DV2 , @DV3 , @DV4 ) direction vectors for pmts 1-4

for(my $i=0; $i<4; $i++){
    my $string = "PMT ";
    print $string;
    print $i;
    for(my $j=0; $j<3; $j++){
	my $space = " ";
	print $space;
	print $DV[$i][$j];
	my $comma = ", ";
	print $comma;
    }
}

my @centers = ( [417.483 , 1558.067 , -62.047] , [462.948 , 1727.744 , 163.333] , [492.379 , 1837.584 , 425.482] , [503.907 , 1880.607 , 707.739] ); # ( @c1 , @c2 , @c3 , @c4 ) centers for pmts 1-4

my @psi = ( atan(abs($DV[0][2])/abs($DV[0][1])) , atan(abs($DV[1][2])/abs($DV[1][1])) , atan(abs($DV[2][2])/abs($DV[2][1])) , atan(abs($DV[3][2])/abs($DV[3][1])) );

my $endl = "\n";

print $endl;

for(my $i=0; $i<4; $i++){
    my $space = " ";
    print $space;
    print $psi[$i]*57.3;
    print $endl;
}

print $endl;
my @mu = ( atan(abs($DV[0][0])/abs($DV[0][1])) , atan(abs($DV[1][0])/abs($DV[1][1])) , atan(abs($DV[2][0])/abs($DV[2][1])) , atan(abs($DV[3][0])/abs($DV[3][1])) );

for(my $i=0; $i<4; $i++){
    my $space = " ";
    print $space;
    print $mu[$i]*57.3;
    print $endl;
}

my @muprime = ( atan($DV[0][0]/sqrt(($DV[0][1]**2) + ($DV[0][2]**2))) , atan($DV[1][0]/sqrt(($DV[1][1]**2) + ($DV[1][2]**2))), atan($DV[2][0]/sqrt(($DV[2][1]**2) + ($DV[2][2]**2))), atan($DV[3][0]/sqrt(($DV[3][1]**2) + ($DV[3][2]**2))) );

print $endl;

for(my $i=0; $i<4; $i++){
    my $space = " ";
    print $space;
    print $muprime[$i]*57.3;
    print $endl;
}

my @normDV = ( sqrt(($DV[0][0]**2) + ($DV[0][1]**2) + ($DV[0][2]**2)) , sqrt(($DV[1][0]**2) + ($DV[1][1]**2) + ($DV[1][2]**2)) , sqrt(($DV[2][0]**2) + ($DV[2][1]**2) + ($DV[2][2]**2)) , sqrt(($DV[3][0]**2) + ($DV[3][1]**2) + ($DV[3][2]**2)) );

print $endl;

for(my $i=0; $i<4; $i++){
    my $space = " ";
    print $space;
    print $normDV[$i];
    print $endl;
}


sub make_PMT
{
    for(my $m=0; $m<12; $m++)
    {
	for(my $n=0; $n<4; $n++)
	{

	    my @DVnew = ( [ $DV[0][0]*cos($m*30*(3.1415926/180)) + $DV[0][1]*sin($m*30*(3.1415926/180)) , $DV[0][1]*cos($m*30*(3.1415926/180)) - $DV[0][0]*sin($m*30*(3.1415926/180)) , $DV[0][2] ] , [ $DV[1][0]*cos($m*30*(3.1415926/180)) + $DV[1][1]*sin($m*30*(3.1415926/180)) , $DV[1][1]*cos($m*30*(3.1415926/180)) - $DV[1][0]*sin($m*30*(3.1415926/180)) , $DV[1][2] ] , [ $DV[2][0]*cos($m*30*(3.1415926/180)) + $DV[2][1]*sin($m*30*(3.1415926/180)) , $DV[2][1]*cos($m*30*(3.1415926/180)) - $DV[2][0]*sin($m*30*(3.1415926/180)) , $DV[2][2] ] , [ $DV[3][0]*cos($m*30*(3.1415926/180)) + $DV[3][1]*sin($m*30*(3.1415926/180)) , $DV[3][1]*cos($m*30*(3.1415926/180)) - $DV[3][0]*sin($m*30*(3.1415926/180)) , $DV[3][2] ] );

	    my @psinew = ( atan($DVnew[0][2]/$DVnew[0][1]) , atan($DVnew[1][2]/$DVnew[1][1]) , atan($DVnew[2][2]/$DVnew[2][1]) , atan($DVnew[3][2]/$DVnew[3][1]) );

# NOTE AJRP: psinew appears to be atan(z/y), i.e., it appears to be the angle that the projection of the PMT orientation vector onto the yz plane makes relative to the y axis

	    my @muprimenew = ( atan($DVnew[0][0]/sqrt(($DVnew[0][1]**2) + ($DVnew[0][2]**2))) , atan($DVnew[1][0]/sqrt(($DVnew[1][1]**2) + ($DVnew[1][2]**2))), atan($DVnew[2][0]/sqrt(($DVnew[2][1]**2) + ($DVnew[2][2]**2))), atan($DVnew[3][0]/sqrt(($DVnew[3][1]**2) + ($DVnew[3][2]**2))) );

# NOTE AJRP: muprimenew appears to be atan( x/(y^2 + z^2) ); i.e., it means that it is the angle of the PMT orientation vector relative to the yz plane. 

	    $detector{"name"}        = "PMT mirror $n section $m";
	    $detector{"mother"}      = "HTCC";
	    #$detector{"mother"}      = "root";
	    $detector{"description"} = "PMT $n $m";

	    my $xposORIG = $centers[$n][0]*cos($m*30*(3.1415926/180)) + $centers[$n][1]*sin($m*30*(3.1415926/180));
	    my $yposORIG = $centers[$n][1]*cos($m*30*(3.1415926/180)) - $centers[$n][0]*sin($m*30*(3.1415926/180));
	    #my $xposORIG = $centers[$n][0];
	    #my $yposORIG = $centers[$n][1];

	    my $xpos = $xposORIG + $DVnew[$n][0];
	    my $ypos = $yposORIG + $DVnew[$n][1];
	    my $zshift = 0;
	    my $zpos = $centers[$n][2] + $DVnew[$n][2] + $zshift;
	    #my $zpos = $centers[$n][2];

	    #for(my $j=0; $j<3; $j++){
	    print $detector{"name"}; 
	    print $endl;

	    my $space = ", ";
	    
	    print $xpos; print $space;
	    print $ypos; print $space;
	    print $zpos ;
	    print $endl;

	    $detector{"pos"}         = "$xpos*mm $ypos*mm $zpos*mm";

	    my $xrot = -((3.14159265/2) - abs($psinew[$n]))*(180/3.14159265); # rotate about the x axis by psi - PI/2
	    my $yrot = ($muprimenew[$n])*(180/3.14159265); # rotate about the y' axis by muprimenew

	    if(($m==3) || ($m==4) || ($m==5) || ($m==6) || ($m==7) || ($m==8))
	    {
		$xrot = ((3.14159265/2) - abs($psinew[$n]))*(180/3.14159265); # bottom pmts
	    }

	    print $endl;
	    print $xrot; print $space;
	    print $yrot; print $endl;
	    #print $zrot; print $endl;

	    $detector{"rotation"}    = "$xrot*deg $yrot*deg 0*deg";
	    $detector{"color"}       = "ee99ff";
	    $detector{"type"}        = "Tube";

	    $detector{"dimensions"}  = "0*mm $PMTradius*mm $normDV[$n]*mm 0*deg 360*deg";
	    $detector{"material"}    = "Air_Opt";
	    #$detector{"material"}    = "Component";

	    $detector{"sensitivity"} = "HTCC";
	    $detector{"hit_type"}    = "HTCC";
			
			my $pmt_index = 1+ $m*4 + $n;
	    $detector{"identifiers"} = "id manual $pmt_index";

	    print_det(\%detector, $file);
	}
    }
}
make_PMT();
