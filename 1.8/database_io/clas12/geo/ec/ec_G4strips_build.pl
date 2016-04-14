#!/usr/bin/perl -w
# BAD!
# Perl script used to generate a file (ECwithG4strips.txt) that is an input to 
# the shell script go_table which puts the ECwithG4strips geometry in the mysql 
# database for gemc to use. G.P.Gilfoyle 8/16/12
# load libraries 

use strict;

use lib ("$ENV{GEMC}/database_io");
use geo;
use Getopt::Long;
use Math::Trig;


my $config_file = 'ec.config';

# Load configuration
my %configuration = load_configuration($config_file); 

# Load parameters from mysql database
my %parameters    = download_parameters(%configuration);

# Assign paramters to local variables
my $thetaEC_deg = $parameters{"thetaEC_deg"};


# local quantities.

my $envelope = 'ECwithG4strips';
my $file     = 'ECwithG4strips.txt'; 
my $rmin = 1;
my $rmax = 1000000;
#
# parameters first. These are described in CLAS-Note 2010-?? by Gilfoyle et al.
#
# Face of the EC is tilted 25 degrees, the large angle side is rotated towards detector, 
# and the small angle vertex is rotated away from detector. 
#
#  large angle side(top) -->  /\
#                             \ \
#      Side view               \ \
#                               \ \
#                                \ \
#                                 \_\   <-- small angle vertex(bottom)
#  target  |
# 
# We are using the Hall B coordinate system with the origin at the target center.

my $thetaEC = $thetaEC_deg*$pi/180;      # angle of EC face to a line perpendicular to the beamline in radians.
my $thetaO = 62.889041*$pi/180;           # angle between sides of EC at large scattering angle (angles opposite the beamside vertex) in radians.
my $a1 = 0.08555;                         # see CLAS-Note 2011-019
my $a2 = 1864.65;
#my $a3 = 4.627;   # corrected 10/3/10
my $a3 = 4.45635;
my $a4 = 4.3708;                        # Used to get the position of the u strips.
my $a5 = 103.66;                        # Used to get the width of the u strips.
my $a6 = 0.2476;                        # Used to get the width of the u strips.
my $a7 = 94.701;                        # Used to get the width of the v strips.
my $a8 = 0.2256;                        # Used to get the width of the v and w strip;
my $a9 = 94.926;                        # Used to get the width of the w strips.

my $dlead = 2.381;                       # thickness of lead layers in mm.
my $dscint= 10.0;                        # thickness of scintillator layers in mm.
my $nlayers = 39;                        # number of scintillator layers, there are 38 lead layers (no lead layer 1).
my $nstrips = 36;                        # number of scintillator strips in a layer.
my $L1 = 7217.23;                        # length of line perpendicular to EC face that passes through the CLAS12 target.
my $ypo = 950.88;                        # distance from perpendicular point to the geometric center of the front face of the first scintillator.
#my $MUoffset = 5265.0;                  # the CLAS12 target is at +5m (or -2 m??) in the gemc coordinates.
my $MUoffset = 5000.0;

# Lid of EC box 

my $d_steel1 = 1.75;
my $d_steel2 = 1.75;
my $d_foam   = 76.2;
my $d_lid    = $d_steel1 + $d_foam + $d_steel2;

#derived quantities.

my $tantheta = tan($thetaO);    	      # tangent of angle between sides of EC at large scattering angle (angles opposite the beamside vertex).
my $sqrttantheta = sqrt(1+($tantheta**2));    # term used several times in later subroutines.
my $gamma1 = $pi - 2*$thetaO;                             # angle between sides of EC at small scattering angle.
my $totaldepth = ($nlayers-1)*($dscint+$dlead) + $dscint; # total thickness of lead and scintillator. There are 39 scintillator layers and 38 lead layers.
my $totalvol = $totaldepth+2*$d_lid;
my $offset = &Angleoffset();		      # angle between the midpoint on the edge of a strip and the absolute middle of the strip.

my %detector = ();    # hash (map) that defines the gemc detector
$detector{"rmin"} = $rmin;
$detector{"rmax"} = $rmax;

# Mother Volume - description of parameters for Geant4 G4Trap volume.
#
# pDx1 	  Half x length of the side at y=-pDy1 of the face at -pDz
# pDx2 	  Half x length of the side at y=+pDy1 of the face at -pDz
# pDz 	  Half z length
# pTheta  Polar angle of the line joining the centres of the faces at -/+pDz
# pPhimom Azimuthal angle of the line joining the centre of the face at -pDz to the centre of the face at +pDz
# pDy1 	  Half y length at -pDz
# pDy2 	  Half y length at +pDz
# pDx3 	  Half x length of the side at y=-pDy2 of the face at +pDz
# pDx4 	  Half x length of the side at y=+pDy2 of the face at +pDz
# pAlp1   Angle with respect to the y axis from the centre of the side (lower endcap)
# pAlp2   Angle with respect to the y axis from the centre of the side (upper endcap)
# 
# Note on pAlph1/2: the two angles have to be the same due to the planarity condition. 
#
# all numbers are in mm or deg as specified in the $detector{"dimensions"} statement.

