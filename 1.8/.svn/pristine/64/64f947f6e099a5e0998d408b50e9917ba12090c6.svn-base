#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use geo qw($pi);

my $DetectorName = 'CDF_solenoid';

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
sub make_detector
{
 $detector{"name"}        = "$DetectorName";
 $detector{"mother"}      = "root";
 $detector{"description"} = $detector{"name"} ;
 $detector{"pos"}         = "0*cm 0*cm 0*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "ff0000";
 $detector{"type"}        = "Tube";
 my $Rin        = 0;
 my $Rout       = 400;
 my $Dz         = 500;
 $detector{"dimensions"}  = "$Rin*cm $Rout*cm $Dz*cm 0*deg 360*deg";
 $detector{"material"}    = "Vacuum";
 $detector{"mfield"}      = "no";
 $detector{"ncopy"}       = 1;
 $detector{"pMany"}       = 1;
 $detector{"exist"}       = 1;
 $detector{"visible"}     = 0;
 $detector{"style"}       = 0;
 $detector{"sensitivity"} = "no";
 $detector{"hit_type"}    = "";
 $detector{"identifiers"} = $detector{"name"};

 print_det(\%detector, $file);
}
make_detector();


# ! Complete coil						
# &reg 	mat=1	, cur=	5968310.278	&		
# &po	y=	-250	, x=	167.64	&	
# &po	y=	250	, x=	167.64	&	
# &po	y=	250	, x=	150	&	
# &po	y=	-250	, x=	150	&	
# &po	y=	-250	, x=	167.64	&	
# ;						
# ! Upper return yoke						
# &reg	mat=2	&				
# &po	y=	-320	, x=	177.64	&	;offeset from coil
# &po	y=	250	, x=	177.64	&	
# &po	y=	250	, x=	252.64	&	
# &po	y=	-320	, x=	252.64	&	
# &po	y=	-320	, x=	177.64	&	
# ;						
# ! Downstream front bar						
# &reg	mat=2	&				
# &po	y=	250	, x=	295	&	
# &po	y=	275	, x=	295	&	
# &po	y=	275	, x=	150	&	
# &po	y=	250	, x=	150	&	;
# &po	y=	250	, x=	295	&	
# ;						
# !upstream yoke						
# &reg	mat=2	&				
# &po	y=	-320	, x=	20	&	
# &po	y=	-320	, x=	177.64	&	
# &po	y=	-270	, x=	177.64	&	
# &po	y=	-270	, x=	20	&	
# &po	y=	-320	, x=	20	&	
# ;						
# ! Down stream upper yoke						
# &reg	mat=2	&				
# &po	y=	275	, x=	295	&	
# &po	y=	485	, x=	295	&	
# &po	y=	485	, x=	255	&	
# &po	y=	275	, x=	255	&	
# &po	y=	275	, x=	295	&	
# ;						
# !downstream magnet yoke						
# &reg	mat=2	&				
# &po	y=	535	, x=	20	&	
# &po	y=	535	, x=	295	&	
# &po	y=	485	, x=	295	&	
# &po	y=	485	, x=	102.9310778	&	
# &po	y=	260	, x=	41.17243111	&	
# &po	y=	260	, x=	20	&	
# &po	y=	535	, x=	20	&	
# ;						
# ! Extra top triangle						
# &reg	mat=2	&				
# &po	y=	250	, x=	295	&	
# &po	y=	100	, x=	252.64	&	
# &po	y=	250	, x=	252.64	&	
# &po	y=	250	, x=	295	&	

sub make_detector_coilyoke
{
 my $NUM  = 7;
 my @pos_Z = (0,-35,262.5,-295,380,0,0);
 my @name = ("Coil","UpperReturnYoke","DownstreamFrontBar","UpstreamYoke","DownStreamUpperYoke","DownstreamMagnetYoke","ExtraTopTriangle");
 my @Rin = (150,177.64,150,20,255);
 my @Rout = (167.64,252.64,295,177.64,295);
 my @Dz   = (250,285,12.5,25,105);
 my @material  = ("Aluminum","Iron","Iron","Iron","Iron","Iron","Iron");
 my @color= ("ffffff","F63BFF","F63BFF","F63BFF","F63BFF","F63BFF","F63BFF","F63BFF");
 my @type= ("Tube","Tube","Tube","Tube","Tube","Polycone","Polycone");
 
 for(my $n=1; $n<=$NUM; $n++)
 {
    $detector{"name"}        = "$DetectorName\_$name[$n-1]";
    $detector{"mother"}      = "$DetectorName";
    $detector{"description"} = $detector{"name"};
    $detector{"pos"}        = "0*cm 0*cm $pos_Z[$n-1]*cm";
    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
    $detector{"color"}      = $color[$n-1];
    $detector{"type"}       = $type[$n-1];
    if ($n<=5) {$detector{"dimensions"} = "$Rin[$n-1]*cm $Rout[$n-1]*cm $Dz[$n-1]*cm 0*deg 360*deg";}
    if ($n==6) {$detector{"dimensions"} = "0*deg 360*deg 4 20*cm 20*cm 20*cm 20*cm 41.17243111*cm 102.9310778*cm 295*cm 295*cm 260*cm 485*cm 485*cm 535*cm";}
    if ($n==7) {$detector{"dimensions"} = "0*deg 360*deg 2 252.64*cm 252.64*cm 253.64*cm 295*cm 100*cm 250*cm";}
    $detector{"material"}   = $material[$n-1];
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
make_detector_coilyoke();

