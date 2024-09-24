library(DiffBind)
library(rtracklayer)
library(GenommicRanges)
library(GenomicFeatures)

##creating the DiffBind object and creaeting the read count matrix, needed for DESeq2

samples <- read.csv("sample_sheet.csv")

dbObj <- dba(sampleSheet = samples)
dbObj

##dba.counts = count reads in binding site intervals
dbObj_counts <- dba.count(dbObj, bUseSummarizeOverlaps=TRUE)
dbObj_counts

count_matrix <- (write.csv(as.matrix(dbObj_counts), file = "/lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/count_matrix.csv", row.names =TRUE))
##check and make sure it saved as a matrix
is.matrix(count_matrix)

##Making PCA plots (optional)

pdf("</path and pdf name/>.pdf")
dba.plotPCA(dbObj_counts, attributes=c(DBA_TISSUE, DBA_CONDITION), label=DBA_ID) 
dev.off()

##can edit attributes as is necessary
