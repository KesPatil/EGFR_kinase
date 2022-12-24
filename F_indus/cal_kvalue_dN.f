         program pncal
         implicit none
         character(len=50) :: ifl,ofl1,ofl2,ofl3,ofl4
         integer i,j,k,nexc,icon 
         integer ndata,nbin,ntbin,nst,bin
         parameter (ndata = 90279,nexc=10000,nbin=600,ntbin=600)
         integer cnt_n(nbin),cnt_nt(ntbin),hist(ntbin)
         double precision temp,kb,pi,alpha
         double precision n_l,n_h,n_i,ndel,nt_dist,kappa
         double precision n(ndata),nt(ndata),t(ndata,3)
         double precision pvnt(ntbin),pvn(nbin),ubni(nbin)
         double precision uni(nbin),ubnti(ntbin),unti(ntbin)
         double precision u_un(nbin),u_unt(ntbin)
         double precision varsq_n,var_n,avg_n,pvnt_g(nbin)
         double precision varsq_nt,var_nt,avg_nt,unt_g(nbin)
         double precision sum_nt,sum_n,nm(nbin),dm,kf,delN

         ifl='../nt_ntw_k0_N0.dat'
         ofl1='Pn_k0_N0.dat'
         ofl2='Pntw_k0_N0.dat'
         ofl3='avg_N_Nt_var.dat'
         ofl4='pnt_gaus_approx'
         open(unit=10,status='unknown',file=trim(ifl))
         open(unit=20,file=trim(ofl1))
         open(unit=30,file=trim(ofl2))
         open(unit=40,file=trim(ofl3))
         open(unit=50,file=trim(ofl4))

         temp=298.0d0
         kb=0.00831446210d0
         kappa=0.00d0
         nst=0
         pi=dacos(-1.0d0)
         ndel=dble(nbin)/dble(ntbin)
         write(*,*)"NOTE: Remember to change the nbin and ntbin
     > depending on range of NTw and N" 
c         write(*,*)"Please enter the N* value"
c         read(*,*) nst
         write(*,*)"Enter the alpha value for umbrella force constant"
         read(*,*) alpha
         write(*,*)"#ki and N* value used: ",kappa,"and ",nst

***************************************************
*         Reading Data File
***************************************************
          read(10,*)
          read(10,*)
          read(10,*)
          read(10,*)
          read(10,*)
       do j=1,ndata
         read(10,*)(t(j,k),k=1,3)
          n(j)=t(j,2)
          nt(j)=t(j,3)
        enddo
**************************************************
*         Calculate P(Nv)
**************************************************
         do i=1,nbin
          cnt_n=0
          do j=nexc,ndata
         if(n(j) .eq. dble(i)) then
          cnt_n(i)=cnt_n(i)+1
         endif
         enddo

         if(cnt_n(i) .ne. 0)then
         pvn(i)=cnt_n(i)/dble(ndata-nexc)
         ubni(i)=-kb*temp*(log(pvn(i)))
         uni(i)=(kappa/2.0d0)*(dble(i)-dble(nst))**(2.0d0)
         u_un(i)=ubni(i)-uni(i)
       write(20,'(i4,4f18.8)')i,pvn(i),ubni(i),uni(i),u_un(i)
         endif
       enddo
         sum_n=0 
         do j=nexc,ndata
          sum_n=sum_n+n(j)
         enddo

         avg_n=sum_n/dble(ndata-nexc)

         varsq_n=0.0d0
       do icon=nexc,ndata
         varsq_n= varsq_n+(n(icon)-avg_n)**2.0d0
       enddo

         var_n=varsq_n/dble(ndata-nexc)
      write(40,*)"N_total and N_avg ====> ",sum_n,"and",avg_n
      write(*,*)"#N_total and N_avg ====> ",sum_n,"and ",avg_n
      write(40,*)'Calculated Variance in N=====> ',var_n
      write(*,*)'#Calculated Variance in N=====> ',var_n
