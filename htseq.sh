#!/bin/bash
#SBATCH --job-name=htseq_counts
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --mem=16G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mail-user=abdalla@uchc.edu
#SBATCH --output=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.out
#SBATCH --error=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.err
set -e

BAM_FILES=/home/FCAM/mabdalla/MGP_final/star_out
GTF=/home/FCAM/mabdalla/MGP_final/mm10_genome/Mus_musculus.GRCm39.113.gtf
OUTPUT=/home/FCAM/mabdalla/MGP_final/counts

mkdir -p $OUTPUT

for bam in \
$BAM_FILES/CTL_04.Aligned.sortedByCoord.out.bam \
$BAM_FILES/CTL_90_4.Aligned.sortedByCoord.out.bam \
$BAM_FILES/DN_04.Aligned.sortedByCoord.out.bam \
$BAM_FILES/DN_90_4.Aligned.sortedByCoord.out.bam
do
sample=$(basename $bam .Aligned.sortedByCoord.out.bam)
htseq-count \
     -f bam \
     -r pos \
     --stranded=reverse \
     -m intersection-nonempty \
     -t exon \
     -i gene_id \
     $bam \
     $GTF \
          > $OUTPUT/${sample}.counts.txt
     echo "HTSEQ counted $sample"
done
