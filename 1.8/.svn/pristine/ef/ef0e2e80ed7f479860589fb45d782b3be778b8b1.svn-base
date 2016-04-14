#!/usr/bin/python
#
# Author: Maurik Holtrop (UNH)
# Date: Jan 26, 2011
#
#
# This script places the crystals for the Electromagnetic Calorimeter for the HPS experiment.
#
# Notes: 
# 1.  The rotations in GEANT4 are not *perfectly* accurate, so to avoid detector overlaps a tiny air gap is needed.
#     The size of the gap is set with "tolerance = 0.001", so 1 micron gap.
#     This is somewhat realistic. The actual detector will probably have 300 micron carbon support between crystals.
#
# 2.  The front face is supposed to be more or less flat.
#
# 3.  Placement of the LeadGlass detectors is not perfect. It is not possible to put flat objects perfectly on a curved surface.
#
# Geometry Notes: 
# Theta_x is the angle w.r.t the z-axis in the x direction, so it is a rotation around y by - the angle.
# Theta_y is the angle w.r.t the z-axis in the y direction, so it is a rotation around x by + the angle.
#
import math
import MySQLdb

Ecal_Table = "ecal";

db=MySQLdb.connect("localhost","maurik","wakende","hps_test");
#db=MySQLdb.connect("improv.unh.edu","maurik","","aprime_geometry");
#db=MySQLdb.connect("clasdb","clasuser","","user_geometry");

cursor=db.cursor()
# sql="""select * from aprime_ecal2 limit 10"""
sql="DROP TABLE IF EXISTS "+Ecal_Table
cursor.execute(sql)
sql="""CREATE TABLE `"""+Ecal_Table+"""` ( `name` varchar(40) DEFAULT NULL,
  `mother` varchar(100) DEFAULT NULL,  `description` varchar(200) DEFAULT NULL,
  `pos` varchar(60) DEFAULT NULL,  `rot` varchar(60) DEFAULT NULL,
  `col` varchar(8) DEFAULT NULL,  `type` varchar(60) DEFAULT NULL,
  `dimensions` text,  `material` varchar(60) DEFAULT NULL,
  `magfield` varchar(40) DEFAULT NULL,  `ncopy` int(11) DEFAULT NULL,
  `pMany` int(11) DEFAULT NULL,  `exist` int(11) DEFAULT NULL,
  `visible` int(11) DEFAULT NULL,  `style` int(11) DEFAULT NULL,
  `sensitivity` varchar(40) DEFAULT NULL,  `hitType` varchar(100) DEFAULT NULL,
  `identity` varchar(200) DEFAULT NULL,  `rmin` int(11) DEFAULT NULL,
  `rmax` int(11) DEFAULT NULL,  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `name` (`name`)) ENGINE=MyISAM DEFAULT CHARSET=latin1;"""
cursor.execute(sql)

#
# Control Parameters
#
flux=1            # Write flux detectors? WARNING: There will write into the "monitor" and "flux_detector" tables!
extra_support = 0 # Create the extra tubes around photon beam, and 1/2 for electron beam.
#
# These are the main parameters that determine the geometry.
#
# From Stepan: Drawings of Vacuum has the box length = 63.93" and it sticks out upstream by 12" == 51.93" = 1319 mm
#
Box_Start_z     = 51.93*25.4;  # Location of the FRONT of the box, in the root system.
z_location_crystal_front = Box_Start_z + 20. + 35. ; # Location of the FRONT of the row 1 crystals, from TARGET

Box_Half_depth = 250. # Size of the calorimeter box in the z-direction.
Box_height = 230.

y_offset =  17.;                      # mm Opening in Y of CRYSTALS
Vacuum_gap_y = 5.;                    # mm size of the vaccum gap for main chaimber.

#
# Determine parameters for the vacuum plates.
#
Plate_thickness = (12. + 3. - 5.)/2.    # 
Plate_width  = 410;        # The rear width of the calorimeter box. It flares out to accomodate crystals (with shift)
Plate_width_front = 384.175;   # The front width of the calorimeter vacuum flanges, matches the PS exit flange. 
Plate_depth  =  230/2;           # (z_location_crystal_front - Box_Start_z + 200.)/2;
#
# Side support
#
Plate_side_thickness = 5;
#
# Front flange
#
Front_flange_thickness = 10; # 2cm
#
# See HPS_Experiment notebook page 21.
#
Photon_pipe_loc = 18.0570  # Location at the FRONT.
Photon_pipe_dy  = 10.
Photon_pipe_dy2 = 12.0
Photon_pipe_angle= -math.atan((18.0570 -  33.8009)/(1305. - 1729.));

Electron_pipe_dy = 10.
Electron_pipe_dy2= 12.
Electron_pipe_dx = 15.
Electron_pipe_dx2= 16.
Electron_pipe_loc=  -36.7943 
Electron_pipe_angle= -math.atan((-36.7929 + 57.2068)/(1305. - 1729.) ) # Angle from a measured beam momentum. Changes when fields change.

Positron_side_support_thick = 10; # Half thickness of positron side support
Electron_side_support_thick = 1;

Box_Front_space = z_location_crystal_front - Box_Start_z # Space from front of box to start of crystals.

x_location_crystal_front = Photon_pipe_loc   # The entire array of crystals is centered on the photon line at entrance point.

