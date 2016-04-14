// %%%%%%%%%%
// G4 headers
// %%%%%%%%%%
#include "G4Box.hh"
#include "G4GeometryManager.hh"
#include "G4LogicalVolumeStore.hh"
#include "G4LogicalVolume.hh"
#include "G4PhysicalVolumeStore.hh"
#include "G4ProductionCuts.hh"
#include "G4PVPlacement.hh"
#include "G4RunManager.hh"
#include "G4SolidStore.hh"
#include "G4VisAttributes.hh"
#include "G4SDManager.hh"
#include "G4OpBoundaryProcess.hh"

// %%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%
#include "MDetectorConstruction.h"
#include "MDetectorMessenger.h"

// %%%%%%%%%%%
// C++ headers
// %%%%%%%%%%%
#include <sstream>
using namespace std;

MDetectorConstruction::MDetectorConstruction(gemc_opts Opts)
{
	gemcOpt = Opts;
	// mdetectorMessenger = new MDetectorMessenger(this);
}

MDetectorConstruction::~MDetectorConstruction()
{
	;
}


G4VPhysicalVolume* MDetectorConstruction::Construct()
{
	string hd_msg     = gemcOpt.args["LOG_MSG"].args + " Construction: >> ";
	double VERB       = gemcOpt.args["G4P_VERBOSITY"].arg ;
	string catch_v    = gemcOpt.args["CATCH"].args;


	// Clean old geometry, if any
	G4GeometryManager::GetInstance()->OpenGeometry();
	G4PhysicalVolumeStore::GetInstance()->Clean();
	G4LogicalVolumeStore::GetInstance()->Clean();
	G4SolidStore::GetInstance()->Clean();


	// Experimental hall is a 40 meters box
	(*Hall_Map)["root"].create_solid(gemcOpt, Hall_Map);
	(*Hall_Map)["root"].create_logical_volume(mats, gemcOpt);
	(*Hall_Map)["root"].create_physical_volumes(gemcOpt, NULL);
	HasMagfield((*Hall_Map)["root"],  gemcOpt);


	if(VERB > 3 || catch_v == "root") cout << hd_msg << "    " << (*Hall_Map)["root"] ;


	cout << hd_msg <<  " Building Detector from Geometry STL Map..." << endl << endl;


	// ########################################################################
	// Resetting Detector Map "scanned". Propagating "exist" to all generations
	// ########################################################################
	if(VERB > 2) cout << hd_msg << " Mapping Physical Detector..." << endl << endl;

	for(map<string, detector>::iterator i =  Hall_Map->begin(); i!=Hall_Map->end(); i++)
	{
		if(VERB > 3) cout << hd_msg << " Scanning Detector " << i->first << " - existance: " << i->second.exist << endl;

		// Find the mother up to "root" - disable kid if ancestor does not exist
		detector mother = FindDetector(i->second.mother);
		
		while(mother.name != "akasha" && mother.name != "notfound")
		{
			if(mother.exist == 0)
			{
				if(VERB > 2) cout << hd_msg <<   "\t" << i->second.mother  << " is not activated. Its child " << i->second.name
					<< " will be disactivated as well." << endl;
				i->second.exist = 0;
			}
			mother = FindDetector(mother.mother);
		}
		if(i->first != "root") i->second.scanned = 0;
	}


	// ########################################################################
	// Building Solids, Logical Volumes, Physical Volumes from the detector Map
	// ########################################################################
	vector<string> relatives;
	string mom, kid;
	for( map<string, detector>::iterator i =  Hall_Map->begin(); i!=Hall_Map->end(); i++)
	{
		// don't build anything if it doesn't exist
		if(i->second.exist == 0) continue;
		
		// put the first volume in relatives
		// typically it's the first in alphabetical order
		if(i->first != "root") relatives.push_back(i->second.name);
		
		while(relatives.size() > 0)
		{
			detector kid = FindDetector(relatives.back());
			detector mom = FindDetector(kid.mother);
	
       // Mom doesn't exists in the Hall_Map. Stopping everything.
			if(mom.name != "akasha"  && mom.name == "notfound")
			{
				cout << hd_msg << "  Mom <" << mom.name<< "> was not created for <" << kid.name << ">. "
											 << " We have a No Child Left Behind policy. Exiting. " << endl << endl;
				exit(0);
			}

			// output the Geneaology
			if(VERB > 3 || kid.name.find(catch_v) != string::npos)
			{
				for(unsigned int ir=0; ir<relatives.size()-1; ir++) cout << "\t";
				cout << hd_msg << " Checking " << kid.name << ", child of " << mom.name
											 << ", for a living ancestor. "
											 << " This Geneaology Depth is " << relatives.size() << "." << endl;
			}
			
			// Mom is built, kid not built yet. 
			if(kid.scanned == 0 && mom.scanned == 1)
			{
				if(VERB > 3 || kid.name.find(catch_v) != string::npos)
				{
					for(unsigned int ir=0; ir<relatives.size()-1; ir++) cout << "\t";
					cout << hd_msg << "  Found:  " << kid.name
					<< " is not built yet but its mommie " << mom.name << " is." 
					<< " Building " << kid.name << " of type: "  << kid.type << "..." << endl;
				}
				
				// Check kid dependency on copies
				if(kid.type.find("CopyOf") == 0)
				{
				
					stringstream ops;
					string operands(kid.type, 6, kid.type.size());
					ops << operands;
					string original;
					ops >> original;
					
					detector dorig = FindDetector(original);
					// if dependency is not built yet, then 
					// add it to the relative list
					if(dorig.scanned == 0)
					{
						relatives.push_back(original);
						if(VERB > 3  || kid.name.find(catch_v) != string::npos)
						{
							for(unsigned int ir=0; ir<relatives.size()-1; ir++) cout << "\t";
							cout << hd_msg << kid.name << " is copied volume. "
							<< " Must build: " << original << " first " << endl;					
						}
					}
					// otherwise can build the kid
					else
					{
						BuildDetector(kid.name);
						kid.scanned = 1;
					}					
				}
				// Check kid dependency on operations
				else if(kid.type.find("Operation:") == 0)
				{				
					int sstart = 10;
					if(kid.type.find("Operation:~") == 0 || kid.type.find("Operation:@") == 0 ) sstart = 11;
					
					stringstream ops;
					string operands(kid.type, sstart, kid.type.size());
					ops << operands;
					string firstop, secondop, tmpop;
					ops >>  firstop >> tmpop >> secondop;
					
					// if dependency is not built yet, then 
					// add it to the relative list
					detector dsecondop = FindDetector(secondop);
					if(dsecondop.scanned == 0)
					{
						relatives.push_back(secondop);
						if(VERB > 3  || kid.name.find(catch_v) != string::npos)
						{
							for(unsigned int ir=0; ir<relatives.size()-1; ir++) cout << "\t";
							cout << hd_msg << kid.name << " is the result of an operation. "
							<< " Must build: " << secondop << " first " << endl;					
						}
					}
					detector dfirstop = FindDetector(firstop);
					if(dfirstop.scanned == 0)
					{
						relatives.push_back(firstop);
						if(VERB > 3  || kid.name.find(catch_v) != string::npos)
						{
							for(unsigned int ir=0; ir<relatives.size()-1; ir++) cout << "\t";
							cout << hd_msg << kid.name << " is the result of an operation. "
							<< " Must build: " << firstop << " first " << endl;					
						}
					}
					
					// otherwise can build the kid
					if(dsecondop.scanned == 1 && dfirstop.scanned == 1)
					{
						BuildDetector(kid.name);
						kid.scanned = 1;
					}					
				}
				else
				// no dependencies found, build the kid
				{
					BuildDetector(kid.name);					
					kid.scanned = 1;
				}
			}

			// if the kid still doesn't exists and its mom doesn't exist. 
			// adding mom to the relatives list
			if(kid.scanned == 0 && mom.scanned == 0) 
			{
				relatives.push_back(kid.mother);				
			}

			// the kid has been built. Can go down one step in geneaology
			if(kid.scanned == 1 && relatives.size())
			{
				if(VERB > 3 || kid.name.find(catch_v) != string::npos)
					cout << hd_msg  << " " <<  kid << " is built." <<  endl << endl;

			relatives.pop_back();
			
			}

		}
	}

	// %%%%%%%
	// Mirrors
	// %%%%%%%
	
	// creating STL vector of Mirrors. 
  // the array of photon energies has size "2"
  // but all mirror properties are independent of energy
	const int nEntries_Mirror = 2;
	double PhotonEnergy_Mirror[nEntries_Mirror] = { 1.034*eV, 5.144*eV };
	
	vector<G4OpticalSurface*>          Mirror_Surfaces;
	vector<G4MaterialPropertiesTable*> Mirror_MPT;
	vector<G4LogicalBorderSurface*>    Mirrors;
	vector<G4LogicalSkinSurface*>      SMirrors;



	// now going through all volumes with the Identifier set to "Mirror:"
	// the second entry is the volume that borders with the one considered
	// the third entry is the reflectivity (double number, between zero and one)
	// the fourth entry is the refractive index (double number, between zero and one)
	for( map<string, detector>::iterator i =  Hall_Map->begin(); i!=Hall_Map->end(); i++)
	{	
		// looking for Mirrors
    if(i->second.identity.size())
      if(i->second.identity[0].name == "Mirror" && i->second.identity[0].rule == "WithSurface:")
      {
        string name        = i->first;
        string borderv     = "";
        string model[2]    = {"unified", "LUT"};
        string finish[2]   = {"polished", "ground"};
        string surfaces[2] = {"dielectric_metal", "dielectric_dielectric"};
	string material    = "";
        double refraction  = 1.0;
        double efficiency  = 1.0;
        double reflection  = 1.0;
        int surfaceType    = 0;
        int finishType     = 0;
        int modelType      = 0;

        for(unsigned int j=0; j<i->second.identity.size(); j++)
        {
                    
          // Border Volume
          if(i->second.identity[j].name == "WithBorderVolume:")
          {
            borderv = i->second.identity[j].rule;
          }
          
          // Surface Type:
          // 0: dielectric dielectric
          // 1: metal dielectric
          if(i->second.identity[j].rule == "WithSurface:")
          {
            surfaceType = i->second.identity[j].id;
          }
         
          // Finish
          // 0: polished
          // 1: ground
          if(i->second.identity[j].name == "With" && i->second.identity[j].rule == "Finish:")
          {
            finishType = i->second.identity[j].id;
          }
          
          
          // Refraction Index is ID / 1,000,000
          if(i->second.identity[j].name == "Refraction" && i->second.identity[j].rule == "Index:")
          {
            refraction = i->second.identity[j].id/1000000.0;
          }

          // Reflectivity is ID / 1,000,000
          if(i->second.identity[j].name == "With" && i->second.identity[j].rule == "Reflectivity:")
          {
            reflection = i->second.identity[j].id/1000000.0;
          }

          // Efficiency is ID / 1,000,000
          if(i->second.identity[j].name == "With" && i->second.identity[j].rule == "Efficiency:")
          {
            efficiency = i->second.identity[j].id/1000000.0;
          }
          
          // Model 
          // 0: unified
          // 1: LUT
          if(i->second.identity[j].name == "With" && i->second.identity[j].rule == "Model:")
          {
            modelType = i->second.identity[j].id;
          }
         
          // AJRP: Use predefined material for the interface? 
          if( i->second.identity[j].name == "WithMaterial:" )
          {
            material = i->second.identity[j].rule;
            
            if(VERB > 3 || name.find(catch_v) != string::npos)
            	cout << hd_msg << " Using properties of material " << material << " for mirror boundary of volume name " << name << endl;
            
          }
          
        }

        if(!(*Hall_Map)[borderv].GetPhysical() && borderv != "MirrorSkin")
        {
          cout << hd_msg << " Border volume " << borderv << " is not found for volume " << name << ". Exiting." << endl;
          exit(0);
        }
        
        string mirror_surf = "Mirror_Surface_for_" + name + "_and_" + borderv;
        if(borderv == "MirrorSkin")
        {
        	mirror_surf = "Mirror_Skin_Surface_for_" + name;
        }
        
        
        Mirror_Surfaces.push_back(new G4OpticalSurface(mirror_surf));

        //AJRP: If a material was given for this interface, AND a material properties table has been defined for said mirror, use this instead of a new table!
        bool MPT_exists = false;
        if( material != "" && ( (*mats)[material] )->GetMaterialPropertiesTable() )
        {
          Mirror_MPT.push_back( ( (*mats)[material] )->GetMaterialPropertiesTable() );
          MPT_exists = true;
        } 
        else 
        {
          Mirror_MPT.push_back(new G4MaterialPropertiesTable());
        } 

        // surface type
        if(surfaceType == 0) Mirror_Surfaces.back()->SetType(dielectric_metal);
        if(surfaceType == 1) Mirror_Surfaces.back()->SetType(dielectric_dielectric);
        
        // surface finish
        if(finishType == 0) Mirror_Surfaces.back()->SetFinish(polished);
        if(finishType == 1) Mirror_Surfaces.back()->SetFinish(ground);
        
        // surface model
        if(modelType == 0) Mirror_Surfaces.back()->SetModel(unified);
        if(modelType == 1) Mirror_Surfaces.back()->SetModel(LUT);
      
        
        double r_index[2] = {refraction, refraction};
        double reflect[2] = {reflection, reflection};
        double efficie[2] = {efficiency, efficiency};
        double spike[2] = {1.0, 1.0};
        double slobe[2] = {0.0, 0.0};
        double sback[2] = {0.0, 0.0};
        double sdiff[2] = {0.0, 0.0};
       
        if( !MPT_exists )
        {
          Mirror_MPT.back()->AddProperty("RINDEX",       PhotonEnergy_Mirror, r_index, nEntries_Mirror);
          Mirror_MPT.back()->AddProperty("REFLECTIVITY", PhotonEnergy_Mirror, reflect, nEntries_Mirror);
          Mirror_MPT.back()->AddProperty("EFFICIENCY",   PhotonEnergy_Mirror, efficie, nEntries_Mirror);
          Mirror_MPT.back()->AddProperty("SPECULARSPIKECONSTANT", PhotonEnergy_Mirror, spike, nEntries_Mirror);
          Mirror_MPT.back()->AddProperty("SPECULARLOBECONSTANT",  PhotonEnergy_Mirror, slobe, nEntries_Mirror);
          Mirror_MPT.back()->AddProperty("BACKSCATTERCONSTANT",   PhotonEnergy_Mirror, sback, nEntries_Mirror);
          Mirror_MPT.back()->AddProperty("DIFFUSELOBECONSTANT",   PhotonEnergy_Mirror, sdiff, nEntries_Mirror);
        }
        
        Mirror_Surfaces.back()->SetMaterialPropertiesTable(Mirror_MPT.back());

        if(borderv=="MirrorSkin")
        {
          SMirrors.push_back(new G4LogicalSkinSurface(name,
                                                      (*Hall_Map)[name].GetLogical(), Mirror_Surfaces.back()));
        }
				else
        {
        
        	Mirrors.push_back(new G4LogicalBorderSurface(name,
                                (*Hall_Map)[borderv].GetPhysical(),
                                (*Hall_Map)[name].GetPhysical(), Mirror_Surfaces.back()));
        }

        
        if(VERB > 3 || name.find(catch_v) != string::npos)
        {
          cout << hd_msg  << " " <<  name << " is a mirror:" << endl;
          cout << "                             > Border Volume: "      << borderv << endl;
          cout << "                             > Surface Type: "       << surfaces[surfaceType] << endl;
          cout << "                             > Finish: "             << finish[finishType] << endl;
          cout << "                             > Refraction Index: "   << refraction << endl;
          cout << "                             > Reflectivity: "       << reflection << endl;
          cout << "                             > Efficiency: "         << efficiency << endl;
          cout << "                             > Model: "              << model[modelType] << endl;
          
          
          Mirror_MPT.back()->DumpTable();

  
        }
      }  
	}	
    
        // BEGIN reflectivity from CLAS12 TDR HTCC for RICH
        const G4int RICHmirror_Len=7;
        G4double RICHmirror_PhoE[RICHmirror_Len]=
        { 1.9074*eV, 2.0664*eV, 2.2543*eV, 3.5424*eV, 4.1328*eV, 4.9594*eV, 6.1992*eV };
        G4double RICHmirror_Ref[RICHmirror_Len]=
        { 0.88,      0.89,      0.90,      0.90,      0.88,      0.85,      0.74      };
        G4double RICHmirror_PhoE2[2]={ 1.9074*eV, 6.1992*eV };
        G4double RICHmirror_Eff[2]  ={ 0.,        0.        };

        G4MaterialPropertiesTable* RICHmirror_MPT = new G4MaterialPropertiesTable();
        RICHmirror_MPT->AddProperty("REFLECTIVITY", RICHmirror_PhoE,  RICHmirror_Ref, RICHmirror_Len);
        RICHmirror_MPT->AddProperty("EFFICIENCY",   RICHmirror_PhoE2, RICHmirror_Eff, 2);

        G4OpticalSurface* RICHmirror_OptSurf = new G4OpticalSurface("RICHmirror_OptSurf");
        RICHmirror_OptSurf->SetType(dielectric_metal);
        RICHmirror_OptSurf->SetFinish(polished);
        RICHmirror_OptSurf->SetModel(unified);
        RICHmirror_OptSurf->SetMaterialPropertiesTable(RICHmirror_MPT);

//        G4LogicalSkinSurface* RICHmirror_SkinSurf1 = new G4LogicalSkinSurface("RICHmirror_SkinSurf1",
//                    (*Hall_Map)["AAr_rich_mirror1"].GetLogical(), RICHmirror_OptSurf);
//        G4LogicalSkinSurface* RICHmirror_SkinSurf2 = new G4LogicalSkinSurface("RICHmirror_SkinSurf2",
//                    (*Hall_Map)["PREMIRROR"].GetLogical(), RICHmirror_OptSurf);
        // END reflectivity from CLAS12 TDR HTCC for RICH



	return (*Hall_Map)["root"].GetPhysical();
}

