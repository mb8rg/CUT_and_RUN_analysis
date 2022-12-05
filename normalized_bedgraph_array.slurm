#!/bin/bash
#SBATCH -A rivanna_fallahi_lab		# account
#SBATCH -p standard	# partition/queue
#SBATCH --nodes=1		# number of compute nodes
#SBATCH --ntasks=1		# number of program instances
#SBATCH --time=02:00:00		# max time before job cancels
#SBATCH --mem=64GB               # memory
#SBATCH --cpus-per-task=8

# Create directory and set variables
DATA_PATH=/project/rivanna_fallahi_lab/cut_and_run_projects/20220902_LOXIMVI_WM115/aligned_reads

# Get list of all bam data files
FILES=($(ls -1 $DATA_PATH/*.bam))
SCALE_FACTORS=Scale_factors.txt

# Use Slurm Array number to select file for this job
FILE=${FILES[$SLURM_ARRAY_TASK_ID]}
SAMPLE_ID=($(basename ${FILE%%_S*}))
SCALE_FACTOR=($(cat $SCALE_FACTORS | awk '$1 == echo '$SLURM_ARRAY_TASK_ID' {print $2}'))

echo "Processing file $FILE"
echo "Sample ID: $SAMPLE_ID"
echo "Scale factor: $SCALE_FACTOR"
start=$SECONDS
module purge
module load gcc
module load samtools
module load bedtools
module load java
module load picard

# Sort by name and mark duplicates
samtools sort -@ 8 -o $SAMPLE_ID.sorted.bam $FILE
java -jar $EBROOTPICARD/picard.jar MarkDuplicates -REMOVE_DUPLICATES true -I $SAMPLE_ID.sorted.bam -O $SAMPLE_ID.dupfiltered.bam -M $SAMPLE_ID.metrics.txt

# Filtering out reads with less than 20 MAPQ score
samtools sort -n -@ 8 $SAMPLE_ID.dupfiltered.bam > $SAMPLE_ID.namesorted.bam
samtools view -h -q 30 -f 2 $SAMPLE_ID.namesorted.bam > $SAMPLE_ID.dupqppfiltered.bam

# Converting a paired-bed BAM file to paired end BED file
bedtools bamtobed -bedpe -i $SAMPLE_ID.dupqppfiltered.bam > $SAMPLE_ID.bed

# Selecting the 5' and 3' coordinates of the read pair to generate a new BED3 file
awk '$1==$4 && $6-$2 < 1000 {print $0}' $SAMPLE_ID.bed > $SAMPLE_ID.clean.bed
cut -f 1,2,6 $SAMPLE_ID.clean.bed | sort -k1,1 -k2,2n -k3,3n | grep -v "^\." > $SAMPLE_ID.fragments.bed

# Converting sorted BAM file to a bedgraph using bedtools genomecov
bedtools genomecov -bg -scale $SCALE_FACTOR -i $SAMPLE_ID.fragments.bed -g GRCh38_genome.txt > $SAMPLE_ID.fragments.normalized.bedgraph

end=$SECONDS
echo "duration:$((end-start)) seconds."