print "KEY Dimensions \n"
print "Box_start_z =  "+str(Box_Start_z)
print "z_location_crystal_front  = " + str(z_location_crystal_front)
print "x_location_crystal_front  = " + str(x_location_crystal_front)
print "y_offset (Opening crystals)=" + str(y_offset)
print "Angle to edge of crystal  = " + str( math.atan(y_offset / z_location_crystal_front) )
print "Plate_thickness           = " + str(Plate_thickness)
print "Electron pipe angle       = " + str(Electron_pipe_angle)
print "Photon pipe angle         = " + str(Photon_pipe_angle)

#
# Number of PbWO4 crystals in the y and x (1/2 front) direction.
#
max_y = 5 
max_x = 23
#
# Number of LeadGlass crystals in the y and x (1/2 front) direction.
#
LG_max_y = 0
LG_max_x = 0
#
#
#
# Geometry of a Inner Calorimeter PbWO4 crystal is: 
#  front face = 2*6.665 x 2*6.665 mm
#  read face  = 2*8.    x 2*8     mm
#  length     = 2*80mm
#
# So the point of convergence is: 2*80 *6.665/(8-6.665) = 798.80149 mm from the front face.
# 
front_half_width=6.665
front_half_height=6.665
back_half_width=8.
back_half_height=8.
half_length=80.
#
#
# LeadGlass dimensions.
# 
LG_front_half_width=38.2/2
LG_front_half_height=38.2/2
LG_half_length=156*(0.8+1.5)/2
#
#
#
tolerance = .001 # A 1 micrometer gap between volumes.
#
# Useful calculated quantities:
#
ff = 2*half_length * front_half_width/(back_half_width - front_half_width)             # distance to Focal point of trapezoids to front face.
theta = math.atan( (back_half_width - front_half_width)/ (2*half_length) ) # Angle of slope of crystal = 1/2 angle beteen adjacent crystals.
theta_deg = theta*(180./math.pi)
mid = ff+half_length
#
#
xcent_shift= (back_half_width + front_half_width)/2
ycent_shift= (back_half_height + front_half_height)/2
inter_layer_space = 0.2
#
#
# Offsets - these define the gap between the 4 groups of crystals.
#

z_location = z_location_crystal_front + Box_Half_depth - Box_Front_space; # 1350  # Location of the CENTER of the calorimeter box. 
x_offset_center =  tolerance # Setting this creates a center gap in between the the two halves
                             # front_half_width is added later to place the central crystals against each other fo offset=0
z_offset = -ff - (Box_Half_depth - Box_Front_space)  # This offset more or less centers the detector in the mother volume.
                                                     # Then z= -150 is the location of the front face of the PbWO4 counters relative to box center.

#
# Placement of the IC volume determines the location of the ecal in the experiment.
# The front face of the ecal is at -150*mm so 1350*mm in z means that the front face is at 1200*mm in global coords.
# The AnaMagnet is at +450*mm, so it's pole face is at 450+500= 950*mm. The front face is then 25 cm from the ecal.  
# 
if flux:
  sql="delete IGNORE from flux_detectors where name = 'IDtop'";
  cursor.execute(sql)

  sql="INSERT INTO flux_detectors VALUES ('IDtop','ps_ecal_mother','Particle Identifier',"
  sql+="'0*mm "+str(Box_height/2+Vacuum_gap_y/2)+"*mm "+str(Box_Start_z-0.01)+"*mm','0*deg 0*deg 0*deg','ffaa00','Box',"
  sql+="'"+str(Plate_width_front)+"*mm "+str(Box_height/2-Vacuum_gap_y/2)+"*mm 0.01*mm',"
  sql+="'Vacuum','no',1,1,1,1,1,'FLUX','FLUX','id manual 5',1,10000,now())"
  cursor.execute(sql)

  sql="delete IGNORE from flux_detectors where name = 'IDbot'";
  cursor.execute(sql)

  sql="INSERT INTO flux_detectors VALUES ('IDbot','ps_ecal_mother','Particle Identifier',"
  sql+="'0*mm "+str(-Box_height/2-Vacuum_gap_y/2)+"*mm "+str(Box_Start_z-0.01)+"*mm','0*deg 0*deg 0*deg','ffaa00','Box',"
  sql+="'"+str(Plate_width_front)+"*mm "+str(Box_height/2-Vacuum_gap_y/2)+"*mm 0.01*mm',"
  sql+="'Vacuum','no',1,1,1,1,1,'FLUX','FLUX','id manual 5',1,10000,now())"
  cursor.execute(sql)

  sql="delete IGNORE from flux_detectors where name = 'ID_back_top'";
  cursor.execute(sql)

  sql="INSERT INTO flux_detectors VALUES ('ID_back_top','IC','Particle Identifier on back side',"
  sql+="'0*mm "+str(Box_height/2+y_offset)+"*mm "+str(-Box_Half_depth +2*Plate_depth-10.01)+"*mm','0*deg 0*deg 0*deg','ffff00','Box',"
  sql+="'"+str(Plate_width)+"*mm "+str(Box_height/2-y_offset/2)+"*mm 0.01*mm',"
  sql+="'Vacuum','no',1,1,1,1,1,'FLUX','FLUX','id manual 6',1,10000,now())"
  cursor.execute(sql)

  sql="delete IGNORE from flux_detectors where name = 'ID_back_bot'";
  cursor.execute(sql)

  sql="INSERT INTO flux_detectors VALUES ('ID_back_bot','IC','Particle Identifier on back side',"
  sql+="'0*mm "+str(-Box_height/2-y_offset)+"*mm "+str( -Box_Half_depth + 2*Plate_depth-10.01)+"*mm','0*deg 0*deg 0*deg','ffff00','Box',"
  sql+="'"+str(Plate_width_front)+"*mm "+str(Box_height/2-y_offset/2)+"*mm 0.01*mm',"
  sql+="'Vacuum','no',1,1,1,1,1,'FLUX','FLUX','id manual 6',1,10000,now())"
  cursor.execute(sql)