#include "G4UserLimits.hh"

void MDetectorConstruction::IsSensitive(detector detect, gemc_opts Opts)
{
	string hd_msg  = gemcOpt.args["LOG_MSG"].args + " Sensitivity: >> ";
	double VERB    = gemcOpt.args["HIT_VERBOSITY"].arg ;
	string catch_v = gemcOpt.args["CATCH"].args;

	string sensi   = detect.sensitivity;

	if(sensi != "no")
	{
    // Sensitive_region->AddRootLogicalVolume(detect.GetLogical());
		G4SDManager* SDman = G4SDManager::GetSDMpointer();
		if (!SDman) throw "Can't get G4SDManager";

		if(VERB > 5 || detect.name.find(catch_v) != string::npos)
			cout << hd_msg  << " " <<  detect.name << " is sensitive."  << endl;

    // The key for the SD, Region, PC maps is the same so we can only check SD
		map<string, MSensitiveDetector*>::iterator itr = SeDe_Map.find(sensi);
		if(itr == SeDe_Map.end())
		{
			if(VERB > 3 || detect.name.find(catch_v) != string::npos)
				cout << endl << hd_msg  << " Sensitive detector <" << sensi
						<< "> doesn't exist yet. Adding <" << sensi << ">. " << endl;

			SeDe_Map[sensi] = new MSensitiveDetector(sensi, gemcOpt);

      // Creating G4 Region, assigning Production Cut to it.
			SeRe_Map[sensi] = new G4Region(sensi);
			SePC_Map[sensi] = new G4ProductionCuts;
			SePC_Map[sensi] ->SetProductionCut(SeDe_Map[sensi]->SDID.ProdThreshold);
			SeRe_Map[sensi]->SetProductionCuts(SePC_Map[sensi]);

			if(VERB > 3 || detect.name.find(catch_v) != string::npos)
				cout << hd_msg  << " Max Step for Sensitive detector <" << sensi
             << ">: " << SeDe_Map[sensi]->SDID.MaxStep/mm << " mm." <<  endl
             << hd_msg  << " Production Cut for Sensitive detector <" << sensi
             << ">: " << SeDe_Map[sensi]->SDID.ProdThreshold/mm << " mm." << endl << endl;

      // Pass Detector Map Pointer to Sensitive Detector
			SeDe_Map[sensi]->Hall_Map        = Hall_Map;

			SDman->AddNewDetector( SeDe_Map[sensi]);

		}
		detect.setSensitivity(SeDe_Map[sensi]);

    // Setting Max Acceptable Step for this SD
		detect.SetUserLimits(new G4UserLimits(SeDe_Map[sensi]->SDID.MaxStep, SeDe_Map[sensi]->SDID.MaxStep));

		map<string, G4Region*>::iterator  itrRE = SeRe_Map.find(sensi);
			if(itrRE != SeRe_Map.end()) SeRe_Map[sensi]->AddRootLogicalVolume(detect.GetLogical());
		else
		{
			cout << hd_msg << " Attention: " << sensi << " doesn't exist in the sensitive detector list. Aborting. " << endl;
			exit(9);
		}
	
	}

}


