#!/bin/bash

#Bash script to filter input bcf file and output both a vcf and the plink format (BED/BIM/FAM) files

INPUT_VCF="/home/hdavis/catherine_creek/bcf_files/combined2024-08-19.bcf"
OUTPUT_PREFIX="/home/hdavis/catherine_creek/bcf_files/CC"
CHR_MAP="/home/hdavis/catherine_creek/chinook_workflow/data/chr_map.txt"

#Convert BCF to both VCF and PLINK format
plink --vcf $INPUT_VCF --recode vcf --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}
#plink --vcf $INPUT_VCF --make-bed --recode vcf --allow-extra-chr --double-id --chr-set 34 --threads 10 --out ${OUTPUT_PREFIX}_step1

#plink --bfile ${OUTPUT_PREFIX}_step1 --allow-extra-chr --make-bed --double-id --chr-set 34 --threads 10 --update-chr $CHR_MAP --out ${OUTPUT_PREFIX}_chr

##Filter variants with >5% missingness
#plink --bfile ${OUTPUT_PREFIX}_step1 --geno 0.05 --allow-extra-chr --make-bed --recode vcf --double-id --chr-set 34 --threads 10 --out ${OUTPUT_PREFIX}_step2
#
##Filter individuals with >10% missingness
#plink --bfile ${OUTPUT_PREFIX}_step2 --mind 0.1 --allow-extra-chr --make-bed --recode vcf --double-id --chr-set 34 --threads 10 --out ${OUTPUT_PREFIX}_step3
#
##Filter MAF < 5%
#plink --bfile ${OUTPUT_PREFIX}_step3 --maf 0.05 --allow-extra-chr --make-bed --recode vcf --double-id --chr-set 34 --threads 10 --out ${OUTPUT_PREFIX}_step4
#
##LD pruning
#plink --bfile ${OUTPUT_PREFIX}_step4 --indep-pairwise 100 10 0.2 --allow-extra-chr --double-id --chr-set 34 --threads 10 --out ${OUTPUT_PREFIX}_step5
#plink --bfile ${OUTPUT_PREFIX}_step4 --extract ${OUTPUT_PREFIX}_step5.prune.in --allow-extra-chr --make-bed --chr-set 34 --threads 10 --recode vcf --out ${OUTPUT_PREFIX}_step6
#
##Remove Hardy-Weinberg equilibrium outliers
#plink --bfile ${OUTPUT_PREFIX}_step6 --hwe 1e-6 --make-bed --recode vcf --allow-extra-chr --double-id --chr-set 34 --threads 10 --out ${OUTPUT_PREFIX}_final