my $pDzmom    = $totalvol/2.0;                        # half z length
my $pDy1mom   = &sycenter($nlayers) + &spDy($nlayers);  # maximum half y length at -pDz. 
my $pDy2mom   = $pDy1mom;                               # half y length at +pDz. 
my $pDx1mom   = 0.001;            # should be zero, but that makes gemc crash.
my $pDx2mom   = &spDx2($nlayers); # Half x length of the side at y=+pDy1 of the face at -pDz.
my $pThetamom = 0;                # Polar angle of the line joining the centres of the faces at +/-pDz
my $pPhimom   = $pThetamom;       # Azimuthal angle from the centre of the face at -pDz to the centre of the face at +pDz. 
my $pDx3mom   = $pDx1mom;         # half x length of the side at y=-pDy2 of the face at +pDz
my $pDx4mom   = $pDx2mom;         # Half x length of the side at y=+pDy2 of the face at +pDz
my $pAlp1mom  = $pThetamom;       # angle with respect to y axis from centre of side(lower endcap)
my $pAlp2mom  = $pThetamom;       # angle with respect to y axis from centre of side(uppder endcap)

# Geant4 builds mother volume in one sector, than rotates the contents in the
# 1st sector to form 6 total sectors. Sector orientations shown below looking
# in the direction of the beam.
#
#             TOP                     ^  y
#              .                      |
#           .  .  .                   |
#        .     .     .          x <----
#     .        .        .
# .       2    .    3       .
# .   .        .        .   .
# .      .     .     .      .
# .         .  .  .         .
# .   1        .       4    .  z/beam - into page
# .         .  .  .         .
# .      .     .     .      .
# .   .        .        .   .
# .       6    .    5       .
#     .        .        .
#        .     .     .
#           .  .  .
#              .

# We place the origin at the geometric center of each layer. The z axis runs along the beam line, 
# the y axis points vertically straight up from beam line and the x axis points left looking out along 
# the beam line. Calculate the position of the center of first scintillator face as the origin.
#
#     1. Get the vector from the target center to the front face of the first scintillator and perpendicular to the face.
my@L1vec = ( 0, $L1*sin($thetaEC), $L1*cos($thetaEC)); 
#     2. Vector that takes you from perpendicular point at L1vec to geometric center of Clas12 EC layer 1. 
my@Svec = ( 0,-$ypo*cos($thetaEC), $ypo*sin($thetaEC)); 
#     3. Now add L1vec+Svec.
my@CLAS12front = ($L1vec[0]+ $Svec[0], $L1vec[1]+ $Svec[1], $L1vec[2]+ $Svec[2]);
#     4. Get vector from center of front face to the midpoint in the z direction
my@toCenter = (0, 0.5*$pDzmom*sin($thetaEC), 0.5*$pDzmom*cos($thetaEC));
#     5. Get final vector from target to center of the mother volume with origin at the center of the front face.
#        MUoffset is needed since the target is at z = 5000 mm and not at the origin.
my@CLAS12center = ($CLAS12front[0]+$toCenter[0],$CLAS12front[1]+$toCenter[1],$CLAS12front[2]+$toCenter[2]-$MUoffset);
 
# array used to calculate pdX values for Geant4. Some lead layers are truncated at the small angle vertex. 
my @beamVertexCut=(0.00001, 0.0000001, 1.440, 0.0000001, 0.000001, 1.448, 0.000001, 0.000001, 1.455, 0.001,
    0.000001, 1.462, 0.000001, 0.000001, 1.0, 0.000001, 0.00001, 1.0, 0.000001, 0.000001, 1.0, 0.000001, 0.000001,
    1.0, 0.000001, 0.000001, 1.0, 0.001, 0.000001, 1.0, 0.000001, 0.000001, 1.0, 0.000001, 0.000001, 1.0, 0.000001, 0.000001);

# generate red mother volume wireframe box, and write to a file. 
$detector{"name"}         = "EC";
$detector{"mother"}       = "sector";
$detector{"description"}  = "Forward Calorimeter";
$detector{"pos"}          = "${CLAS12center[0]}*mm ${CLAS12center[1]}*mm ${CLAS12center[2]}*mm";
$detector{"rotation"}     = "$thetaEC_deg*deg 0*deg";# pure rotation about the geometric center of EC mother volume.
$detector{"color"}        = "ff1111";
$detector{"type"}         = "G4Trap";
$detector{"dimensions"}   = "${pDzmom}*mm ${pThetamom}*deg ${pPhimom}*deg ${pDy1mom}*mm ${pDx1mom}*mm ${pDx2mom}*mm ${pAlp1mom}*deg ${pDy2mom}*mm ${pDx3mom}*mm ${pDx4mom}*mm ${pAlp2mom}*deg";
$detector{"material"}     = "Air";
$detector{"mfield"}       = "no";
$detector{"ncopy"}        = 1;
$detector{"pMany"}        = 1;
$detector{"exist"}        = 1;
$detector{"visible"}      = 0;
$detector{"style"}        = 0;
$detector{"sensitivity"}  = "no";
$detector{"hit_type"}     = "";
$detector{"identifiers"}  = "";


