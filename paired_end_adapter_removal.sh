#!/bin/bash

# Define input/output directory variables
RAW_DIR="path/to/raw_reads"
OUT_DIR="path/to/clean_reads/paired_end"

# Create output directory if it doesn't exist
mkdir -p $OUT_DIR

# Loop over paired-end read files (_1 and _2)
for R1 in ${RAW_DIR}*_1.fastq.gz; do
  SAMPLE=$(basename $R1 _1.fastq.gz)
  R2=${RAW_DIR}${SAMPLE}_2.fastq.gz

  echo "Processing paired-end sample: $SAMPLE"

  AdapterRemoval --file1 $R1 \
                 --file2 $R2 \
                 --basename ${OUT_DIR}/${SAMPLE} \
                 --trimns \
                 --trimqualities \
                 --minquality 20 \
                 --minlength 30 \
                 --gzip \
                 --collapse
done
