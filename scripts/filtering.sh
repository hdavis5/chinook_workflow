#!/bin/bash

#Bash script to filter input bcf file and output both a vcf and the plink format (BED/BIM/FAM) files

INPUT_VCF="/home/hdavis/catherine_creek/bcf_files/combined2024-08-19.bcf"
OUTPUT_PREFIX="/home/hdavis/catherine_creek/bcf_files/CC"
CHR_MAP="/home/hdavis/catherine_creek/chinook_workflow/data/chr_map.txt"

plink --vcf $INPUT_VCF --make-bed --recode vcf --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_convert

#Filter variants with >5% missingness
plink --bfile ${OUTPUT_PREFIX}_convert --geno 0.05 --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_step1

#Filter individuals with >10% missingness
plink --bfile ${OUTPUT_PREFIX}_step1 --mind 0.1 --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_step2

#Filter MAF < 5%
plink --bfile ${OUTPUT_PREFIX}_step2 --maf 0.05 --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_step3

#LD pruning
plink --bfile ${OUTPUT_PREFIX}_step3 --indep-pairwise 100 10 0.2 --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_step4
plink --bfile ${OUTPUT_PREFIX}_step3 --extract ${OUTPUT_PREFIX}_step4.prune.in --allow-extra-chr --threads 10 --out ${OUTPUT_PREFIX}_step5

#Remove Hardy-Weinberg equilibrium outliers
plink --bfile ${OUTPUT_PREFIX}_step5 --hwe 1e-6 --make-bed --recode vcf --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_filtered

bcftools annotate --rename-chrs $CHR_MAP -o ${OUTPUT_PREFIX}_filterRename -O v ${OUTPUT_PREFIX}_filtered

rm ${OUTPUT_PREFIX}_step*