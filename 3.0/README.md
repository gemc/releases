

 Pre-processor
 Found with scons SHOWBUILD=1
 Can paste in one line in Build Settings - preprocessor macro.
 For example G4MULTITHREADED will change the meaning of G4cout (will use G4cout_p instead)
 -DG4OPTIMISE -DG4_STORE_TRAJECTORY -DG4VIS_USE_OPENGL -DG4UI_USE_TCSH -DG4INTY_USE_QT  -DG4UI_USE_QT -DG4VIS_USE_OPENGLQT -DG4USE_STD11 -DG4MULTITHREADED
   G4OPTIMISE=1 G4_STORE_TRAJECTORY=1 G4VIS_USE_OPENGL=1 G4UI_USE_TCSH=1 G4INTY_USE_QT=1  G4UI_USE_QT=1 G4VIS_USE_OPENGLQT=1 G4USE_STD11=1 G4MULTITHREADED=1

Remember add the preprocessor in the libraries using geant4: g4display, g4volume 

 Add ALL external libraries to COPY in build phases, but not the products like g4display.
 We also need to add 2 additional qt frameworks: printing and qtopengl, due to.


 
 Instrument:
 https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/


 MT notes:
 https://twiki.cern.ch/twiki/bin/view/Geant4/QuickMigrationGuideForGeant4V10
 shared pointer: http://en.cppreference.com/w/cpp/memory/shared_ptr
 Shared classes:
 - geometry and physics tables are shared: G4VUserDetectorConstruction, G4VUserPhysicsList and newly introduced G4VUserActionInitialization
 Local thread classes:
 - EventManager, TrackingManager, SteppingManager, TransportationManager, GeometryManager, FieldManager, Navigator, SensitiveDetectorManager

G4RunManager::GetRunManager() returns the following pointer:
- It returns the pointer to the G4WorkerRunManager of the local thread when it is invoked from thread-local object.
- It returns the pointer to the G4MTRunManager when it is invoked from shared object.
- It returns the pointer to the base G4RunManager if it is used in the sequential mode.

 Log output
 G4cout is used for the geant4 master log (physics initialization and detector construction). It is redirected to a file by the glog class
 G4cout coming from the worker thread is re-directed to output by UIManager command.

cout is used for sequential log on screen by gemc.


 Memory usage
 
 First run valgrind (Linux): valgrind --tool=callgrind gemc /group/clas12/gemc/4a.1.1/clas12.gcard -USE_GUI=0 -N=100
 qcachegrind can be installed with brew on mac
 qcachegrind callgrind.out.<pid>
