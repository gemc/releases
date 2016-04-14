#!/usr/bin/perl 

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;

my $envelope = 'FT';
my $file     = 'FT.txt';

my $rmin      = 1;
my $rmax      = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;


use Getopt::Long;
use Math::Trig;

###########################################################################################
# Define the coordinates of the focal point of the IC in mm

my $xFocal = 0;
my $yFocal = 0;
my $zFocal = 850;       # put the inner radius at (0.,0.,0)

# Define the dimensions of the crystals
my $ltFront = 13.33 ;  # Length of the sides on front face in mm 
my $ltBack  = 16.0  ;  # Length of the sides on the back side in mm
my $depth   = 160.0 ;  # Depth of the crystals in mm

# Determine the focal lenght and the aperature in both directions for the cystals
my $dAlpha = 2.0 * atan( ( $ltBack - $ltFront ) / ( 2.0 * $depth ) );
my $lFoc   =  ( $ltFront / 2.0 )  / tan( $dAlpha / 2.0 );

# Number of crystals in horizonthal and vertical directions
my $Nx = 23;
my $Ny = 23;


###########################################################################################3




if( ( $Nx % 2 ) == 0 || ( $Nx % 2 ) == 0 )
{
 print STDERR  "I only want to work with odd numbers ... \nExiting \n";
 die -1;
}



