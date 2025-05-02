#!/bin/bash
#SBATCH --job-name=mm10_star
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 6
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=32G
#SBATCH --mail-user=abdalla@uchc.edu
#SBATCH --output=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.out
#SBATCH --error=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.err

set -e  # Exit immediately if any command fails (important for debugging)

# Record start time
start_time=$(date +%s)  # Get timestamp in seconds


date
echo "host name : " `hostname`

# Load necessary packages
module load STAR/2.7.11a
module load IGVtools/2.9.1

# Input directory
IN_DIR=/home/FCAM/mabdalla/MGP_final

# Output directory, where STAR will drop the BAM files
OUTPUT_DIR=/home/FCAM/mabdalla/MGP_final/star_out
mkdir -p $OUTPUT_DIR

SAMPLES="CTL_04 CTL_90_4 DN_04 DN_90_4" #base names

for sample in $SAMPLES; do
  STAR --runThreadN 6 \
       --genomeDir /home/FCAM/mabdalla/MGP_final/mm10_genome \
       --readFilesIn $IN_DIR/${sample}_1.fastq $IN_DIR/${sample}_2.fastq \
       --outFileNamePrefix $OUTPUT_DIR/${sample}. \
       --outSAMtype BAM SortedByCoordinate \
       --outBAMsortingThreadN 6 \
       --outFilterType BySJout \
       --outFilterMultimapNmax 20 \
       --alignSJoverhangMin 8 \
       --alignSJDBoverhangMin 1 \
       --outFilterMismatchNoverReadLmax 0.04 \
       --alignIntronMin 20 \
       --alignIntronMax 300000 \
       --alignMatesGapMax 300000

  echo "Finished $sample"
done

date
echo "All samples complete."

# Record end time
end_time=$(date +%s)  # Get timestamp in seconds

# Calculate runtime duration
runtime=$((end_time - start_time))
echo "Pipeline completed successfully."
echo "Total runtime: $((runtime / 60)) minutes and $((runtime % 60)) seconds."
