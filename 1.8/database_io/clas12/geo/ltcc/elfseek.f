      PROGRAM AV
c     ==========
c
C    Purpose and methods : calculates focus points of the ellips
c                          and semi-axes
c                          using its 5-param. form:
C             p1*x**2+p2*y**2+p3*x*y+p4*x+p5*y+1=0
c
C    Created:   10-SEP-2009   Alexander V Vlassov
C
c=============================================================
c
      implicit none
c
      integer i,j
c
      double precision pe0(5,18),ph0(5,18),pe(5),ph(5),pd(5),exc,alc
      double precision cs,sn,ss,alpha,x_c,y_c,pi,aldeg,raddeg,a_ax,b_ax
      double precision f1x,f1y,f2x,f2y,skobka,ddd,sss,pc(5)
c
      real shf(2),axis1(18),axis2(18),focus1(2,18),focus2(2,18)
c
      data pi / 3.14159265358979324 /
      data raddeg /57.2957795130823209/
c
c
      data pe0 /
     1 -6.077340367482975E-05, -3.009328247571829E-05,
     1  4.851911853620549E-06, -2.684259321540594E-03,
     1  1.282648090273141E-02,
     2 -6.214775203261524E-05, -3.132118217763490E-05,
     2  8.401230843446683E-06, -4.176238086074590E-03,
     2  1.335206534713506E-02,
     3 -5.529043846763670E-05, -2.730170854192692E-05,
     3  3.705132940012845E-06,  2.657587465364485E-04,
     3  1.123890280723571E-02,
     4 -5.423010225058533E-05, -2.690152359718922E-05,
     4  4.722905941889621E-06,  4.733993555419147E-04,
     4  1.094712968915700E-02,
     5 -5.334062007023021E-05, -2.647465589689090E-05,
     5  4.755088411911856E-06,  1.388423028402030E-03,
     5  1.060978136956691E-02,
     6 -5.258136661723256E-05, -2.617923928482923E-05,
     6  5.270664132694946E-06,  1.920653972774744E-03,
     6  1.033128984272480E-02,
     7 -5.199034058023244E-05, -2.604955443530343E-05,
     7  6.222567662916844E-06,  2.089481335133314E-03,
     7  1.015397068113088E-02,
     8 -5.162054003449156E-05, -2.603724897198844E-05,
     8  7.086252026056172E-06,  2.240415895357728E-03,
     8  1.004421617835760E-02,
     9 -5.171889279154129E-05, -2.633548501762561E-05,
     9  8.221581083489581E-06,  2.269015880301594E-03,
     9  1.010975614190101E-02,
     A -5.182181848795153E-05, -2.673726703505963E-05,
     A  9.587453860149253E-06,  2.116384916007518E-03,
     A  1.023401133716106E-02,
     1 -5.226489884080365E-05, -2.772782499960158E-05,
     1  1.206817614729516E-05,  1.088266726583242E-03,
     1  1.071925275027751E-02,
     2 -4.068568887305445E-05, -2.299850893905386E-05,
     2  7.539211310358950E-06,  2.430732594802975E-03,
     2  8.428963832557201E-03,
     3 -4.084609463461674E-05, -2.365567343076691E-05,
     3  9.143265742750372E-06,  1.814155722968280E-03,
     3  8.755354210734367E-03,
     4 -3.406752875889651E-05, -2.093213697662577E-05,
     4  6.825904620200162E-06,  2.443424193188548E-03,
     4  7.472269237041473E-03,
     5 -3.355958324391394E-05, -2.098092591040767E-05,
     5  7.567465672764228E-06,  2.357408637180924E-03,
     5  7.378464564681053E-03,
     6 -3.308136729174293E-05, -2.108723856508731E-05,
     6  8.288641765830107E-06,  2.279550768435001E-03,
     6  7.308232598006725E-03,
     7 -3.269118678872473E-05, -2.130477878381498E-05,
     7  9.030843102664221E-06,  2.227053279057145E-03,
     7  7.284171413630247E-03,
     8 -3.232768358429893E-05, -2.138056333933491E-05,
     8  9.471052180742844E-06,  2.335202414542436E-03,
     8  7.172088604420423E-03 /
