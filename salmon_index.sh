#!/bin/bash
#SBATCH --job-name=indexSalmon
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mail-user=abdalla@uchc.edu
#SBATCH --mem=16G
#SBATCH --output=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.out
#SBATCH --error=/home/FCAM/mabdalla/MGP_final/eofiles/%x.%j.err

module load salmon/1.9.0

transcriptome="/home/FCAM/mabdalla/MGP_final/mm10_genome/Mus_musculus.GRCm39.cdna.all.fa"
salmon_index="/home/FCAM/mabdalla/MGP_final/salmon_index"

mkdir -p "/MGP_final/salmon_index"

#run salmon index

salmon index \
     -t $transcriptome \
     -i $salmon_index \
     -k 31 \
     -p 4

echo "Salmon index built in $salmon_index"
