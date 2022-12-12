# CUT_and_RUN_analysis
Analysis pipeline for paired CUT&RUN data.

The following pipeline is adapted from the following analysis tutorials:  
Zheng Y et al (2020). Protocol.io  
Zhu et al. Genome Biology (2019)   
Kong et al. STAR Protocols (2021)  
Meers et al. Epigenetics & Chromatin (2019)  
SNAP-CUTANA K-MetStat Panel Shell Script


The following tools are required in this pipeline:
* FastQC
* Trim Galore (wrapper around Cutadapt and FastQC)
* Bowtie 2
* Qualimap 2
* SAM Tools
* PICARD
* BEDTools
* SEACR
* DESeq2
* ChiPSeeker

### 1. Preliminary analysis of the quality of reads: FastQC

### 2. Trimming reads: Trim Galore

### 3. Quality control of antibody specificity: K-Met panel analysis

### 4. Read alignment to human and _E. coli_ genomes: Bowtie2

### 5. Quality control of aligned reads: Qualimap

### 6. Read normalization using spike-in _E. coli_ 

### 7. Filtering alignements and file format conversion: SAM Tools, PICARD, BEDtools

### 8. Peak calling: SEACR



