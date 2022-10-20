#!/bin/bash
#SBATCH -A bme4350		# account
#SBATCH -p standard	# partition/queue
#SBATCH --nodes=1		# number of compute nodes
#SBATCH --ntasks=1		# number of program instances
#SBATCH --time=01:00:00		# max time before job cancels
#SBATCH --mem=32GB               # memory

# Create directory and set variables
DATA_PATH=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/aligned_reads

# Get list of all data files
BAM_FILES=($(ls -1 $DATA_PATH/*.bam))
OUTDIR=$DATA_PATH/qualimap_files

start=$SECONDS
module purge
unset DISPLAY
module load gcc qualimap

qualimap multi-bamqc -r -d ./configuration.txt -outdir $OUTDIR/$SAMPLE_ID/ --java-mem-size=32G

end=$SECONDS
echo "duration:$((end-start)) seconds."
