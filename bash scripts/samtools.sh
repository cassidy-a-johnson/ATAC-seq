#!/bin/bash

###This is a document to run samtools: 
    #converting sam to bam, sorting, indexing, and filtering out unmapped and multimapped reads

##sam to bam | sort | index 


#SBATCH -o /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/sbatch/sams.%A.%a.out
#SBATCH --job-name=GCF.samtools
#SBATCH --partition=vgl
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --time=24:02:00
#SBATCH --mail-type=all
#SBATCH --mail-user=cjohnson02@rockefeller.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH -a 0-27%10


cd /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC
SMPL_LIST=($(<VAR_LS.txt))
SMPL=${SMPL_LIST[${SLURM_ARRAY_TASK_ID}]}

mkdir bams

##check if the sams are gzipped or not
#bgzip "$SMPL".sam > "$SMPL".sam.gz

samtools view -b /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/sams/"$SMPL".sam > ./bams/"$SMPL".bam

samtools sort -O bam -o "$SMPL"_sorted.bam "$SMPL".bam

samtools index "$SMPL"_sorted.bam

samtools view -bq 10 -F 0x4 -o "$SMPL"_unique.bam "$SMPL"_sorted.bam

samtools index "$SMPL"_unique.bam


##counting sorted reads vs unique reads:
#srun -pvgl -c32 samtools view -c AX1_sorted.bam
#srun -pvgl -c32 samtools view -c AX1_unique.bam


##merging bams:
#cd /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/bams/unique

#samtools merge -o AX_merge.bam AX1_S3_unique.bam AX2_S7_unique.bam AX4_S3_unique.bam AX5_S7_unique.bam
#samtools merge -o HVC_merge.bam HVC1_S1_unique.bam HVC2_S2_unique.bam HVC3_S3_unique.bam HVC4_S4_unique.bam
#samtools merge -o RA_merge.bam RA1_S1_unique.bam RA2_S5_unique.bam RA4_S1_unique.bam RA5_S5_unique.bam
