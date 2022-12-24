
      implicit none
      integer :: ndata, i, thda, ph1, ph2, arg1, arg2,
     +           arg3, arg4, asp1, asp2, mgcat, mgnuc,
     +           proc, nproc, opara, ind, j, ndata1,
     +           ntraj,bin, bin1, bin2
 
      integer :: loop
      real(8) :: wttot, rmsd, explim, redum, low1, up1, low2, up2
      real(8), dimension(5000,5) :: a,b,c,d
      real(8), dimension(50) :: k1, r1, k2,r2, fi, fip
      character(19) :: chdum1, chdum2
      real(8), dimension(50,50,50) :: hist1, hist2 ,hist3
      real(8), dimension(50,50) :: dis1, dis2, dis3, dis4
      real(8), dimension(50) :: x1, x2
      integer, dimension(50) :: nd
      character(19) :: filename, chdummy
      character(24) :: filename1, filename2, filename3,
     +                 filename4, filename5
      character(4) :: chdum3
      character(3) :: chdum4
      character(2) :: chdum5


      write (*,*) 'number of windows harvested'
      read (*,*) ntraj

      write (*,*) 'number of bins in fe-landscape (5 to 50)'
      read (*,*) bin

      write (*,*) 'low1, high1, low2, high2'
      read (*,*) low1, up1, low2, up2

      open (1, file = 'sampling', status = 'old')
      open (16, file='dfe2.dat', status = 'unknown')
      open (17, file='axis2d.dat', status = 'unknown')
      open (18, file='scatter.dat', status = 'unknown')


      explim=exp(120.0)
      hist1=0.0
      hist2=0.0
      hist3=0.0
! number of datapoints in simulation
!      read in array nd

! number of windows
      do proc = 1,ntraj

      read (1,*) filename, k1(proc), r1(proc), k2(proc), r2(proc), 
     +        nd(proc)
      filename1 = filename // ".dat1"
      filename2 = filename // ".dat2"

      open (11, file = filename1, status = 'old')
      open (12, file = filename2, status = 'old')

      do j = 1, 17
         read (11,*) chdummy
         read (12,*) chdummy
      enddo

! reading the restraint distances
      do i = 1,nd(proc)
         read (11,*) ind, a(i,1)
         read (12,*) ind, a(i,2)
         write (18,*) a(i,1), a(i,2)

! binning the histograms      
         bin1=int(((a(i,1)-low1)/(up1-low1))*bin)+1
         bin2=int(((a(i,2)-low2)/(up2-low2))*bin)+1
         hist1(proc,bin1,bin2)=hist1(proc,bin1,bin2)+1
      enddo
      close(11)
      close(12)

! biased distribution functions
      ndata=0
      do i=1,bin
         do j=1,bin
            ndata=ndata+hist1(proc,i,j)
         enddo
      enddo

      do i=1,bin
         do j=1,bin
            hist1(proc,i,j)=hist1(proc,i,j)/ndata
         enddo
      enddo

      enddo
! enddo number of windows

! histogram reweighting (WHAM algorithm)

! coordinate value for each bin
      do ph1=1,bin
         x1(ph1)=(real(ph1)-0.5)*(up1-low1)/bin+low1
         x2(ph1)=(real(ph1)-0.5)*(up2-low2)/bin+low2
         write (17,*) x1(ph1), x2(ph1) 
      enddo


! Initialize unknown constants Fi(1) to Fi(bin) to 1
      Fi=1.0

! self consistent solution by iteration
      do loop=1,10000

! equation 1
      dis1=0.0
      dis2=0.0
      dis3=0.0
      do ph1=1,bin
         do ph2=1,bin
            do proc=1,ntraj
            dis1(ph1,ph2)=dis1(ph1,ph2)+real(nd(proc))
     +                                   *hist1(proc,ph1,ph2)
            wttot=0.5*(k1(proc)*(x1(ph1)-r1(proc))**2)/0.6+
     +            0.5*(k2(proc)*(x2(ph2)-r2(proc))**2)/0.6
            dis2(ph1,ph2)=dis2(ph1,ph2)+
     +                 real(nd(proc))*exp(-wttot)*exp(Fi(proc))
            if ((dis1(ph1,ph2).gt.0.0).and.(dis2(ph1,ph2).gt.0).and.
     +           (dis2(ph1,ph2).lt.explim)) then
               dis3(ph1,ph2)=dis1(ph1,ph2)/dis2(ph1,ph2)
            else
               dis3(ph1,ph2)=0.0
            endif
            enddo
         enddo
      enddo

! equation 2
      do proc=1,ntraj
         fip(proc)=0.0
         do ph1=1,bin
            do ph2=1,bin
            wttot=0.5*(k1(proc)*(x1(ph1)-r1(proc))**2)/0.6+
     +            0.5*(k2(proc)*(x2(ph2)-r2(proc))**2)/0.6
            fip(proc)=fip(proc)+exp(-wttot)*dis3(ph1,ph2)
            enddo
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
            do ph2=1,bin
            if (dis3(ph1,ph2).ne.0) dis4(ph1,ph2)=-log(dis3(ph1,ph2))
            enddo
         enddo
         do ind=1,bin
            write (16,10) (dis4(ind,i),i=1,bin)
         enddo
         close(1)
         close(16)
 10      format (20 (F6.1, 1x))   
      endif
      end

