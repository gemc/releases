#!/usr/bin/python
#
# Authors: Ebrahim Ebrahim & Maurik Holtrop (UNH)  Jan 2, 2011
#
import math
import MySQLdb

# Version of the muon detector with segmented hodoscopes.
# These are the variables you should adjust to your liking (all in cm or radians):
# (and don't forget to put a . in floating pt vars!!)
# Please also look at the diagram that goes with these

Table      = "aprime_muon";     #name of the table
Flux_Table = "aprime_muon";     #name of table with Flux detectors. Must be same as muon table. 
flux=1	#do you want the flux detectors? (0 or 1)
flux_width=.2	#thickness of the flux detectors

db=MySQLdb.connect("roentgen.unh.edu","maurik","","aprime_geometry");
#db=MySQLdb.connect("roentgen.unh.edu","ebrahim","","ebrahim");
#db=MySQLdb.connect("localhost","maurik","","aprime_geometry");


vertseg_gap=.01;  # cm How far apart the strips of hodoscoopes should be from each other
vertseg_num= 8;	  # How many vertical segments for the FIRST hodoscope
vertseg_size= 3.; # cm Vertical size.
from_target=200. #how far from target is front face, in cm. adjust this to move the whole detector in z

depth=[6.8,6.8,6.8,6.8,15.,15.,15.]	#list of depths of the iron absorbers in cm (these are not half-depths)
gap=[.2,.2,.2,.2,.2,.2,.2]	#list of gap widths between the iron absorbers and the hodoscopes
hodz=1.	# cm hodoscope width (not half)

theta1=.025	#fan out angle in y of the middle part
#
# The fan out angle determines the vertical size of the detector. In this case, we calculate it by fitting a certain number of hodoscopes 
# for the first readout layer.
#
theta2=math.atan( (vertseg_num*vertseg_size+(vertseg_num-1)*vertseg_gap+(from_target+depth[0]+gap[0])*math.tan(theta1) )/
		  (from_target+depth[0]+gap[0]))	#fan out angle in y of the outer part
theta3=math.atan(50./(from_target))	#fan out angle in x


fan_out=1	#do you want the connecting iron piece to be 30 cm wide the whole way through, or fan out? (0 or 1)
#note: the aluminum plates for the vacuum system will not correct themselves if you set this to 1, I assumed we do not want fanning out
connecting_width=40.	#if you picked fan_out=0 use this to set how far in the connecting iron piece goes
theta4=5./180.*math.pi # math.atan(10./(from_target))	#if you picked fan_out=1 use this to set the angle

alum_plate_width=1. #width of the aluminum plate
alum_side_width=1.	#width of the side wall of the vac system
alum_airgap= 0.01	#how much room (in y and x) do you want between the aluminum plate and the iron chunks (in cm)
al_extra1= 35.	#see diagram
al_extra2=20.	#see diagram
al_extra3= from_target-156.	#see diagram

vac_pullz=al_extra3	#how far to extend the vacuum (-z) towards ecal
vac_pushz=al_extra1	#how far to extend the vacuum (+z) beyond muon detector
#Here is how the 156 above was chosen (in case I need to change it):
#mysql -u clasuser -h improv.unh.edu -e "select name, mother, material, pos, dimensions from aprime_geometry.aprime_ecal_new3 where mother='root' or material='Vacuum'"
#run the above command then calculate the global z coord of the end of the ecal's vacuum region


#CREATE TABLE:

