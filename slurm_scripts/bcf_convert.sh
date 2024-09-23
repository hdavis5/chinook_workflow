#!/bin/bash

#SBATCH --job-name=bcf_merge
#SBATCH --output=log/bcf_merge

#SBATCH --mail-user=hayden.davis@noaa.gov
#SBATCH --mail-type=ALL

#SBATCH -c 10
#SBATCH -t 02:00:00
#SBATCH --mem=4G

#SBATCH --output=/home/hdavis/catherine_creek/slurm_logs/slurm-%j.out
#SBATCH --error=/home/hdavis/catherine_creek/slurm_logs/slurm-%j.err

# Setup
module load bio/bcftools/1.11

# change reference, samples, and SAMPLES output directories as needed
BCF=/home/hdavis/catherine_creek/bcf_files/combined2024-08-19.bcf
OUT=/home/hdavis/catherine_creek/bcf_files/combined2024-08-19.vcf

# Commands
bcftools view -O v -o $OUT $BCF
