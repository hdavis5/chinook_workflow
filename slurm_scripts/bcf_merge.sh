#!/bin/bash

#SBATCH --job-name=bcf_merge
#SBATCH --output=log/bcf_merge

#SBATCH --mail-user=hayden.davis@noaa.gov
#SBATCH --mail-type=ALL

#SBATCH -c 10
#SBATCH -t 100-0
#SBATCH --mem=4G

#SBATCH --output=/home/hdavis/catherine_creek/slurm_logs/slurm-%j.out
#SBATCH --error=/home/hdavis/catherine_creek/slurm_logs/slurm-%j.err

# Setup
module load bio/bcftools/1.11

# change reference, samples, and SAMPLES output directories as needed
SAMPLES=/home/hdavis/catherine_creek/bcf_files
OUT=/home/hdavis/catherine_creek/bcf_files/out

# Commands
bcftools merge ${SAMPLES}/*.bcf -Oz -o ${SAMPLES}/combined2024-08-19.bcf

bcftools index ${SAMPLES}/combined2024-08-19.bcf
