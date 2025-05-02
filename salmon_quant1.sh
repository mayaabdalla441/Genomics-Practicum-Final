#!/bin/bash
#BATCH --job-name=quant_Salmonall
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8   
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=8G
#SBATCH --mail-user=abdalla@uchc.edu
#SBATCH --output=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.out
#SBATCH --error=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.err

set -e  # Exit immediately if any command fails

# Record start time
start_time=$(date +%s)  # Get timestamp in seconds


date
echo "Hostname: $(hostname)"

# Load required modules
module load salmon/1.9.0

# Directory containing your .fastq files
FASTQ_DIR=/home/FCAM/mabdalla/MGP_final

# Path to your existing Salmon index
SALMON_INDEX=/home/FCAM/mabdalla/MGP_final/salmon_index

# Where all quant outputs will go
OUTPUT_DIR=/home/FCAM/mabdalla/MGP_final/salmon_quant
mkdir -p "$OUTPUT_DIR"

# Enable nullglob so the loop skips if no matches
shopt -s nullglob

for fq1 in "$FASTQ_DIR"/*_1.fastq; do
  # Derive sample name, stripping off "_1.fastq"
  sample=$(basename "$fq1" _1.fastq)
  fq2="$FASTQ_DIR/${sample}_2.fastq"

  # sanity check: make sure the mate exists
  if [[ ! -e "$fq2" ]]; then
    echo "ERROR: missing mate for $sample → $fq2" >&2
    exit 1
  fi

  # run salmon quant
  salmon quant \
    -i "$SALMON_INDEX" \
    -l A \
    -1 "$fq1" \
    -2 "$fq2" \
    --validateMappings \
    -p 8 \
    -o "$OUTPUT_DIR/$sample"

  echo " Quantified $sample"
done

echo "All samples processed into $OUTPUT_DIR"
