#!/bin/bash

#SBATCH --job-name=plink_chr
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
OUTFILE="/home/hdavis/catherine_creek/chinook_workflow/data/"
OUTPUT_PREFIX="CC_chr_filtered"
CHR_MAP="/home/hdavis/catherine_creek/chinook_workflow/data/chr_map.txt"


plink --bfile $BFILE --allow-extra-chr --chr-set 34 --list-duplicate-vars suppress-first --make-bed --out ${OUTPUT_PREFIX}_dedup

# Step 2: Update chromosome names in the deduplicated dataset
plink --bfile ${OUTPUT_PREFIX}_dedup --make-bed --allow-extra-chr --double-id --chr-set 34 \
      --update-chr $CHR_MAP --out ${OUTPUT_PREFIX}_updated

# Step 3: Convert the updated PLINK dataset back to VCF format
plink --bfile ${OUTPUT_PREFIX}_updated --recode vcf --allow-extra-chr --double-id --chr-set 34 --out $OUTFILE
#
#plink --bfile $BFILE --make-bed --allow-extra-chr --double-id --chr-set 34 \
#      --update-chr $CHR_MAP --set-missing-var-ids @:#:$1:$2 \
#      --out ${OUTPUT_PREFIX}
#
## Step 2: Convert the updated PLINK dataset back to VCF format
#plink --bfile ${OUTPUT_PREFIX} --recode vcf --allow-extra-chr --double-id --chr-set 34 --out $OUTFILE
#
## Step 3: Perform any further analysis, such as PCA, using the updated dataset
#plink --bfile ${OUTPUT_PREFIX} --pca --allow-extra-chr --double-id --chr-set 34 --threads 10 --out $OUTFILE