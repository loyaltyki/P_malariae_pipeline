###script to launch download of data from Ibrahim et al. malariae paper https://pmc.ncbi.nlm.nih.gov/articles/PMC11685946/#MOE$

##preparation
#set base directory
baseDir=/your file location

#navigate to base directory
cd $baseDir

#launch wget download script from ENA for samples in BioProject PRJEB75553
./ena-file-download-read_run-PRJEB75553-bam_ftp-20250603-1135.sh

#download adapterremoval tool 
git clone https://github.com/MikkelSchubert/adapterremoval.git

##Adapter Removal Script
This script (`run_adapterremoval_array.sh`) runs AdapterRemoval on a list of FASTQ files using a Sun Grid Engine (SGE) array job.
??????

??????or direct use of the .sh
##step1 Handling single-end samples (those without _1/_2)
mkdir -p /SAN/ballouxlab/hcov19/P_malariae/cleaned/single_end
#!/bin/bash

INPUT_DIR="/SAN/ballouxlab/hcov19/P_malariae/raw_fastq/"
OUTPUT_DIR="/SAN/ballouxlab/hcov19/P_malariae/cleaned/single_end/"

mkdir -p $OUTPUT_DIR

for FQ in ${INPUT_DIR}*.fastq.gz; do
  #Skip files with _1 or _2
  if [[ $FQ == *_1.fastq.gz || $FQ == *_2.fastq.gz ]]; then
    continue
  fi
  SAMPLE=$(basename $FQ .fastq.gz)
  echo "Processing single-end sample: $SAMPLE"
  AdapterRemoval --file1 $FQ \
                 --basename ${OUTPUT_DIR}${SAMPLE} \
                 --trimns \
                 --trimqualities \
                 --minquality 20 \
                 --minlength 30 \
                 --gzip
done

##step2 Handling pair-end samples (who contains _1/_2)
mkdir -p /SAN/ballouxlab/hcov19/P_malariae/cleaned/paired_end
#!/bin/bash

INPUT_DIR="/SAN/ballouxlab/hcov19/P_malariae/raw_fastq/"
OUTPUT_DIR="/SAN/ballouxlab/hcov19/P_malariae/cleaned/paired_end/"

mkdir -p $OUTPUT_DIR

for R1 in ${INPUT_DIR}*_1.fastq.gz; do
  SAMPLE=$(basename $R1 _1.fastq.gz)
  R2=${INPUT_DIR}${SAMPLE}_2.fastq.gz
  echo "Processing paired-end sample: $SAMPLE"
  AdapterRemoval --file1 $R1 \
                 --file2 $R2 \
                 --basename ${OUTPUT_DIR}${SAMPLE} \
                 --trimns \
                 --trimqualities \
                 --minquality 20 \
                 --minlength 30 \
                 --gzip \
                 --collapse
done

@@@@@@@@@@@@@
Do we need this?
## Input

- A text file (`pwd_malariae.txt`) containing the full paths to all cleaned `.gz` files (one per line).
- Files should be paired-end (`*.pe.combined.gz`) or single-end (`*.truncated.gz`).

## How to run
qsub run_adapterremoval_array.sh



