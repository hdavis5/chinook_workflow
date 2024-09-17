#!/bin/bash

#SBATCH --job-name=vcf_filter

#SBATCH --mail-user=hayden.davis@noaa.gov
# See manual for other options for --mail-type
#SBATCH --mail-type=ALL
#SBATCH -c 10
#SBATCH --mem=16G
#SBATCH --time=48:00:00
#SBATCH --output=/home/hdavis/catherine_creek/bcf_files/out/indexed_bcf.out
#SBATCH --error=/home/hdavis/catherine_creek/bcf_files/out/indexed_bcf.err

# Commands to run
# Setup
module load bio/plink/1.90b6.23

bash /home/hdavis/catherine_creek/chinook_workflow/scripts/filtering.sh