#print "\nStreamlined Results: \n\n";
#print "pDzmom=",$pDzmom," pThetamom=",$pThetamom," pPhimom=",$pPhimom," pDy1mom=",$pDy1mom," pDy2mom=",$pDy2mom,"\n";
#print "pDx1mom=",$pDx1mom," pDx2mom=",$pDx2mom," pDx3mom=",$pDx3mom," pDx4mom=",$pDx4mom," pAlp1mom=",$pAlp1mom," pAlp2mom=",$pAlp2mom,"\n\n";

print_det(\%detector, $file);

# now start to do the alternating layers of scintillator and lead. Set up inputs first.

# All volumes produced are now placed in mother volume's coordinate sytem. 
#  The Mother volume coordinate system has it's y axis running from the mother 
#  volumes small angle vertex straight up to form a perpendicular angle at the 
#  midpoint of the large angle side. 
#
#
#                large angle side(top). 
#         ...........................      
#         \            |            / 
#          .           |           .     
#          \           |           /        
#           .          |          .       
#           \          |y_axis    /      
#            .         |         .
#            \         |         /
#             .        |        .
#             \        |        /   
#        _____________ o________x_axis____
#              \       |       /        
#               .      |      .   
#               \      |      /           
#                .     |     .  
#                \     |     /           
#                 .    |    .   
#                 \    |    /               
#                  .   |    .   
#                  \   |   /                 
#                    .  |   .  
#                   \  |  /                   
#                    . |  .        
#                    \ | /                      
#                    . | .           
#                     \|/                        
#                      .    
#             small angle vertex(bottom)
#                     
my $subname;
my $submother = "EC";
my $description;
my $pos;
my $rotation = "0*deg 0*deg 0*deg";
my $color = "0147FA";
my $type = "G4Trap";
my $dimensions;
my $material ="Air";
my $mfield = "no";
my $ncopy = 1;
my $pMany = 1;
my $exist = 1;
my $visible = 1;
my $style = 1;
my $sensitivity = "no";
my $hit_type = "";
my $identifiers = "";

# now put in the G4Trap parameters for the components of the EC box. set the G4Trap parameters.
#
my $pDx1   = 0.001;  # should be zero, but that makes gemc crash.
my $pDx2   = &spDx2(1);
my $pDz    = $dscint/2.0;  #<-------------------------------------
my $pTheta = 0;
my $pPhi   = $pTheta;
my $pDy1   = &spDy(1);
my $pDy2   = $pDy1;
my $pDx3   = $pDx1;
my $pDx4   = $pDx2;
my $pAlp1  = $pTheta;
my $pAlp2  = $pTheta;

my $i = 1;
my $j = 1;
my $view   = &ECview($i);
my $stack  = &ECstack($i);

# fill the Geant4 description of the volume and write the results into the file.

my $xscint = &sxcenter($i);
my $yscint = &sycenter($i);
my $zscint = &szcenter($i);

my $pDzlid = $d_steel1/2;
my $x_lid = $xscint;
my $y_lid = $yscint;
my $z_lid = $zscint-$pDz-$d_steel2-$d_foam-$d_steel1/2;

#Generate first stainless cover using first scintillator dimensions
$detector{"name"}        = "ECLID1";
$detector{"mother"}      = "EC";
$detector{"description"} = "Stainless Steel Skin 1";
$detector{"pos"}         = "${x_lid}*mm ${y_lid}*mm ${z_lid}*mm";
$detector{"rotation"}    = $rotation;
$detector{"color"}       = "FCFFF0";
$detector{"type"}        = "G4Trap";
$detector{"dimensions"}  = "${pDzlid}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
$detector{"material"}    = "StainlessSteel";
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

$pDzlid = $d_foam/2;
$z_lid = $zscint-$pDz-$d_steel2-$d_foam/2;
#Generate Last-a-Foam layer using first scintillator dimensions
$detector{"name"}        = "ECLID2";
$detector{"mother"}      = "EC";
$detector{"description"} = "Last-a-Foam";
$detector{"pos"}         = "${x_lid}*mm ${y_lid}*mm ${z_lid}*mm";
$detector{"rotation"}    = $rotation;
$detector{"color"}       = "EED18C";
$detector{"type"}        = "G4Trap";
$detector{"dimensions"}  = "${pDzlid}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
$detector{"material"}    = "LastaFoam";
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

$pDzlid = $d_steel2/2;
$z_lid =  $zscint-$pDz-$d_steel2/2;
#Second stainless steel cover using first scintillator dimensions
$detector{"name"}        = "ECLID3";
$detector{"mother"}      = "EC";
$detector{"description"} = "Stainless Steel Skin 2";
$detector{"pos"}         = "${x_lid}*mm ${y_lid}*mm ${z_lid}*mm";
$detector{"rotation"}    = $rotation;
$detector{"color"}       = "FCFFF0";
$detector{"type"}        = "G4Trap";
$detector{"dimensions"}  = "${pDzlid}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
$detector{"material"}    = "StainlessSteel";
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