cursor=db.cursor()
sql="DROP TABLE IF EXISTS "+Table
cursor.execute(sql)
sql="""CREATE TABLE `"""+Table+"""` ( `name` varchar(40) DEFAULT NULL,
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


#just some useful quantities for later use:
MD_depth=sum(depth)+2*sum(gap)-gap[len(gap)-1]+len(depth)*hodz #the length of the the whole detector (actually the distance from the front of the first iron piece to the back of the last hodoscope piece)
muon_box_z=from_target+.5*MD_depth - .5*max(vac_pullz,al_extra3)+.5*max(vac_pushz,al_extra1); #the z position of the mother box of the whole detector, in the root coordinate system (does not affect actual detector positioning)
MD_mid=from_target-muon_box_z+.5*MD_depth #in the MD coord system, the z pos of the middle of the whole detector
z=from_target-muon_box_z+depth[0]/2 #in the MD coord system, the z pos of the middle of the first iron absorber (to be incremented in upcoming loop)
theta=.5*(theta1+theta2) #the average of theta1 and theta2
tt1=math.tan(theta1) #the tangent of theta1
tt2=math.tan(theta2) #the tangent of theta2
tt3=math.tan(theta3) #the tangent of theta3
tt4=math.tan(theta4) #the tangent of theta4
tt34=math.tan( (theta3+theta4)/2 )  
tt=math.tan(theta) #the tangent of the average


#placement of the muon detector volume.
#this really just places the mother box around the detector, moving it is not the proper way to move the whole detector
#in this script, if you want to move the whole detector, change the variable from_target, defined above
#the mother volume will automatically wrap itself around whatever size detector you make with 1 cm extra all around except in z
sql="INSERT INTO "+Table +" VALUES ('MD','root','Muon Detector','"
sql+=str( 0 )+"*cm 0*cm "+str( muon_box_z )
sql+="*cm','0*deg 0*deg 0*deg','ffff00','Box','"
sql+=str( max((from_target+MD_depth+al_extra1)*tt3+al_extra2,(from_target+MD_depth+vac_pushz)*tt3)+2. )+"*cm "+str( (from_target+MD_depth)*tt2+2. )+"*cm "+str(.5*MD_depth+.5*max(al_extra1,vac_pushz)+.5*max(al_extra3,vac_pullz))+"*cm','Air','no',1,1,1,1,0,'no','','',1,10000,now())"
cursor.execute(sql)


#BEGIN LOOP FOR DRAWING MD:

for i in range(len(depth)):

	gz= z+muon_box_z #global z (distance from target in cm)

	#INSERT TOP IRON ABSORBER:

	sql="INSERT INTO "+Table+" VALUES ('MD_top_iron_"+str(i)+"','MD','Top iron absorber number "+str(i)+"','"
	sql+= str( 0 )+"*cm "
	sql+= str( gz*tt )+"*cm "
	sql+= str( z )+"*cm','0*deg 0*deg 90*deg','888899','G4Trap','"	#90 or 270 deg?
	
	sql+= str( depth[i]/2 )+"*cm "
	sql+= str( -theta )+"*rad "
	sql+= str( 0 )+"*deg "
	sql+= str( (gz-depth[i]/2)*tt3 )+"*cm "
	sql+= str( .5*(gz-depth[i]/2)*(tt2-tt1) )+"*cm "
	sql+= str( .5*(gz-depth[i]/2)*(tt2-tt1) )+"*cm "
	sql+= str( 0 )+"*deg "
	sql+= str( (gz+depth[i]/2)*tt3 )+"*cm "	#or 57?
	sql+= str( .5*(gz+depth[i]/2)*(tt2-tt1) )+"*cm "
	sql+= str( .5*(gz+depth[i]/2)*(tt2-tt1) )+"*cm "
	sql+= str( 0 )+"*deg', "
	
	sql+= "'Iron','no',1,1,1,1,1,'no','','',1,10000,now())"
	cursor.execute(sql)

	
	#INSERT BOTTOM IRON ABSORBER:

	sql="INSERT INTO "+Table+" VALUES ('MD_bot_iron_"+str(i)+"','MD','Bottom iron absorber number "+str(i)+"','"
	sql+= str( 0 )+"*cm "
	sql+= str( -gz*tt )+"*cm "
	sql+= str( z )+"*cm','0*deg 0*deg 90*deg','888899','G4Trap','"
	
	sql+= str( depth[i]/2 )+"*cm "
	sql+= str( theta )+"*rad "
	sql+= str( 0 )+"*deg "
	sql+= str( (gz-depth[i]/2)*tt3 )+"*cm "
	sql+= str( .5*(gz-depth[i]/2)*(tt2-tt1) )+"*cm "
	sql+= str( .5*(gz-depth[i]/2)*(tt2-tt1) )+"*cm "
	sql+= str( 0 )+"*deg "
	sql+= str( (gz+depth[i]/2)*tt3 )+"*cm "	
	sql+= str( .5*(gz+depth[i]/2)*(tt2-tt1) )+"*cm "
	sql+= str( .5*(gz+depth[i]/2)*(tt2-tt1) )+"*cm "
	sql+= str( 0 )+"*deg', "
	
	sql+= "'Iron','no',1,1,1,1,1,'no','','',1,10000,now())"
	cursor.execute(sql)


	#INSERT TOP HODOSCOPES:

	y=.5*(gz+depth[i]/2)*tt2+.5*(gz+depth[i]/2+gap[i]+hodz)*tt1
	L=(gz+depth[i]/2)*(tt2-tt1)-(gap[i]+hodz)*tt1
	
	vertseg_num = int( (L + vertseg_gap) / (vertseg_size + vertseg_gap ) +0.2)

#	vertseg_size = (L + vertseg_gap - float(vertseg_num)*vertseg_gap)/float(vertseg_num)

	for j in range(vertseg_num):

		sql="INSERT INTO "+Table+" VALUES ('MD_hodo_"+str(i)+"_"+str(j+1)+"','MD','Hodoscope segment ("+str(i)+","+str(j+1)+")','"
		sql+= str( 0 )+"*cm "
		sql+= str( vertseg_size/2-L/2+y+j*(vertseg_size+vertseg_gap) )+"*cm "	#see notebook page 78 for explanation
		sql+= str( z+depth[i]/2+gap[i]+hodz/2 )+"*cm','0*deg 0*deg 0*deg','cc4444','Box','"

		sql+= str( (gz+depth[i]/2)*tt3 )+"*cm "
		sql+= str( vertseg_size/2 )+"*cm "  #see notebook page 78 for explanation
		sql+= str( hodz/2 )+"*cm',"
	
		sql+="'Scintillator','no',1,1,1,1,1,'HS','HS','ih manual "+str(i)+" iv manual "+str(j+1)+"',1,1000000,now())"
		cursor.execute(sql)


	#INSERT BOTTOM HODOSCOPES:

	for j in range(vertseg_num):

		sql="INSERT INTO "+Table+" VALUES ('MD_hodo_"+str(i)+"_"+str(-j-1)+"','MD','Hodoscope segment ("+str(i)+","+str(-j-1)+")','"
		sql+= str( 0 )+"*cm "
		sql+= str( -(vertseg_size/2-L/2+y+j*(vertseg_size+vertseg_gap)) )+"*cm "	#the negative of the top hodoscope value
		sql+= str( z+depth[i]/2+gap[i]+hodz/2 )+"*cm','0*deg 0*deg 0*deg','cc4444','Box','"

		sql+= str( (gz+depth[i]/2)*tt3 )+"*cm "
		sql+= str( vertseg_size/2 )+"*cm "  #see notebook page 78 for explanation
		sql+= str( hodz/2 )+"*cm',"
	
		sql+="'Scintillator','no',1,1,1,1,1,'HS','HS','ih manual "+str(i)+" iv manual "+str(-j-1)+"',1,1000000,now())"
		cursor.execute(sql)



	#INSERT CONNECTING IRON PIECE:

	if fan_out==0:
		sql="INSERT INTO "+Table+" VALUES ('MD_con_iron_"+str(i)+"','MD','Connecting iron number "+str(i)+"','"
		sql+= str( -(gz*tt3-connecting_width/2) )+"*cm "
		sql+= str( 0 )+"*cm "
		sql+= str( z )+"*cm','0*deg 0*deg 0*deg','8888FF','G4Trap','"
	
		sql+= str( depth[i]/2 )+"*cm "    # Dz     = Half length z
		sql+= str( -theta3 )+"*rad "      # pTheta = Polar angle of the line joining the centres of the faces at -/+pDz
		sql+= str( 0 )+"*deg "            # pPhi   = Azimuthal angle of ...
		sql+= str( gz*tt1 )+"*cm "         # pDy1   = Half-length along y of the face at -pDz
		sql+= str( connecting_width/2 )+"*cm " # pDx1    Half-length along x of the side at y=-pDy1 of the face at -pDz
		sql+= str( connecting_width/2 )+"*cm " # pDx2    Half-length along x of the side at y=+pDy1 of the face at -pDz
		sql+= str( 0 )+"*deg "            # pAlp1   Angle with respect to the y axis from the centre of the side at y=-pDy1 to the centre at y=+pDy1 of the face at -pDz
		sql+= str( gz*tt1 )+"*cm "	  # pDy2    Half-length along y of the face at +pDz
		sql+= str( connecting_width/2 )+"*cm " # pDx3    Half-length along x of the side at y=-pDy2 of the face at +pDz
		sql+= str( connecting_width/2 )+"*cm " # pDx4    Half-length along x of the side at y=+pDy2 of the face at +pDz
		sql+= str( 0 )+"*deg', "          # pAlp2   Angle with respect to the y axis from the centre of the side at y=-pDy2 to the centre at y=+pDy2 of the face at +pDz
		
		sql+= "'Iron','no',1,1,1,1,1,'no','','',1,10000,now())"
		cursor.execute(sql)


	if fan_out==1:
		sql="INSERT INTO "+Table+" VALUES ('MD_con_iron_"+str(i)+"','MD','Connecting iron number "+str(i)+"','"
		sql+= str( -.5*gz*(tt3+tt4) )+"*cm "
		sql+= str( 0 )+"*cm "
		sql+= str( z )+"*cm','0*deg 0*deg 0*deg','8888FF','G4Trap','"
	
		sql+= str( depth[i]/2 )+"*cm "
		sql+= str( -.5*(theta3+theta4) )+"*rad "
		sql+= str( 0 )+"*deg "
		sql+= str( gz*tt1 )+"*cm "
		sql+= str( .5*(gz-depth[i]/2)*(tt3-tt4) )+"*cm "
		sql+= str( .5*(gz-depth[i]/2)*(tt3-tt4) )+"*cm "
		sql+= str( 0 )+"*deg "
		sql+= str( gz*tt1 )+"*cm "	
		sql+= str( .5*(gz+depth[i]/2)*(tt3-tt4) )+"*cm "
		sql+= str( .5*(gz+depth[i]/2)*(tt3-tt4) )+"*cm "
		sql+= str( 0 )+"*deg', "
		
		sql+= "'Iron','no',1,1,1,1,1,'no','','',1,10000,now())"
		cursor.execute(sql)

	#INCREMENT z TO MIDDLE OF NEXT IRON ABSORBER:

	if i!=(len(depth)-1):
		z = z + .5*depth[i] + .5*depth[i+1] + 2*gap[i] + hodz


#INSERT TOP ALUMINUM PLATE:

if fan_out == 0:
	sql="INSERT INTO "+Table+" VALUES ('MD_top_alum','MD','Top aluminum plate','"
	sql+= str( .5*connecting_width+.5*alum_airgap+.5*al_extra2 )+"*cm "
	sql+= str( (from_target+.5*MD_depth+.5*(al_extra1-al_extra3))*tt1-.5*alum_plate_width-alum_airgap )+"*cm "
	sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','0*deg 0*deg 90*deg','ddddee','G4Trap','"
	
	sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
	sql+= str( -theta1 )+"*rad "
	sql+= str( 0 )+"*deg "
	sql+= str( (from_target-al_extra3)*tt3-.5*connecting_width-.5*alum_airgap+.5*al_extra2 )+"*cm "
	sql+= str( alum_plate_width/2 )+"*cm "
	sql+= str( alum_plate_width/2 )+"*cm "
	sql+= str( 0 )+"*deg "
	sql+= str( (from_target+MD_depth+al_extra1)*tt3-.5*connecting_width-.5*alum_airgap+.5*al_extra2 )+"*cm "	
	sql+= str( alum_plate_width/2 )+"*cm "
	sql+= str( alum_plate_width/2 )+"*cm "
	sql+= str( 0 )+"*deg', "
	
	sql+= "'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
	cursor.execute(sql)
	
	
#INSERT BOTTOM ALUMINUM PLATE:
	
	sql="INSERT INTO "+Table+" VALUES ('MD_bot_alum','MD','Bottom aluminum plate','"
	sql+= str( .5*connecting_width+.5*alum_airgap+.5*al_extra2 )+"*cm "
	sql+= str( -((from_target+.5*MD_depth+.5*(al_extra1-al_extra3))*tt1-.5*alum_plate_width-alum_airgap) )+"*cm "
	sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','0*deg 0*deg 90*deg','ddddee','G4Trap','"
	
	sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
	sql+= str( theta1 )+"*rad "
	sql+= str( 0 )+"*deg "
	sql+= str( (from_target-al_extra3)*tt3-.5*connecting_width-.5*alum_airgap+.5*al_extra2 )+"*cm "
	sql+= str( alum_plate_width/2 )+"*cm "
	sql+= str( alum_plate_width/2 )+"*cm "
	sql+= str( 0 )+"*deg "
	sql+= str( (from_target+MD_depth+al_extra1)*tt3-.5*connecting_width-.5*alum_airgap+.5*al_extra2 )+"*cm "	
	sql+= str( alum_plate_width/2 )+"*cm "
	sql+= str( alum_plate_width/2 )+"*cm "
	sql+= str( 0 )+"*deg', "
	
	sql+= "'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
	cursor.execute(sql)
	
	
	
#INSERT OUTER SIDE ALUMINUM PLATE:
	
	sql="INSERT INTO "+Table+" VALUES ('MD_side_alum','MD','Outer side aluminum plate','"
	sql+= str( (from_target+MD_depth/2+.5*(al_extra1-al_extra3))*tt3+al_extra2-.5*alum_side_width )+"*cm "
	sql+= str( 0 )+"*cm "
	sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','0*deg 0*deg 0*deg','ddddee','G4Trap','"
	
	sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
	sql+= str( theta3 )+"*rad "
	sql+= str( 0 )+"*deg "
	sql+= str( (from_target-al_extra3)*tt1-alum_airgap )+"*cm "
	sql+= str( alum_side_width/2 )+"*cm "
	sql+= str( alum_side_width/2 )+"*cm "
	sql+= str( 0 )+"*deg "
	sql+= str( (from_target+MD_depth+al_extra1)*tt1-alum_airgap )+"*cm "
	sql+= str( alum_side_width/2 )+"*cm "
	sql+= str( alum_side_width/2 )+"*cm "
	sql+= str( 0 )+"*deg', "
	
	sql+= "'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
	cursor.execute(sql)
	
	
#INSERT INNER SIDE ALUMINUM PLATE:
	
	sql="INSERT INTO "+Table+" VALUES ('MD_side_alum_near_conn','MD','Inner side aluminum plate','"
	sql+= str( -(from_target+MD_depth/2+.5*(al_extra1-al_extra3))*tt3+.5*alum_side_width  +  connecting_width + alum_airgap )+"*cm "
	sql+= str( 0 )+"*cm "
	sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','0*deg 0*deg 0*deg','ddddee','G4Trap','"
	
	sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
	sql+= str( -theta3 )+"*rad "
	sql+= str( 0 )+"*deg "
	sql+= str( (from_target-al_extra3)*tt1-alum_airgap )+"*cm "
	sql+= str( alum_side_width/2 )+"*cm "
	sql+= str( alum_side_width/2 )+"*cm "
	sql+= str( 0 )+"*deg "
	sql+= str( (from_target+MD_depth+al_extra1)*tt1-alum_airgap )+"*cm "
	sql+= str( alum_side_width/2 )+"*cm "
	sql+= str( alum_side_width/2 )+"*cm "
	sql+= str( 0 )+"*deg', "
	
	sql+= "'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
	cursor.execute(sql)
	
	
#INSERT VACUUM REGION IN BETWEEN:
	
	sql="INSERT INTO "+Table+" VALUES ('MD_vac','MD','Vacuum region in Muon Detector','"
	sql+= str( .5*connecting_width + .5*al_extra2+.5*alum_airgap )+"*cm "
	sql+= str( 0 )+"*cm "
	sql+= str( MD_mid-vac_pullz/2+vac_pushz/2 )+"*cm','0*deg 0*deg 0*deg','ffffff','G4Trap','"
	
	sql+= str( MD_depth/2+vac_pullz/2+vac_pushz/2 )+"*cm "
	sql+= str( 0 )+"*rad "
	sql+= str( 0 )+"*deg "
	sql+= str( (from_target-vac_pullz)*tt1-alum_airgap-alum_plate_width )+"*cm " 
	sql+= str( (from_target-vac_pullz)*tt3-.5*connecting_width-alum_side_width-.5*alum_airgap+.5*al_extra2 )+"*cm "
	sql+= str( (from_target-vac_pullz)*tt3-.5*connecting_width-alum_side_width-.5*alum_airgap+.5*al_extra2 )+"*cm "
	sql+= str( 0 )+"*deg "
	sql+= str( (from_target+MD_depth+vac_pushz)*tt1-alum_airgap-alum_plate_width )+"*cm "	
	sql+= str( (from_target+MD_depth+vac_pushz)*tt3-.5*connecting_width-alum_side_width-.5*alum_airgap+.5*al_extra2 )+"*cm "
	sql+= str( (from_target+MD_depth+vac_pushz)*tt3-.5*connecting_width-alum_side_width-.5*alum_airgap+.5*al_extra2 )+"*cm "
	sql+= str( 0 )+"*deg', "
	
	sql+= "'Vacuum','no',1,1,1,1,0,'no','','',1,10000,now())"
	cursor.execute(sql)

#------FLUX DETECTORS-------

	if flux==1:

	#INSERT FLUX DETECTOR ON TOP ALUMINUM PLATE:

           sql="DELETE from "+Flux_Table+" where name='muonfluxtop'"
	   cursor.execute(sql)
	   
	   sql="INSERT INTO "+Flux_Table+" VALUES ('muonfluxtop','MD_top_alum','flux detector on top aluminum plate','"
	   #	sql+= str( .5*connecting_width+.5*alum_airgap+.5*al_extra2 )+"*cm "
	   #	sql+= str( (from_target+.5*MD_depth)*tt1-alum_plate_width-alum_airgap+flux_width/2 )+"*cm " 
	   #	sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+
	   print "alum_plate_width: "+str(alum_plate_width)+"\n"
	   sql+= str( -(alum_plate_width-flux_width)/2)+"*cm 0*cm 0*cm','0*deg 0*deg 0*deg','ffaa00','G4Trap','"   # Rotation of mother means move in -x not y.
	   sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
	   sql+= str( -theta1 )+"*rad "
	   sql+= str( 0 )+"*deg "
	   sql+= str( (from_target-al_extra3)*tt3-.5*connecting_width-.5*alum_airgap+.5*al_extra2 )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( 0 )+"*deg "
	   sql+= str( (from_target+MD_depth+al_extra1)*tt3-.5*connecting_width-.5*alum_airgap+.5*al_extra2 )+"*cm "	
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( 0 )+"*deg', "
	   
	   sql+= "'Aluminum','no',1,1,1,1,0,'FLUX','FLUX','id manual 10',1,1000,now())" #make sure material here is the same as the material of the plate
	   cursor.execute(sql)
	   
	#INSERT FLUX DETECTOR ON BOTTOM ALUMINUM PLATE:
	   
	   sql="DELETE from "+Flux_Table+" where name='muonfluxbot'"
	   cursor.execute(sql)
	   
	   sql="INSERT INTO "+Flux_Table+" VALUES ('muonfluxbot','MD_bot_alum','flux detector on bottom aluminum plate','"
	   #	sql+= str( .5*connecting_width+.5*alum_airgap+.5*al_extra2 )+"*cm "
	   #	sql+= str( -((from_target+.5*MD_depth)*tt1-alum_plate_width-alum_airgap+flux_width/2) )+"*cm "
	   #	sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','0*deg 0*deg 90*deg','ffaa00','G4Trap','"
	   sql+= str( +(alum_plate_width-flux_width)/2)+"*cm 0*cm 0*cm','0*deg 0*deg 0*deg','ffaa00','G4Trap','"
	   sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
	   sql+= str( theta1 )+"*rad "
	   sql+= str( 0 )+"*deg "
	   sql+= str( (from_target-al_extra3)*tt3-.5*connecting_width-.5*alum_airgap+.5*al_extra2 )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( 0 )+"*deg "
	   sql+= str( (from_target+MD_depth+al_extra1)*tt3-.5*connecting_width-.5*alum_airgap+.5*al_extra2 )+"*cm "	
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( 0 )+"*deg', "
	   
	   sql+= "'Aluminum','no',1,1,1,1,0,'FLUX','FLUX','id manual 11',1,1000,now())" #make sure material here is the same as the material of the plate
	   cursor.execute(sql)
	   
	   
	#INSERT FLUX DETECTOR ON OUTER SIDE ALUMINUM PLATE:
	   
	   sql="DELETE from "+Flux_Table+" where name='muonfluxout'"
	   cursor.execute(sql)
	   
	   sql="INSERT INTO "+Flux_Table+" VALUES ('muonfluxout','MD_side_alum','flux detector on outer side aluminum plate','"
	   #	sql+= str( (from_target+MD_depth/2+.5*(al_extra1-al_extra3))*tt3+al_extra2-alum_side_width+.5*flux_width )+"*cm "
	   #	sql+= str( 0 )+"*cm "
	   #	sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','0*deg 0*deg 0*deg','ffaa00','G4Trap','"
	   sql+= str( +(alum_side_width-flux_width)/2 )+"*cm 0*cm 0*cm','0*deg 0*deg 0*deg','ffaa00','G4Trap','"
	   sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
	   sql+= str( theta3 )+"*rad "
	   sql+= str( 0 )+"*deg "
	   sql+= str( (from_target-al_extra3)*tt1-alum_airgap-alum_plate_width )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( 0 )+"*deg "
	   sql+= str( (from_target+MD_depth+al_extra1)*tt1-alum_airgap-alum_plate_width )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( 0 )+"*deg', "
	   
	   sql+= "'Aluminum','no',1,1,1,1,0,'FLUX','FLUX','id manual 12',1,1000,now())" #make sure material here is the same as the material of the plate
	   cursor.execute(sql)
	   
	   
	   
	   sql="DELETE from "+Flux_Table+" where name='muonfluxin'"
	   cursor.execute(sql)
	   
	# #INSERT FLUX DETECTOR ON INNER SIDE ALUMINUM PLATE:
	   
	   sql="INSERT INTO "+Flux_Table+" VALUES ('muonfluxin','MD_side_alum_near_conn','flux detector on inner side aluminum plate','"
	   #	sql+= str( -(from_target+MD_depth/2+.5*(al_extra1-al_extra3))*tt3+alum_side_width-.5*flux_width+connecting_width+alum_airgap )+"*cm "
	   #	sql+= str( 0 )+"*cm "
	   #	sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','0*deg 0*deg 0*deg','ffaa00','G4Trap','"
	   sql+= str( -(alum_side_width-flux_width)/2)+"*cm','0*deg 0*deg 0*deg','ffaa00','G4Trap','"
	   sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
	   sql+= str( -theta3 )+"*rad "
	   sql+= str( 0 )+"*deg "
	   sql+= str( (from_target-al_extra3)*tt1-alum_airgap-alum_plate_width )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( 0 )+"*deg "
	   sql+= str( (from_target+MD_depth+al_extra1)*tt1-alum_airgap-alum_plate_width )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( flux_width/2 )+"*cm "
	   sql+= str( 0 )+"*deg', "
	   
	   sql+= "'Aluminum','no',1,1,1,1,0,'FLUX','FLUX','id manual 13',1,1000,now())" #make sure material here is the same as the material of the plate
	   cursor.execute(sql)
	   

else:                            ### fan_out=1 , When you fan out the inside angle of the vacuum region.
   
# INSERT TOP ALUMINUM PLATE
    print "Theta3: "+str(theta3) +"  Theta4: " + str( theta4 )+ "  Theta3-Theta4: " + str(theta3- theta4)
    print "TT3   : "+str(tt3) +   "  TT4   : " + str( tt4 )
    print "MD_mid: "+str(MD_mid)+ "  MD_depth: " + str(MD_depth)

    L1= (from_target - al_extra3)*(math.tan(theta3)+math.tan(theta4)) - alum_airgap + al_extra2 
    L2= (from_target + MD_depth + al_extra1)*(math.tan(theta3) + math.tan(theta4)) - alum_airgap + al_extra2
    L3=(MD_depth+al_extra1+al_extra3)*math.tan(theta3) 
    L4=(MD_depth+al_extra1+al_extra3)*math.tan(theta4)
 
    half_width=(from_target+(MD_depth+al_extra1-al_extra3)/2)*math.tan(theta3)
    center_point=half_width + al_extra2 - (L2+L1)/4
    skew_angle = math.atan( (L2/2 - L4 - L1/2)/(MD_depth+al_extra1+al_extra3) )

    print "Check "+str(L1+L3+L4 - L2)
    print "Center point: "+str(center_point)
    print "L1: "+str(L1) + " L2: " + str(L2) + " half_width: " + str(half_width)
    print "Skew angle: " + str(skew_angle)+"*rad  (theta3 - theta4)/2: " + str( (theta3-theta4)/2 )

    sql="INSERT INTO "+Table+" VALUES ('MD_top_alum','MD','Top aluminum plate','"
    sql+= str( center_point )+ "*cm "
    sql+= str( (from_target+.5*MD_depth+.5*(al_extra1-al_extra3))*tt1-.5*alum_plate_width-alum_airgap)+"*cm "

    sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','"+str(theta1)+"*rad 0*deg 90*deg','ddddee','G4Trap','"    

    sql+= str( (MD_depth+al_extra1+al_extra3)/2 )+"*cm "
    sql+= str( skew_angle)+"*rad "
    sql+= str( 90 )+"*deg "
    sql+= str( L1/2  )+"*cm "
    sql+= str( alum_plate_width/2 )+"*cm "
    sql+= str( alum_plate_width/2 )+"*cm "
    sql+= str( 0 )+"*deg "
    sql+= str( L2/2 )+"*cm "	
    sql+= str( alum_plate_width/2 )+"*cm "
    sql+= str( alum_plate_width/2 )+"*cm "
    sql+= str( 0 )+"*deg', "    

    sql+= "'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
    cursor.execute(sql)
    
    if flux==1:

#INSERT FLUX DETECTOR ON TOP ALUMINUM PLATE:
	    
        sql="DELETE from "+Flux_Table+" where name='muonfluxtop'"
	cursor.execute(sql)
	
	sql="INSERT INTO "+Flux_Table+" VALUES ('muonfluxtop','MD_top_alum','flux detector on top aluminum plate','"
	sql+= str( -(alum_plate_width-flux_width)/2)+"*cm 0*cm 0*cm ','0*deg 0*deg 0*deg','ffaa00','G4Trap','"   # Rotation of mother means move in -x not y.

	sql+= str( (MD_depth+al_extra1+al_extra3)/2 )+"*cm "
	sql+= str( skew_angle )+"*rad "
	sql+= str( 90 )+"*deg "
	sql+= str( L1/2 )+"*cm "
	sql+= str( flux_width/2 )+"*cm "
	sql+= str( flux_width/2 )+"*cm "
	sql+= str( 0 )+"*deg "
	sql+= str( L2/2 )+"*cm "	
	sql+= str( flux_width/2 )+"*cm "
	sql+= str( flux_width/2 )+"*cm "
	sql+= str( 0 )+"*deg', "       
	sql+= "'Aluminum','no',1,1,1,1,0,'FLUX','FLUX','id manual 10',1,1000,now())" #make sure material here is the same as the material of the plate
	cursor.execute(sql)
	
#INSERT BOTTOM ALUMINUM PLATE:
    
    sql="INSERT INTO "+Table+" VALUES ('MD_bot_alum','MD','Bottom aluminum plate','"
    sql+= str( center_point )+"*cm "
    sql+= str( -((from_target+.5*MD_depth+.5*(al_extra1-al_extra3))*tt1-.5*alum_plate_width-alum_airgap) )+"*cm "
    sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','"+str(-theta1)+"*rad 0*deg 90*deg','ddddee','G4Trap','"
    
    sql+= str( (MD_depth+al_extra1+al_extra3)/2 )+"*cm "
    sql+= str( skew_angle)+"*rad "
    sql+= str( 90 )+"*deg "
    sql+= str( L1/2)+"*cm "
    sql+= str( alum_plate_width/2 )+"*cm "
    sql+= str( alum_plate_width/2 )+"*cm "
    sql+= str( 0 )+"*deg "
    sql+= str( L2/2 )+"*cm "	
    sql+= str( alum_plate_width/2 )+"*cm "
    sql+= str( alum_plate_width/2 )+"*cm "
    sql+= str( 0 )+"*deg', "
    
    sql+= "'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
    cursor.execute(sql)
    
    if flux==1:

	#INSERT FLUX DETECTOR ON BOTTOM ALUMINUM PLATE:
       
       sql="DELETE from "+Flux_Table+" where name='muonfluxbot'"
       cursor.execute(sql)
       
       sql="INSERT INTO "+Flux_Table+" VALUES ('muonfluxbot','MD_bot_alum','flux detector on bottom aluminum plate','"
       sql+= str( +(alum_plate_width-flux_width)/2)+"*cm 0*cm 0*cm','0*deg 0*deg 0*deg','ffaa00','G4Trap','"
       sql+= str( (MD_depth+al_extra1+al_extra3)/2 )+"*cm "
       sql+= str( skew_angle)+"*rad "
       sql+= str( 90 )+"*deg "
       sql+= str( L1/2 )+"*cm "
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( 0 )+"*deg "
       sql+= str( L2/2 )+"*cm "	
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( 0 )+"*deg', "
       
       sql+= "'Aluminum','no',1,1,1,1,0,'FLUX','FLUX','id manual 11',1,1000,now())" #make sure material here is the same as the material of the plate
       cursor.execute(sql)
       

    
#INSERT OUTER SIDE ALUMINUM PLATE:
    
    sql="INSERT INTO "+Table+" VALUES ('MD_side_alum','MD','Outer side aluminum plate','"
    sql+= str( (from_target+MD_depth/2+.5*(al_extra1-al_extra3))*tt3+al_extra2-.5*alum_side_width )+"*cm "
    sql+= str( 0 )+"*cm "
    sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','0*deg 0*deg 0*deg','ddddee','G4Trap','"
    
    sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
    sql+= str( theta3 )+"*rad "
    sql+= str( 0 )+"*deg "
    sql+= str( (from_target-al_extra3)*tt1- alum_airgap - alum_plate_width)+"*cm "
    sql+= str( alum_side_width/2 )+"*cm "
    sql+= str( alum_side_width/2 )+"*cm "
    sql+= str( 0 )+"*deg "
    sql+= str( (from_target+MD_depth+al_extra1)*tt1- alum_airgap -alum_plate_width)+"*cm "
    sql+= str( alum_side_width/2 )+"*cm "
    sql+= str( alum_side_width/2 )+"*cm "
    sql+= str( 0 )+"*deg', "
    
    sql+= "'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
    cursor.execute(sql)
    
    
#INSERT INNER SIDE ALUMINUM PLATE:
    
    sql="INSERT INTO "+Table+" VALUES ('MD_side_alum_near_conn','MD','Inner side aluminum plate','"
    sql+= str( -(from_target+MD_depth/2+.5*(al_extra1-al_extra3))*tt4+.5*alum_side_width + alum_airgap )+"*cm "
    sql+= str( 0 )+"*cm "
    sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','0*deg 0*deg 0*deg','ddddee','G4Trap','"
    
    sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
    sql+= str( -theta4 )+"*rad "
    sql+= str( 0 )+"*deg "
    sql+= str( (from_target-al_extra3)*tt1-alum_airgap - alum_plate_width )+"*cm "
    sql+= str( alum_side_width/2 )+"*cm "
    sql+= str( alum_side_width/2 )+"*cm "
    sql+= str( 0 )+"*deg "
    sql+= str( (from_target+MD_depth+al_extra1)*tt1-alum_airgap - alum_plate_width )+"*cm "
    sql+= str( alum_side_width/2 )+"*cm "
    sql+= str( alum_side_width/2 )+"*cm "
    sql+= str( 0 )+"*deg', "
    
    sql+= "'Aluminum','no',1,1,1,1,1,'no','','',1,10000,now())"
    cursor.execute(sql)

    if flux==1:
	# #INSERT FLUX DETECTOR ON INNER SIDE ALUMINUM PLATE:
       
       sql="INSERT INTO "+Flux_Table+" VALUES ('muonfluxin','MD_side_alum_near_conn','flux detector on inner side aluminum plate','"
       #	sql+= str( -(from_target+MD_depth/2+.5*(al_extra1-al_extra3))*tt3+alum_side_width-.5*flux_width+connecting_width+alum_airgap )+"*cm "
       #	sql+= str( 0 )+"*cm "
       #	sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','0*deg 0*deg 0*deg','ffaa00','G4Trap','"
       sql+= str( -(alum_side_width-flux_width)/2)+"*cm 0*cm 0*cm','0*deg 0*deg 0*deg','ffaa00','G4Trap','"
       sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
       sql+= str( -theta4 )+"*rad "
       sql+= str( 0 )+"*deg "
       sql+= str( (from_target-al_extra3)*tt1-alum_airgap-alum_plate_width )+"*cm "
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( 0 )+"*deg "
       sql+= str( (from_target+MD_depth+al_extra1)*tt1-alum_airgap-alum_plate_width )+"*cm "
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( 0 )+"*deg', "
       
       sql+= "'Aluminum','no',1,1,1,1,0,'FLUX','FLUX','id manual 13',1,1000,now())" #make sure material here is the same as the material of the plate
       cursor.execute(sql)
    
    
#INSERT VACUUM REGION IN BETWEEN:
    
    sql="INSERT INTO "+Table+" VALUES ('MD_vac','MD','Vacuum region in Muon Detector','"
    sql+= str( center_point )+"*cm "
    sql+= str( 0 )+"*cm "
    sql+= str( MD_mid-vac_pullz/2+vac_pushz/2 )+"*cm','0*deg 0*deg 90*deg','ffffff','G4Trap','"
    
    sql+= str( MD_depth/2+vac_pullz/2+vac_pushz/2 )+"*cm "
    sql+= str( skew_angle )+"*rad "
    sql+= str( 90 )+"*deg "
    sql+= str( (L1-2*alum_side_width)/2 )+"*cm " 
    sql+= str( (from_target-al_extra3)*tt1 - alum_plate_width - alum_airgap )+"*cm "
    sql+= str( (from_target-al_extra3)*tt1 - alum_plate_width - alum_airgap )+"*cm "
    sql+= str( 0 )+"*deg "
    sql+= str( (L2-2*alum_side_width)/2 )+"*cm "	
    sql+= str( (from_target+MD_depth+al_extra1)*tt1 - alum_plate_width - alum_airgap )+"*cm "
    sql+= str( (from_target+MD_depth+al_extra1)*tt1 - alum_plate_width - alum_airgap )+"*cm "
    sql+= str( 0 )+"*deg', "
    
    sql+= "'Vacuum','no',1,1,1,1,0,'no','','',1,10000,now())"
    cursor.execute(sql)
    
    
#------FLUX DETECTORS-------
    
    if flux==1:
       
	#INSERT FLUX DETECTOR ON OUTER SIDE ALUMINUM PLATE:
       
       sql="DELETE from "+Flux_Table+" where name='muonfluxout'"
       cursor.execute(sql)
       
       sql="INSERT INTO "+Flux_Table+" VALUES ('muonfluxout','MD_side_alum','flux detector on outer side aluminum plate','"
       #	sql+= str( (from_target+MD_depth/2+.5*(al_extra1-al_extra3))*tt3+al_extra2-alum_side_width+.5*flux_width )+"*cm "
       #	sql+= str( 0 )+"*cm "
       #	sql+= str( MD_mid+.5*(al_extra1-al_extra3) )+"*cm','0*deg 0*deg 0*deg','ffaa00','G4Trap','"
       sql+= str( +(alum_side_width-flux_width)/2 )+"*cm 0*cm 0*cm','0*deg 0*deg 0*deg','ffaa00','G4Trap','"
       sql+= str( MD_depth/2+.5*(al_extra1+al_extra3) )+"*cm "
       sql+= str( theta3 )+"*rad "
       sql+= str( 0 )+"*deg "
       sql+= str( (from_target-al_extra3)*tt1-alum_airgap-alum_plate_width )+"*cm "
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( 0 )+"*deg "
       sql+= str( (from_target+MD_depth+al_extra1)*tt1-alum_airgap-alum_plate_width )+"*cm "
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( flux_width/2 )+"*cm "
       sql+= str( 0 )+"*deg', "
       
       sql+= "'Aluminum','no',1,1,1,1,0,'FLUX','FLUX','id manual 12',1,1000,now())" #make sure material here is the same as the material of the plate
       cursor.execute(sql)
       
       
       
       sql="DELETE from "+Flux_Table+" where name='muonfluxin'"
       cursor.execute(sql)
       
       
