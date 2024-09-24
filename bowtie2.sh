#!/bin/bash

###This is a document to run Bowtie2 on the finch genome and all ZF trimmed fastq's [fastp's]

###Example: bowtie2-build [options]* <reference_in> <bt2_base>
###Example: $BT2_HOME/bowtie2 -x lambda_virus -1 $BT2_HOME/example/reads/reads_1.fq -2 $BT2_HOME/example/reads/reads_2.fq -S eg2.sam


#SBATCH -o /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/sbatch/2019_bowtie2.%A.%a.out
#SBATCH --job-name=bowtie
#SBATCH --partition=vgl
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --time=24:02:00
#SBATCH --mail-type=all
#SBATCH --mail-user=cjohnson02@rockefeller.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH -a 0-27%10


#conda activate cutadaptenv
cd /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/
mkdir sams

SMPL_LIST=($(<VAR_LS.txt))
SMPL=${SMPL_LIST[${SLURM_ARRAY_TASK_ID}]}


##INSERT REFERENCE HERE:
bowtie2-build -f <reference_in> zebrafinch
bowtie2 -x zebrafinch -1 /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/fqs/"$SMPL"_R1_001_val_1.fq.gz -2 /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/fqs/"$SMPL"_R2_001_val_2.fq.gz -S ./sams/"$SMPL".sam
