#!/usr/bin/python
#
# Author: Maurik Holtrop and Ebrahim Ebrahim, UNH
# Version: 1.0
# Date: Jan 26, 2011
#
# Script to put the silicon tracker geometries in the database for the HPS
# experiment.
#
#
# NOTE: 
# Theta_x is the angle w.r.t the z-axis in the x direction, so it is a rotation around y by - the angle.
# Theta_y is the angle w.r.t the z-axis in the y direction, so it is a rotation around x by + the angle.
#
from math import *
import MySQLdb

TABLE_NAME="aprime_silicon"


# db=MySQLdb.connect("roentgen","maurik","","aprime_geometry");
db=MySQLdb.connect("localhost","maurik","","aprime_geometry");
cursor=db.cursor()

sql="DROP TABLE IF EXISTS "+TABLE_NAME
cursor.execute(sql)
sql="""CREATE TABLE """+TABLE_NAME+""" ( `name` varchar(40) DEFAULT NULL,
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


# The parameters below are used in the loop after to set the positions of the strips
# For the meaning of the parameters see the diagram on the ebrahim log, entry 10.05.25 
# https://nuclear.unh.edu:8080/Ebrahim/100526_101314/siliconbox.jpeg?lb=Ebrahim
# They are all in mm.
#
# The container, AnaMagnet, is the 1m long dipole magnet. 
# The target is at -45cm to the center of the anamagnet, so 5cm from the edge.
# The fist silicon should be at -35cm to the center of the anamagnet, or 10 cm from target.
# The stereo layers are 5mm from the non-stereo layers.
# The center of the silicon box is at +5cm to the center of anamagnet, otherwise the silicon box overlaps with the target.
a=-350.-100.-50.      # z distance offset for placement of SiDetectors. This is the location of the target. The locations of detectors are then relative to the target.
zt = 0                # Tweak for the z distance of the detectors. 

theta=.015	      # Dead Zone angle in radians. Sensitive area of detectors starts for larger angles.
dead_zone=1.	      # Inactive zone of sensors (mm), this is the edge of the sensor that is not sensitive.

Nsil = 12             # Total number of sensors.

locations=[100,105,200,205,300,305,500,505,700,705,900,905]  # Z-locations of the stips. Relative to TARGET.

c=range(Nsil)
d=range(Nsil)
e=range(Nsil)

#Nx=range(Nsil)
#Ny=range(Nsil)

strip_width =40.34
strip_height=100.
strip_active_width=38.34;
strip_active_height= 98.33;
strip_thick= 0.32

backing_thick_rohacell = 3.0
backing_thick_carbon = 0.3    # Carbon fiber and PGS Passivation are close enough, so double carbon fibre thickness. 
backing_gap = 0.2
# Enclosing Volume
#
# SiContainer  AnaMagnet Container for Silicon   0*cm +0.00*mm 5*cm  0.0*deg 0*deg 0*deg  f29618   Box  15.0*cm 15.0*cm   41.00*cm  Vacuum       no    1     1     1     1     0    no
sql="INSERT INTO "+ TABLE_NAME +" VALUES ('SiContainer','AnaMagnet','Container for Silicon','0.*cm 0.*cm 5.*cm','0*deg 0*deg 0*deg','f29618','Box','20.0*cm 12.0*cm 43.0*cm','Vacuum','no',1,1,1,1,0,'no','','',1,10000,now())"

cursor.execute(sql)


#
# Input the number of silicon devices in x and in y direction.
# According to Figure 4.3.4.1 of proposal Tracking section and table 4.3.4.1
#
# Bend Plane Sensors	4       4	6	10	14	18
# Stereo Sensors	2	2	4	10	14	18
#
Nx = [2,1,2,1,3,1,5,5,7,7,9,9] # number of sensors for one detector segment (up or down).
Ny = [1,1,1,1,1,2,1,1,1,1,1,1]

for i in range(Nsil/2):
#
# BACKING DIMENSIONS:
#
# Bend plane detectors oriented x=38.34 y=98.3 Active,  x= 40.34 y=100 Passive
# 
    c[i*2]=Nx[i*2]*strip_width  #  - (Nx[i*2]-1)*0.5 + 2	# strip width (xdim), overlaps are 0.5 mm in active. 2mm for dead zone.
    e[i*2]=Ny[i*2]*strip_height			        # strip height (ydim), y direction never stacked.
 
#
# Stereo plane detectors are rotated: x= 98.3, y=38.34 Active, x = 100, y =40.34 Passive. FOR FIRST 2, which are 90 degree stereo
#
    if i <3:
        c[i*2+1]=Nx[i*2+1]*strip_height   # - (Nx[i*2+1] -1)*0.5 + 1.7   # width
        e[i*2+1]=Ny[i*2+1]*strip_width  # -(Ny[i*2+1]-1)*0.5  + 2     # height

    else:
        c[i*2+1]=Nx[i*2+1]*strip_width  # - (Nx[i*2+1]-1)*0.5 + 2   # strip width (xdim), overlaps are 0.5 mm in active. 2mm for dead zone.
        e[i*2+1]=Ny[i*2+1]*strip_height + tan(50./1000.)*strip_width         # strip height (ydim), y direction never stacked.


#
# Positions
pos=[]   #  x,  y ,  z , SL, Type, Segment
for i in range(Nsil):
    if i%2 == 0:
        stype=1
    else:
        if i<6:
            stype=2
        else:
            stype=3

    segment = i +1        
    pos.append([0,
                .5*e[i]+tan(theta)*(zt+locations[i])-dead_zone,
                a+locations[i],
                int((i/2)+1), stype, segment ])



for i in range(len(pos)):
#
# Write the BACKING planes to DB
#  

  for top in ((1,'u',1),(-1,'d',2)):
    sql="INSERT INTO " + TABLE_NAME +" VALUES ("
    sql+= "'BackingR_"+str(i+1)+top[1]+"','SiContainer','Silicon Strip Detector Backing Rohacell"+str(i+1)+top[1]+"', "
    sql+="'"+str(pos[i][0])+"*mm " + str(top[0]*pos[i][1])+"*mm "+ str(pos[i][2]) +"*mm',"       # x,y,z position in mm
    sql+="'0*deg 0*deg 0deg','dddddd',"
    sql+="'Box','"+str(c[i]/2)+"*mm "+str(e[i]/2)+"*mm "+str(backing_thick_rohacell/2)+"*mm','Rohacell','no',1,1,1,1,1,'no','',"
    sql+="'',1,1000,now() )"
#    print sql
    cursor.execute(sql)

    sql="INSERT INTO " + TABLE_NAME +" VALUES ("
    sql+= "'BackingC_"+str(i+1)+top[1]+"','SiContainer','Silicon Strip Detector Backing Carbon Fibre"+str(i+1)+top[1]+"', "
    sql+="'"+str(pos[i][0])+"*mm " + str(top[0]*pos[i][1])+"*mm "+ str(pos[i][2]+(backing_thick_rohacell+backing_thick_carbon+backing_gap)/2) +"*mm',"       # x,y,z position in mm
    sql+="'0*deg 0*deg 0deg','ddddFF',"
    sql+="'Box','"+str(c[i]/2)+"*mm "+str(e[i]/2)+"*mm "+str(backing_thick_carbon/2)+"*mm','CarbonFiber','no',1,1,1,1,1,'no','',"
    sql+="'',1,1000,now() )"
#    print sql
    cursor.execute(sql)

#  print str(i)+" Pos: z="+str(pos[i][2])+"  SL="+str(pos[i][3])+"  Type="+str(pos[i][4])+"  Segm="+str(pos[i][5])+" Module="+str(top[2]) + " DIM: " + str(c[i]/2)+"*mm "+str(e[i]/2)+"*mm "+str(d[i]/2)+"*mm \n"


for i in range(len(pos)):
#
# Silicon Strips on the Backing...
#
  for top in ((1,'u',1),(-1,'d',2)):
    for nn in range(Nx[i]*Ny[i]):
        if nn%2 == 0:
            zdelta = -backing_thick_rohacell/2 - backing_gap;
        else:
            zdelta =  backing_thick_rohacell/2 + backing_thick_carbon+1.5*backing_gap;

        if pos[i][4]==1:   # Type 1, vertical oriented modules.
            xloc = pos[i][0] + ( (1-float(Nx[i]))/2 + nn)*strip_active_width;

            sql="INSERT INTO " + TABLE_NAME +" VALUES ("
            sql+= "'Silicon_"+str(i+1)+top[1]+str(nn)+"','SiContainer','Silicon Strip Detector"+str(i+1)+top[1]+"', "
            sql+="'"+str(xloc)+"*mm " + str(top[0]*pos[i][1])+"*mm "+ str(pos[i][2]+zdelta) +"*mm',"       # x,y,z position in mm
            sql+="'0*deg 0*deg 0deg','ff4444',"
            sql+="'Box','"+str(strip_width/2)+"*mm "+str(strip_height/2)+"*mm "+str(strip_thick/2)+"*mm','Silicium','no',1,1,1,1,1,'STR','STR',"
            sql+="'superlayer manual "+str(pos[i][3])
            sql+=" type manual " + str(pos[i][4]) + " segment manual "+ str(top[0]*pos[i][5])+ " module manual "+str(nn)+" strip manual 1',"
            sql+="1,1000,now() )"
    #    print sql
            cursor.execute(sql)

        if pos[i][4]==2:   # Type 2, horizontal oriented modules.
            xloc = pos[i][0];
            yloc = pos[i][1] + ( (1-float(Ny[i]))/2. + nn)* strip_active_width;

            sql="INSERT INTO " + TABLE_NAME +" VALUES ("
            sql+= "'Silicon_"+str(i+1)+top[1]+str(nn)+"','SiContainer','Silicon Strip Detector"+str(i+1)+top[1]+"', "
            sql+="'"+str(xloc)+"*mm " + str(top[0]*yloc)+"*mm "+ str(pos[i][2]+zdelta) +"*mm',"       # x,y,z position in mm
            sql+="'0*deg 0*deg 90*deg','ff4444',"
            sql+="'Box','"+str(strip_width/2)+"*mm "+str(strip_height/2)+"*mm "+str(strip_thick/2)+"*mm','Silicium','no',1,1,1,1,1,'STR','STR',"
            sql+="'superlayer manual "+str(pos[i][3])
            sql+=" type manual " + str(pos[i][4]) + " segment manual "+ str(top[0]*pos[i][5])+ " module manual "+str(nn)+" strip manual 1',"
            sql+="1,1000,now() )"
    #    print sql
            cursor.execute(sql)

        if pos[i][4]==3:   # Type 3, vertical STEREO oriented modules.
            xloc = pos[i][0] + ( (1-float(Nx[i]))/2 + nn)*strip_active_width;

            sql="INSERT INTO " + TABLE_NAME +" VALUES ("
            sql+= "'Silicon_"+str(i+1)+top[1]+str(nn)+"','SiContainer','Silicon Strip Detector"+str(i+1)+top[1]+"', "
            sql+="'"+str(xloc)+"*mm " + str(top[0]*pos[i][1])+"*mm "+ str(pos[i][2]+zdelta) +"*mm',"       # x,y,z position in mm
            sql+="'0*deg 0*deg 50*mrad','ff4444',"
            sql+="'Box','"+str(strip_width/2)+"*mm "+str(strip_height/2)+"*mm "+str(strip_thick/2)+"*mm','Silicium','no',1,1,1,1,1,'STR','STR',"
            sql+="'superlayer manual "+str(pos[i][3])
            sql+=" type manual " + str(pos[i][4]) + " segment manual "+ str(top[0]*pos[i][5])+ " module manual "+str(nn)+" strip manual 1',"
            sql+="1,1000,now() )"
    #    print sql
            cursor.execute(sql)


#
db.close()
