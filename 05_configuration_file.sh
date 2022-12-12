#!/bin/bash

# Create directory and set variables
DATA_PATH=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/aligned_reads

# Get list of all data files
BAM_FILES=($(ls -1 $DATA_PATH/*.bam))

# pipe sam files into bam output files

for n in {0..41}  
do
	BAM_FILE=${BAM_FILES[$n]}
	SAMPLE_ID=($(basename ${BAM_FILE%%.bam}))
	printf '%s\t%s\n' $SAMPLE_ID $BAM_FILE >> configuration.txt
done 