#
# Insert the BEAM Monitors in the monitors table:
#
  sql="delete IGNORE from monitor where name = 'B1'";
  cursor.execute(sql)

  sql="INSERT INTO monitor VALUES ('B1','ps_ecal_mother','Beam Monitor at target',"
  sql+="'0*mm 0*mm -0.11*mm','0*deg 0*deg 0*deg','ffff00','Box',"
  sql+="'100*mm 20*mm 0.1*mm',"
  sql+="'Vacuum','no',1,1,1,1,1,'FLUX','FLUX','id manual 10',1,10000,now())"
  cursor.execute(sql)
  
  sql="delete IGNORE from monitor where name = 'B3'";
  cursor.execute(sql)

  sql="INSERT INTO monitor VALUES ('B3','ps_ecal_mother','Beam Monitor in front of ECAL',"
  sql+="'0*mm 0*mm "+str(Box_Start_z-0.02)+"*mm','0*deg 0*deg 0*deg','ffff00','Box',"
  sql+="'"+str(Plate_width_front)+"*mm "+str(Box_height)+"*mm 0.01*mm',"
  sql+="'Vacuum','no',1,1,1,1,1,'FLUX','FLUX','id manual 12',1,10000,now())"
  cursor.execute(sql)
  
  sql="delete IGNORE from monitor where name = 'B4'";
  cursor.execute(sql)

  sql="INSERT INTO monitor VALUES ('B4','ps_ecal_mother','Beam Monitor behind ECAL',"
  sql+="'0*mm 0*mm "+str(z_location+Box_Half_depth+0.1)+"*mm','0*deg 0*deg 0*deg','ffff00','Box',"
  sql+="'"+str(Plate_width)+"*mm "+str(Box_height)+"*mm 0.01*mm',"
  sql+="'Vacuum','no',1,1,1,1,1,'FLUX','FLUX','id manual 13',1,10000,now())"
  cursor.execute(sql)
  

sql="INSERT INTO "+Ecal_Table +" VALUES ('IC','ps_ecal_mother','Inner Calorimeter','0*mm 0*mm "+str(z_location)+"*mm','0*deg 0*deg 0*deg','ffff00','Box',"
sql+="'"+str(Plate_width+2*Plate_side_thickness+tolerance)+"*mm "+str(Box_height+tolerance)+"*mm "+str(Box_Half_depth)+"*mm','Air','no',1,1,1,0,0,'no','','',1,10000,now())"
cursor.execute(sql)


#####################################################################################################################################

#####################################################################################################################################
#
# Vacuum Enclosure.
#
#####################################################################################################################################
#
# First, we make the vacuum region, then place the vacuum chamber plates and material in it. 
# This is easier than matching up a complicated vacuum shape.
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vacuum_front','IC','Front vacuum region',"
sql+="'0*mm 0*mm "+str(-Box_Half_depth + Plate_depth)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'FFFFFF','Trd',"
sql+="'"+str(Plate_width_front)+"*mm "+str(Plate_width)+"*mm "+str(Vacuum_gap_y + 2*Plate_thickness)+"*mm "+str(Vacuum_gap_y + 2*Plate_thickness)+"*mm "+str(Plate_depth)+"*mm',"
sql+="'Vacuum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)


#
# Create the main vacuum plates. TOP
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_plate_top','Vacuum_front','Top vacuum box plate.',"
sql+="'0*mm 0*mm 0*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Trd',"
sql+="'"+str(Plate_width_front)+"*mm "+str(Plate_width)+"*mm "+str(Plate_thickness)+"*mm "+str(Plate_thickness)+"*mm "+str(Plate_depth)+"*mm',"
sql+="'Component','no',1,1,1,0,0,'no','','',1,10000,now())"
cursor.execute(sql)

#
# Positron side Vaccum support
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_plate_sup','Vacuum_front','Positron side vacuum box support.',"
sql+="'"+str(+Positron_side_support_thick+Photon_pipe_dy+Photon_pipe_loc -2 - Plate_depth*math.tan(Photon_pipe_angle ))+"*mm "+str(-Vacuum_gap_y - Plate_thickness)+"*mm "+str(0)+"*mm',"
sql+="'0*rad "+str(Photon_pipe_angle)+"*rad 0*rad',"
sql+="'CCCCFF','Box',"
sql+="'"+str(Positron_side_support_thick)+"*mm "+str(Vacuum_gap_y)+"*mm "+str(Plate_depth/math.cos(Photon_pipe_angle))+"*mm',"
sql+="'Component','no',1,1,1,0,0,'no','','',1,10000,now())"
cursor.execute(sql)


#
# Electron side Vaccum support
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_plate_el_sup','Vacuum_front','Electron side vacuum box support.',"
sql+="'"+str(Electron_pipe_loc + Electron_side_support_thick + Electron_pipe_dx -Plate_depth*math.tan(Electron_pipe_angle ))+"*mm "
sql+=    str(-Vacuum_gap_y - Plate_thickness)+"*mm "+str(0)+"*mm',"
sql+="'0*rad "+str(Electron_pipe_angle)+"*rad 0*rad',"
sql+="'CCCCFF','Box',"
sql+="'"+str(Electron_side_support_thick)+"*mm "+str(Vacuum_gap_y)+"*mm "+str((Plate_depth+2)/math.cos(Electron_pipe_angle))+"*mm',"
sql+="'Component','no',1,1,1,0,0,'no','','',1,10000,now())"
cursor.execute(sql)

