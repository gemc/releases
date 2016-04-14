// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "run_conditions.h"
#include "string_utilities.h"

run_conditions::run_conditions(gemc_opts gemcOpt)
{
	string hd_msg    = gemcOpt.args["LOG_MSG"].args + " gcard: >> " ;

	string file = gemcOpt.args["gcard"].args;
	if(file=="no") return;

	QFile gcard(file.c_str());

	if (!domDocument.setContent(&gcard))
	{
		gcard.close();
		cout << hd_msg << " gcard format is wrong - check XML syntax. Exiting." << endl;
		exit(0);
	}
	gcard.close();

	QDomElement docElem = domDocument.documentElement(); ///< reading gcard file
	QDomNode n;


	n = docElem.firstChild();  ///< looping over SQL tables entries
	while(!n.isNull())
	{
		QDomElement e = n.toElement();                    ///< converts the node to an element.
		if(!e.isNull())                                   ///< the node really is an element.
			if(gemc_tostring(e.tagName()) == "sqltable")    ///< selecting "sqltable" nodes
		{
			string table_name = gemc_tostring(e.attributeNode("name").value());  ///< table name
			gTab_Vec.push_back(table_name);
		}
		n = n.nextSibling();
	}


	n = docElem.firstChild(); ///< looping over detector mods entries
	while(!n.isNull())
	{
		QDomElement e = n.toElement();                    ///< converts the node to an element.
		if(!e.isNull())                                   ///< the node really is an element.
			if(gemc_tostring(e.tagName()) == "detector")    ///< selecting "detector" nodes
		{
			gcard_detector gdet;
			gdet.set_position("0*cm",  "0*cm",  "0*cm");   ///< Initializing Position
			gdet.set_rotation("0*deg", "0*deg", "0*deg");  ///< Initializing Rotation

			string det_name = gemc_tostring(e.attributeNode("name").value());  ///< detector name

			QDomNode nn = e.firstChild();               ///< checking detector attributes
			while(!nn.isNull())
			{
				QDomElement ee = nn.toElement();
				if(!ee.isNull())
				{
					if(gemc_tostring(ee.tagName()) == "position")  ///< Initializing Position
					{
						gdet.set_position(gemc_tostring(ee.attributeNode("x").value()),
                              gemc_tostring(ee.attributeNode("y").value()),
                              gemc_tostring(ee.attributeNode("z").value()) );
					}
					if(gemc_tostring(ee.tagName()) == "rotation")  ///< Initializing Rotation
					{
						gdet.set_rotation(gemc_tostring(ee.attributeNode("x").value()),
                              gemc_tostring(ee.attributeNode("y").value()),
                              gemc_tostring(ee.attributeNode("z").value()) );
					}
					if(gemc_tostring(ee.tagName()) == "existence")  ///< Initializing Existance
					{
						gdet.set_existance(gemc_tostring(ee.attributeNode("exist").value()));
					}
				}

				nn = nn.nextSibling();
			}
			gDet_Map[det_name] = gdet;

		}

		n = n.nextSibling();
	}

	cout << hd_msg << "  Importing SQL tables: " << endl << endl;
	for(unsigned int i=0; i<gTab_Vec.size(); i++)
		cout << "                       \"" << gTab_Vec[i] << "\"" << endl ;
	cout << endl;
}

run_conditions::~run_conditions(){}


void gcard_detector::set_position(string X, string Y, string Z)
{
	pos.setX(get_number(X));
	pos.setY(get_number(Y));
	pos.setZ(get_number(Z));
}

void gcard_detector::set_rotation(string X, string Y, string Z)
{
	rot = G4RotationMatrix(G4ThreeVector(1, 0, 0),
								         G4ThreeVector(0, 1, 0),
                         G4ThreeVector(0, 0, 1));

	rot.rotateX(get_number(X));
	rot.rotateY(get_number(Y));
	rot.rotateZ(get_number(Z));
  
  vrot.setX(get_number(X)); 
  vrot.setY(get_number(Y)); 
  vrot.setZ(get_number(Z)); 
  
}

void gcard_detector::set_existance(string exist)
{
	if(exist == "no" || exist == "NO" || exist == "No")
		is_present = 0;
}


