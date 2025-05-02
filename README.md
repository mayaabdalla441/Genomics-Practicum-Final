# Genomics-Practicum-Final
 
## Link to [Paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC6760191/)

## Overview of project
My project aimed to replicate the RNA-Seq analysis the authors described in the paper. The authors performed Illumina sequencing with 69-bp paired end reads, and then FastQC for library preparation/sequencing. Since the reads were of high quality, no reads were trimmed or filtered before alignment to the Mus musculus mm10 genome using STAR. Gene counts were generated with HTSeq using the mm10 refSeq annotation. However, when I attempted this step, the HTSeq run time exceeded 20 days, so I switched to Salmon for efficient transcript quantification.

The authors used TMM normalization, RUVseq (k=1), and differential expression analysis with the limma-voom pipeline. I found this approach too complex to reproduce, so I opted for DESeq2 instead. DESeq2's size factor normalization adjusts for sequencing depth using gene-wise geometric means, which was sufficient to the normalization techniques in the paper. 

While I initially wanted to follow the authors' pipeline exactly, practical limitations led me to adapt the workflow using familiar tools. This project was a valuable experience, it allowed me to explore a paper of personal interest while applying core RNA-Seq techniques. In the end, I performed a pairwise differential expression analysis comparing mice at day 0 and day 90 of degeneration. Below is a step-by-step summary of my workflow

## STEP 1: Downloaded and extracted the SRR # of interest

### Sample Files
SRR9026494	CTL-0-4 CTL male 5 0 SAMN11603137 https://www.ncbi.nlm.nih.gov/biosample/11603137

SRR9026475	CTL-90-4 CTL male 5 90 SAMN11603161 https://www.ncbi.nlm.nih.gov/biosample/11603161

SRR9026459	DN-0-4 DN male 5 0 SAMN11603165 https://www.ncbi.nlm.nih.gov/biosample/11603165

SRR9026502	DN-90-4 5 90 SAMN11603189 https://www.ncbi.nlm.nih.gov/biosample/11603189

## Fetch SRR files and dump into directory 
```bash 
mkdir -p MGP_final

module load sratoolkit

module load fastqc


prefetch SRR9026494 && vdb-validate SRR9026494 && fasterq-dump SRR9026494 -O MGP_final

mv SRR9026494 CTL_04

prefetch SRR9026475 && vdb-validate SRR9026475 && fasterq-dump SRR9026475 -O MGP_final

mv SRR9026475 CTL_90_4

prefetch SRR9026459 && vdb-validate SRR9026459 && fasterq-dump SRR9026459 -O MGP_final

mv SRR9026459 DN_04

prefetch SRR9026502 && vdb-validate SRR9026502 && fasterq-dump SRR9026502 -O MGP_final

mv SRR9026502 DN_90_4
```

## Step 2: Run FASTQC and build STAR index
* No reads were trimmed or filtered before the alignment (STAR) stage because Phred scores were high, 
70 across cycles and nucelotide composition was uniform, according to the authors

``` bash 
# Fastqc on all files ending in .fastq and then built a Star index
module load fastqc
fastqc *.fastq 


# Building a STAR Index - First need to obtain files
mkdir -p mm10_genome
cd mm10_genome

# FASTA (Reference genome)
wget https://ftp.ensembl.org/pub/release-113/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz

# GTF file (Gene annotation)
wget https://ftp.ensembl.org/pub/release-113/gtf/mus_musculus/Mus_musculus.GRCm39.113.gtf.gz

# Gunzip the files to uncompress them 
gunzip Mus_musculus.GRCm39.dna.primary_assembly.fa.gz --> Mus_musculus.GRCm39.dna.primary_assembly.fa

gunzip Mus_musculus.GRCm39.113.gtf.gz --> Mus_musculus.GRCm39.113.gtf

# After obtaining the genomes, I ran the 
mm10_starindex.sh script 

# Then I aligned the sorted BAM files with STAR, running the 
mm10_star.sh script
```
## Inspected alignment results to ensure succesful mapping 
* Before moving on, I wanted to ensure the statistics of my reads matched those from the paper (Tables 1 and 9), so I generated this table in Excel


![Excel_stats](https://github.com/mayaabdalla441/Genomics-Practicum-Final/blob/main/Screenshot%20(220).png)

* My statistics matched those from the paper, only off by a few numbers, assuming this is due to me using the most up to date Mus Musculus genome, while they used the previously published version. 

## Step 3: Fragment counts, Salmon Indexing, and Running Salmon Quant

* I then tried the HTSeq count loop, but it was too slow so I switch to renaming and indexing the BAM files and proceeding with the Salmon pipeline

``` bash 
# Utilized the script below to remove ".Aligned.sortedByCoord.out" from BAM names and index them with IGVtools

bam_indexing.sh

# Then, I ran the script below to build a Salmon index from the Enseml mm10 cDNA FASTA file

indexSalmon.sh

# Then quantified with Salmon (script below) on all paired FASTQs and outputed to salmon_quant directory

quant_Salmonall.sh

# Lastly I opened each quant.sf file and ensured that the contents were reasonable before exporting for DESeq2 analysis

head _quant.sf
#Print an example output of the quant.sf

```

## Step 4: DESeq2 results and figures from .Rmd File
The figures and results below are from the [MGP_Final.Rmd file](https://github.com/mayaabdalla441/Genomics-Practicum-Final/blob/main/MGP_Final.Rmd) 

Figure 1. MA Plot of Filtered Results - Filtered meaning removing low p values (those = na)
[MA plot 1](https://github.com/mayaabdalla441/Genomics-Practicum-Final/blob/main/MA_plot_CTL_VS_DN.pdf)

Figure 2. MA Plot of Significant Genes 
[MA plot 2](https://github.com/mayaabdalla441/Genomics-Practicum-Final/blob/main/MA_plot_Significant_CTL_VS_DN.pdf)

Figure 3. Volcano Plot of All samples
[Volcano Plot](https://github.com/mayaabdalla441/Genomics-Practicum-Final/blob/main/volcano1_1_1.pdf)

Figure 4. DAY 0 (CTL vs. DN 90) Scatter Plot
[Day0 Scatter Plot](https://github.com/mayaabdalla441/Genomics-Practicum-Final/blob/main/0_days_scatterplot.pdf)


Figure 5. DAY 90 (CTL vs. DN 90) Scatter Plot
[Day 90 Scatter Plot](https://github.com/mayaabdalla441/Genomics-Practicum-Final/blob/main/90_days_scatterplot.pdf)


# Conclusion
Based on the results of the scatterplots, the CTL04 and DN04 (DAY 0) tissues are transcriptionally similar. But overtime, as expected the CTL90 and DN90 (DAY 90) tissues show large-scale gene expression divergence over time, as expected, with denervated skeletal muscle overtime, as the biological effects of denervation progress over time. These results support the conclusion that gene dysregulation and variation increases overtime in DN samples. From this pairwise comparision exploration I enjoyed using the tools learned from class to do this analysis, see the results I expect and validate them. 

