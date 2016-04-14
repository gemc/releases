      PROGRAM AV
c     ==========
c
C    Purpose and methods : calculates focus points of the hyperbola
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
      double precision ph0(5,18),pe0(5,18),pe(5),ph(5),pd(5),exc,alc
      double precision cs,sn,ss,alpha,x_c,y_c,pi,aldeg,raddeg,a_ax,b_ax
      double precision f1x,f1y,f2x,f2y,skobka,ddd,sss,pc(5)
c
      real shf(2),axis1(18),axis2(18),focus1(2,18),focus2(2,18)
c
      data pi / 3.14159265358979324 /
      data raddeg /57.2957795130823209/
c
      data ph0 /
     1 -3.769544036913430E-07,  5.213531949266325E-06,
     1  3.036938323930371E-06, -1.309770275838673E-03,
     1 -4.567536059767007E-03,
     2  3.106743804437428E-07,  5.258976671029813E-06,
     2  3.944012860301882E-06, -1.704570371657609E-03,
     2 -4.586969036608934E-03,
     3 -2.159462475503914E-08,  5.296890321915270E-06,
     3  2.934321628345060E-06, -1.252635032869875E-03,
     3 -4.603860899806022E-03,
     4 -2.249848130020382E-08,  5.316628175933146E-06,
     4  2.938454372269916E-06, -1.245374092832207E-03,
     4 -4.612906370311975E-03,
     5 -1.875937698514462E-07,  5.382762537919916E-06,
     5  2.167340653613791E-06, -9.005396859720349E-04,
     5 -4.641986452043056E-03,
     6 -2.531679399453423E-07,  5.450224307423923E-06,
     6  1.777606257746811E-06, -7.224114378914237E-04,
     6 -4.671597387641668E-03,
     7 -2.033357304753735E-07,  5.473571491165785E-06,
     7  2.163470753657747E-06, -8.776842732913792E-04,
     7 -4.682510159909725E-03,
     8 -2.275628645520555E-07,  5.486811460286844E-06,
     8  2.031285930570447E-06, -8.146020118147134E-04,
     8 -4.688984714448451E-03,
     9 -2.933105918145883E-07,  5.602359124168287E-06,
     9  1.626309881430643E-06, -6.296337815001606E-04,
     9 -4.738918039947748E-03,
     A -1.951799362132078E-07,  5.548074568650918E-06,
     A  2.281855586261372E-06, -9.032685193233191E-04,
     A -4.717167932540178E-03,
     1 -1.557730797685508E-07,  5.668020548910135E-06,
     1  1.986033339562709E-06, -7.805757340975105E-04,
     1 -4.767207428812980E-03,
     2 -1.626671348731178E-07,  5.625612175208516E-06,
     2  2.475829433024045E-06, -9.678160422481596E-04,
     2 -4.752129316329956E-03,
     3 -1.526413626606881E-07,  5.730169959861086E-06,
     3  2.164058969356119E-06, -8.373869350180029E-04,
     3 -4.795671440660953E-03,
     4 -2.475655094258399E-07,  5.628206508845323E-06,
     4  2.591487145764403E-06, -9.823220316320657E-04,
     4 -4.759370349347591E-03,
     5 -2.895388604429172E-07,  5.730966222472488E-06,
     5  2.432386281725484E-06, -8.973327348940074E-04,
     5 -4.804879892617464E-03,
     6 -2.351053325355678E-07,  5.706898718926822E-06,
     6  2.696277988434303E-06, -1.000696793198585E-03,
     6 -4.797415342181921E-03,
     7 -2.359388133754691E-07,  5.757787221227772E-06,
     7  2.700545110201346E-06, -9.890293003991246E-04,
     7 -4.821478854864835E-03,
     8 -2.427759397960471E-07,  5.819504167448030E-06,
     8  2.727268338276189E-06, -9.843894513323903E-04,
     8 -4.850162193179130E-03 /
C
C --- Input parameters for elliptical and hyperbolic mirrors
c
c   ================================================================
c
      do j = 1,18
c     ===========
      ph(1) = ph0(1,j)
      ph(2) = ph0(2,j)
      ph(3) = ph0(3,j)
      ph(4) = ph0(4,j)
      ph(5) = ph0(5,j)
c
      print *,'  '
      print *,' *** new channel   ***',j,'   ***'
c
      print *,'ph'
      print 900,ph
c
c     center of an ellips
c
      print *,'Hyperbola center :'
c
      ddd =  ph(3)*ph(3) - 4.0d0 * ph(1)*ph(2)
      x_c = ( 2.0d0 * ph(2)*ph(4) - ph(3)*ph(5) ) / ddd 
      y_c = ( 2.0d0 * ph(1)*ph(5) - ph(3)*ph(4) ) / ddd 
      print 900, x_c,y_c
c
      ddd = 1.0d00 + ph(1)*x_c*x_c + ph(2)*y_c*y_c + ph(3)*x_c*y_c
     & + ph(4)*x_c + ph(5)*y_c
      pd(1) = ph(1) / ddd
      pd(2) = ph(2) / ddd
      pd(3) = ph(3) / ddd
      pd(4) = (ph(4) + ph(3)*y_c + 2.0d00*ph(1)*x_c) / ddd
      pd(5) = (ph(5) + ph(3)*x_c + 2.0d00*ph(2)*y_c) / ddd
c
      print *,' parameters after the shift ;'
      print 900, pd
c

      ss = ph(3)/(ph(1) - ph(2))
      print *,'ss'
      print 900,ss
      alpha = 0.5*datan(ss)
c
      alpha = 0.5*pi + alpha
c      alpha = - alpha

c
      aldeg = raddeg*alpha
      print *,' alpha in degrees',aldeg
      print *,' turn the hyperbola on -alpha'
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
c
      print *,'skobka',skobka
c
      a_ax = dsqrt( skobka / pc(1))
      b_ax = dsqrt( -skobka / pc(2))
      print *,'axis a,b :'
      print 900, a_ax, b_ax
c
c excentricitet
c
      exc = dsqrt(1.0d00 + b_ax*b_ax/(a_ax*a_ax))
      print *,'excentricitet :'
      print 900, exc
c 
      alc = dsqrt(b_ax*b_ax - a_ax*a_ax)
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
      stop
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