#now for loop is over layers and generates Geant4 parameters for each scint and lead layer. 

for ($i = 1; $i <= $nlayers; $i++) {

# lead layer
    if( $i >= 2){   # skip the 'first' lead layer since there is one more scint layer than lead.  Compare this with EC!!
    my $xlead = &sxcenterPb($i);
    my $ylead = &sycenterPb($i);
    my $zlead = &szcenterPb($i);

    $subname = "EClayerLead${i}";
    $description = "Forward Calorimeter lead layer ${i}";
    $pos = "${xlead}*mm ${ylead}*mm ${zlead}*mm";         #position of center of trapezoid. 
    $pDz = $dlead/2.0;
    $pDy1 = &spDy($i) - $beamVertexCut[$i-2];     
    $pDy2 = $pDy1;
    $pDx1 = $beamVertexCut[$i-2]*tan($gamma1/2);
    $pDx3 = $pDx1;
    $pDx2 = &spDx2($i);
    $pDx4 = $pDx2;
    $pTheta = 0;
    $pPhi   = $pTheta;
    $pAlp1  = $pTheta;
    $pAlp2  = $pTheta;
    $detector{"name"}         = $subname;
    $detector{"mother"}       = $submother;
    $detector{"description"}  = $description;
    $detector{"pos"}          = $pos;
    $detector{"rotation"}     = $rotation;
    $detector{"color"}        = "7CFC00";
    $detector{"type"}         = "G4Trap";
    $detector{"dimensions"}   = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg  ${pDy1}*mm ${pDx1}*mm  ${pDx2}*mm  ${pAlp1}*deg  ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
    $detector{"material"}     = "Lead";
    $detector{"mfield"}       = "no";
    $detector{"ncopy"}        = 1;
    $detector{"pMany"}        = 1;
    $detector{"exist"}        = 1;
    $detector{"visible"}      = 1;
    $detector{"style"}        = 1;
    $detector{"sensitivity"}  = "no";
    $detector{"hit_type"}     = "";
    $detector{"identifiers"}  = "";
    
#write values to a file. 
    print_det(\%detector, $file);
} # end of if on lead layer.

    my $remainder = $i % 3;  # used in upcoming if statments to determine if a U,V, or W layer is built.

    if( $remainder == 1 )
    {
	for( $j = 1; $j < $nstrips+1; $j++ ) {   # loop over the strips for the U layer

	    $pDx1   = &UspDx2($i,$j); 
	    $pDx2   = &UspDx2($i,$j+1);
	    $pDz    = $dscint/2.0;
	    $pTheta = 0;
	    $pPhi   = $pTheta;
	    $pDy1   = &UspDy($i)/2.0;
	    $pDy2   = $pDy1;
	    $pDx3   = $pDx1;
	    $pDx4   = $pDx2;
	    $pAlp1  = $pTheta;
	    $pAlp2  = $pTheta;
	    
	    
	    $view   = &ECview($i);
	    $stack  = &ECstack($i);

# fill the Geant4 description of the volume and write the results into the file.

	    $xscint = &sxcenter($i);
	    $yscint = &Usycenter($i, $j);
	    $zscint = &szcenter($i);

	    $subname = "EClayerScint${i}strip${j}";
	    $description ="Forward Calorimeter scintillator layer ${i}";
	    $pos = "$xscint*mm $yscint*mm $zscint*mm";
	    $detector{"name"}         = $subname;
	    $detector{"mother"}       = $submother;
	    $detector{"description"}  = $description;
	    $detector{"pos"}          = $pos;
	    $detector{"rotation"}     = $rotation;
	    $detector{"color"}        = "0147FA";
	    $detector{"type"}         = "G4Trap";
	    $detector{"dimensions"}   = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
	    $detector{"material"}     = "Scintillator";
	    $detector{"mfield"}       = "no";
	    $detector{"ncopy"}        = 1;
	    $detector{"pMany"}        = 1;
	    $detector{"exist"}        = 1;
	    $detector{"visible"}      = 1;
	    $detector{"style"}        = 1;
	    $detector{"sensitivity"}  = "EC";
	    $detector{"hit_type"}     = "ECwithG4strips";
	    $detector{"identifiers"}  = "sector ncopy 0 stack manual $stack view manual $view strip manual $j";

	    print_det(\%detector, $file);
	}  # end of U layer strips loop
    } # end of if to select U view.

    if( $remainder == 2 )
    {
	for( $j = 2; $j <= $nstrips+1; $j++ ) {  # loop over the strips for the V view. Start at strip 2 and go to 37

	    $pDx1   = &VXedgelength($i,$j-1);  
	    $pDx2   = &VXedgelength($i,$j);
	    $pDz    = $dscint/2.0;
	    $pTheta = 0;
	    $pPhi   = $pTheta;
	    $pDy1   = &Vwidth($i)/2.0;
	    $pDy2   = $pDy1;
	    $pDx3   = $pDx1;
	    $pDx4   = $pDx2;
	    $pAlp1  = $offset; # angle of offset between strip absolute center and edge center.
	    $pAlp2  = $offset; # angle of offset between strip absolute center and edge center.
   
	    $view   = &ECview($i);
	    $stack  = &ECstack($i);

# fill the Geant4 description of the volume and write the results into the file.

	    $xscint = &Vsxcenter($i, $j);
	    $yscint = &Vstripedge($i, $j - 0.5, $xscint);
	    $zscint = &szcenter($i);

	    # multiply $xscint by negative 1 to get the right sign. 
	    $xscint = -1*$xscint;

	    $subname = "EClayerScint${i}strip${j}";
	    $description ="Forward Calorimeter scintillator layer ${i}";
	    $pos = "$xscint*mm $yscint*mm $zscint*mm";
	    $detector{"name"}         = $subname;
	    $detector{"mother"}       = $submother;
	    $detector{"description"}  = $description;
	    $detector{"pos"}          = $pos;
	    $detector{"rotation"}     = "0*deg 0*deg 117.110959*deg";
	    $detector{"color"}        = "0147FA";
	    $detector{"type"}         = "G4Trap";
	    $detector{"dimensions"}   = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
	    $detector{"material"}     = "Scintillator";
	    $detector{"mfield"}       = "no";
	    $detector{"ncopy"}        = 1;
	    $detector{"pMany"}        = 1;
	    $detector{"exist"}        = 1;
	    $detector{"visible"}      = 1;
	    $detector{"style"}        = 1;
	    $detector{"sensitivity"}  = "EC";
	    $detector{"hit_type"}     = "ECwithG4strips";
	    $detector{"identifiers"}  = "sector ncopy 0 stack manual $stack view manual $view strip manual $j";

	    print_det(\%detector, $file);

	} # end of V layer strips loop
    }# end of 'if' to select V view.

    if( $remainder == 0 ){
	for( $j = 2; $j <= $nstrips+1; $j++ ) {  # loop over the strips for the W layer. Start strip at 2 and go to 37

	    $pDx1   = &WXedgelength($i,$j);  
	    $pDx2   = &WXedgelength($i,$j-1);
	    $pDz    = $dscint/2.0;
	    $pTheta = 0;
	    $pPhi   = $pTheta;
	    $pDy1   = &Wwidth($i)/2.0;
	    $pDy2   = $pDy1;
	    $pDx3   = $pDx1;
	    $pDx4   = $pDx2;
	    $pAlp1  = -1 * $offset; # angle of offset between strip absolute center and edge center.
	    $pAlp2  = -1 * $offset; # angle of offset between strip absolute center and edge center.
   
    
	    $view   = &ECview($i);
	    $stack  = &ECstack($i);

# fill the Geant4 description of the volume and write the results into the file.

	    $xscint = &Wsxcenter($i, $j);
	    $yscint = &Wstripedge($i, $j - 0.5, $xscint);
	    $zscint = &szcenter($i);

	    # multiply $xscint by negative 1 to get the right sign.
	    $xscint = -1*$xscint;

	    $subname = "EClayerScint${i}strip${j}";
	    $description ="Forward Calorimeter scintillator layer ${i}";
	    $pos = "$xscint*mm $yscint*mm $zscint*mm";
	    $detector{"name"}         = $subname;
	    $detector{"mother"}       = $submother;
	    $detector{"description"}  = $description;
	    $detector{"pos"}          = $pos;
	    $detector{"rotation"}     = "0*deg 0*deg 62.889041*deg";
	    $detector{"color"}        = "0147FA";
	    $detector{"type"}         = "G4Trap";
	    $detector{"dimensions"}   = "${pDz}*mm ${pTheta}*deg ${pPhi}*deg ${pDy1}*mm ${pDx1}*mm ${pDx2}*mm ${pAlp1}*deg ${pDy2}*mm ${pDx3}*mm  ${pDx4}*mm  ${pAlp2}*deg";
	    $detector{"material"}     = "Scintillator";
	    $detector{"mfield"}       = "no";
	    $detector{"ncopy"}        = 1;
	    $detector{"pMany"}        = 1;
	    $detector{"exist"}        = 1;
	    $detector{"visible"}      = 1;
	    $detector{"style"}        = 1;
	    $detector{"sensitivity"}  = "EC";
	    $detector{"hit_type"}     = "ECwithG4strips";
	    $detector{"identifiers"}  = "sector ncopy 0 stack manual $stack view manual $view strip manual $j";

	    print_det(\%detector, $file);

	} # end of W layer loop
    }# end of 'if' to select W view.

}# end of 'for' loop over lead-scint layers.