**************************************************
*       Calculate P(Ntv) Counting method
**************************************************
c         do i=0,ntbin
c            n_l=i*ndel
c            n_h=n_l+ndel
c            nt_dist=(n_l+n_h)/2.0d0
c          cnt_nt=0
c          do j=nexc,ndata
c         if(nt(j) .ge. n_l .and. nt(j).lt. n_h) then
c          cnt_nt(i)=cnt_nt(i)+1
c         endif
c         enddo
c         if(dble(cnt_nt(i)) .ne. 0.0d0)then
c         pvnt(i)=(cnt_nt(i))/(dble(ndata-nexc)*ndel)
c         ubnti(i)=-kb*temp*na*10**(-3.d0)*(log(pvnt(i)))
c         unti(i)=(kappa/2.0d0)*(nt_dist-dble(nst))**(2.0d0)
c         u_unt(i)=ubnti(i)-unti(i)
c       write(30,'(5f18.8)')n_i,pvnt(i),ubnti(i),unti(i),u_unt(i)
c        endif
c       enddo

c***************************************************
*     Calculate P(Ntv), Histogram Method)
****************************************************

         hist=0
         sum_nt=0
          do j=nexc,ndata
          bin=nint(nt(j)/ndel)+1
          hist(bin)=hist(bin)+1
          sum_nt=sum_nt+nt(j)
          enddo

         avg_nt=sum_nt/dble(ndata-nexc)
         do i=1,ntbin
            n_l=0.0d0
            n_i=n_l+(i-1)*ndel

         if(dble(hist(i)) .ne. 0.0d0)then
         pvnt(i)=(hist(i))/(dble(ndata-nexc)*ndel)
         ubnti(i)=-kb*temp*(log(pvnt(i)))
         unti(i)=(kappa/2.0d0)*(n_i-dble(nst))**(2.0d0)
         u_unt(i)=ubnti(i)-unti(i)
       write(30,'(5f18.8)')n_i,pvnt(i),ubnti(i),unti(i),u_unt(i)
        endif
       enddo

         varsq_nt=0.0d0
       do icon=nexc,ndata
         varsq_nt= varsq_nt+(nt(icon)-avg_nt)**2.0d0
       enddo

         var_nt=varsq_nt/dble(ndata-nexc)
      write(40,*)"Nt_total and Nt_avg ====> ",sum_nt,"and",avg_nt
      write(*,*)"#Nt_total ====> ",sum_nt
      write(*,*)"#Nt_avg ====> ",avg_nt
      write(40,*)'Calculated Variance in Nt=====> ',var_nt
      write(*,*)'#Calculated Variance in Nt=====> ',var_nt

*********************************************************************
*     Calculate PvNt from Gausian approximation
**********************************************************************
      do i=1,2.5*int(avg_nt)
         nm(i-1)=exp((-((i-1)-avg_nt))**2.0d0/(2.0d0*var_nt))
         dm=(2.0d0*pi*var_nt)**0.50d0
         pvnt_g(i-1)=nm(i-1)/dm
         unt_g(i-1)=-(log(pvnt_g(i-1))) 
       write(50,*)i-1,pvnt_g(i-1),unt_g(i-1)
      enddo

**********************************************************************
*    Calculate force constant for umbrella potential
************************************************************************
       kf=alpha*kb*temp/var_nt
      delN=4.0d0*(sqrt(1.0d0+alpha)/alpha)*sqrt(var_nt)
      write(40,*)"K value and dN for INDUS ====> ",kf,"and",delN
      write(*,*)"#K value for INDUS ====> ",kf
      write(*,*)"# Approx. dN for INDUS ====> ",delN
******************************************************
*       Writing Output
******************************************************
       write(*,*)"Output file generated ---> ",trim(ofl1)," and ",
     > trim(ofl2)," and ", trim(ofl3), " and ", trim(ofl4)
       stop
        end
