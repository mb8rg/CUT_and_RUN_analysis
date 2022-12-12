#!/bin/bash
#SBATCH -A rivanna_fallahi_lab		# account
#SBATCH -p standard	# partition/queue
#SBATCH --nodes=1		# number of compute nodes
#SBATCH --ntasks=1		# number of program instances
#SBATCH --time=02:00:00		# max time before job cancels
#SBATCH --mem=32GB               # memory
#SBATCH --cpus-per-task=8

# Create directory and set variables
BEDGRAPH_FILES_PATH=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/bedgraph_files/normalized_bedgraph_files/20220712_LOXIMVI
IgG_FILE_PATH=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/bedgraph_files/normalized_bedgraph_files/20220712_LOXIMVI/IgG_file
OUTDIR=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/SEACR_peak_calling/spike_in_normalized/20220712_LOXIMVI
mkdir -p $OUTDIR

# Get list of all data files
FILES=($(ls -1 $BEDGRAPH_FILES_PATH/*.fragments.normalized.bedgraph))
IgG_FILE=($(ls -1 $IgG_FILE_PATH/*.fragments.normalized.bedgraph))

# Use Slurm Array number 
#to select file for this job
FILE=${FILES[$SLURM_ARRAY_TASK_ID]}
SAMPLE_ID=($(basename ${FILE%%\.fragments.normalized.bedgraph}))
IgG_SAMPLE_ID=($(basename ${IgG_FILE%%\.fragments.normalized.bedgraph}))

echo "Processing file $FILE"
echo "Sample ID: $SAMPLE_ID IgG SAMPLE_ID: $IgG_SAMPLE_ID"
start=$SECONDS
module purge
module load gcc/9.2.0 openmpi/3.1.6 R/4.2.1
module load bedtools/2.29.2
module load seacr/1.3

bash SEACR_1.3.sh $FILE $IgG_FILE non stringent $OUTDIR/$SAMPLE_ID.peaks

end=$SECONDS
echo "duration:$((end-start)) seconds."
