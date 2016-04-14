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

Ecal_Table = "aprime_ecal";

db=MySQLdb.connect("localhost","maurik","wakende","aprime_geometry");
#db=MySQLdb.connect("improv.unh.edu","maurik","","aprime_geometry");

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
flux=1    # Write flux detectors? 
#
# These are the main parameters that determine the geometry.
#
z_location_crystal_front = 1200;     # Location of the FRONT of the row 1 crystals.
y_offset =  15.                      # 15 mm opening in Y.
#
# Number of PbWO4 crystals in the y and x (1/2 front) direction.
#
max_y = 5 
max_x = 23
#
# Number of LeadGlass crystals in the y and x (1/2 front) direction.
#
LG_max_y = 3
LG_max_x = 8
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
Box_Half_depth = 210. # Size of the calorimeter box in the z-direction.
Box_Front_space = 60. # Space from front of box to start of crystals.
#
# Offsets - these define the gap between the 4 groups of crystals.
#

z_location = z_location_crystal_front + Box_Half_depth - Box_Front_space; # 1350  # Location of the CENTER of the calorimeter box. 
x_offset =  tolerance # front_half_width is added later to place the central crystals against each other fo offset=0
z_offset = -ff - (Box_Half_depth - Box_Front_space)  # This offset more or less centers the detector in the mother volume.
                                                     # Then z= -150 is the location of the front face of the PbWO4 counters relative to box center.

#
# Define the Aluminum vaccuum window and box.
#

airgap = 0.06           # 60 micron gap
depth = 380.
height = 230. - y_offset
al_thickness_front=10.
al_thickness = 10. - airgap
Material="Aluminum"
al_cut = 30.		#width of cut-out
al_thin = 1.
al_z_offset = -150. - 30.
al_x_l = -390.		#I changed this and the one below to 390, it was 380 before. -ebrahim
al_x_gap_l = -20.
al_x_gap_h = +140.  ## Changed from +70 for 2.2 GeV runs. Probably too big.
al_x_h = 390.
al_sd_y=230.		#sd means aluminum side support pieces:




#
# Placement of the IC volume determines the location of the ecal in the experiment.
# The front face of the ecal is at -150*mm so 1350*mm in z means that the front face is at 1200*mm in global coords.
# The AnaMagnet is at +450*mm, so it's pole face is at 450+500= 950*mm. The front face is then 25 cm from the ecal.  
# 
if flux:
  sql="INSERT INTO "+Ecal_Table +" VALUES ('IDtop','root','Particle Identifier','0*mm 115*mm 1110*mm','0*deg 0*deg 0*deg','ffff00','Box','40*cm 11*cm 1*mm','Vacuum','no',1,1,1,1,0,'FLUX','FLUX','id manual 5',1,10000,now())"
  cursor.execute(sql)
  sql="INSERT INTO "+Ecal_Table +" VALUES ('IDbot','root','Particle Identifier','0*mm -115*mm 1110*mm','0*deg 0*deg 0*deg','ffff00','Box','40*cm 11*cm 1*mm','Vacuum','no',1,1,1,1,0,'FLUX','FLUX','id manual 5',1,10000,now())"
  cursor.execute(sql)

print "insert IC";
sql="INSERT INTO "+Ecal_Table +" VALUES ('IC','root','Inner Calorimeter','0*mm 0*mm "+str(z_location)+"*mm','0*deg 0*deg 0*deg','ffff00','Box','400*mm 230*mm "+str(Box_Half_depth)+"*mm','Air','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)


