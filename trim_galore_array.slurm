#!/bin/bash
#SBATCH -A bme4350		# account
#SBATCH -p standard	# partition/queue
#SBATCH --nodes=1		# number of compute nodes
#SBATCH --ntasks=1		# number of program instances
#SBATCH --time=05:00:00		# max time before job cancels
#SBATCH --mem=9GB               # memory
#SBATCH -c 16
# Create directory and set variables

DATA_PATH=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/original_fastq_files
OUTDIR=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/trimmed_reads/stringency_1/fastqc_output_array
mkdir -p $OUTDIR

# Get list of all data files
FILES_FOR=($(ls -1 $DATA_PATH/*R1_001.fastq.gz))
FILES_REV=($(ls -1 $DATA_PATH/*R2_001.fastq.gz))

# Use Slurm Array number 
#to select file for this job
FILE_FOR=${FILES_FOR[$SLURM_ARRAY_TASK_ID]}
FILE_REV=${FILES_REV[$SLURM_ARRAY_TASK_ID]}

echo "Processing file $FILE_FOR and $FILE_REV"
start=$SECONDS
module purge
module load trimgalore/0.6.4

trim_galore --cores 4 --nextseq 20 --adapter AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
--adapter2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT --length 20 --paired \
--fastqc_args "--outdir $OUTDIR" --output_dir ./trimmed_reads/ $FILE_FOR $FILE_REV 

end=$SECONDS
echo "duration:$((end-start)) seconds."
