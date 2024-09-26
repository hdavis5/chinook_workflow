#!/bin/bash

#Bash script to filter input bcf file and output both a vcf and the plink format (BED/BIM/FAM) files

INPUT_VCF="/home/hdavis/catherine_creek/bcf_files/combined2024-08-19.bcf"
OUTPUT_PREFIX="/home/hdavis/catherine_creek/bcf_files/CC"
CHR_MAP="/home/hdavis/catherine_creek/chinook_workflow/data/chr_map.txt"

#Filter variants with >5% missingness
plink --vcf $INPUT_VCF --geno 0.05 --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_temp_step1

#Filter individuals with >10% missingness
plink --vcf ${OUTPUT_PREFIX}_temp_step1 --mind 0.1 --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_temp_step2

#Filter MAF < 5%
plink --vcf ${OUTPUT_PREFIX}_temp_step2 --maf 0.05 --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_temp_step3

#LD pruning
plink --vcf ${OUTPUT_PREFIX}_temp_step3 --indep-pairwise 100 10 0.2 --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_temp_step4
plink --vcf ${OUTPUT_PREFIX}_temp_step3 --extract ${OUTPUT_PREFIX}_temp_step4.prune.in --allow-extra-chr --threads 10 --out ${OUTPUT_PREFIX}_temp_step5

#Remove Hardy-Weinberg equilibrium outliers
plink --vcf ${OUTPUT_PREFIX}_temp_step5 --hwe 1e-6 --make-bed --recode vcf --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_filtered

rm ${OUTPUT_PREFIX}_temp*