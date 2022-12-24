#!/bin/bash

#SBATCH -J WT

#SBATCH -p standby
#####################################################
#SBATCH --nodes=2
#SBATCH --tasks-per-node=32
#SBATCH --mem-per-cpu=2500M
#SBATCH -t 10-00:00:00
#SBATCH -C "[ib1|ib2|ib3|ib4]"
#SBATCH -o stdout_file
#SBATCH -e stderr_file

#####################################################
echo "SLURM_JOBID="$SLURM_JOBID
echo "SLURM_JOB_NODELIST"=$SLURM_JOB_NODELIST
echo "SLURM_NNODES"=$SLURM_NNODES
echo "SLURMTMPDIR="$SLURMTMPDIR

echo "working directory = "$SLURM_SUBMIT_DIR
cd $SLURM_SUBMIT_DIR

#####################################################
# configure environment
module load gcc/openmpi/2.1.0
#module load intel/openmpi/2.1.0
gmxdir="/home/patilk/src_gromacs_4.5.3.unbiased/bin"
source $gmxdir/GMXRC



#echo 8 | pdb2gmx -f egfr_inactive_L747P_final.pdb -o processed.gro -water spce
#editconf -f processed.gro -o newbox.gro -c -d 1.0 -bt cubic
#genbox -cp newbox.gro -cs spc216.gro -o solv.gro -p topol.top
#grompp -f ions.mdp -c solv.gro -p topol.top -o ions.tpr -maxwarn 1
#echo 13| genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -conc 0.150000 -neutral
#grompp -f minim.mdp -c solv_ions.gro -p topol.top -o em.tpr
#mdrun -v -deffnm em
#grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
#mdrun -deffnm nvt
#grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
#mdrun -deffnm npt
mpirun -np 64 grompp -f md.mdp -c md_0_2.gro -t md_0_2.cpt -p topol.top -o md_0_3.tpr
#mdrun -deffnm md_0_3

mdrun -deffnm md_0_3 -append -cpi md_0_3



