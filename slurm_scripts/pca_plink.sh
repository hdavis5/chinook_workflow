#!/bin/bash

#SBATCH --job-name=plink_pca_analysis
#SBATCH --mail-user=hayden.davis@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -c 10
#SBATCH --mem=8G
#SBATCH --time=2:00:00
#SBATCH --output=/home/hdavis/catherine_creek/chinook_workflow/data/pca_analysis.out
#SBATCH --error=/home/hdavis/catherine_creek/chinook_workflow/data/pca_analysis.err

# Load modules for PLINK and Python
module load bio/plink/1.90b6.23

# Variables
BFILE="/home/hdavis/catherine_creek/bcf_files/filtered_vcf/CC_filtered_final"
OUTFILE="/home/hdavis/catherine_creek/chinook_workflow/data/pca_results"

# Step 1: Run PLINK PCA
plink --bfile $BFILE --pca --out $OUTFILE