#
#subroutines *********************************************************************
#
# scintillator positions:

# gives the x position of each scintillator layers geometric center inside the mother volume. 
sub sxcenter($){
    my $xcent = 0;
    return $xcent; 
} 

# gives the x center position of V layer strips inside the mother volume.
sub Vsxcenter($){
    # get the corners for the desired V strip.
    my $layer = $_[0];
    my $strip = $_[1] - 1; # to be consistent with Keegan's conventions.
    my @corners = &VstripCorners($layer,$strip);
    my @point1 = ($corners[0],$corners[1]);
    my @point2 = ($corners[2],$corners[3]);
    my @point3 = ($corners[4],$corners[5]);
    my @point4 = ($corners[6],$corners[7]);

    # average the corner positions to get the geometric center of the strip.
    my @stripAve = (($point1[0]+$point2[0]+$point3[0]+$point4[0])/4,($point1[1]+$point2[1]+$point3[1]+$point4[1])/4);
    my $Vxcent = $stripAve[0];

    return $Vxcent;
}

# gives the x center position of W layer strips inside the mother volume.
sub Wsxcenter($){
    # get the corners for the desired W strip.
    my $layer = $_[0];
    my $strip = $_[1] - 1; # to be consistent with Keegan's conventions.
    my @corners = &WstripCorners($layer,$strip);
    my @point1 = ($corners[0],$corners[1]);
    my @point2 = ($corners[2],$corners[3]);
    my @point3 = ($corners[4],$corners[5]);
    my @point4 = ($corners[6],$corners[7]);

    my @stripAve = (($point1[0]+$point2[0]+$point3[0]+$point4[0])/4,($point1[1]+$point2[1]+$point3[1]+$point4[1])/4);
    my $Wxcent = $stripAve[0];

    return $Wxcent;
}

