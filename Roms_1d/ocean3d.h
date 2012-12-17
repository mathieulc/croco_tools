!
! ocean variables
!
! t          Tracer type variables (usually, potential temperature
!              and salinity).
! u          U-momentum component (m/s). 
! v          V-momentum component (m/s).  
! w          vertical velocity (m/s).
! rhop0      Density anomaly (kg/m3).  
! rho1       Density(kg/m3).  
! bvf        Brunt-Vaisala frequency squared (1/s2). 
! tnudge     Data towards which the tracers are relaxed.
! delta      Inverse time scale (1/s) of the nudging towards tracer data.
!
      real u(N,2),   v(N,2),  w(0:N),   t(N,2,NT),
     &     rhop0(N), rho1(N), bvf(0:N), tnudge(N,NT),  delta(N)
      common /ocean/ u,v,w,t, rhop0, rho1, bvf, tnudge, delta