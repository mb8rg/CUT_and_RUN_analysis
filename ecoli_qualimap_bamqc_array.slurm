#!/bin/bash
#SBATCH -A bme4350		# account
#SBATCH -p standard	# partition/queue
#SBATCH --nodes=1		# number of compute nodes
#SBATCH --ntasks=1		# number of program instances
#SBATCH --time=05:00:00		# max time before job cancels
#SBATCH --mem=32GB               # memory

# Set paths
DATA_PATH=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/Ecoli_aligned_reads

# Get list of all bam data files
FILES=($(ls -1 $DATA_PATH/*.bam))

# Use Slurm Array number to select file for this job
FILE=${FILES[$SLURM_ARRAY_TASK_ID]}
SAMPLE_ID=($(basename ${FILE%%_S*}))

# Out directory
OUTDIR=$DATA_PATH/qualimap_files_not_filtered/$SAMPLE_ID

echo "Processing file $FILE"
echo "Sample ID: $SAMPLE_ID"

start=$SECONDS
module purge
unset DISPLAY
module load gcc qualimap
module load samtools

# Sort BAM file by location
samtools sort -m 32G $FILE -o $DATA_PATH/qualimap_files_not_filtered/$SAMPLE_ID.sorted.bam

# Run qualimap on each file in the array
qualimap bamqc -bam $DATA_PATH/qualimap_files_not_filtered/$SAMPLE_ID.sorted.bam --paint-chromosome-limits \
-outdir $OUTDIR --java-mem-size=32G

end=$SECONDS
echo "duration:$((end-start)) seconds."