sql="INSERT INTO "+Ecal_Table+" VALUES ('M0','root','Mark0','"
sql+= str(0)+"*mm "
sql+= str(0)+"*mm "
sql+= str(0)+"*mm','0*deg 0*deg 0*deg','000000','Box','1*mm 1*mm 1*mm','Air','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)
#
# Markers help orient you on the picture.
#
#sql="INSERT INTO  "+Ecal_Table+" VALUES ('M1','IC','Mark1','0*mm 0*mm 200*mm','0*deg 0*deg 0*deg','ff0000','Box','1*cm 1*cm 1*cm','Air','no',1,1,1,1,0,'no','','',1,10000,now())"
#cursor.execute(sql)
#sql="INSERT INTO  "+Ecal_Table+" VALUES ('M2','IC','Mark2','200*mm 0*mm 0*mm','0*deg 0*deg 0*deg','00ff00','Box','1*cm 1*cm 1*cm','Air','no',1,1,1,1,0,'no','','',1,10000,now())"
#cursor.execute(sql)
#sql="INSERT INTO  "+Ecal_Table+" VALUES ('M3','IC','Mark3','0*mm 200*mm 0*mm','0*deg 0*deg 0*deg','0000ff','Box','1*cm 1*cm 1*cm','Air','no',1,1,1,1,0,'no','','',1,10000,now())"
#cursor.execute(sql)
#


# Define Vacuum region:

sql="INSERT INTO "+Ecal_Table+" VALUES ('Vacu','IC','Vacuum region, main','"
sql+= str( (al_x_l+al_x_h)/2 )+"*mm "
sql+= str( 0 )+"*mm "
sql+= str( 0 )+"*mm','0*deg 0*deg 0*deg','ffff88','Box','"
sql+= str( abs(al_x_h - al_x_l)/2 )+"*mm "
sql+= str( abs(y_offset - airgap) )+"*mm 210*mm','Vacuum','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)

# sql="INSERT INTO "+Ecal_Table+" VALUES ('Vacu','IC','Vacuum region, main','"
# sql+= str( (al_x_l+al_x_h)/2 )+"*mm "
# sql+= str( 0 )+"*mm "
# sql+= str( 0 )+"*mm','0*deg 0*deg 0*deg','ffff88','Box','"
# sql+= str( abs(al_x_h - al_x_l)/2 )+"*mm "
# sql+= str( abs(y_offset - al_thickness - airgap) )+"*mm 210*mm','Vacuum','no',1,1,1,1,0,'no','','',1,10000,now())"
# cursor.execute(sql)

# sql="INSERT INTO "+Ecal_Table+" VALUES ('Vacu_top','IC','Vacuum region, insert','"
# sql+= str( (al_x_gap_l+al_x_gap_h)/2 )+"*mm "
# sql+= str( y_offset-(al_thickness - al_thin)/2 - al_thin - airgap )+"*mm "
# sql+= str( 0 )+"*mm','0*deg 0*deg 0*deg','ffff88','Box','"
# sql+= str( abs(al_x_gap_h-al_x_gap_l)/2 )+"*mm "
# sql+= str( abs(al_thickness - al_thin)/2)+"*mm 210*mm','Vacuum','no',1,1,1,1,0,'no','','',1,10000,now())"
# cursor.execute(sql)

# sql="INSERT INTO "+Ecal_Table+" VALUES ('Vacu_bottom','IC','Vacuum region, insert','"
# sql+= str( (al_x_gap_l+al_x_gap_h)/2 )+"*mm "
# sql+= str( -(y_offset-(al_thickness - al_thin)/2 - al_thin  - airgap) )+"*mm "
# sql+= str( 0 )+"*mm','0*deg 0*deg 0*deg','ffff88','Box','"
# sql+= str( abs(al_x_gap_h-al_x_gap_l)/2 )+"*mm "
# sql+= str( abs(al_thickness - al_thin)/2)+"*mm 210*mm','Vacuum','no',1,1,1,1,0,'no','','',1,10000,now())"
# cursor.execute(sql)

################### Top Windows
#BEGIN top left window
#Thin box part

sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_tl_box','Vacu','Top vacuum window left','"
sql+= str( (al_x_l+al_x_gap_l)/2 )+"*mm "
sql+= str(y_offset - airgap - al_thin/2)+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddee','Box','"
sql+= str( abs(al_x_gap_l - al_x_l)/2 )+"*mm "
sql+= str( al_thin/2 )+"*mm "
sql+= str(depth/2)+"*mm','"
sql+= Material+"','no',1,1,1,1,1,'no','','',1,10000,now())"

cursor.execute(sql)

