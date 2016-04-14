c
      SUBROUTINE CCDEIN
CA)========================================(begin of short description)
C     CC GEOMETRICAL INITIALIZATION
CB)-----------------------------------------(begin of long description)
C
C    Purpose and methods : To open files for CC geometrie initialization
C                          and close them after filling common /CCP/
C
C    Called by:      CCINIT
C
C    Input arguments : None
C    Input/output arguments : None
C    Output arguments : None
C----------------------------------------------------------------------
C
C    Side effects : Common /CCP/ initialisation.
C
C-
C-   Created  16-APR-1994   Alexander V. Vlassov
C-
C    Modified:
C
CC)-------------------------------------------(end of long description)
CD)----------------------------------(declare common blocks, variables)
************   +SEQ, CCP.    *******************************************
************   +SEQ, CCP.    ********************************************
C
C --- Common /CCP/ - geometry --------------------------------------------
C
C --- Parameters of mirror definition p1*x2+p2*y2+p3*xy+p4*x+p5*y+1=0
C-   pe0 - elliptic mirror parameters
C-   ph0 - hiperbolic mirror parameters
C-   pwo - WC ellips parameters in its coordinate system:
C-     pw0(1)*x**2 + pw0(2)*y**2 + pw0(3)*z**2 + 1 = 0
C-     where z is along the biggest axis of the ellips.
C-   wc0 - coordinates of WC window center.
C-   pmt0 - coordinates of PMT center.
C-     PMT assume to be flat
C-   wcr  - WC max radius
C-   wcer - WC window radius
C-   pmtr - radius of PMT
C-   dplwc - distance between two planes in WC.
C-   wcang - angle between this planes and Segment median plane.
C-     PLANES ARE DEFINED as p(1)*x + p(2)*y + p(3)*z + 1.0 = 0
C-
C-   p00 - Sector middle plane
C-   p10 - PMT black wall
C-   p20 - Coil plane
C-   p30 - WC window plane
C-   p40 - PMT plane
C-   p50 - Bottom black wall
C-   p60 - edge plane between this CC segment and smaller number one
C-   p70 - edge plane between this CC segment and bigger number one
C-   p80 - bounding WC plane between this WC segment and smaller WC.
C-   p90 - bounding WC plane between this WC segment and bigger WC.
C-   pa0 - Plane, parallel to Sector Dividing plane,at dist. 1in.
C-         ( surface of the sidewall)
C-   pb0 - Additional mirror surface.
C-
c-   x11,y11 - x12,y12 : PMT side wall plane
c-   x11,y11 (in the WC window plane) is the point in OUTER
c-   WC surface (shield?), nearest to the middle plane
c-   x12,y12 is the distant edge of elliptic mirror
c-
c-   x21,y21 - x22,y22 : COIL plane
c-   x22,y22 is the distant point of inner surface of WC window.
c-   x21,y21 defines an edge point for all CC section when discribed
c-   as a trapezoid. If photon crosses this plane in positive
c-   direction, it suppose to be absorbed.
c-
c-   csa0 - angle between Y and WC axis (in radians).
c-   sw0  - WC elliptical surface center coordinates in SEGment
c-   Reference System. They are used for Reference transformation
c-   between CC SEGment R.S. and WC R.S.
c-
c-   th - polar angles (in degree) of the centers of cc segment
c-   thmin - polar angles of planes between CC segments.
c-   ****  should be redefined ! ****
c-
c-   xp1,yp1 - xp2,yp2  : PMT coordinates are calculated.
c-
c-   x_pl - X coordinate of the beginning of flat part of
c-   elliptic mirror: 7.0 or 10.0 cm
c-   elt_pl - this plane parameters 
c-
c-   hwcpmt - distance between WC window and PMT planes
c-
c-   pwc10  - parameters of WC bounding plane (near the smaller CC #)
c-   pwc20  - parameters of WC bounding plane (near the bigger  CC #)
c-
c-   hwde   - half of the elliptical width
c-   hwdh   - half of the hiperbolic width
c-
c-   cmsx1,cmsx2   - coordinates of the Magnetic Shield axis points
c- 
c-   hmssz  - half of the Magnetic Shield walls sizes
c-   
c-   plms0  - Magnetic shield planes parameters
c-      
c-   pcms0  - Magnetic shield points coordinates - center of MS (1),
c-          centers of MS walls (4) and center of MS enterance window (1)
c-   
c-   plmsw  - Magnetic shield window plane parameters
c- 
c-   scrnp1,scrnp2 - two points on the sidewall: first - center
c-                   of the screen, second - center of the hole
c- 
      REAL pe0,ph0,pw0,p00,p10,p20,p30,p40,p50,p60,p70,p80,p90,pa0
      REAL x11,y11,x12,y12,x21,y21,x22,y22,pb0
      REAL csa0,wc0,sw0,th,thmin,xp1,yp1,xp2,yp2
      REAL x_pl,elt_pl,pmt0,wcr,wcer,pmtr,dplwc,wcang,hwcpmt
      REAL pwc10,pwc20,hwde,hwdh,cmsx1,cmsx2,hmssz,plms0,pcms0
      REAL plmsw, scrnp1, scrnp2, wcz, wcxy
c
      COMMON/CCP/pe0(5,18),ph0(5,18),pw0(3,18),wc0(3,18),
     *  pmt0(3,18),wcr(18),wcer(18),pmtr(18),dplwc(18),wcang(18),
     *  p00(3),p10(3,18),p20(3,18),p30(3,18),p40(3,18),
     *  p50(3,18),p60(3,18),p70(3,18),p80(3,18),p90(3,18),pa0(3,18),
     *  x11(18),y11(18),x12(18),y12(18),x21(18),y21(18),x22(18),
     *  y22(18),xp1(18),yp1(18),xp2(18),yp2(18),csa0(18),sw0(3,18),
     *  th(18),thmin(19),pb0(3,18),
     *  x_pl(18),elt_pl(3,18),hwcpmt(18),pwc10(3,18),pwc20(3,18),
     *  hwde(18),hwdh(18),cmsx1(3,18),cmsx2(3,18),hmssz(3,18),
     *  plms0(3,5,18),pcms0(3,6,18),plmsw(3,18),scrnp1(3,18),
     *  scrnp2(3,18), wcz(18), wcxy(18)
C
***************************************************8
C
C     Extracted parameters for ONE cc segment.
c-    Optionally filled by CCDEFPAR subroutine.
c-
c-    PE = pe0(i) ; PH = ph0(i) ; PW = pw0(i) ;
c-    P1,...P9,PA = p10(i),...p90(i),PA(i) ;
c-    PE_PL = elt_pl(i) ;
c-    WCC = wc0(i) ; SW = sw0(i) ;
c-    CSA = csa0(i) ;
c-    XE_PL = x_pl(i) ;
c-    pwc1,pwc2 = pwc10(i),pwc20(i)
c-    plms = plms0( , ,i)
c-    pcms = Magnetic Shield Point Coordinates - 4 points of 5 walls 
c-    scrp1,scrp2 = scrnp1(i), scrnp2(i)
c- 
      REAL PE,PH,PW,P1,P2,P3,P4,P5,P6,P7,P8,P9,PA,PB,
     *  PE_PL,WCC,SW,CSA,XE_PL,pwc1,pwc2,plms,pcms,scrp1,scrp2
C-
      COMMON /CCPW/ PE(5),PH(5),PW(3),P1(3),P2(3),P3(3),P4(3),
     *  P5(3),P6(3),P7(3),P8(3),P9(3),PA(3),PB(3),
     *  PE_PL(3),WCC(3),SW(3),CSA,XE_PL,
     *  pwc1(3),pwc2(3),plms(3,5),pcms(3,4,5),scrp1(3),scrp2(3)
C----
************   +SEQ, CCP.    ********************************************
C
***************   +SEQ, CCFRMP.      **********************************
c
C --- COMMON /CCFRMP/ Coordinates for frame draw in ccview.
c
c --- mirrn - number of points for mirrors
c --- nwcon - number of points for WC
c
c --- xell(j,i),yell(j,i) - elliptical mirror coordinates
c --- xhyp(j,i),yhyp(j,i) - hyperbolic mirror coordinates
c
c --- xw1(j,i),yw1(j,i) - WC surface nearest to the middle plane
c --- xw2(j,i),yw2(j,i) - WC surface far from the middle plane
c
c --- xcms(j,i,k) - X Coordinates for Magnetic Shield walls
c --- ycms(j,i,k) - Y Coordinates for Magnetic Shield walls
c --- zcms(j,i,k) - Z Coordinates for Magnetic Shield walls
c                   j - point # (1-4); i - wall # (1-4); k - CC#         
      integer mirrn,nwcon
c
      parameter (mirrn=99)
      parameter (nwcon=25)
c
      real xell,yell,xhyp,yhyp,xw1,yw1,xw2,yw2,xcms,ycms,zcms
c
      COMMON /CCFRMP/ xell(mirrn,18),yell(mirrn,18),
     &                xhyp(mirrn,18),yhyp(mirrn,18),
     &  xw1(nwcon,18),yw1(nwcon,18),xw2(nwcon,18),yw2(nwcon,18),
     &  xcms(4,4,18),ycms(4,4,18),zcms(4,4,18)
c
c ===============================================================
c
***************   +SEQ, CCFRMP.      **********************************
*******************   +SEQ, GCONSP.    ***************************** 
      DOUBLE PRECISION PI,TWOPI,PIBY2,DEGRAD,RADDEG,CLIGHT,BIG,EMASS
      DOUBLE PRECISION EMMU,PMASS,AVO
*
      PARAMETER (PI=3.14159265358979324)
      PARAMETER (TWOPI=6.28318530717958648)
      PARAMETER (PIBY2=1.57079632679489662)
      PARAMETER (DEGRAD=0.0174532925199432958)
      PARAMETER (RADDEG=57.2957795130823209)
      PARAMETER (CLIGHT=29979245800.)
      PARAMETER (BIG=10000000000.)
      PARAMETER (EMASS=0.0005109990615)
      PARAMETER (EMMU=0.105658387)
      PARAMETER (PMASS=0.9382723128)
      PARAMETER (AVO=0.60221367)
*******************   +SEQ, GCONSP.    ***************************** 
c
C
C  Variables in argument list: None
C  Save variables:
C  External references:
CE)===============================================(end of declarations)
C
C-----------------------------------------------------------------------
c
      real vdot, vdist
      external vdot, vdist
c
      INTEGER i,j,ncc,k
      INTEGER LUNG,ISTAT,IRES
c
      REAL vlar,r(5),t(4),s,d,ve(3),xv(3),xu(3),ul(3),teta
      REAL tg,tm(3),pm(3), xmi,xma
      real Z(3), al, xms(3,7), pms(3,4,4)
c
      DATA vlar /1000001./
      DATA Z /0., 0., 0./
C
C ----- end of declarations
C
***************************************************
C----
    1 FORMAT(5D24.16)
C
***************************************************8
C
C --- Input parameters for elliptical and hyperbolic mirrors
C
      LUNG = 33
C
      OPEN( UNIT=LUNG, FILE='ccgeom.dat',
     &  STATUS='OLD',FORM='FORMATTED',ACCESS='SEQUENTIAL')
      write(*,*) ' File for geometry parameters is open - Lun:',LUNG
C
      DO i=1,18
        READ (LUNG,*,end=2) r
        call ucopy(r,pe0(1,i),5)
      END DO
c
      DO i=1,18
        READ (LUNG,*,end=2) r
        call ucopy(r,ph0(1,i),5)
      END DO
c
      do i = 1,18
        read(LUNG,*,end=2) j,wc0(1,i),wc0(2,i),pmt0(1,i),pmt0(2,i),
     &  wcr(i),pmtr(i),dplwc(i),wcang(i)
        wc0 (3,i) = 0.
        pmt0(3,i) = 0.
         write(*,*) j, wc0(1,i), wc0(2,i), wc0(3,i), pmt0(1,i),
     &  pmt0(2,i), pmt0(3,i), wcr(i), pmtr(i), dplwc(i), wcang(i)
      end do
c
C --- Input parameters for PMT wall
c
      DO i=1,18
        READ (LUNG,*) t
        x11(i)= t(1)
        y11(i)= t(2)
        x12(i)= t(3)
        y12(i)= t(4)
      END DO
c
C --- Input parameters for coil plane
c
      DO i=1,18
        READ (LUNG,*) t
        x21(i)= t(1)
        y21(i)= t(2)
        x22(i)= t(3)
        y22(i)= t(4)
      END DO
c
      DO i=1,18
        READ (LUNG,*) hwde(i), hwdh(i), wcz(i), wcxy(i),
     &  cmsx1(2,i), cmsx1(3,i), cmsx2(2,i), cmsx2(3,i),
     &  hmssz(1,i),  hmssz(2,i),  hmssz(3,i)
        cmsx1(1,i) = 0.  
        cmsx2(1,i) = 0.  
      END DO
c
      DO i=1,18
        READ (LUNG,*) j, thmin(i), th(i), scrnp1(1,i),
     &  scrnp1(2,i), scrnp2(1,i), scrnp2(2,i)
        scrnp1(3,i) = 0.  
        scrnp2(3,i) = 0.  
      END DO
c
      read (lung,*) j,thmin(19)
c
C---- end of reading -----
c
      CLOSE (LUNG)
c
      write(*,*) ' File for geometry parameters is closed - Lun:',LUNG
c
C
c---   PARAMETER calculations   ----
c
      ENTRY CCPARM
c     ============
c
C     Winstone Cone parameters
C
      DO i=1,18
C
C ---  Parameters for Winston Cone slope
C
        s = (wc0(1,i) - pmt0(1,i))*(wc0(1,i) - pmt0(1,i))
     &    + (wc0(2,i) - pmt0(2,i))*(wc0(2,i) - pmt0(2,i))
        d = ( pmt0(1,i) - wc0(1,i) )/sqrt(s)
        csa0(i)=asin(d)
c-
        call ccwcpar(i,wcz(i),wcxy(i),sw0(1,i),pw0(1,i),wcer(i))
c-
      END DO
C
      write(*,*) 'csa0',csa0
      write(*,*) 'sw0',sw0
c-
c-    Let's redefine x11,y11,x22,y22
c     ==============================
c-
      do i = 1,18
c-
        d = csa0(i)
        x11(i) = wc0(1,i) - wcr(i)*cos(d)
        y11(i) = wc0(2,i) + wcr(i)*sin(d)
        x22(i) = wc0(1,i) + wcr(i)*cos(d)
        y22(i) = wc0(2,i) - wcr(i)*sin(d)
c-
c-    Let's define xp1,yp1,xp2,yp2
c     ============================
c
        xp1(i) = pmt0(1,i) - pmtr(i)*cos(d)
        yp1(i) = pmt0(2,i) + pmtr(i)*sin(d)
        xp2(i) = pmt0(1,i) + pmtr(i)*cos(d)
        yp2(i) = pmt0(2,i) - pmtr(i)*sin(d)
c-
      end do
c
      write(*,*) 'x22',x22
      write(*,*) 'y22',y22
c
C --- Middle plane  ----
c
      p00(1)=vlar
      p00(2)=0.
      p00(3)=0.
c
C --- Up-Front line (wall of PMT)
c
      DO i=1,18
        d=x11(i)*y12(i)-x12(i)*y11(i)
        p10(1,i)=(y11(i)-y12(i))/d
        p10(2,i)=(x12(i)-x11(i))/d
        p10(3,i)=0.
      END DO
c
C --- Back-bottom (under PMT) line
c
      DO i=1,18
        d=x21(i)*y22(i)-x22(i)*y21(i)
        p20(1,i)=(y21(i)-y22(i))/d
        p20(2,i)=(x22(i)-x21(i))/d
        p20(3,i)=0.
      END DO
c
C --- Input in Winston Cone (WC window plane)
c
      DO i=1,18
        d = 0.
        hwcpmt(i) = 0.
        do j = 1,3
          ve(j) = pmt0(j,i) - wc0(j,i)
          d = d + wc0(j,i)*ve(j)
          hwcpmt(i) = hwcpmt(i) + ve(j)*ve(j)
        end do
        hwcpmt(i) = sqrt(hwcpmt(i))
        do j = 1,3
          p30(j,i) = -ve(j)/d
        end do
      END DO
c
C --- PhotoMultipier Tube window plane (PMT plane)
c
      DO i=1,18
        d = 0.
        do j = 1,3
          ve(j) = pmt0(j,i) - wc0(j,i)
          d = d + pmt0(j,i)*ve(j)
        end do
        do j = 1,3
          p40(j,i) = -ve(j)/d
        end do
      END DO
c
C --- bottom black wall around hyperbolic mirror
c
      DO i=1,18
        p50(1,i)=0.
        p50(2,i)=-1./y21(i)
        p50(3,i)=0.
      END DO
c
C --- close plane(mirror for #18),through it light comes to next CC sect.
c
      DO i=1,18
        d=(th(i)-thmin(i))*DEGRAD
        tg=tan(d)
        p60(1,i)=0.
        p60(2,i)=-vlar
        p60(3,i)=-vlar/tg
      END DO
c
C --- fare plane(mirror for # 1),through it light comes to prev. CC sect.
c
      DO i=1,18
        d=(thmin(i+1)-th(i))*DEGRAD
        tg=tan(d)
        p70(1,i)=0.
        p70(2,i)=-vlar
        p70(3,i)=vlar/tg
      END DO
c
C --- X-loc., where elliptical mirrow should be replaced by attached plane
C
      do i = 1,18
         x_pl(i) = 7.5
         if(i.ge.11) x_pl(i) = 10.0
      end do
c
C --- Plane parameters of this attached plane:
C     in form elt_pl(1)*x + elt_pl(2)*y + elt_pl(3)*z + 1 = 0.
C
      xv(3) = 0.
c
      ve(1) = 0.
      ve(2) = 1.
      ve(3) = 0.
c
      do i = 1,18
c
c     crossing point :
c
        xv(1) = x_pl(i)
        xv(2) = 0.
        call CCROSE(xv,ve,pe0(1,i),IRES,S,R)
        if(IRES.ne.1) then
          print *,'pe0 :',pe0(1,i),pe0(2,i),pe0(3,i)
          print *,'pe0 :',pe0(4,i),pe0(5,i)
          print *,' i, xv,ve,IRES',i,xv,ve,IRES
          write (*,*) ' Wrong code from CCROSE'   
        end if
C
        d = R(2)
        xv(2) = R(2)
C*******
        elt_pl(1,i) = 2*pe0(1,i)*xv(1) + pe0(3,i)*xv(2) + pe0(4,i)
        elt_pl(2,i) = 2*pe0(2,i)*xv(2) + pe0(3,i)*xv(1) + pe0(5,i)
        elt_pl(3,i) = 0.
C*******
        S = elt_pl(1,i)*xv(1) + elt_pl(2,i)*xv(2)
        elt_pl(1,i) = -elt_pl(1,i) / S
        elt_pl(2,i) = -elt_pl(2,i) / S
C*******
      end do
c
c    Plane parameters for WC bounding planes
c
      do i = 1,18
c
c *****  turn in contra-clockwise direction
c
        pwc10(1,i) =  2.*cos(degrad*wcang(i))/dplwc(i)
        pwc10(2,i) =  2.*sin(degrad*wcang(i))/dplwc(i)
        pwc10(3,i) =  0.
c
        pwc20(1,i) = -2.*cos(degrad*wcang(i))/dplwc(i)
        pwc20(2,i) = -2.*sin(degrad*wcang(i))/dplwc(i)
        pwc20(3,i) =  0.
c
c     Parameters of these planes in CC SEGment system
c
        ncc = i
        d     = degrad*wcang(i)   ! in radians
c
        ul(1) =  cos(d)
        ul(2) =  sin(d)
        ul(3) =  0.
c
c  ******  P80  ******
c
        xu(1) =  -dplwc(i)*cos(d)/2.
        xu(2) =  -dplwc(i)*sin(d)/2.
        xu(3) =   0.
c
c
c   From WC to CC Reference System :
c
        call CCFRWC(ncc,xu,ul,xv,ve)
c
c       Now xv and ve - point on the plane and plane unit vector
c
*        write(nlo,*) 'xv',xv
*        write(nlo,*) 've',ve
c
        s = vdot(xv,ve,3)
*        write(nlo,*) s
        do j = 1,3
          P80(j,i) = -ve(j)/s
        end do
c
c  ******  P90  ******
c
        xu(1) =  dplwc(i)*cos(d)/2.
        xu(2) =  dplwc(i)*sin(d)/2.
        xu(3) =  0.
c
c
c   From WC to CC Reference System :
c
        call CCFRWC(ncc,xu,ul,xv,ve)
c
c       Now xv and ve - point on the plane and plane unit vector
c
        d = vdot(xv,ve,3)
        do j = 1,3
          P90(j,i) = -ve(j)/d
        end do
c
      end do
c------------------------------------------------------------------
c
c    Parameters of the inner surface of the SideWall
c    ( 2.54 cm apart from the Sector Dividing plane )
c
c
c    Plane parameters
c
      xv(1) = sqrt(3.)/2.
      xv(2) = -0.5
      xv(3) =  0.
c
      ve(1) = - 2.54 * sqrt(3.) / 2.
      ve(2) =  2.54  / 2.
      ve(3) = 0.
c
c
c   TO NEW ( CC_i ) Reference System :
c
      do i = 1,18
        teta = th(i) - 90.
c
        tm(1) = 90.
        tm(2) = 90. - teta
        tm(3) = -teta
c
        pm(1) =  0.
        pm(2) = 90.
        pm(3) = 90.
c
C------------------------------------------------------------
        call CCREFS(ve,xv,tm,pm,Z,xu,ul)
c
c ==============================================================
c
        d = vdot(xu,ul,3)
c
        do j = 1,3
          PA0(j,i) = -ul(j)/d
        end do
c
      end do
c
C --- New reflection plane (under WC window)
c
      DO i=1,18
        d = x22(i)*x22(i)+y22(i)*y22(i)-x11(i)*x22(i)-y11(i)*y22(i)
        pb0(1,i)=(x11(i)-x22(i))/d
        pb0(2,i)=(y11(i)-y22(i))/d
        pb0(3,i)=0.
      END DO
c

C----------------------------------------------------------------
c    Magnetic shield planes definitions   
C----------------------------------------------------------------
c
      do i = 1,18
c
c   ****   Point definitions in the R.S. of the "TURNED WC" ***
c  Center of MS :
c
        do j = 1,3
          xms(j,1) = 0.5*(cmsx1(j,i) + cmsx2(j,i))
        end do
        teta = atan((cmsx2(2,i)-cmsx1(2,i))/(cmsx2(3,i)-cmsx1(3,i)))
c
c  Centers of walls      
c
        xms(1,2) = xms(1,1) 
        xms(2,2) = xms(2,1) - hmssz(2,i)*cos(teta) 
        xms(3,2) = xms(3,1) + hmssz(2,i)*sin(teta)
c
        xms(1,3) = xms(1,1) + hmssz(1,i) 
        xms(2,3) = xms(2,1) 
        xms(3,3) = xms(3,1)
c
        xms(1,4) = xms(1,1) 
        xms(2,4) = xms(2,1) + hmssz(2,i)*cos(teta) 
        xms(3,4) = xms(3,1) - hmssz(2,i)*sin(teta)
c
        xms(1,5) = xms(1,1) - hmssz(1,i) 
        xms(2,5) = xms(2,1) 
        xms(3,5) = xms(3,1)
c
c    Center of MS window = lower end of the MS axes
c
        call ucopy(cmsx1(1,i),xms(1,6),3)
        call ucopy(cmsx2(1,i),xms(1,7),3)
c
c  Now transfer these coordinates to the CC R.S. :
c
        xu(1) = 0.
        xu(2) = 0.
        xu(3) = 1.
c
        do j = 1,7
          call CCWCFRS(i,xms(1,j),xms(1,j))
          call CCFRWC(i,xms(1,j),xu,xms(1,j),xv)
        end do
c
c   Plane parameters definitions :
c
c   Planes #1 - #4 :
c
        do j = 1,4
c
          k = j+1
          call vsub(xms(1,k),xms(1,1),ve,3)
          d = -1./vdot(ve,xms(1,k),3)
          call vscale(ve,d,plms0(1,j,i),3)
c
        end do
        call vsub(xms(1,7),xms(1,1),ve,3)
        d = -1./vdot(ve,xms(1,7),3)
        call vscale(ve,d,plms0(1,5,i),3)
c
c       SAVE xms coordinates :
c       ====================
        call ucopy(xms,pcms0(1,1,i),18)   ! 18 = 3 * 6
c
      end do
c
C----------------------------------------------------------------
c               /CCFRMP/ parameters definition
C----------------------------------------------------------------
c
      do i = 1,18
c
        ncc = i
        call ccdefpar(i)
c
        xmi = 0.
        xma = x12(i)
        d   = (xma-xmi)/(mirrn - 1.)
c
        xu(2) = 0.
        xu(3) = 0.

        xv(1) = 0.
        xv(2) = 1.
        xv(3) = 0.
c ===  Ellips
        DO j = 1,mirrn
c       ==============
c
          xu(1) = xmi + d*(j-1)
          xell(j,i) = xu(1)
          call CCROSE(xu,xv,PE,IRES,S,R)
          yell(j,i) = R(2)
c
        END DO
c
        xu(2) = 500.
        xv(2) = -1.
        xma   = x21(i)
        d   = (xma-xmi)/(mirrn - 1.)
c ===  Hyperbola
        DO j = 1,mirrn
c       ==============
c
          xu(1) = xmi + d*(j-1)
          xhyp(j,i) = xu(1)
          call CCROSH(xu,xv,PH,IRES,S,R)
          yhyp(j,i) = R(2)
c
        END DO
c
c ===  Winston cone  ===
c
        teta  =  csa0(i)
        xv(1) = -cos(teta)
        xv(2) =  sin(teta)
        xv(3) =  0.
        xu(3) =  0.
c
        s = (wc0(1,i) - pmt0(1,i))*(wc0(1,i) - pmt0(1,i))
     &    + (wc0(2,i) - pmt0(2,i))*(wc0(2,i) - pmt0(2,i))
        d = sqrt(s)/(nwcon - 1.)
c 
        do j = 1,nwcon
c       ==============
c
          xu(1) = wc0(1,i) + d*(j-1)*sin(teta)
          xu(2) = wc0(2,i) + d*(j-1)*cos(teta)
c
*          s  = d*(j-1)
          s  = vdist(xu,sw0(1,i),3)
          al = -(pw(3)*s*s + 1.)/pw(1)
          al = sqrt(al)
c
          xw1(j,i) = xu(1) + al*xv(1)
          yw1(j,i) = xu(2) + al*xv(2)
c
          xw2(j,i) = xu(1) - al*xv(1)
          yw2(j,i) = xu(2) - al*xv(2)
c
        end do
c
C----------------------------------------------------------------
c    Magnetic shield walls 
C----------------------------------------------------------------
c
c       RESTORE xms coordinates :
c       =========================
        call ucopy(pcms0(1,1,i),xms,18)   ! 18 = 3 * 6
c
        call vsub(xms(1,6),xms(1,1),ve,3)
        call vsub(xms(1,2),xms(1,1),xu,3)
        call vsub(xms(1,3),xms(1,1),xv,3)
c
c   Wall #1
c
        call vadd(xms(1,2),ve,        ul,3)
        call vadd(      ul,xv,pms(1,1,1),3)
        call vsub(      ul,xv,pms(1,2,1),3)
        call vsub(xms(1,2),ve,        ul,3)
        call vsub(      ul,xv,pms(1,3,1),3)
        call vadd(      ul,xv,pms(1,4,1),3)
c
c   Wall #2
c
        call vadd(xms(1,3),ve,        ul,3)
        call vadd(      ul,xu,pms(1,1,2),3)
        call vsub(      ul,xu,pms(1,2,2),3)
        call vsub(xms(1,3),ve,        ul,3)
        call vsub(      ul,xu,pms(1,3,2),3)
        call vadd(      ul,xu,pms(1,4,2),3)
c
c   Wall #3
c
        call vadd(xms(1,4),ve,        ul,3)
        call vadd(      ul,xv,pms(1,1,3),3)
        call vsub(      ul,xv,pms(1,2,3),3)
        call vsub(xms(1,4),ve,        ul,3)
        call vsub(      ul,xv,pms(1,3,3),3)
        call vadd(      ul,xv,pms(1,4,3),3)
c
c   Wall #4
c
        call vadd(xms(1,5),ve,        ul,3)
        call vadd(      ul,xu,pms(1,1,4),3)
        call vsub(      ul,xu,pms(1,2,4),3)
        call vsub(xms(1,5),ve,        ul,3)
        call vsub(      ul,xu,pms(1,3,4),3)
        call vadd(      ul,xu,pms(1,4,4),3)
c
        do k = 1,4
          do j = 1,4
            xcms(j,k,i) = pms(1,j,k)
            ycms(j,k,i) = pms(2,j,k)
            zcms(j,k,i) = pms(3,j,k)
          end do
        end do
c
      end do
c
c =====================================================
c
c ==============   end of definitions   ===============
c
c =====================================================
c
*      do i = 1,18
*        write(nlo,*) '*****************************************'
*        write(nlo,*) 'CC section ',i
*        write(nlo,*) '============================'
*        write(nlo,*) 'pw0',(pw0(j,i),j=1,3)
*        write(nlo,*) 'wc0',(wc0(j,i),j=1,3)
*        write(nlo,*) 'pmt0',(pmt0(j,i),j=1,3)
*        write(nlo,*) 'wcr',wcr(i)
*        write(nlo,*) 'wcer',wcer(i)
*        write(nlo,*) 'pmtr',pmtr(i)
*        write(nlo,*) 'dplwc',dplwc(i)
*        write(nlo,*) 'wcang',wcang(i)
*        write(nlo,*) '============================'
*        write(nlo,*) 'p10',(p10(j,i),j=1,3)
*        write(nlo,*) 'p20',(p20(j,i),j=1,3)
*        write(nlo,*) 'p30',(p30(j,i),j=1,3)
*        write(nlo,*) 'p40',(p40(j,i),j=1,3)
*        write(nlo,*) 'p50',(p50(j,i),j=1,3)
*        write(nlo,*) 'p60',(p60(j,i),j=1,3)
*        write(nlo,*) 'p70',(p70(j,i),j=1,3)
*        write(nlo,*) 'p80',(p80(j,i),j=1,3)
*        write(nlo,*) 'p90',(p90(j,i),j=1,3)
*        write(nlo,*) 'pa0',(pa0(j,i),j=1,3)
*        write(nlo,*) 'elt_pl',(elt_pl(j,i),j=1,3)
*        write(nlo,*) 'pwc10',(pwc10(j,i),j=1,3)
*        write(nlo,*) 'pwc20',(pwc20(j,i),j=1,3)
*        write(nlo,*) '============================'
*      end do
C-
      return
C
    2 continue
C  --- ERROR ---
      write(*,*) 'Unable to retrieve the DETECTOR information'
C
C
      RETURN
      END
c
