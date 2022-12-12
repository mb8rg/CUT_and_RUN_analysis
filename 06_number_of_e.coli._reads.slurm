#!/bin/bash
#SBATCH -A bme4350		# account
#SBATCH -p standard	# partition/queue
#SBATCH --nodes=1		# number of compute nodes
#SBATCH --ntasks=1		# number of program instances
#SBATCH --time=02:00:00		# max time before job cancels
#SBATCH --mem=64GB               # memory
#SBATCH --cpus-per-task=8
#SBATCH -c 8

# Create directory and set variables
DATA_PATH=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/Ecoli_aligned_reads

# Get list of all bam data files
FILES=($(ls -1 $DATA_PATH/*.bam))

start=$SECONDS
module purge
module load gcc
module load samtools

for n in {0..41}
do
	FILE=${FILES[$n]}
	samtools view -F 0x04 -c -@8 $FILE >> ecoli_read_counts
	samtools view -F 0x04 -q 20 -c -@ 8 $FILE >> qual20_ecoli_read_counts
done

end=$SECONDS
echo "duration:$((end-start)) seconds."
