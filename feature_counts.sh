#!/bin/bash
#SBATCH --job-name=feature_counts
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

set -e


module load subread

BAM_FILES=/home/FCAM/mabdalla/MGP_final/star_out
GTF=/home/FCAM/mabdalla/MGP_final/mm10_genome/Mus_musculus.GRCm39.113.gtf
OUTPUT=/home/FCAM/mabdalla/MGP_final/counts_featurecounts

mkdir -p $OUTPUT

for bam in $BAM_FILES/*.bam; do
  sample=$(basename "$bam" .Aligned.sortedByCoord.out.bam)
  featureCounts \
    -T 8 \                # use 8 threads
    -p \                  # paired-end
    -s 2 \                # strandedness: 2 = reverse
    -t exon \             # feature type
    -g gene_id \          # attribute to group by
    -a "$GTF" \           # annotation
    -o "$OUTPUT/${sample}.counts.txt" \
    "$bam"
  echo "featureCounts done for $sample"
done
