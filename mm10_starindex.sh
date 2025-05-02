#!/bin/bash
#SBATCH --job-name=mm10_index
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 2
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=32G
#SBATCH --mail-user=abdalla@uchc.edu
#SBATCH --output=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.out
#SBATCH --error=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.err

date
echo "host name : " `hostname`

module load STAR/2.7.11a

STAR --runThreadN 2 \
     --runMode genomeGenerate \
     --genomeDir /home/FCAM/mabdalla/MGP_final/mm10_genome \
     --genomeFastaFiles /home/FCAM/mabdalla/MGP_final/mm10_genome/Mus_musculus.GRCm39.dna.primary_assembly.fa \
     --sjdbGTFfile /home/FCAM/mabdalla/MGP_final/mm10_genome/Mus_musculus.GRCm39.113.gtf \
     --sjdbOverhang 68 \
     --genomeSAindexNbases 12

echo "Pipeline completed successfully."
