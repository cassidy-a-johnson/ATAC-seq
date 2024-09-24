#!/bin/bash

###This is a document to run MACS2 for peak calling

##EXAMPLE: macs2 callpeak -f BAMPE -t ATAC.bam -g hs -n test -B -q 0.01


#SBATCH -o /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/sbatch/calling.%A.%a.out
#SBATCH --job-name=callpeaks
#SBATCH --partition=vgl
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --time=24:02:00
#SBATCH --mail-type=all
#SBATCH --mail-user=cjohnson02@rockefeller.edu
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH -a 0-27%5

cd /lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/bams/unique
SMPL_LIST=($(<VAR_LS.txt))
SMPL=${SMPL_LIST[${SLURM_ARRAY_TASK_ID}]}

macs2 callpeak -f BAMPE -t "$SMPL"_unique.bam -g 1e9 -n "$SMPL" -B -q 0.05 --outdir peaks

##note: peak directory will be located inside "unique" directory