#
# Subtract out a tube shape for the photon beam.
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_ph_tube_top','Vacuum_front','Vacuum region for the photon beam top',"
sql+="'"+str(Photon_pipe_loc - Plate_depth*math.tan(Photon_pipe_angle))+"*mm "+str(-Vacuum_gap_y - Plate_thickness)+"*mm 0*mm',"
sql+="'0*rad "+str(Photon_pipe_angle)+"*rad 0*rad',"
sql+="'FFFFFF','Tube',"
sql+="'0*mm "+str(Photon_pipe_dy2)+"*mm "+str( (Plate_depth+1)/math.cos(Photon_pipe_angle))+"*mm 0*deg 360*deg',"
sql+="'Component','no',1,1,1,0,0,'no','','',1,10000,now())"
cursor.execute(sql)


#
# Subtract out a tube shape for the electron beam vacuum.
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_el_tube_top','Vacuum_front','Vacuum region for the electron beam top',"
sql+="'"+str(Electron_pipe_loc - Plate_depth*math.tan(Electron_pipe_angle))+"*mm "+str(-Vacuum_gap_y - Plate_thickness)+"*mm 0*mm',"
sql+="'0*rad "+str(Electron_pipe_angle)+"*rad 0*rad',"
sql+="'FFFFFF','EllipticalTube',"
sql+="'"+str(Electron_pipe_dx)+"*mm "+str(Electron_pipe_dy)+"*mm "+str((Plate_depth+1)/math.cos(Electron_pipe_angle))+"*mm',"
sql+="'Component','no',1,1,1,0,0,'no','','',1,10000,now())"
cursor.execute(sql)

#
# Combine components.
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_xa_plate_top','Vacuum_front','Top vacuum box plate, with subtractions',"
sql+="'0*mm "+ str(Vacuum_gap_y + Plate_thickness)+"*mm "+str(0)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Operation: Vac_plate_top +  Vac_plate_sup',"
sql+="'0*mm',"
sql+="'Component','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_xb_plate_top','Vacuum_front','Top vacuum box plate, with subtractions',"
sql+="'0*mm "+ str(Vacuum_gap_y + Plate_thickness)+"*mm "+str(0)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Operation: Vac_xa_plate_top -  Vac_ph_tube_top',"
sql+="'0*mm',"
sql+="'Component','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)


sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_xc_plate_top','Vacuum_front','Top vacuum box plate, with subtractions',"
sql+="'0*mm "+ str(Vacuum_gap_y + Plate_thickness)+"*mm "+str(0)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Operation: Vac_xb_plate_top + Vac_plate_el_sup',"
sql+="'0*mm',"
sql+="'Component','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_xd_plate_top','Vacuum_front','Top vacuum box plate, with subtractions',"
sql+="'0*mm "+ str(Vacuum_gap_y + Plate_thickness)+"*mm "+str(0)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Operation: Vac_xc_plate_top - Vac_el_tube_top',"
sql+="'0*mm',"
sql+="'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)

#
# Create the main vacuum plates. BOTTOM
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_plate_bot','Vacuum_front','Bot vacuum box plate.',"
sql+="'0*mm 0*mm 0*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Box',"
sql+="'"+str(Plate_width)+"*mm "+str(Plate_thickness)+"*mm "+str(Plate_depth)+"*mm',"
sql+="'Component','no',1,1,1,0,0,'no','','',1,10000,now())"
cursor.execute(sql)

#
# Subtract out a tube shape for the photon beam.
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_photon_tube_bot','Vacuum_front','Vacuum region for the photon beam bottom',"
sql+="'"+str(Photon_pipe_loc - Plate_depth*math.tan(Photon_pipe_angle))+"*mm "+str(+Vacuum_gap_y +Plate_thickness)+"*mm 0*mm',"
sql+="'0*rad "+str(Photon_pipe_angle)+"*rad 0*rad',"
sql+="'FFFFFF','Tube',"
sql+="'0*mm "+str(Photon_pipe_dy)+"*mm "+str((Plate_depth+2)/math.cos(Photon_pipe_angle) )+"*mm 0*deg 360*deg',"
sql+="'Component','no',1,1,1,0,0,'no','','',1,10000,now())"
cursor.execute(sql)

#
# Subtract out a tube shape for the electron beam.
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_el_tube_bot','Vacuum_front','Vacuum region for the electron beam bottom',"
sql+="'"+str(Electron_pipe_loc-Plate_depth*math.tan(Electron_pipe_angle))+"*mm "+str(Vacuum_gap_y + Plate_thickness)+"*mm 0*mm',"
sql+="'0*rad "+str(Electron_pipe_angle)+"*rad 0*rad',"
sql+="'FFFFFF','EllipticalTube',"
sql+="'"+str(Electron_pipe_dx)+"*mm "+str(Electron_pipe_dy)+"*mm "+str((Plate_depth+2)/math.cos(Electron_pipe_angle))+"*mm',"
sql+="'Component','no',1,1,1,0,0,'no','','',1,10000,now())"
cursor.execute(sql)