C
C
C --- Input parameters for elliptical and hyperbolic mirrors
c
c   ================================================================
c
      do j = 1,18
c     ===========
      pe(1) = pe0(1,j)
      pe(2) = pe0(2,j)
      pe(3) = pe0(3,j)
      pe(4) = pe0(4,j)
      pe(5) = pe0(5,j)
c
      print *,'  '
      print *,' *** new channel   ***',j,'   ***'
c
      print *,'pe'
      print 900,pe
c
c     center of an ellips
c
      print *,'Elliptica center :'
c
      ddd =  pe(3)*pe(3) - 4.0d0 * pe(1)*pe(2)
      x_c = ( 2.0d0 * pe(2)*pe(4) - pe(3)*pe(5) ) / ddd 
      y_c = ( 2.0d0 * pe(1)*pe(5) - pe(3)*pe(4) ) / ddd 
      print 900, x_c,y_c
c
      ddd = 1.0d00 + pe(1)*x_c*x_c + pe(2)*y_c*y_c + pe(3)*x_c*y_c
     & + pe(4)*x_c + pe(5)*y_c
      pd(1) = pe(1) / ddd
      pd(2) = pe(2) / ddd
      pd(3) = pe(3) / ddd
      pd(4) = (pe(4) + pe(3)*y_c + 2.0d00*pe(1)*x_c) / ddd
      pd(5) = (pe(5) + pe(3)*x_c + 2.0d00*pe(2)*y_c) / ddd
c
      print *,' parameters after the shift ;'
      print 900, pd
c

      ss = pe(3)/(pe(1) - pe(2))
c      print *,'ss'
c      print 900,ss
      alpha = 0.5*datan(ss)
c      print *,'alpha ='
c      print 900,alpha
      aldeg = raddeg*alpha
c      print *,' alpha in degrees',aldeg
c
      alpha = 0.5*pi + alpha
c      alpha = - alpha
c
      aldeg = raddeg*alpha
      print *,' alpha in degrees',aldeg
      print *,' turn the ellips on -alpha'
      cs = dcos(-alpha)
      sn = dsin(-alpha)
c      print *,'cos,sin'
c
c      print 900, cs,sn
c
      pc(1) =  pd(1)*cs*cs + pd(2)*sn*sn - pd(3)*sn*cs
      pc(2) =  pd(1)*sn*sn + pd(2)*cs*cs + pd(3)*sn*cs
      pc(3) =  2.*sn*cs*(pd(1)-pd(2)) + pd(3)*(cs*cs -sn*sn)
      pc(4) =  pd(4)*cs - pd(5)*sn  
      pc(5) =  pd(5)*cs + pd(4)*sn 
      print *,'parameters after the turn :'
      print 900,pc
c
c     semi-axis :
c
      skobka = 0.25d00*pc(4)*pc(4)/pc(1)+0.25d00*pc(5)*pc(5)/pc(2) - 1.
      a_ax = dsqrt( skobka / pc(1))
      b_ax = dsqrt( skobka / pc(2))
      print *,'skobka =',skobka
      print *,'axis a,b :'
      print 900, a_ax, b_ax
c
c excentricitet
c
      exc = dsqrt(1.0d00 - b_ax*b_ax/(a_ax*a_ax))
      print *,'excentricitet :'
      print 900, exc
c 
      alc = dsqrt(a_ax*a_ax - b_ax*b_ax)
      print *,'distance from the center to focus :'
      print 900, alc
c 
      f1x =  x_c - alc*cs
      f1y =  y_c + alc*sn
      f2x =  x_c + alc*cs
      f2y =  y_c - alc*sn
c
      print *,'Focus position : f1,f2:'
      print 900,f1x,f1y,f2x,f2y
      print *,'    =================  end of channel ',j,'  ========='
      print *,' '
c
      axis1(j) = a_ax
      axis2(j) = b_ax
      focus1(1,j) = f1x
      focus1(2,j) = f1y
      focus2(1,j) = f2x
      focus2(2,j) = f2y
c
      end do
c
      print *,'Axis a :'
      print *,axis1
c
      print *,'Axis b :'
      print *,axis2
c
      print *,'First focus :'
      print *,focus1
c
      print *,'Second focus :'
      print *,focus2
c
      stop
 900  format(5d25.15)
C
      stop
      END
