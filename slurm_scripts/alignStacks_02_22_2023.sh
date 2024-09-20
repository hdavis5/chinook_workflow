#!/bin/bash

# Garrett's script for processing RAD data for NOAA Coop-funded Y-chromosome haplotypes, February 2023

#SBATCH --job-name=alignStacks_02_22_2023
#SBATCH --output=alignStacks_02_22_2023.log

#SBATCH --mail-user=Garrett.Mckinney@noaa.gov
# See manual for other options for --mail-type
#SBATCH --mail-type=ALL

#SBATCH -c 20
#SBATCH -t 168:00:00
#SBATCH -D /share/nwfsc/pmoran/CoopRAD_processing/

# Commands to run
module load aligners/bwa/0.7.17
module load bio/samtools/1.15.1


src=/share/nwfsc/pmoran/CoopRAD_processing
bwa_db=/share/nwfsc/refgenomes/Otsh_v2/GCF_018296145.1_Otsh_v2.0_genomic.fna

ID_FILE=${src}/RAD_IDs_02_22_2023.txt
IDS=$(cat ${ID_FILE})

#
# Align paired-end data with BWA, convert to BAM and SORT.
#
for sample in ${IDS}

do 
    bwa mem -t 20 $bwa_db $src/demultiplexed/${sample}.1.fq.gz $src/demultiplexed/${sample}.2.fq.gz |
      samtools view -b |
      samtools sort --threads 20 > $src/aligned/${sample}.bam
done