# gives the y position of each scintillator layers geometric center inside the mother volume. 
sub sycenter($){
    my $ycent = $a1*($_[0] - 1);
    return $ycent; 
}

# gives the y position of each U strip geometric center within the mother volume.
sub Usycenter($){
    # average the y positions for the bottom and top of strip n. See eq. 10.
    my $Uycent = -$a2 - $a4*($_[0] - 1) + ($_[1] - 0.5)*Uwidth($_[0]);

    return $Uycent;
}

# gives the y position of V strips inside the mother volume.
sub Vstripedge($){
    # get the corners for the desired V strip.
    my $layer = $_[0];
    my $strip = $_[1];
    my @corners = &VstripCorners($layer,$strip);
    my @point1 = ($corners[0],$corners[1]);
    my @point2 = ($corners[2],$corners[3]);
    my @point3 = ($corners[4],$corners[5]);
    my @point4 = ($corners[6],$corners[7]);

     # average the corner positions to get the geometric center of the strip.
    my @stripAve = (($point1[0]+$point2[0]+$point3[0]+$point4[0])/4,($point1[1]+$point2[1]+$point3[1]+$point4[1])/4);
    my $Vycent = $stripAve[1];
   
    return $Vycent;
}

# gives the y position of W strips inside the mother volume.
sub Wstripedge($){
    my $Wycent = &sycenter($_[0]) - &DeltaY($_[0]) + (&Wwidth($_[0]) * (37 - $_[1]) * $sqrttantheta) + ($tantheta * $_[2]);
    return $Wycent;
}

#gives the z position of each scintillator layers geometric center inside the mother volume. 
sub szcenter($){
    my $layer = $_[0];
    my $zcent = -$totaldepth/2 + ($layer - 1)*($dscint + $dlead) + $dscint/2;
    return $zcent; 
}

sub DeltaY($){
	my $dy = $a2 + $a3 * ($_[0] - 1);
	return $dy;
}

# lead positions.
# gives the x position of each lead layers geometric center inside the mother volume. 
sub sxcenterPb($){
    my $xcentPb = 0;
    return $xcentPb; 
}

#gives the y position of each lead layers geometric center inside the mother volume. 
sub sycenterPb($){
    my $ycentPb = &sycenter($_[0]) + $beamVertexCut[$_[0]-2]/2;
    return $ycentPb; 
}

#gives the z position of each lead layers geometric center inside the mother volume. 
sub szcenterPb($){
    my $zcentPb = -$totaldepth/2 + ($_[0] - 2)*($dscint + $dlead) + $dscint/2 + ($dscint+$dlead)/2;
    return $zcentPb; 
}

# half-widths of lead and scintillator layers.
#
# gives half y distance of trapezoidal EC layer $i, 
sub spDy($){ 
    my $ywidth = $a2 + $a3*($_[0] - 1); 
    return $ywidth;
}

# gives half x distance of trapezoidal EC layer $i; 
sub spDx2($){
    my $xwidth = (2*&spDy($_[0]))/($tantheta);   
    return $xwidth;
}

# gives half y distance of trapezoidal U layer strips in layer $i, 
sub UspDy($){ 
    my $Uywidth = $a5 + $a6*($_[0] - 1); 
    return $Uywidth;
}

# gives half x distance of trapezoidal EC layer $i; 
sub UspDx2($){
    my $Uxwidth = -((&UYminus($_[0]) - &UYbottom($_[0], $_[1]))/($tantheta));
    if( $Uxwidth == 0 ) {
	return 0.00000000000001; # should return zero but that makes gemc crash
    }else{
	return $Uxwidth;
    }
}

# gives absolute minimum y value of U layer $i
sub UYminus($){
    my $Uymin = -$a2 - $a4*($_[0] - 1);
    return $Uymin;
}

