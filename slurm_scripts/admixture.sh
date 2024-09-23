#!/bin/bash

#SBATCH --job-name=admixture
#SBATCH --mail-user=hayden.davis@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -c 10
#SBATCH --mem=8G
#SBATCH --time=15:00:00
#SBATCH --output=/home/hdavis/catherine_creek/chinook_workflow/data/admixture_analysis.out
#SBATCH --error=/home/hdavis/catherine_creek/chinook_workflow/data/admixture_analysis.err

# Load modules for PLINK and Python
module load bio/admixture/1.3.0

# Variables
ADMIX_FILE="/home/hdavis/catherine_creek/chinook_workflow/data/admixture/CC_filtered_final.bed"
OUTFILE="/home/hdavis/catherine_creek/chinook_workflow/data/admixture/out"

# Run ADMIXTURE process single time
for k in {1..4}; do
        admixture $ADMIX_FILE --seed=$RANDOM --cv -C 0.0000001 $k >$OUTFILE/results$k.txt
        done

# Run ADMIXTURE process 10 times 
#for i in {1...10}; do
#    mkdir run$i
#    cd run$1
#        for k in {1...4}; do
#        admixture ADMIX_FILE --seed=$RANDOM --cv -C 0.0000001 $k >results$k.txt
#        done
#    grep "CV error" results*.txt >> $OUTFILE/CVerror.txt
#done