#Trapezoid part
sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_tl_trap','Vacu','Top vacuum window left trapezoid','"
sql+= str( (al_x_l+al_x_gap_l)/2-al_cut/4)+"*mm "
sql+= str(y_offset- al_thickness/2 - airgap-al_thin/2 )+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddff','G4Trap','"
sql+= str(depth/2)+"*mm "
sql+= "0*mm "
sql+= "0*mm "
sql+= str( (al_thickness-al_thin)/2 )+"*mm "
sql+= str( (abs(al_x_gap_l - al_x_l)-al_cut)/2 )+"*mm "
sql+= str( abs(al_x_gap_l - al_x_l)/2 )+"*mm "
sql+= str(math.atan(al_cut/(2*(al_thickness-al_thin))))+"*mm "
sql+= str( (al_thickness-al_thin)/2 )+"*mm "
sql+= str( (abs(al_x_gap_l - al_x_l)-al_cut)/2 )+"*mm "
sql+= str( abs(al_x_gap_l - al_x_l)/2 )+"*mm "
sql+= str(math.atan(al_cut/(2*(al_thickness-al_thin))))+"*mm','"
sql+= Material+"','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)
#END top left window

## Vacuum support block

sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_support','Vacu','Top vacuum window left','"
sql+= str( al_x_gap_l - al_thickness/2 - al_cut )+"*mm "
sql+= str( 0 )+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddff','Box','"
sql+= str( al_thickness/2)+"*mm "
sql+= str( y_offset - al_thickness - airgap )+"*mm "
sql+= str(depth/2)+"*mm','"
sql+= Material+"','no',1,1,1,1,1,'no','','',1,10000,now())"

cursor.execute(sql)

## Air on e+ side


sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_air','Vacu','Top vacuum window left','"
sql+= str( (al_x_l +  al_x_gap_l - al_thickness - al_cut) /2 )+"*mm "
sql+= str( 0 )+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ff9999','Box','"
sql+= str( abs(al_x_l  -  al_x_gap_l + al_thickness + al_cut)/2)+"*mm "
sql+= str( y_offset - al_thickness - airgap )+"*mm "
sql+= str(depth/2)+"*mm','Air','no',1,1,1,1,0,'no','','',1,10000,now())"

cursor.execute(sql)



#BEGIN top middle thin window
sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_tm','Vacu','Top vacuum window thin center','"
sql+= str( (al_x_gap_l+al_x_gap_h)/2 )+"*mm "
sql+= str(y_offset-al_thin/2-airgap)+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddee','Box','"
sql+= str( abs(al_x_gap_h - al_x_gap_l)/2)+"*mm "
sql+= str( al_thin/2 )+"*mm "
sql+= str(depth/2)+"*mm','"
sql+= Material+"','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)
#END top middle thin window

#BEGIN top right window
#Thin box part
sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_tr_box','Vacu','Top vacuum window right','"
sql+= str( (al_x_h+al_x_gap_h)/2 )+"*mm "
sql+= str(y_offset - airgap - al_thin/2)+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddee','Box','"

sql+= str( abs(al_x_gap_h - al_x_h)/2 )+"*mm "
sql+= str( al_thin/2 )+"*mm "
sql+= str(depth/2)+"*mm','"
sql+= Material+"','no',1,1,1,1,1,'no','','',1,10000,now())"

cursor.execute(sql)

#Trapezoid part
sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_tr_trap','Vacu','Top vacuum window right','"
sql+= str( (al_x_h+al_x_gap_h)/2+al_cut/4)+"*mm "
sql+= str(y_offset- al_thickness/2 - airgap-al_thin/2 )+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddff','G4Trap','"
sql+= str(depth/2)+"*mm "
sql+= "0*mm "
sql+= "0*mm "
sql+= str( (al_thickness-al_thin)/2 )+"*mm "
sql+= str( (abs(al_x_gap_h - al_x_h)-al_cut)/2 )+"*mm "
sql+= str( abs(al_x_gap_h - al_x_h)/2 )+"*mm "
sql+= str(-math.atan(al_cut/(2*(al_thickness-al_thin))))+"*mm "
sql+= str( (al_thickness-al_thin)/2 )+"*mm "
sql+= str( (abs(al_x_gap_h - al_x_h)-al_cut)/2 )+"*mm "
sql+= str( abs(al_x_gap_h - al_x_h)/2 )+"*mm "
sql+= str(-math.atan(al_cut/(2*(al_thickness-al_thin))))+"*mm', '"
sql+= Material+"','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)
#END top right window


