#!/bin/bash

#SBATCH -J WT2050

#SBATCH -p standby
#####################################################
#SBATCH --nodes=1
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
gmxdir="/home/patilk/src_gromacs_indus/bin"
source $gmxdir/GMXRC

#grompp -f minim.mdp -c solv_ions.gro -p topol.top -o em.tpr
#mdrun -v -deffnm em
#grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
#mdrun -deffnm nvt
#grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
#mdrun -deffnm npt



#grompp_indus -f umb.mdp -c md_0_2.gro -t md_0_2.cpt -p topol.top -n index.ndx -o md_0_3.tpr
#mdrun_indus -deffnm md_0_3 -append -cpi md_0_3

#grompp_indus -f umb.mdp -c md_0_3.gro -t md_0_3.cpt -p topol.top -n index.ndx -o md_0_4.tpr
#mdrun_indus -deffnm md_0_4 -append -cpi md_0_4

#grompp_indus -f umb.mdp -c md_0_4.gro -t md_0_4.cpt -p topol.top -n index.ndx -o md_0_5.tpr
#mdrun_indus -deffnm md_0_5 -append -cpi md_0_5

#grompp_indus -f umb.mdp -c md_0_5.gro -t md_0_5.cpt -p topol.top -n index.ndx -o md_0_6.tpr
#mdrun_indus -deffnm md_0_6 -append -cpi md_0_6

#grompp_indus -f umb.mdp -c md_0_6.gro -t md_0_6.cpt -p topol.top -n index.ndx -o md_0_7.tpr
#mdrun_indus -deffnm md_0_7 -append -cpi md_0_7

#grompp_indus -f umb.mdp -c md_0_7.gro -t md_0_7.cpt -p topol.top -n index.ndx -o md_0_8.tpr
#mdrun_indus -deffnm md_0_8 -append -cpi md_0_8

grompp_indus -f umb.mdp -c md_0_8.gro -t md_0_8.cpt -p topol.top -n index.ndx -o md_0_9.tpr
mdrun_indus -deffnm md_0_9 -append -cpi md_0_9

grompp_indus -f umb.mdp -c md_0_9.gro -t md_0_9.cpt -p topol.top -n index.ndx -o md_0_10.tpr
mdrun_indus -deffnm md_0_10 -append -cpi md_0_10
