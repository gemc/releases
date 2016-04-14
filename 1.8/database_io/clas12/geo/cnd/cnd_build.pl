#!/usr/bin/perl -w

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use Getopt::Long;
use Math::Trig;


my $config_file = 'cnd.config';

# Load configuration
my %configuration = load_configuration($config_file); 

# Load parameters from mysql database
my %parameters    = download_parameters(%configuration);

# Assign parameters to local variables:

my $layers = $parameters{"layers"};
my $paddles1 = $parameters{"paddles_type_1"};  # per layer! The old, narrow ones
my $paddles2 = $parameters{"paddles_type_2"};  # per layer! The new, wider ones

my $length1 = $parameters{"paddles_length1"};  # length of paddles in each layer, numbered outwards from center
my $length2 = $parameters{"paddles_length2"};
my $length3 = $parameters{"paddles_length3"};

my $r0 = $parameters{"inner_radius"};   # not counting the wrapping
my $r1 = $parameters{"outer_radius"};

my $z_offset1 = $parameters{"z0_layer1"};  # offset of center of paddles in layer 1 from center of mother volume
my $z_offset2 = $parameters{"z0_layer2"};
my $z_offset3 = $parameters{"z0_layer3"}; 

my $mother_offset = $parameters{"z0_mothervol"}; # offset of center of mother volume from magnet center

my $mother_clearance = $parameters{"mothervol_z_gap"};    #cm, clearance at either end of mother volume
my $mother_gap1 = $parameters{"mothervol_gap_in"};        #cm, clearance on the inside of mother volume (just to fit in wrapping)
my $mother_gap2 = $parameters{"mothervol_gap_out"};       #cm, clearance on outside of mother volume (to allow for the corners of the trapezoid paddles)

my $layer_gap = $parameters{"layer_gap"};
my $paddle_gap = $parameters{"paddle_gap"};
my $block_gap1 = $parameters{"segment_gap_type1"};  # gap either side of block (of six paddles) of type 1
my $block_gap2 = $parameters{"segment_gap_type2"};  # gap between blocks of type 2

my $wrap_thickness = $parameters{"wrap_thickness"};  # total thickness of wrapping material


# Normal Start of the script
my $envelope         = $ARGV[0];
my $file             = $envelope.".txt";

my $rmin = 1;
my $rmax = 1000000;

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

my @length = ($length1, $length2, $length3);             # full length of the paddles

my @z_offset = ($z_offset1, $z_offset2, $z_offset3);     # offset of center of each paddle wrt center of magnet

my $angle_slice = 360.0/($paddles1 + $paddles2);   # degrees, angle corresponding to one segment in phi 

my $dR = ($r1 - $r0 - (($layers-1) * $layer_gap)) / $layers;  # thickness of one layer (assuming all layers are equally thick)

my @mother_gap = ($mother_gap1, $mother_gap2);      #cm, clearance on the inside of mother volume (just to fit in wrapping), followed by 
                                                    # clearance on outside of mother volume (to allow for the corners of the trapezoid paddles)

my $ratio = ($paddles1+$paddles2) / $paddles1;  # ratio of total paddles over paddles of type 1

my @pcolor1 = ('33dd66', '33bb88', '33aaaa', '3399bb');  # paddle colours by layer, paddle width type 1
my @pcolor2 = ('65ff98', '47cf9c', '47bebe', '5bc1e3');  # paddle colours by layer, paddle width type 2