# Mother Volume
sub make_FT
{
 my $IR = sprintf("%.3f", 0.97*$lFoc);
 my $OR = sprintf("%.3f", 1.05*( $lFoc + $depth));


 $detector{"name"}        = $envelope;
 $detector{"mother"}      = "root";
 $detector{"description"} = "Forward Tagger";
 $detector{"pos"}         = "$xFocal*mm $yFocal*mm $zFocal*mm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "1437f4";
 $detector{"type"}        = "Sphere";
 $detector{"dimensions"}  = "$IR*mm $OR*mm 0*deg 360.0*deg 0.0*deg 13.0*deg";
 $detector{"material"}    = "Air";
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



my %Slot ;
my %Chan ;

&read_trans_table( \%Slot, \%Chan ) ;


# Loop over all crystals and define their positions
sub make_crystals
{
 for ( my $iX = 1; $iX <= $Nx; $iX++ )
 {
    if( exists $Slot{$iX} )
    {
       for ( my $iY = 1; $iY <= $Ny; $iY++ )
       {
          if( exists $Slot{$iX}{$iY} )
          {
             my %crystPars = &getCrystGeom( $iX, $iY );
             if( scalar %crystPars )
             {

                $detector{"name"}        = $crystPars{"name"};
                $detector{"mother"}      = $crystPars{"mother"};
                $detector{"description"} = $crystPars{"desc"} ;
                $detector{"pos"}         = "$crystPars{'locX'}*mm $crystPars{'locY'}*mm $crystPars{'locZ'}*mm";
                $detector{"rotation"}    = "$crystPars{'phiX'}*deg $crystPars{'phiY'}*deg $crystPars{'phiZ'}*deg";
                $detector{"color"}       = $crystPars{"color"};
                $detector{"type"}        = "$crystPars{'shape'}";
                $detector{"dimensions"}  = "$crystPars{'dx1'}*mm $crystPars{'dy1'}*mm $crystPars{'dx2'}*mm $crystPars{'dy2'}*mm $crystPars{'dz'}*mm";
                $detector{"material"}    = $crystPars{"mate"};
                $detector{"mfield"}      = $crystPars{"magf"};
                $detector{"ncopy"}       = $crystPars{"ncpy"};
                $detector{"pMany"}       = $crystPars{"pMany"};
                $detector{"exist"}       = $crystPars{"exist"};
                $detector{"visible"}     = $crystPars{"visib"};
                $detector{"style"}       = $crystPars{"style"};
                $detector{"sensitivity"} = $crystPars{"sens"};
                $detector{"hit_type"}    = $crystPars{"hit"};
                $detector{"identifiers"} = $crystPars{"identifier"};

                print_det(\%detector, $file);

             }
          }
       }
    }
 }
}



sub getCrystGeom
{
 my ( $iX, $iY ) = @_;
 my %geomPars = ();


 # Determine the directional angle wrt the three axes
 my $centX = ( int $Nx/2 ) + 1;
 my $centY = ( int $Ny/2 ) + 1;
 my $alphaX = acos( 0. ) - ( $iX - $centX ) * $dAlpha;
 my $alphaY = acos( 0. ) - ( $iY - $centY ) * $dAlpha;
 my $cosTrans2 = ( cos( $alphaX ) )**2 + ( cos( $alphaY ) )**2 ;


 if ( $cosTrans2 < 1.0 )
 {
    my $alphaZ = acos( sqrt( 1.0 - $cosTrans2 ) );

    my $phiX = 0.0 + ( $iY - $centY ) * $dAlpha;
    my $phiY = 0.0 - ( $iX - $centX ) * $dAlpha;
    my $phiZ = 0.0 ;

    # Radius at the center of trapezoid from the focal point
    my $radius = $lFoc + ( $depth / 2.0 );
    my $inH = cnumber($iX);
    my $inV = cnumber($iY);

#    $geomPars{"name"}        = "IC_CR_" . $inH . "_" . $inV ;
    $geomPars{"name"}        = "FT_CR_" . $iX . "_" . $iY ;
    $geomPars{"desc"}        = "FT Crystal  (h:" . $iX . ", v:" . $iY . ")" ;
    $geomPars{"mother"}      = $envelope ;
    $geomPars{"color"}       = "44ffbb" ;
    $geomPars{"shape"}       = "Trd" ;
    $geomPars{"mate"}        = "LeadTungsten" ;
    $geomPars{"magf"}        = "no" ;
    $geomPars{"magf"}        = "no" ;
    $geomPars{"ncpy"}        = "1" ;
    $geomPars{"pMany"}       = "1" ;
    $geomPars{"exist"}       = "1" ;
    $geomPars{"visib"}       = "1" ;
    $geomPars{"style"}       = "1" ;
    $geomPars{"sens"}        = "IC" ;	# connected to the sensitive volume described in the proper bank
#   $geomPars{"hit"}         = "IC" ;	# connencted to the hit characteristics defined in clas12_hits_def.txt
    $geomPars{"hit"}         = "FT" ;	# connencted to the hit characteristics defined in clas12_hits_def.txt
    $geomPars{"identifier"}  = "ih manual $iX iv manual $iY" ;

    # these are logical volume parameters for crystals, they do not change
    $geomPars{"dz"}      = sprintf("%.3f", $depth   / 2.0)  ;
    $geomPars{"dx1"}     = sprintf("%.3f", $ltFront / 2.0)  ;
    $geomPars{"dy1"}     = sprintf("%.3f", $ltBack  / 2.0)  ;
    $geomPars{"dx2"}     = sprintf("%.3f", $ltFront / 2.0)  ;
    $geomPars{"dy2"}     = sprintf("%.3f", $ltBack  / 2.0)  ;

    # These are raotaional angles around the 3 different axis
    $geomPars{"phiX"}    = sprintf("%.3f", $phiX * 90.0 / acos( 0. ));
    $geomPars{"phiY"}    = sprintf("%.3f", $phiY * 90.0 / acos( 0. ));
    $geomPars{"phiZ"}    = sprintf("%.3f", $phiZ * 90.0 / acos( 0. ));

    $geomPars{"locX"}    = sprintf("%.3f", $radius * cos( $alphaX ));
    $geomPars{"locY"}    = sprintf("%.3f", $radius * cos( $alphaY ));
    $geomPars{"locZ"}    = sprintf("%.3f", $radius * cos( $alphaZ ));
 }
 return  %geomPars ;
}




#---------------------------------------------------------------------

sub read_trans_table 
{
 my  ($Slot_ptr, $Chan_ptr) = @_;
 my $tr_filename = "trans_table_ft.txt" ;

 # This is Stepan's mapping of the scaler by geom locations
 # in classc2 crate.
 my %sc_addr = ( 5  =>  9,
                 6  => 10,
                 7  =>  1,
                 8  =>  4,
                 9  => 11,
                 10 =>  2,
                 11 =>  6,
                 12 =>  7,
                 13 =>  8,
                 14 =>  3,
                 15 =>  5,
                 16 => 12,
                 17 => 13,
                 18 =>  0
               );

 open ( TRTB, "< $tr_filename" ) or
 die "Sorry, can't open file $tr_filename \n";

 my $line = <TRTB>;

 while ( $line = <TRTB> ) 
 {
    chop $line;
    my @lin_list = split(/\s+/, $line) ;

    my $xpos = $lin_list[1];
    my $ypos = $lin_list[2];
    my $cble = $lin_list[3];
    my $pin  = $lin_list[4];

    my $geom_loc = int( $cble/2 ) + 5;
    my $slot = $sc_addr{$geom_loc};
    my $flag = int( $cble%2 + 0.49 );

    $$Slot_ptr{$xpos}{$ypos} = $slot;
    $$Chan_ptr{$xpos}{$ypos} = $pin+$flag*16;
 }
 close( TRTB );
}

make_FT();
make_crystals();








