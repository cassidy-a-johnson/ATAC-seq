#!/bin/bash

###This is a document to picard MarkDups to tag and remove duplicate reads w/ the REMOVE_DUPLICATES option

###Example: picard MarkDuplicates \
    #I=input.bam \
    #O=marked_duplicates.bam \
    #M=marked_dup_metrics.txt

#SBATCH -o /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/sbatch/markdups.%A.%a.out
#SBATCH --job-name=mapping
#SBATCH --partition=vgl
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --time=24:02:00
#SBATCH --mail-type=all
#SBATCH --mail-user=cjohnson02@rockefeller.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH -a 0-27%5
#SBATCH --nice=10

cd /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC
SMPL_LIST=($(<VAR_LS.txt))
SMPL=${SMPL_LIST[${SLURM_ARRAY_TASK_ID}]}

picard MarkDuplicates REMOVE_DUPLICATES=true I="$SMPL"_unique.bam O="$SMPL"_marked_dup.bam M="$SMPL"_markdup_metric.txt

#MarkDuplicates -REMOVE_DUPLICATES true -I AX1_unique.bam -O AX1_marked_dup.bam -M AX1_markdup_metric.txt