{
 // all dimensions are in mm


 double min_angle = 4.5;                        // 4.5 degrees in radians is the max opening angle of the absorber
 double att = atan(min_angle*3.14159265/180.0); // atan(min_angle)
 double TL        = 0.0;                        // Target length
 double max_thick = 120.0;                      // Max Outer Radius allowed (better match the ID of the Torus Ring)

 double dz        = 10.0;
 double startz    = 300.0;   // Start of the absorber
 double endz      = 4000.0;  // Approx torus z pos

 double zp, R;   // zp = position relative to the back of the target
 double zpp;     // position relative to the start of the absorber

 for(double iz = startz; iz<endz; iz += dz)
 {
    zp = iz - TL/2.0;
    zpp = iz - startz;
    R  = zp*att;
    if(R >max_thick) R = max_thick;
    cout << " z=" << iz << "       z'=" << zp << "          R=" << R << "        zpp=" << zpp << endl;

 }

}