################### Bottom Windows.

#BEGIN bottom left window
#Thin box part
sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_bl_box','Vacu','Bottom vacuum window left','"
sql+= str( (al_x_l+al_x_gap_l)/2 )+"*mm "
sql+= str(-(y_offset - airgap - al_thin/2))+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddee','Box','"

sql+= str( abs(al_x_gap_l - al_x_l)/2 )+"*mm "
sql+= str( al_thin/2 )+"*mm "
sql+= str(depth/2)+"*mm','"
sql+= Material+"','no',1,1,1,1,1,'no','','',1,10000,now())"

cursor.execute(sql)

#Trapezoid part
sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_bl_trap','Vacu','Bottom vacuum window left','"
sql+= str( (al_x_l+al_x_gap_l)/2-al_cut/4)+"*mm "
sql+= str(-(y_offset- al_thickness/2 - airgap-al_thin/2) )+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddee','G4Trap','"

sql+= str(depth/2)+"*mm "
sql+= "0*mm "
sql+= "0*mm "
sql+= str( (al_thickness-al_thin)/2 )+"*mm "
sql+= str( abs(al_x_gap_l - al_x_l)/2 )+"*mm "
sql+= str( (abs(al_x_gap_l - al_x_l)-al_cut)/2 )+"*mm "
sql+= str(-math.atan(al_cut/(2*(al_thickness-al_thin))))+"*mm "
sql+= str( (al_thickness-al_thin)/2 )+"*mm "
sql+= str( abs(al_x_gap_l - al_x_l)/2 )+"*mm "
sql+= str( (abs(al_x_gap_l - al_x_l)-al_cut)/2 )+"*mm "
sql+= str(-math.atan(al_cut/(2*(al_thickness-al_thin))))+"*mm', '"
sql+= Material+"','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)
#END bottom left window



#BEGIN bottom middle thin window
sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_bm','Vacu','Bottom vacuum window thin center','"
sql+= str( (al_x_gap_l+al_x_gap_h)/2 )+"*mm "
sql+= str( -(y_offset-al_thin/2-airgap))+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddee','Box','"
sql+= str( abs(al_x_gap_h - al_x_gap_l)/2)+"*mm "
sql+= str( al_thin/2 )+"*mm "
sql+= str(depth/2)+"*mm','"
sql+= Material+"','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)
#END bottom middle thin window

#BEGIN bottom right window
#Thin box part
sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_br_box','Vacu','Bottom vacuum window right','"
sql+= str( (al_x_h+al_x_gap_h)/2 )+"*mm "
sql+= str(-(y_offset - airgap - al_thin/2))+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddee','Box','"

sql+= str( abs(al_x_gap_h - al_x_h)/2 )+"*mm "
sql+= str( al_thin/2 )+"*mm "
sql+= str(depth/2)+"*mm','"
sql+= Material+"','no',1,1,1,1,1,'no','','',1,10000,now())"

cursor.execute(sql)

#Trapezoid part
sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_br_trap','Vacu','Bottom vacuum window right','"
sql+= str( (al_x_h+al_x_gap_h)/2+al_cut/4)+"*mm "
sql+= str(-(y_offset- al_thickness/2 - airgap-al_thin/2) )+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddff','G4Trap','"
sql+= str(depth/2)+"*mm "
sql+= "0*mm "
sql+= "0*mm "
sql+= str( (al_thickness-al_thin)/2 )+"*mm "
sql+= str( abs(al_x_gap_h - al_x_h)/2 )+"*mm "
sql+= str( (abs(al_x_gap_h - al_x_h)-al_cut)/2 )+"*mm "
sql+= str(math.atan(al_cut/(2*(al_thickness-al_thin))))+"*mm "
sql+= str( (al_thickness-al_thin)/2 )+"*mm "
sql+= str( abs(al_x_gap_h - al_x_h)/2 )+"*mm "
sql+= str( (abs(al_x_gap_h - al_x_h)-al_cut)/2 )+"*mm "
sql+= str(math.atan(al_cut/(2*(al_thickness-al_thin))))+"*mm', '"
sql+= Material+"','no',1,1,1,1,1,'no','','',1,10000,now())"
cursor.execute(sql)
#END bottom right window


