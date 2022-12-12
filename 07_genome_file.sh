#!/bin/bash

# Directory to the genome .fa file
GENOME=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/hg38_gencode_v41/GRCh38.primary_assembly.genome.fa

# Load modules
module purge
module load gcc
module load samtools

samtools faidx $GENOME
# print the first and second column separated by a tab
awk -v OFS='\t' {'print $1,$2'} $GENOME.fai > GRCh38_genome.txt
