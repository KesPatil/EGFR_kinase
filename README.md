# EGFR_kinase

This GitHub repo has folders required for setting up the molecular dynamics simulations, indus simulations and post-processing codes for studies on EGFR kinase and Exon 19 deletion mutations


<p align="justify">
README:  There are four folders F_unbiased that includes the files to setup and perform Unbiased Molecular Dynamics using GROMACS, F_indus contains files to setup and perform indirect umbrella sampling, F_post_processing_codes contains files to perform post processing and F_structures has structures of EGFR Exon 19 deletion mutation systems. <br />
</p>

## Folders

***F_unbiased***: This folder has the input gromacs .mdp scripts required to perform Unbiased Molecular Dynamics of EGFR <br />
1. The topology files .top are generated using Gromacs function : "pdb2gmx" and we implement charmm27 forcefield <br />
2. The outputs (.gro, .cpt, .top, .tpr) of the unbiased MD simulation. <br />

***F_indus***: This folder has the input scripts required to perform indirect umbrella sampling <br />
1. wham1d.f - weighted histogram analysis code to obtain unbiased free energy <br />
2. input_files - includes files to set up indus simulations <br />
3. make_umb_conf.f - to make the umbrella.conf file to perform indus simulations <br />
4. free_energy - Includes free energy curves for all EGFR Exon-19 deletion systems <br />

***F_post_processing_codes***: This folder contain the python scripts used for post-processing trajectories data to calculate Hydrogen bond occupancy, SASA, Mutual information, Joint Mutual information, SHAP values  </br> 



## Forcefield implemented

Our MD and metadynamics simulations use charmm27.ff from GROMACS 4.5.3

## Procedure
### 1. MD simulation in GROMACS <br />
<p align="justify">
The MD simulations are performed in GROMACS 4.5.3

All mutations are introduced using BioPhysCode Automacs routine based on MODELLER. Please see MODELLER here: <br />

https://salilab.org/modeller/ <br />

The INDUS code was obtained from 

All the requisite files needed to setup and run the unbiased simulations are  included in the F_unbiased. We followed Bevan Lab Tutorials: "Lysozyme in water" example for equilibration and production <br />
http://www.mdtutorials.com/gmx/lysozyme/index.html
</p>

### 2. Enhanced sampling simulation - Indirect Umbrella Samplinig <br />
<p align="justify">
We patch GROMACS 4.5.3 with INDUS code and compute k (kappa) and dN (water molecule steps) using cal_kvalue_dN.f <br />
</p>

<p align="justify">
The water molecules in the probe volume around the protein are in generally varied in steps of 50  <br />
</p>


<p align="justify">
Aggregate of 10ns INDUS is run and found to be enough for convergence in all the EGFR Exon-19 deletion systems <br />
</p>

<p align="justify">
The output of the INDUS run is a .dat file (see F_indus/input_files/nt_ntw_k0.012_N2050.dat which is processed using wham1d.f to obtain unbiased free energy curves using INDUS_free_energy_analysis.ipynb <br />
</p>

### 3. Description of the post-processing codes <br />

Analysis of the trajectories was done using python and mostly MDanalysis package in python: https://www.mdanalysis.org  <br />

 The folder F_post_processing contains five codes: <br />

 + `Aloop_helicity.ipynb` is the code to compute hbonds that contribute to making the partial helix in the activation loop of kinase <br />
 + `Analysis_weighted_correlation.ipynb` is the code that computes boltzmann weighted SASA, Hbond and their log ratio plot  <br />
 + `Boltz_corr_plotter.ipynb` is the code to plot the boltzmann weighted correlation matrices  <br />
 + `Dihedral_compute.ipynb` is the code to compute the distribution of the dihedral angle representing the DFG flip  <br />
 + `FELandscape_plotter.ipynb` is the code to plot the free energy landscape  <br />
 

## Citations

If you have any suggestions or queries please feel free to reach out at : patilk@seas.upenn.edu  <br />
If you found the above scripts and/or codes helpful in your work, please cite: <br />
1. Jordan, E. Joseph, et al. "Computational algorithms for in silico profiling of activating mutations in cancer." Cellular and Molecular Life Sciences 76.14 (2019): 2663-2679.
2. Patil, Keshav, et al. "Computational studies of anaplastic lymphoma kinase mutations reveal common mechanisms of oncogenic activation." Proceedings of the National Academy of Sciences 118.10 (2021).
3.
</p>

