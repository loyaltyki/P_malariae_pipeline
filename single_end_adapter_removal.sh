#!/bin/bash

# Define input/output directory variables
RAW_DIR="path/to/raw_reads"
OUT_DIR="path/to/clean_reads/single_end"

# Create output directory if it doesn't exist
mkdir -p $OUT_DIR

# Loop over all single-end reads (excluding paired-end _1/_2 files)
for FQ in ${RAW_DIR}*.fastq.gz; do
  if [[ $FQ == *_1.fastq.gz || $FQ == *_2.fastq.gz ]]; then
    continue
  fi

  SAMPLE=$(basename $FQ .fastq.gz)

  echo "Processing single-end sample: $SAMPLE"

  AdapterRemoval --file1 $FQ \
                 --basename ${OUT_DIR}/${SAMPLE} \
                 --trimns \
                 --trimqualities \
                 --minquality 20 \
                 --minlength 30 \
                 --gzip \
                 --adapter1 AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
                 --adapter2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
done
