#!/bin/bash

#SBATCH --job-name=bcf_convert
#SBATCH --output=log/bcf_convert

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
BCF=/home/hdavis/catherine_creek/bcf_files/filtered_vcf/CC_filtered_final.vcf
GZ=/home/hdavis/catherine_creek/bcf_files/CC_filtered_final.vcf.gz
OUT=/home/hdavis/catherine_creek/bcf_files/cc_renamed.vcf
CHR_MAP=/home/hdavis/catherine_creek/bcf_files/filtered_vcf/chr_map.txt

bgzip -c $BCF > $GZ

bcftools index -t $GZ

# Commands
#update chromosome names
bcftools annotate --rename-chrs $CHR_MAP -o $OUT -O v $GZ

# Remove contigs that are not associated with chromosomes
bcftools view -r ^NW_ $OUT -o cc_filtered.vcf -O v