################### Front Window

sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_tf','IC','Top Front vacuum window','"
sql+= str( (al_x_l+al_x_h)/2 )+"*mm "
sql+= str(y_offset + height/2)+"*mm "
sql+= str(al_z_offset + al_thickness_front/2 )+"*mm','0*deg 0*deg 0*deg','ddddee','Box','"
sql+= str( abs(al_x_h - al_x_l)/2 )+"*mm "
sql+= str( height/2 )+"*mm "
sql+= str( al_thickness_front/2 )+"*mm','Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"

cursor.execute(sql)


sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_bf','IC','Top Front vacuum window','"
sql+= str( (al_x_l+al_x_h)/2 )+"*mm "
sql+= str( -(y_offset + height/2))+"*mm "
sql+= str(al_z_offset + al_thickness/2 )+"*mm','0*deg 0*deg 0*deg','ddddee','Box','"
sql+= str( abs(al_x_h - al_x_l)/2 )+"*mm "
sql+= str( height/2 )+"*mm "
sql+= str( al_thickness_front/2 )+"*mm','Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"

cursor.execute(sql)

#Side support pieces

#left box
sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_side_tl','IC','Vacuum window side support left','"
sql+= str( al_x_l-al_thickness/2 )+"*mm "
#sql+= str(y_offset - airgap +al_sd_height/2)+"*mm "
sql+= str(0)+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddee','Box','"
sql+= str( al_thickness/2 )+"*mm "
sql+= str( al_sd_y )+"*mm "
sql+= str(depth/2)+"*mm','Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"

cursor.execute(sql)


#right box
sql="INSERT INTO "+Ecal_Table+" VALUES ('VacW_side_tr','IC','Vacuum window side support right','"
sql+= str( al_x_h+al_thickness/2 )+"*mm "
sql+= str(0)+"*mm "
sql+= str(al_z_offset + depth/2)+"*mm','0*deg 0*deg 0*deg','ddddee','Box','"
sql+= str( al_thickness/2 )+"*mm "
sql+= str( al_sd_y )+"*mm "
sql+= str(depth/2)+"*mm','Aluminum','no',1,1,1,1,0,'no','','',1,10000,now())"

cursor.execute(sql)



# sql="INSERT INTO "+Ecal_Table+" VALUES ('M3','IC','Mark3','"
# sql+= str(x_offset)+"*mm "
# sql+= str(y_offset)+"*mm "
# sql+= str(-150)+"*mm','0*deg 0*deg 0*deg','ff0000','Box','2*mm 2*mm 2*mm','Air','no',1,1,1,1,1,'no','','',1,10000,now())"
# cursor.execute(sql)

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
        pos_x = xsign*(x_offset + xcent_shift)  +  xsign*( mid*math.sin(nx*2*theta)  + xshift )

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
print "max_x: ",max_x, "  theta_x= ", theta_x, " pos_x=", pos_x, " xshift=", xshift
print "max_y: ",max_y, "  theta_y= ", theta_y, " pos_y=", pos_y, " yshift=", yshift

theta_x_offset = 0 # math.atan(x_offset/ff)    
theta_y_offset = theta_y + theta  # math.atan( (y_offset/ff)  
# theta_y_offset = theta_y_offset + max_y*2*theta 
#
x_point = x_offset
y_point = pos_y - half_length*math.sin(theta_y) + front_half_width + inter_layer_space
z_point = z_offset + ff

print "Mark1 at: (",x_point,",",y_point,",",z_point,") "

# sql="INSERT INTO  "+Ecal_Table+" VALUES ('M1','IC','Mark1','"
# sql+= str(x_point)+"*mm "
# sql+= str(y_point)+"*mm "
# sql+= str(z_point)+"*mm','0*deg 0*deg 0*deg','000000','Box','1*mm 1*mm 1*mm','Air','no',1,1,1,1,1,'no','','',1,10000,now())"
# cursor.execute(sql)
#
# Point 2 is the opposite end at the larges x corner.
#
x2_point = x_offset + max_x*(2*front_half_width + tolerance)
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