#
# Combine components.
#

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_xa_plate_bot','Vacuum_front','Bottom vacuum box plate, with subtractions',"
sql+="'0*mm "+ str(-Vacuum_gap_y - Plate_thickness)+"*mm "+str(0)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Operation: Vac_plate_top - Vac_photon_tube_bot',"
sql+="'0*mm',"
sql+="'Component','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('Vac_xb_plate_bot','Vacuum_front','Bottom vacuum box plate, with subtractions',"
sql+="'0*mm "+ str(-Vacuum_gap_y - Plate_thickness)+"*mm "+str(0)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Operation: Vac_xa_plate_bot - Vac_el_tube_bot',"
sql+="'0*mm',"
sql+="'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)


#
# FLUX detector embedded in the plates.
#


if flux:
  sql="delete IGNORE from flux_detectors where name = 'Vac_xe_plate_top_id'";
  cursor.execute(sql)

  sql= "INSERT INTO flux_detectors VALUES ('Vac_xe_plate_top_id','Vac_xd_plate_top','Top vacuum box plate FLUX detector',"
  sql+="'0*mm "+str(Plate_thickness - 0.012)+"*mm 0*mm',"
  sql+="'0*deg 0*deg 0*deg',"
  sql+="'FFFF00','Trd',"
  sql+="'"+str(Plate_width_front)+"*mm "+str(Plate_width)+"*mm "+str(0.01)+"*mm "+str(0.01)+"*mm "+str(Plate_depth)+"*mm',"
  sql+="'Aluminum','no',1,1,1,1,0,'FLUX','FLUX','id manual 21',1,10000,now())"
  cursor.execute(sql)



if flux:
  sql="delete IGNORE from flux_detectors where name = 'Vac_xe_plate_bot_id'";
  cursor.execute(sql)

  sql= "INSERT INTO flux_detectors VALUES ('Vac_xe_plate_bot_id','Vac_xb_plate_bot','Bottom vacuum box plate FLUX detector',"
  sql+="'0*mm "+str(-Plate_thickness - 0.012)+"*mm 0*mm',"
  sql+="'0*deg 0*deg 0*deg',"
  sql+="'FFFF00','Trd',"
  sql+="'"+str(Plate_width_front)+"*mm "+str(Plate_width)+"*mm "+str(0.01)+"*mm "+str(0.01)+"*mm "+str(Plate_depth)+"*mm',"
  sql+="'Aluminum','no',1,1,1,1,0,'FLUX','FLUX','id manual 22',1,10000,now())"
  cursor.execute(sql)



#
# Back side Vacuum plates and Vacuum
#

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_vacuum2','IC','Vacuum backside',"
sql+="'0*mm 0*mm "+str(Plate_depth)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'FFFFFF','Box',"
sql+="'"+str(Plate_width)+"*mm "+str(Vacuum_gap_y+2*Plate_thickness)+"*mm "+str(Box_Half_depth - Plate_depth)+"*mm',"
sql+="'Vacuum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_plate2_top','IC','Top vacuum box plate, backside',"
sql+="'0*mm "+ str(Vacuum_gap_y + 2*Plate_thickness + 5.)+"*mm "+str(Plate_depth - 5 )+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Box',"
sql+="'"+str(Plate_width)+"*mm "+str(5.)+"*mm "+str(Box_Half_depth - Plate_depth+  5)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_plate2_bot','IC','Bottom vacuum box plate, backside',"
sql+="'0*mm "+ str( -Vacuum_gap_y - 2*Plate_thickness - 5.)+"*mm "+str(Plate_depth - 5)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Box',"
sql+="'"+str(Plate_width)+"*mm "+str(5.)+"*mm "+str(Box_Half_depth - Plate_depth + 5)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)

#
# Front Flanges the sides are slanted to match the vacuum plates.
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_flange_top','IC','Front top vacuum box flange',"
sql+="'0*mm "+ str(Box_height/2+Vacuum_gap_y/2+Plate_thickness)+"*mm "+str(-Box_Half_depth+Front_flange_thickness)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Trd',"
sql+="'"+str(Plate_width_front)+"*mm "
sql+=str(Plate_width_front+Front_flange_thickness/Plate_depth*(Plate_width-Plate_width_front))+"*mm "
sql+=str(Box_height/2 - Vacuum_gap_y/2- Plate_thickness)+"*mm "+str(Box_height/2 - Vacuum_gap_y/2- Plate_thickness)+"*mm "
sql+=str(Front_flange_thickness)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_flange_bot','IC','Front bottom vacuum box flange',"
sql+="'0*mm "+ str(-Box_height/2-Vacuum_gap_y/2-Plate_thickness)+"*mm "+str(-Box_Half_depth+Front_flange_thickness)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Trd',"
sql+="'"+str(Plate_width_front)+"*mm "
sql+=str(Plate_width_front+Front_flange_thickness/Plate_depth*(Plate_width-Plate_width_front))+"*mm "
sql+=str(Box_height/2 - Vacuum_gap_y/2- Plate_thickness)+"*mm "+str(Box_height/2 - Vacuum_gap_y/2- Plate_thickness)+"*mm "
sql+=str(Front_flange_thickness)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)


#
# Sides
#

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_side_right','IC','Right side box plate',"
sql+="'"+str((Plate_width + Plate_width_front)/2+Plate_side_thickness)+"*mm 0*mm "+str(-Box_Half_depth + Plate_depth)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Parallelepiped',"
sql+="'"+str(Plate_side_thickness)+"*mm "+str(Box_height)+"*mm "+str(Plate_depth)+"*mm "
sql+="0*deg "+str( math.atan((Plate_width-Plate_width_front)/(2*Plate_depth)) )+"*rad 0*deg',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)


sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_side_left','IC','left side box plate',"
sql+="'"+str(-(Plate_width + Plate_width_front)/2-Plate_side_thickness)+"*mm 0*mm "+str(-Box_Half_depth + Plate_depth)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Parallelepiped',"
sql+="'"+str(Plate_side_thickness)+"*mm "+str(Box_height)+"*mm "+str(Plate_depth)+"*mm "
sql+="0*deg "+str( -math.atan((Plate_width-Plate_width_front)/(2*Plate_depth)) )+"*rad 0*deg',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)


sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_side_right_back','IC','Right side box plate back',"
sql+="'"+str(Plate_width+Plate_side_thickness)+"*mm 0*mm "+str(Plate_depth-Plate_side_thickness)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Box',"
sql+="'"+str(Plate_side_thickness)+"*mm "+str(Box_height)+"*mm "+str(Box_Half_depth-Plate_depth-Plate_side_thickness)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_side_left_back','IC','Left side box plate back',"
sql+="'"+str(-Plate_width-Plate_side_thickness)+"*mm 0*mm "+str(Plate_depth-Plate_side_thickness)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Box',"
sql+="'"+str(Plate_side_thickness)+"*mm "+str(Box_height)+"*mm "+str(Box_Half_depth-Plate_depth-Plate_side_thickness)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_back_top','IC','Back top side box plate',"
sql+="'0*mm "+str(Vacuum_gap_y/2+Plate_thickness +5 + Box_height/2)+"*mm "+str(Box_Half_depth-Plate_side_thickness)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Box',"
sql+="'"+str(Plate_width)+"*mm "+str(Box_height/2-Vacuum_gap_y/2-Plate_thickness-5)+"*mm "+str(Plate_side_thickness)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_back_bot','IC','Back bottom side box plate',"
sql+="'0*mm "+str(-(Vacuum_gap_y/2+Plate_thickness +5 + Box_height/2))+"*mm "+str(Box_Half_depth-Plate_side_thickness)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Box',"
sql+="'"+str(Plate_width)+"*mm "+str(Box_height/2-Vacuum_gap_y/2-Plate_thickness-5)+"*mm "+str(Plate_side_thickness)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)


#
# Create the box top & bottom of box
#
sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_top','IC','Top box plate, front',"
sql+="'0*mm "+str(Box_height-Plate_side_thickness)+"*mm "+str(-Box_Half_depth + Plate_depth)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Trd',"
sql+="'"+str(Plate_width_front)+"*mm "+str(Plate_width)+"*mm "+str(Plate_side_thickness)+"*mm "+str(Plate_side_thickness)+"*mm "+str(Plate_depth)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_bot','IC','Bottom box plate, front',"
sql+="'0*mm "+str(-Box_height+Plate_side_thickness)+"*mm "+str(-Box_Half_depth + Plate_depth)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Trd',"
sql+="'"+str(Plate_width_front)+"*mm "+str(Plate_width)+"*mm "+str(Plate_side_thickness)+"*mm "+str(Plate_side_thickness)+"*mm "+str(Plate_depth)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_top_back','IC','Top vacuum box plate, backside',"
sql+="'0*mm "+ str(Box_height-Plate_side_thickness)+"*mm "+str(Plate_depth)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Box',"
sql+="'"+str(Plate_width)+"*mm "+str(Plate_side_thickness)+"*mm "+str(Box_Half_depth - Plate_depth)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)

sql= "INSERT INTO  "+Ecal_Table+" VALUES ('IC_box_bot_back','IC','Bottom vacuum box plate, backside',"
sql+="'0*mm "+ str(-Box_height+Plate_side_thickness)+"*mm "+str(Plate_depth)+"*mm',"
sql+="'0*deg 0*deg 0*deg',"
sql+="'CCCCFF','Box',"
sql+="'"+str(Plate_width)+"*mm "+str(Plate_side_thickness)+"*mm "+str(Box_Half_depth - Plate_depth)+"*mm',"
sql+="'Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)


#####################################################################################################################################
#
# Crystal placement
#
#####################################################################################################################################

count =0
#
# POS ranges over the 4 quadrants: (x,y) = ++, +-, --, -+
#

for pos in range(4):

  slide_z=0
  slide_zy=0
  xshift=0
  yshift=0
  zshift=0
  zyshift=0

  for ny in range(max_y):

    if pos==0 or pos==3:
      iny = ny+1
      ysign=1
    else:
      iny= -ny-1
      ysign=-1

    theta_y = ysign*((ny*2+1)*theta)        
    slide_zy = ff*(1-math.cos((2*ny+1)*theta)) - zyshift 

    if(ny!=0):
      zyshift = zyshift + slide_zy
      yshift = yshift +  slide_zy * math.tan(ny*2*theta) + tolerance

    pos_y = ysign*(y_offset + ycent_shift+ny*inter_layer_space) +  ysign*( mid*math.sin(ny*2*theta)  + yshift )



    xshift = 0
    zshift = 0

    for nx in range(max_x):

      n=pos*max_y*max_x+ny*max_x+nx

      if pos==0 or pos==1:
        inx = nx+1            # identity
        xsign=1
      else:
        inx = -nx            # identity
        xsign=-1


#      print "Now %02d, %02d, %02d --> %03d " % (pos,inx,iny,n),

      if ny>99 and nx<0:
        print "Skipped: (" +str(nx) + ","+str(ny)+")"
      else:

