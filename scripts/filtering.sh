#!/bin/bash

#Bash script to filter input bcf file and output both a vcf and the plink format (BED/BIM/FAM) files

INPUT_VCF="/home/hdavis/catherine_creek/bcf_files/combined2024-08-19.bcf"
OUTPUT_PREFIX="CC_filtered"

#Convert BCF to both VCF and PLINK format
plink --vcf $INPUT_VCF --make-bed --recode vcf --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_step1

#Filter variants with >5% missingness
plink --bfile ${OUTPUT_PREFIX}_step1 --geno 0.05 --allow-extra-chr --make-bed --recode vcf --double-id --threads 10 --out ${OUTPUT_PREFIX}_step2

#Filter individuals with >10% missingness
plink --bfile ${OUTPUT_PREFIX}_step2 --mind 0.1 --allow-extra-chr --make-bed --recode vcf --double-id --threads 10 --out ${OUTPUT_PREFIX}_step3

#Filter MAF < 5%
plink --bfile ${OUTPUT_PREFIX}_step3 --maf 0.05 --allow-extra-chr --make-bed --recode vcf --double-id --threads 10 --out ${OUTPUT_PREFIX}_step4

#LD pruning
plink --bfile ${OUTPUT_PREFIX}_step4 --indep-pairwise 100 10 0.2 --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_step5
plink --bfile ${OUTPUT_PREFIX}_step4 --extract ${OUTPUT_PREFIX}_step5.prune.in --allow-extra-chr --make-bed --recode vcf --out ${OUTPUT_PREFIX}_step6

#Remove Hardy-Weinberg equilibrium outliers
plink --bfile ${OUTPUT_PREFIX}_step6 --hwe 1e-6 --make-bed --recode vcf --allow-extra-chr --double-id --threads 10 --out ${OUTPUT_PREFIX}_final

bcftools annotate --rename-chrs $CHR_MAP -o ${OUTPUT_PREFIX}_filterRename -O v ${OUTPUT_PREFIX}_filtered

#rm ${OUTPUT_PREFIX}_step*