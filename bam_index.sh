#!/bin/bash
#SBATCH --job-name=bam_indexing
#SBATCH --nodes=1
#SBATCH --ntask=1
#SBATCH --cpus-per-task=1      
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mail-user=abdalla@uchc.edu
#SBATCH --mem=16G
#SBATCH --output=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.out
#SBATCH --error=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.err

set -euo pipefail

module load IGVtools/2.9.1

OUT="/home/FCAM/mabdalla/MGP_final/star_out"

for oldbam in "$OUT"/*.Aligned.sortedByCoord.out.bam; do
  sample=$(basename "$oldbam" .Aligned.sortedByCoord.out.bam)
  newbam="$OUT/${sample}.bam"

  # rename
  mv "$oldbam" "$newbam"

  #  creates newbam.bai in the same directory
  igvtools index "$newbam"

  echo "Indexed $newbam  $newbam.bai"
done