#
#        For a CURVED FRONT calorimeter:

#        theta_x_offset = math.atan((x_offset+front_half_width)/ff)    
#        theta_y_offset = math.atan((y_offset+front_half_width)/ff)   # this means the cal is slightly tipped forward!

#
#        theta_x = xsign*(theta_x_offset + nx*2*theta)
#        theta_y = ysign*(theta_y_offset + ny*2*theta)
#        pos_x = mid*math.sin(theta_x)
#        pos_y = mid*math.sin(theta_y)
#        pos_z = z_offset+mid*(math.cos(theta_x)*math.cos(theta_y))

#
#       For a FLAT FRONT Calorimeter:
#
        theta_x = xsign*((nx*2+1)*theta)

        slide_z = ff*(1-math.cos((2*nx+1)*theta) ) - zshift 

        if(nx!=0):
          zshift = zshift +  slide_z
          xshift = xshift +  slide_z * math.tan(nx*2*theta) + abs(math.sin(theta_y)*math.sin(theta_x)) + tolerance 

#
# Last term is a small correction in the x spaceing for larger rotation crystals. 
# It is not well explained, other than that there may be an in accurace in the rotation?
#
        pos_z = z_offset + mid*math.cos(nx*2*theta)*math.cos(ny*2*theta)  + zshift + zyshift
        pos_x = x_location_crystal_front+ xsign*(x_offset_center + xcent_shift)  +  xsign*( mid*math.sin(nx*2*theta)  + xshift )

#        print "nx=",nx, " ny=",ny
#        print "slide z = ",slide_z,"  zshift = ", zshift,"   xshift = ",xshift, " zyshift=", zyshift, " yshift= ",yshift 
#        print "theta = ",theta, "  theta_x = ", theta_x,"  theta_y = ", theta_y
#        print "pos_x = ",pos_x , " pos_y = ",pos_y, " pos_z = ", pos_z
#        print 
#

        sql="INSERT INTO "+Ecal_Table+" VALUES ("  # Inser into database, VALUES are ordered.
        sql+= "'IC_"                              # name, must be unique
        sql+= str(n) + "',"
        sql+= "'IC',"                             # Mother volume = IC
        sql+= "'IC Crystal ("                     # Description, include (x,y) identifier
        sql+= str(inx) + ","
        sql+= str(iny) + ")','" 
        sql+= str(pos_x) + "*mm "                 # Position x y z
        sql+= str(pos_y) + "*mm "
        sql+= str(pos_z) + "*mm'"
        sql+= ",'"                                # Rotations, x y z (Rotate first around x, then y then z)
        sql+= str(  theta_y*180/math.pi) + "*deg " 
        sql+= str( -theta_x*180/math.pi) + "*deg "
        sql+= "0*deg',"
        if ((xsign+1)/2+nx)%2 == 0:                           # Color and Trans: CCCCCCT  T=0 -> 5 (max transparency)
          if ny%2 == 0:
            sql+= "'ff0000',"        
          else:
            sql+= "'00ff00',"
        else:
          if ny%2 == 0:
            sql+= "'0000ff',"        
          else:
            sql+= "'ff00ff',"
            
        sql+= "'Trd','" 
        sql+= str(front_half_width)+ "*mm "  # Shape: Trapezoid 1/2 width x front
        sql+= str( back_half_width)+ "*mm "  #                  1/2 width x back
        sql+= str(front_half_height)+"*mm "  #                  1/2 width y front
        sql+= str( back_half_height)+"*mm "  #                  1/2 width y back
        sql+= str( half_length )    + "*mm',"#                  1/2 length.  
        sql+= "'LeadTungsten',"                  # Material
        sql+= "'no',1,1,1,1,1,"                  # Mag-field, copy number, pmany, Exists?, Visibility, Style (0-wireframe, 1-solid)
        sql+= "'IC','IC',"                       # Sensitivity, hitType
        sql+= "'ih manual " + str(inx)            # identity
        sql+= " iv manual " + str(iny) + "',"
        sql+= "1,1000000,now())"                 # time
            
        cursor.execute(sql)
#        print ". executed"
        count += 1

print "--------------------------------------------"
print " "
print "Placed ", count, " PbWO4 Crystals."
print " "
print "--------------------------------------------"
print " "
#
# Now we enter the Shashlyk Detectors.
# 
# We first want to locate the point at the corner of the first crystal
#           
#print "max_x: ",max_x, "  theta_x= ", theta_x, " pos_x=", pos_x, " xshift=", xshift
#print "max_y: ",max_y, "  theta_y= ", theta_y, " pos_y=", pos_y, " yshift=", yshift

theta_x_offset = 0 # math.atan(x_offset/ff)    
theta_y_offset = theta_y + theta  # math.atan( (y_offset/ff)  
# theta_y_offset = theta_y_offset + max_y*2*theta 
#
x_point = x_offset_center
y_point = pos_y - half_length*math.sin(theta_y) + front_half_width + inter_layer_space
z_point = z_offset + ff

# sql="INSERT INTO  "+Ecal_Table+" VALUES ('M1','IC','Mark1','"
# sql+= str(x_point)+"*mm "
# sql+= str(y_point)+"*mm "
# sql+= str(z_point)+"*mm','0*deg 0*deg 0*deg','000000','Box','1*mm 1*mm 1*mm','Air','no',1,1,1,1,1,'no','','',1,10000,now())"
# cursor.execute(sql)
#
# Point 2 is the opposite end at the larges x corner.
#
x2_point = x_offset_center + max_x*(2*front_half_width + tolerance)
y2_point = y_point
z2_point = z_offset + ff # *math.cos(theta_x_offset+max_x*2*theta)*math.cos(theta_y_offset)

