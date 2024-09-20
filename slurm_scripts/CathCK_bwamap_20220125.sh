#!/bin/bash

#SBATCH --job-name=bwa_30-544521016
#SBATCH --output=bwa_30-544521016_log

#SBATCH --mail-user=paul.moran@noaa.gov
# See manual for other options for --mail-type
#SBATCH --mail-type=ALL
#SBATCH -t 100-0

#SBATCH -c 20

# WGS processing script from Mike Ford, edited by Paul Moran 1/25/22

# Setup
module load aligners/bwa
module load bio/samtools


# Change directories as needed
BASE=/share/nwfsc/pmoran
SAMPLES=${BASE}/30-544521016 
OUT=${SAMPLES}/bwa_output


# Check date of reference genome and update if needed
# LET'S MOVE THIS TO A CENTRAL LOCATION (e.g., /share/refSeq/ or /share/nwfsc/refSeq))
#REF=/share/nwfsc/refSeq
# But use Mike's reference for now
REF=/home/mford/refgenomes/Otsh_v2/GCF_018296145.1_Otsh_v2.0_genomic.fna 


FILESR1=$(ls ${SAMPLES}/*R1*.gz)
FILESR2=$(ls ${SAMPLES}/*R2*.gz)
FILESR1=($FILESR1)
FILESR2=($FILESR2)

N=${#FILESR1[*]}  # Get the number of samples
echo ${N}

for ((i=0; i<N; i++)); 
do
	echo $i
    echo ${FILESR1[$i]}
    echo ${FILESR2[$i]}
    F1=${FILESR1[$i]##*/}  # this just strips off the full path that was put earlier
	F2=${FILESR2[$i]##*/}

#README example for Illumina/454/IonTorrent paired-end reads longer than ~70bp:
	#bwa mem ref.fa read1.fq read2.fq > aln-pe.sam
	#

	bwa mem -t 20 ${REF} ${SAMPLES}/${F1} ${SAMPLES}/${F2} > ${OUT}/${F1}.sam
	samtools fixmate -m -@ 19 -O bam ${OUT}/${F1}.sam ${OUT}/${F1}.fixm.bam 
	samtools sort -@ 19 -O bam -o ${OUT}/${F1}.sorted.bam  ${OUT}/${F1}.fixm.bam
	samtools markdup -@ 19 ${OUT}/${F1}.sorted.bam ${OUT}/${F1}.markdup.bam
	samtools flagstats -@ 19  -O tsv ${OUT}/${F1}.markdup.bam > ${OUT}/${F1}.flagstat   

done
