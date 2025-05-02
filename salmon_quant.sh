#!/bin/bash
#SBATCH --job-name=quantSalmon_fastq
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4                      # number of threads for salmon
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mail-user=abdalla@uchc.edu
#SBATCH --mem=16G
#SBATCH --output=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.out
#SBATCH --error=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.err

set -euo pipefail

module load salmon/1.9.0

FASTQ_DIR=/home/FCAM/mabdalla/MGP_final
SALMON_INDEX=/home/FCAM/mabdalla/MGP_final/salmon_index
OUTPUT_DIR=/home/FCAM/mabdalla/MGP_final/salmon_quant

mkdir -p "$OUTPUT_DIR"

for fq1 in "$FASTQ_DIR"/*_1.fastq; do
  # Derive sample name by stripping the _1.fastq suffix
  sample=$(basename "$fq1" _1.fastq)
  fq2="$FASTQ_DIR/${sample}_2.fastq"

  if [[ ! -e "$fq2" ]]; then
    echo "ERROR: missing R2 file for $sample: $fq2" >&2
    exit 1
  fi

  salmon quant \
    -i "$SALMON_INDEX" \
    -l A \
    -1 "$fq1" \
    -2 "$fq2" \
    --validateMappings \
    -p 4 \
    -o "$OUTPUT_DIR/$sample"

  echo "Quantified $sample"
done

echo "All FASTQ samples quantified into $OUTPUT_DIR"
