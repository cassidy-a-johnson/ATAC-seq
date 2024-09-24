# ATAC-seq
My pipeline to run ATAC-seq [or similar] analysis on zebra finch microdissected samples. Parts are adapted from the RU BRC pipeline.

The combination of bash commands and Rscripts depends on the tool being used. Ranging from indexing and sorting, all the way to differential analysis and plot generation.

Required bash tools: bowtie2, samtools, deeptools, macs2, markdups.
Required Rscript libraries: install.packages('BiocManager')
BiocManager::install('RockefellerUniversity/RU_ATACseq',subdir='atacseq')

Note: some of these filtering steps are optional.

This was done in 2024 with the 4.2.3 version of R.

Cassidy Johnson
Rockefeller University
