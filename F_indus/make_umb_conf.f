* This program calculates <Nv>_phi and <delNv^2>_phi
* One should know each variables before using this program
* This program is written by Dr. Debdas Dhabal on 02/27/2018
* Nphi = strength of the linear biasing potential
* dNt = bin interval
* kb = Boltzman constant in kJ/Mol/K
* temp = simulation temperature 
* beta = 1/kb/temp

*------------Things one should know before running this code------------------
c1. Change the value of Nt according to your need
c2. Change the value of the width between the two Nt
c3. Make sure the value of Nt_max is large enough that produce no error in results
c4. Change the system temperature
*----------------------------------------------------------------------------- 
******************************************************************************
       program N_av_phi
       implicit none
       character(len=8) :: i_char
       integer i,k
       integer nh
       double precision rlow,rhigh
       parameter(nh=2479,rlow=-0.50,rhigh=0.60)
       integer t(10,nh)

*==============================================================================
!                           OPEN,READ, WRITE                                  =
*==============================================================================
       open(10,file='index_H.ndx',status='unknown')
       open(20,file='umbrella.conf',status='unknown')


        write(20,'(1A1,1A58)')";","Umbrella potential for ensemble of
     >  spheres exclude water"
        write(20,'(1A1,1A83)')";","Name    Type          Group  Kappa
     > Nstar    mu    width  cutoff  outfile    nstout"

       write(20,'(1A100)')"CAVITATOR dyn_union_sph_sh   Protein-H  0.000
     >   0   0.0    0.01   0.02   nt_ntw_k0_N0.dat   50     \"
c         write(20,'(1A10,1A18,1A19)')"T(K)","mu_ex(Kj/Mol)","beta*mu_ex"
         read(10,*) 
         do i=1,1
         read(10,*)(t(i,k),k=1,nh)
         enddo

        do k=1,nh
        write(i_char, '(i8)')t(1,k)
      write(20,'(1f4.1,1f11.2,2a6,1A1)')rlow,rhigh,"",adjustl(i_char),
     > "\"
        enddo
      stop 
       end  
