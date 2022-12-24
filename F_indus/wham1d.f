
      implicit none
      integer :: ndata, i, thda, ph1, ph2, arg1, arg2,
     +           arg3, arg4, asp1, asp2, mgcat, mgnuc,
     +           proc, nproc, opara, ind, j, ndata1,
     +           ntraj,bin, bin1, bin2
 
      integer :: nd, loop
      real(8) :: wttot, rmsd, low1, up1
      real(8), dimension(5000000,5) :: a,b,c,d
      real(8), dimension(50) :: k1, r1, k2,r2, fi, fip
      character(19) :: chdum1, chdum2
      real(8), dimension(50,200) :: hist1, hist2 ,hist3
      real(8), dimension(200) :: dis1, dis2, dis3, dis4, x1, x2
      character(4) :: filename, chdummy
      character(13) :: filename1, filename2, filename3,
     +                 filename4, filename5


      write (*,*) '# windows harvested, # points per window'
      read (*,*) ntraj, nd

      write (*,*) 'number of bins in fe-landscape (50-200)'
      read (*,*) bin
      write (*,*) 'low1, high1'
      read (*,*) low1, up1

      open (1, file = 'sampling', status = 'old')
      open (16, file='histres', status='unknown')
      open (17, file='freeene', status='unknown')
 
      hist1=0.0
      hist2=0.0
      hist3=0.0
! number of datapoints in simulation
!      nd=50

! number of windows
      do proc = 1,ntraj

      read (1,*) filename, k1(proc), r1(proc)
!                  , k2(proc), r2(proc)
      filename1 = filename // "/traj.out"

      open (11, file = filename1, status = 'old')
!      do j = 1, 14
!         read (11,*) chdummy
!      enddo

! reading the restraint distances
      do i = 1,nd
         read (11,*) a(i,1), a(i,2)
! binning the histograms      
         bin1=int(((a(i,1)-low1)/(up1-low1))*bin)+1
!         bin1=int(((a(i,1)-1.7)/(4.2-1.7))*200.0)+1
         hist1(proc,bin1)=hist1(proc,bin1)+1
      enddo
      close(11)
! biased distribution functions
      ndata=0
      do i=1,200
         ndata=ndata+hist1(proc,i)
      enddo

      do i=1,200
      hist1(proc,i)=hist1(proc,i)/ndata
      enddo

      enddo
! enddo number of windows

! histogram reweighting (WHAM algorithm)

! coordinate value for each bin
      do ph1=1,200
         x1(ph1)=(real(ph1)-0.5)*(up1-low1)/bin+low1
!         x1(ph1)=(real(ph1)-0.5)*(4.2-1.7)/200.0+1.7
      enddo


! Initialize unknown constants Fi(1) to Fi(50) to 1
      Fi=1.0

! self consistent solution by iteration
      do loop=1,10000

! equation 1
      dis1=0.0
      dis2=0.0
      dis3=0.0
      do ph1=1,200
         do proc=1,ntraj
            dis1(ph1)=dis1(ph1)+real(nd)*hist1(proc,ph1)
            wttot=0.5*(k1(proc)*(x1(ph1)-r1(proc))**2)/0.6
            dis2(ph1)=dis2(ph1)+real(nd)*exp(-wttot)*exp(Fi(proc))
            if ((dis1(ph1).gt.0.0).and.(dis2(ph1).gt.0))
     +           dis3(ph1)=dis1(ph1)/dis2(ph1)
         enddo
      enddo

! equation 2
      do proc=1,ntraj
         fip(proc)=0.0
         do ph1=1,200
            wttot=0.5*(k1(proc)*(x1(ph1)-r1(proc))**2)/0.6
            fip(proc)=fip(proc)+exp(-wttot)*dis3(ph1)
         enddo
         if (fip(proc).ne.0) fip(proc)=-log(fip(proc))
      enddo

! Assess convergence of fis
      rmsd=0.0
      do proc=1,ntraj
         rmsd=rmsd+(fip(proc)-fi(proc))**2
      enddo

      if (rmsd.lt.0.00001) then
         exit
! exit loop
      else
         ! next iteration
         do proc=1,ntraj
            fi(proc)=fip(proc)
         enddo
      endif

      write (*,*) '----------------------------------'
      write (*,*) loop, rmsd

      enddo
! enddo loop

! convergence acheived or not 
      if (loop.ge.10000) then
         write (*,*) "****Convergence Failure******"
      else
         write (*,*) "convergence acheived in steps=", loop
! Converged distribution in each window
         do ph1=1,bin
            if (dis3(ph1).ne.0) dis4(ph1)=-log(dis3(ph1))
            write (17,*) x1(ph1), dis4(ph1)
         enddo
      endif
      end

