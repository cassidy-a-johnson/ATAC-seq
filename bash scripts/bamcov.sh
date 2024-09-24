#!/bin/bash

###This is a document to run bamcoverage from deeptools to convert bams to bigwigs


#SBATCH -o /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/sbatch/bamcov.%A.%a.out
#SBATCH --job-name=bamcov
#SBATCH --partition=vgl
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --time=24:02:00
#SBATCH --mail-type=all
#SBATCH --mail-user=cjohnson02@rockefeller.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH -a 0-26%6

cd /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC
SMPL_LIST=($(<VAR_LS.txt))
SMPL=${SMPL_LIST[${SLURM_ARRAY_TASK_ID}]}

#bamCoverage -b AX1_marked_dup.bam --outFileName AX1_bamCov --outFileFormat bigwig
bamCoverage -b </input bam/> --outFileName "$SMPL".bw --outFileFormat bigwig

##add the proper </input bam/> before running!