void MDetectorConstruction::HasMagfield(detector detect, gemc_opts Opts)
{
	string hd_msg  = gemcOpt.args["LOG_MSG"].args + " Magnetic Field: >> ";
	double VERB    = gemcOpt.args["MGN_VERBOSITY"].arg ;
	string catch_v = gemcOpt.args["CATCH"].args;
	string field   = gemcOpt.args["NO_FIELD"].args;

	if(field == "all" || detect.name.find(field) != string::npos)
		return;
	
	string magf   = detect.magfield;

	if(magf != "no")
	{
		if(VERB > 5 || detect.name.find(catch_v) != string::npos)
			cout << hd_msg  << " " <<  detect.name << " is inside "  << magf << " magnetic field." << endl;

		map<string, MagneticField>::iterator itr = FieldMap->find(magf);
		if(itr == FieldMap->end())
		{
			cout << hd_msg << " Magnetic Field <" << magf
					<< "> is not defined. Exiting." << endl;
			exit(0);
		}
		if(itr->second.get_MFM() == NULL)
		{
			cout << hd_msg << " Magnetic Field <" << magf
					<< "> doesn't exist yet. Adding <" << magf << ">. " << endl;
			itr->second.create_MFM();
		}

		if(itr->second.get_MFM() != NULL)
		{
			detect.AssignMFM(itr->second.get_MFM());

			if(VERB > 6 || detect.name.find(catch_v) != string::npos)
				cout << hd_msg  << " Field <" <<  magf << "> assigned to " << detect.name << "." << endl;

		}
	}

}