# sql="INSERT INTO  "+Ecal_Table+" VALUES ('M2','IC','Mark2','"
# sql+= str(x2_point)+"*mm "
# sql+= str(y2_point)+"*mm "
# sql+= str(z2_point)+"*mm','0*deg 0*deg 0*deg','000000','Box','1*mm 1*mm 1*mm','Air','no',1,1,1,1,1,'no','','',1,10000,now())"
# cursor.execute(sql)

sl_theta_x  = 0 # theta_x_offset + (max_x-1)*theta   # All crystals at the same x angle.
#sl_theta_x = math.atan((z_point - z2_point)/(x2_point-x_point))  
sl_theta_y  = theta_y_offset

#
#
# Useful calculated quantities:
#

#
# X,Y,Z offsets, along the edge, plus one half crystal.
#
mid = ff + LG_half_length
#
# The first crystal, center point. We need to translate from the corner, which is the line-up.
# This is effectively a rotation around the corner point of the crystal.
#
sl_x_offset = x_point + LG_front_half_width * math.cos(sl_theta_x) + LG_half_length* math.sin(sl_theta_x)
sl_y_offset = y_point + LG_half_length* math.cos(sl_theta_x)*math.sin(sl_theta_y) + LG_front_half_width*math.cos(sl_theta_y)
sl_z_offset = z_point + LG_half_length* math.cos(sl_theta_x)*math.cos(sl_theta_y) - LG_front_half_width*math.sin(sl_theta_x) -LG_front_half_width*math.sin(sl_theta_y)
#

count =0

for pos in range(4):
  for ny in range(LG_max_y):
    for nx in range(LG_max_x):

      n=pos*LG_max_y*LG_max_x+ny*LG_max_x+nx

      if pos==0 or pos==1:
        inx = nx+1            # identity
        xsign=1
      else:
        inx = -nx            # identity
        xsign=-1

      if pos==0 or pos==3:
        iny = ny+10
        ysign=1
      else:
        iny= -ny-10
        ysign=-1


#      print "Now %02d, %02d, %02d --> %03d " % (pos,inx,iny,n),

      if ny>=0 and nx>=0: # DUMMY IF to keep indentation

#        print "Skipped: (" +str(nx) + ","+str(ny)+")"
#      else:

        theta_x = sl_theta_x
        theta_y = sl_theta_y

        pos_x = xsign*(sl_x_offset + 2*nx* (LG_front_half_width  + 2*tolerance) * math.cos(sl_theta_x))
        pos_y = ysign*(sl_y_offset + 2*ny* (LG_front_half_height + 2*tolerance)* math.cos(sl_theta_y)) 
        pos_z = sl_z_offset - 2*nx* LG_front_half_width * math.sin(sl_theta_x)* math.cos(sl_theta_y) - 2*ny*LG_front_half_width*math.sin(sl_theta_y);

          
        sql="INSERT INTO "+Ecal_Table+" VALUES ("  # Inser into database, VALUES are ordered.
        sql+= "'ICS_"                              # name, must be unique
        sql+= str(n) + "',"
        sql+= "'IC',"                             # Mother volume = IC
        sql+= "'ICS Crystal ("                    # Description, include (x,y) identifier
        sql+= str(inx) + ","
        sql+= str(iny) + ")','" 
        sql+= str(pos_x) + "*mm "                 # Position x y z
        sql+= str(pos_y) + "*mm "
        sql+= str(pos_z) + "*mm'"
        sql+= ",'"                                # Rotations, x y z (Rotate first around x, then y then z)
        sql+= str(ysign*sl_theta_y*180/math.pi) + "*deg " 
        sql+= str(-xsign*sl_theta_x*180/math.pi) + "*deg "
        sql+= "0*deg',"
        if ((xsign+1)/2+nx)%2 == 0:                           # Color and Trans: CCCCCCT  T=0 -> 5 (max transparency)
          if ny%2 == 0:
            sql+= "'ffAA00',"        
          else:
            sql+= "'DDff00',"
        else:
          if ny%2 == 0:
            sql+= "'00BBff',"        
          else:
            sql+= "'BB00ff',"
          
        sql+= "'Trd','" 
        sql+= str(LG_front_half_width)+ "*mm "  # Shape: Trapezoid 1/2 width x front
        sql+= str(LG_front_half_width)+ "*mm "  #                  1/2 width x back
        sql+= str(LG_front_half_height)+"*mm "  #                  1/2 width y front
        sql+= str(LG_front_half_height)+"*mm "  #                  1/2 width y back
        sql+= str(LG_half_length )    + "*mm',"#                  1/2 length.  

        sql+= "'LgTF1',"                  # Material
        sql+= "'no',1,1,1,1,1,"                  # Mag-field, copy number, pmany, Exists?, Visibility, Style (0-wireframe, 1-solid)
        sql+= "'IC','IC',"                       # Sensitivity, hitType
        sql+= "'ih manual " + str(inx)            # identity
        sql+= " iv manual " + str(iny) + "',"
        sql+= "1,1000000,now())"                 # time
          
        cursor.execute(sql)
#        print ". executed"
        count += 1


print "Placed  ",count," LgTF1 crystals."
print " "
print "--------------------------------------------"

db.close()
