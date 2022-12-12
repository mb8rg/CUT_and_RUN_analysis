#!/bin/bash
#SBATCH -A bme4350		# account
#SBATCH -p standard	# partition/queue
#SBATCH --nodes=1		# number of compute nodes
#SBATCH --ntasks=1		# number of program instances
#SBATCH --time=00:30:00		# max time before job cancels
#SBATCH --mem=9GB               # memory

# Create directory and set variables

DATA_PATH=/project/class/bme4350/rnaseq
OUTDIR=./fastqc_output_array
mkdir -p $OUTDIR

# Get list of all data files
FILES=($(ls -1 $DATA_PATH/*.fastq.gz))

# Use Slurm Array number 
#to select file for this job
FILE=${FILES[$SLURM_ARRAY_TASK_ID]}

echo "Processing file $FILE"
module purge
module load fastqc

fastqc $FILE --outdir $OUTDIR 

