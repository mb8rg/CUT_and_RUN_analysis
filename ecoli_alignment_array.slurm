#!/bin/bash
#SBATCH -A bme4350		# account
#SBATCH -p standard	# partition/queue
#SBATCH --nodes=1		# number of compute nodes
#SBATCH --ntasks=1		# number of program instances
#SBATCH --time=02:00:00		# max time before job cancels
#SBATCH --mem=32GB               # memory
#SBATCH --cpus-per-task=8

# Create directory and set variables
DATA_PATH=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/trimmed_reads/stringency_1
GENOME_INDEX_PATH=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/Ecoli_genomeindex

# Get list of all data files
FILES_FOR=($(ls -1 $DATA_PATH/*_R1_001_val_1.fq.gz))
FILES_REV=($(ls -1 $DATA_PATH/*_R2_001_val_2.fq.gz))

# Use Slurm Array number 
#to select file for this job
FILE_FOR=${FILES_FOR[$SLURM_ARRAY_TASK_ID]}
FILE_REV=${FILES_REV[$SLURM_ARRAY_TASK_ID]}
SAMPLE_ID=($(basename ${FILE_FOR%%_L001_R*}))

echo "Processing file $FILE_FOR and $FILE_REV"
echo "Sample ID: $SAMPLE_ID"
start=$SECONDS
module purge
module load gcc
module load bowtie2
module load samtools

bowtie2 \
-p $SLURM_CPUS_PER_TASK --no-mixed --no-discordant --no-overlap --no-dovetail \
-x $GENOME_INDEX_PATH/GCF_000005845.2_ASM584v2_genomic_index \
-1 $FILE_FOR -2 $FILE_REV | samtools sort -m 32G -o $SAMPLE_ID.bam

end=$SECONDS
echo "duration:$((end-start)) seconds."