# Mother Volume
sub make_CND
{    

 my $longest_half1 = 0.;
 my $longest_half2 = 0.;
    
 for(my $i=0; $i<3; $i++)
 {
     my $temp_dz1 = 0.5 * $length[$i] - $z_offset[$i];    #upstream half
     my $temp_dz2 = 0.5 * $length[$i] + $z_offset[$i];    #downstream half
     
     if ($longest_half1 < $temp_dz1){
	 $longest_half1 = $temp_dz1;
     }
     if ($longest_half2 < $temp_dz2){
	 $longest_half2 = $temp_dz2;
     }
 }
 
 my $mother_dz = ($longest_half1 + $longest_half2) * 0.5 + $mother_clearance;
 
 my $IR = $r0 - $mother_gap[0];
 my $OR = $r1 + $mother_gap[1];

 $detector{"name"}        = $envelope;
 $detector{"mother"}      = "root";
 $detector{"description"} = "Central Neutron Detector";
 $detector{"pos"}         = "0*cm 0*cm $mother_offset*cm";
 $detector{"rotation"}    = "0*deg 0*deg 0*deg";
 $detector{"color"}       = "33bb99";
 $detector{"type"}        = "Tube";
 $detector{"dimensions"}  = "$IR*cm $OR*cm $mother_dz*cm 0*deg 360*deg";
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



# Paddles
sub make_CND_paddles
{

  for(my $j=1; $j<=$layers; $j++)
  {
	my $innerRadius = $r0 + ($j-1)*$dR + ($j-1)*$layer_gap;
	my $outerRadius = $innerRadius + $dR;
        my $alpha = rad2deg(atan(0.5*tan(rad($angle_slice)))); 
	
	my $dz = $length[$j-1] / 2.0;
	my $dy = $dR / 2.0;
	
	my $counter1 = 1;    # to match the chosen paddles - assuming paddle 1 is of the first type	
	my $counter2 = 1;    # goes between 0 and 2, for each block
        my $counter3 = 1;    # to count the blocks
        my $tx = 0.;    #declare them
        my $bx = 0.;

	for(my $i=1; $i<=($paddles1+$paddles2); $i++)
	{

            if ($i == $counter1)     # matches numbers for the first type of paddle
	    {   
		$counter2++;
		if ($counter2 == 2)
		{	
		     $counter1 = $counter3 * $ratio * 2;
                     $counter2 = 0;
		     $counter3++;
                }
		else{
		  $counter1++;
		}

		$bx = 0.5*$innerRadius*tan(rad($angle_slice)) - 0.25*$paddle_gap - 0.25*$block_gap1/(cos(rad($angle_slice)));
		$tx = 0.5*$outerRadius*tan(rad($angle_slice)) - 0.25*$paddle_gap - 0.25*$block_gap1/(cos(rad($angle_slice)));

	    	$detector{"color"}       = $pcolor1[$j-1];

            }   
	    else     # must be second type of paddle
            {

		$bx = 0.5*$innerRadius*tan(rad($angle_slice)) - 0.25*$paddle_gap - 0.25*$block_gap2/(cos(rad($angle_slice)));
		$tx = 0.5*$outerRadius*tan(rad($angle_slice)) - 0.25*$paddle_gap - 0.25*$block_gap2/(cos(rad($angle_slice)));

	    	$detector{"color"}       = $pcolor2[$j-1];

  	    }

       	    my $pnumber = cnumber($i-1, 10);
	    my $angle = ((-1)**($i+1))*$alpha;
	    my $theta = ($i - ((1 + ((-1)**($i+1)))/2))*$angle_slice;   # increment angle for every other paddle
	    my $dxc = ($tx+$bx)/2.0;                                    # shape's center position along x 
	    my $x = sprintf("%.3f", ($innerRadius+$dy)*sin(rad($theta)) - ((-1)**$i)*(($paddle_gap/2.0)+$dxc)*cos(rad($theta)));
	    my $y = sprintf("%.3f", ($innerRadius+$dy)*cos(rad($theta)) + ((-1)**$i)*(($paddle_gap/2.0)+$dxc)*sin(rad($theta)));
            my $z = sprintf("%.3f", $z_offset[$j-1]);  
	    
	    $detector{"name"}        = "CND_Layer$j"."_Paddle_$pnumber";
	    $detector{"mother"}      = $envelope;
	    $detector{"description"} = "Central Neutron Detector, Layer $j, Scintillator $i";
	    $detector{"pos"}         = "$x*cm $y*cm $z*cm";
	    $detector{"rotation"}    = "0*deg 0*deg $theta*deg";
	    $detector{"type"}        = "G4Trap";
	    $detector{"dimensions"}  = "$dz*cm 0*deg 0*deg $dy*cm $bx*cm $tx*cm $angle*deg $dy*cm $bx*cm $tx*cm $angle*deg";
	    $detector{"material"}    = "ScintillatorB";
	    $detector{"mfield"}      = "no";
	    $detector{"ncopy"}       = $pnumber;
	    $detector{"pMany"}       = 1;
	    $detector{"exist"}       = 1;
	    $detector{"visible"}     = 1;
	    $detector{"style"}       = 1;
	    $detector{"sensitivity"} = "CND";
	    $detector{"hit_type"}    = "CND";
	    $detector{"identifiers"} = "layer manual $j paddle manual $i";
	    
	    print_det(\%detector, $file);	    
        }
  }   
}   


# Paddle wrapping (aluminium)
sub make_paddle_wrapping
{
    for(my $j=1; $j<=2*$layers; $j++)
    {

        my $outerRadius = $r0 +  (2*$j - 1 + (-1)**$j)*$dR/4.0  +  (2*$j - 3 - (-1)**$j)*$layer_gap/4.0  +  (1 + (-1)**$j)*$wrap_thickness/2.0;  
        my $innerRadius = $outerRadius - $wrap_thickness;
        my $alpha = rad2deg(atan(0.5*tan(rad($angle_slice))));
	
	my $dz = $length[(2*$j-3-(-1)**$j)/4] / 2.0;
	my $dy = $wrap_thickness / 2.0;
        my $bx = 0.;   #declare them
        my $tx = 0.;


	my $counter1 = 1;    # to match the chosen paddles - assuming paddle 1 is of the first type	
	my $counter2 = 1;    # goes between 0 and 2, for each block
        my $counter3 = 1;    # to count the blocks

	for(my $i=1; $i<=($paddles1+$paddles2); $i++)
	{
            if ($i == $counter1)     # matches numbers for the first type of paddle
	    {   
		$counter2++;
		if ($counter2 == 2)
		{	
		    $counter1 = $counter3 * $ratio * 2;
                    $counter2 = 0;
		    $counter3++;
                }
		else {
		 $counter1++;
		}	
		$bx = 0.5*$innerRadius*tan(rad($angle_slice)) - 0.25*$paddle_gap - 0.25*$block_gap1/(cos(rad($angle_slice)));
		$tx = 0.5*$outerRadius*tan(rad($angle_slice)) - 0.25*$paddle_gap - 0.25*$block_gap1/(cos(rad($angle_slice)));
            }   
	    else     # must be second type of paddle
            {

		$bx = 0.5*$innerRadius*tan(rad($angle_slice)) - 0.25*$paddle_gap - 0.25*$block_gap2/(cos(rad($angle_slice)));
		$tx = 0.5*$outerRadius*tan(rad($angle_slice)) - 0.25*$paddle_gap - 0.25*$block_gap2/(cos(rad($angle_slice)));

  	    }
	    
	    my $pnumber = cnumber($i-1, 10);
	    
	    my $angle = ((-1)**($i+1))*$alpha;
	    my $theta = ($i - ((1 + ((-1)**($i+1)))/2))*$angle_slice;   # increment angle for every other paddle
	    my $dxc = ($tx+$bx)/2.0;                                    #shape's center position along x 
	    my $x = sprintf("%.3f", ($innerRadius+$dy)*sin(rad($theta)) - ((-1)**$i)*(($paddle_gap/2.0)+$dxc)*cos(rad($theta)));
	    my $y = sprintf("%.3f", ($innerRadius+$dy)*cos(rad($theta)) + ((-1)**$i)*(($paddle_gap/2.0)+$dxc)*sin(rad($theta)));
            my $z = sprintf("%.3f", $z_offset[(2*$j-3-(-1)**$j)/4]);
	    
	    $detector{"name"}        = "CND_paddlewrap_wrapLayer$j"."_Paddle_$pnumber";
	    $detector{"mother"}      = $envelope;
	    $detector{"description"} = "Central Neutron Detector, Paddle Wrapping Layer $j, Scintillator $i";
	    $detector{"pos"}         = "$x*cm $y*cm $z*cm";
	    $detector{"rotation"}    = "0*deg 0*deg $theta*deg";
	    $detector{"color"}       = "cef6f5";
	    $detector{"type"}        = "G4Trap";
	    $detector{"dimensions"}  = "$dz*cm 0*deg 0*deg $dy*cm $bx*cm $tx*cm $angle*deg $dy*cm $bx*cm $tx*cm $angle*deg";	    
	    $detector{"material"}    = "G4_Al";
	    $detector{"mfield"}      = "no";
	    $detector{"ncopy"}       = $pnumber;
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
}


make_CND();
make_CND_paddles();
make_paddle_wrapping();