# gives y value for bottom side of a U strip.
sub UYbottom($){
    my $Uy = &UYminus($_[0]) + ($_[1] - 1)*(&UspDy($_[0]));
    return $Uy;
}

# gives x half length values for the V strip edges.
sub VXedgelength($){	
    # get the corners for the desired V strip.
    my $layer = $_[0];
    my $strip = $_[1] - 1; # shift the strip to be consistent with KS.
    my @corners = &VstripCorners($layer,$strip);
    my @point1 = ($corners[0],$corners[1]);
    my @point2 = ($corners[2],$corners[3]);
    my @point3 = ($corners[4],$corners[5]);
    my @point4 = ($corners[6],$corners[7]);

    # get the position of the midpoint of the near-V-vertex edge of the strip and
    # then calculate the distance from there to one of the corners along that edge.
    my @ave34 = (($point3[0]+$point4[0])/2,($point3[1]+$point4[1])/2);
    my $Vx    = sqrt(($ave34[0] - $point4[0])**2 + ($ave34[1] - $point4[1])**2);

    if( $Vx == 0 ) {
	return 0.00000000000001;   # should return zero but that makes gemc crash
    }else{
	return $Vx;
    }
}

# gives x half length values for the W strip edges.
sub WXedgelength($){
    # get the corners for the desired W strip.
    my $layer = $_[0];
    my $strip = $_[1] - 1; # shift strip to be consistent with KS.
    my @corners = &WstripCorners($layer,$strip);
    my @point1 = ($corners[0],$corners[1]);
    my @point2 = ($corners[2],$corners[3]);
    my @point3 = ($corners[4],$corners[5]);
    my @point4 = ($corners[6],$corners[7]);

    # get the position of the midpoint of the near-V-vertex edge of the strip and
    # then calculate the distance from there to one of the corners along that edge.
    my @ave34    = (($point3[0]+$point4[0])/2,($point3[1]+$point4[1])/2);
    my $Wx = sqrt(($ave34[0] - $point4[0])**2 + ($ave34[1] - $point4[1])**2);

    if( $Wx == 0 ) {
	return 0.00000000000001;   # should return zero but that makes gemc crash
    }else{
	return $Wx;
    }
}

# gives the width of the U strips in layer $i, 
sub Uwidth($){ 
    my $Uwidth = $a5 + $a6*($_[0] - 1); 
    return $Uwidth;
}

## gives the width of the V strips.
sub Vwidth($){
    my $Vwidth = $a7 + $a8*($_[0] - 2);
    return $Vwidth;
}
# gives the width of the W strips.
sub Wwidth($){
    my $Wwidth = $a9 + $a8*($_[0] - 3);
    return $Wwidth;
}

sub Angleoffset($){
    # set parameters. The offset is the same for all strips (V and W) so just pick one 
    # strip/layer combination to do the calculation.
    my $layer=2;
    my $strip=30;
    my $pi=3.141592654;

    my @corners = &VstripCorners($layer,$strip);
    my @point1 = ($corners[0],$corners[1]);
    my @point2 = ($corners[2],$corners[3]);
    my @point3 = ($corners[4],$corners[5]);
    my @point4 = ($corners[6],$corners[7]);

    # get the midpoint of edge of the strip closest to the vertex for that view.
    my @edgeAve = (($point1[0]+$point2[0])/2,($point1[1]+$point2[1])/2);
    # get the geometric middle of the strip by averaging all the corners.
    my @stripAve = (($point1[0]+$point2[0]+$point3[0]+$point4[0])/4,($point1[1]+$point2[1]+$point3[1]+$point4[1])/4);

    # get the slopes of the line perpendicular to the strip edge (slope12), the slope of the line from the midpoint
    # of the edge of the strip to the middle of the strip (slope2middle), then extract the angle between those lines.
    my $slope12 = ($point2[1]-$point1[1])/($point2[0]-$point1[0]); # slope of the edge of the strip;
    my $slope12perp = -1/$slope12; # slope of the normal to the edge of the strip;
    my $slope2middle = ($stripAve[1]-$edgeAve[1])/($stripAve[0]-$edgeAve[0]); # slope of line for midpoint of strip edge to midpoint of entire strip.
    my $tanpsi = ($slope2middle - $slope12perp)/(1 + ($slope2middle*$slope12perp)); # tangent of angle between the lines.
    my $offset = atan($tanpsi)*180/$pi;

    return $offset 
}

sub ECview($) {
    # using the layer to generate a number (1,2,3) for the different views (U, V,W).

    my $layer = $_[0];
    my $mod = $layer%3;

    my $view = 4;
    if ($mod == 1) {$view = 1;}
    if ($mod == 2) {$view = 2;}
    if ($mod == 0) {$view = 3;}

    if ($view == 4) {print "**** WARNING: No View assignment made. ****\n";}

    return $view;

}

