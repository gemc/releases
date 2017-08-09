# GEMC

# Code conventions 
# - camel case for all variable names, class definitions
# - type definitions start with Capital letter
# - instances start with lowercase letter

# Pre-processor
# Found with scons SHOWBUILD=1
# Can paste in one line in Build Settings - Pre-Processor macro.
# For example G4MULTITHREADED will change the meaning of G4cout (will use G4cout_p instead)
# -DG4OPTIMISE -DG4_STORE_TRAJECTORY -DG4VIS_USE_OPENGL -DG4UI_USE_TCSH -DG4INTY_USE_QT  -DG4UI_USE_QT -DG4VIS_USE_OPENGLQT -DG4USE_STD11 -DG4MULTITHREADED
#   G4OPTIMISE=1 G4_STORE_TRAJECTORY=1 G4VIS_USE_OPENGL=1 G4UI_USE_TCSH=1 G4INTY_USE_QT=1  G4UI_USE_QT=1 G4VIS_USE_OPENGLQT=1 G4USE_STD11=1 G4MULTITHREADED=1


# Add the following libraries to copy link:
# libG4digits_hits.dylib
# libG4event.dylib
# libG4geometry.dylib
# libG4global.dylib
# libG4graphics_reps.dylib
# libG4intercoms.dylib
# libG4materials.dylib
# libG4particles.dylib
# libG4physicslists.dylib
# libG4processes.dylib
# libG4run.dylib
# libG4track.dylib
# libG4tracking.dylib
# libG4zlib.dylib


# Add the env variable for run time:
# G4ENSDFSTATEDATA /opt/jlab_software/devel/Darwin_macosx10.12-x86_64-clang8.1.0/geant4/4.10.03.p01/data/Geant4-10.3.1/data/G4ENSDFSTATE2.1
# G4LEDATA         /opt/jlab_software/devel/Darwin_macosx10.12-x86_64-clang8.1.0/geant4/4.10.03.p01/data/Geant4-10.3.1/data/G4EMLOW6.50
# G4LEVELGAMMADATA /opt/jlab_software/devel/Darwin_macosx10.12-x86_64-clang8.1.0/geant4/4.10.03.p01/data/Geant4-10.3.1/data/PhotonEvaporation4.3
# G4SAIDXSDATA     /opt/jlab_software/devel/Darwin_macosx10.12-x86_64-clang8.1.0/geant4/4.10.03.p01/data/Geant4-10.3.1/data/G4SAIDDATA1.1
# G4NEUTRONXSDATA  /opt/jlab_software/devel/Darwin_macosx10.12-x86_64-clang8.1.0/geant4/4.10.03.p01/data/Geant4-10.3.1/data/G4NEUTRONXS1.4


# Instrument:
# https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/


# MT notes:
# https://twiki.cern.ch/twiki/bin/view/Geant4/QuickMigrationGuideForGeant4V10
# shared pointer: http://en.cppreference.com/w/cpp/memory/shared_ptr
# Shared classes:
# - geometry and physics tables are shared: G4VUserDetectorConstruction, G4VUserPhysicsList and newly introduced G4VUserActionInitialization
# Local thread classes:
# - EventManager, TrackingManager, SteppingManager, TransportationManager, GeometryManager, FieldManager, Navigator, SensitiveDetectorManager


# Log output
# G4cout is used for the geant4 master log (physics initialization and detector construction). It is redirected to a file by the glog class
# G4cout coming from the worker thread is re-directed to output by UIManager command.
# cout is used for sequential log on screen by gemc.


# Memory usage
# First run valgrind (Linux): valgrind --tool=callgrind gemc /group/clas12/gemc/4a.1.1/clas12.gcard -USE_GUI=0 -N=100
# qcachegrind can be installed with brew on mac
# qcachegrind callgrind.out.<pid>
