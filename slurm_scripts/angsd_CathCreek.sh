#!/bin/bash

#SBATCH --job-name=angsd

#SBATCH --mail-user=hayden.davis@noaa.gov
#SBATCH --mail-type=ALL

#SBATCH -c 24
#SBATCH -t 100-0
#SBATCH -p himem

#SBATCH --output=/home/hdavis/catherine_creek/slurm_logs/slurm-%j.out
#SBATCH --error=/home/hdavis/catherine_creek/slurm_logs/slurm-%j.err

# Setup
module load bio/angsd/0.940

# change reference, samples, and SAMPLES output directories as needed
OUT=/home/hdavis/catherine_creek/angsd/out

# Commands
#mkdir ${OUT}
angsd -GL 2 -doGlf 2 -bam /home/hdavis/catherine_creek/angsd/bams.filelist -doMajorMinor 1 -SNP_pval 1e-6 -doMaf 1