void MDetectorConstruction::UpdateGeometry()
{
	cout << "Updating geometry... " << endl;
	G4RunManager::GetRunManager()->GeometryHasBeenModified();
}

detector MDetectorConstruction::FindDetector(string name)
{
	map<string, detector>::iterator it = Hall_Map->find(name); 
	if(it != Hall_Map->end())
		return it->second;
	
	detector notfound;
	notfound.name   = "notfound";
	notfound.mother = "notfound";
	
	return notfound;	
	
}

void MDetectorConstruction::BuildDetector(string name)
{
	detector kid = FindDetector(name);
	detector mom = FindDetector(kid.mother);
	
	if(kid.name != "notfound" || mom.name != "notfound")
	{
		
		(*Hall_Map)[kid.name].create_solid(gemcOpt, Hall_Map);
		// creating logical volume
		if((*Hall_Map)[kid.name].create_logical_volume(mats, gemcOpt))
		{
			// creating physical volume
			(*Hall_Map)[kid.name].create_physical_volumes(gemcOpt, mom.GetLogical());
			IsSensitive((*Hall_Map)[kid.name], gemcOpt);
			HasMagfield((*Hall_Map)[kid.name], gemcOpt);
		}
		(*Hall_Map)[kid.name].scanned = 1;
	}

	if(kid.name == "notfound" )
		cout << "   Attention: " << kid.name << " not found. " << endl;
	if(mom.name == "notfound" )
		cout << "   Attention: " << mom.name << " not found. " << endl;


}