sub ECstack($) {
    # using the layer to generate a number (1,2,3) for the inner and outer stacks in the EC.

    my $layer = $_[0];

    my $stack = 3;
    if ($i <= 15) {$stack = 1;}
    if ($i >  15) {$stack = 2;}
    if ($stack == 3) {print "**** WARNING: No Stack assignment made. ****\n";}

    return $stack;

}

# the three lines that define the edges of the triangular layer.
#
# border of scintillator layer at large polar angle.
sub youter($){
    my $y_outer = &sycenter($_[0]) + &DeltaY($_[0]);
    return $y_outer;
}

# left border of scintillator layer as you look outward from the target.
sub yleft($){
    my $y_left = &sycenter($_[0]) - &DeltaY($_[0]) - $tantheta*$_[1];
    return $y_left;
}

# right border of scintillator layer as you look outward from the target.
sub yright($){
    my $y_right = &sycenter($_[0]) - &DeltaY($_[0]) + $tantheta*$_[1];
    return $y_right;
}


sub VstripCorners($){

    # get the four corners of the strip using the equations in CLAS-NOTE 2011-019.
    #      1. set eq 7 = eq 12 with n = strip number and solve for x. y is given by eq 7. This is the strip edge closest to the V vertex.
    #      2. set eq 6 = eq 12 with n = strip number and solve for x. y is given by eq 6. This is the strip edge closest to the V vertex.
    #      3. set eq 7 = eq 12 with n = strip number + 1 and solve for x. y is given by eq 7. This is the strip edge farthest from the V vertex.
    #      4. set eq 6 = eq 12 with n = strip number + 1 and solve for x. y is given by eq 6. This is the strip edge farthest from the V vertex.
    #
    # The number scheme is the following.        3   1
    #                                            -----
    #                                             \   \
    #                                              \   \
    #                                               \   \
    #                                                \   \
    #                                                 -----
    #                                                 4   2

    my $layer = $_[0];
    my $strip = $_[1];

    my @Vcorner1 = ((-&youter($layer) + &sycenter($layer) - &DeltaY($layer) + (37-$strip)*&Vwidth($layer)*$sqrttantheta)/$tantheta,&youter($layer));
    my $xvalue1 = (37-$strip)*&Vwidth($layer)*$sqrttantheta/(2*$tantheta);
    my @Vcorner2 =  ($xvalue1,&yright($layer,$xvalue1));
    my @Vcorner3 = ((-&youter($layer) + &sycenter($layer) - &DeltaY($layer) + (37-($strip+1))*&Vwidth($layer)*$sqrttantheta)/$tantheta,&youter($layer));
    my $xvalue2 = (37-($strip+1))*&Vwidth($layer)*$sqrttantheta/(2*$tantheta);
    my @Vcorner4 =  ($xvalue2,&yright($layer,$xvalue2));

    my @Vcorners = (@Vcorner1, @Vcorner2, @Vcorner3, @Vcorner4);
    #print "Vxcent = ",$Vxcent," myVxcent = ", $myVxcent,"\n";
    # return the corner arrays as a 1D array since perl does not do 2D arrays.
    return @Vcorners;
}

sub WstripCorners($){

    my $layer = $_[0];
    my $strip = $_[1];

    # get the four corners of the strip using the equations in CLAS-NOTE 2011-019.
    #      1. set eq 7 = eq 13 with n = strip number and solve for x. y is given by eq 7. This is the strip edge closest to the W vertex.
    #      2. set eq 5 = eq 13 with n = strip number and solve for x. y is given by eq 5. This is the strip edge closest to the W vertex.
    #      3. set eq 7 = eq 13 with n = strip number + 1 and solve for x. y is given by eq 7. This is the strip edge farthest from the W vertex.
    #      4. set eq 5 = eq 13 with n = strip number + 1 and solve for x. y is given by eq 5. This is the strip edge farthest from the W vertex.
    #
    # The number scheme is the following.        1   3
    #                                            -----
    #                                           /   /
    #                                          /   /
    #                                         /   /
    #                                        /   /
    #                                       -----
    #                                       2   4

    my @Wcorner1 = ((&youter($layer) - &sycenter($layer) + &DeltaY($layer) - (37-$strip)*&Wwidth($layer)*$sqrttantheta)/$tantheta,&youter($layer));
    my $xvalue1  = -(37-$strip)*&Wwidth($layer)*$sqrttantheta/(2*$tantheta);
    my @Wcorner2 =  ($xvalue1,&yleft($layer,$xvalue1));
    my @Wcorner3 = ((&youter($layer) - &sycenter($layer) + &DeltaY($layer) - (37-($strip+1))*&Wwidth($layer)*$sqrttantheta)/$tantheta,&youter($layer));
    my $xvalue2  = -(37-($strip+1))*&Wwidth($layer)*$sqrttantheta/(2*$tantheta);
    my @Wcorner4 =  ($xvalue2,&yleft($layer,$xvalue2));

    my @Wcorners = (@Wcorner1, @Wcorner2, @Wcorner3, @Wcorner4);
    #print "Vxcent = ",$Vxcent," myVxcent = ", $myVxcent,"\n";
    # return the corner arrays by reference since perl does not do 2D arrays.
    return @Wcorners;
}
