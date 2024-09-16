#!/bin/bash

#SBATCH --job-name=bwa_index
#SBATCH --output=bwa_index_log

#SBATCH --mail-user=hayden.davis@noaa.gov
# See manual for other options for --mail-type
#SBATCH --mail-type=ALL
#SBATCH -c 10
#SBATCH --mem=4G
#SBATCH --output=/home/hdavis/catherine_creek/bcf_files/out/indexed_bcf.out
#SBATCH --error=/home/hdavis/catherine_creek/bcf_files/out/indexed_bcf.err

# Commands to run
# Setup
module load bio/bcftools/1.11

REF=/home/hdavis/catherine_creek/bcf_files

for bcf_file in ${REF}/*.bcf
do 
	bcftools index $bcf_file
done
