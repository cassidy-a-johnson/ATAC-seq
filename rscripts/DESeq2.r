library(DiffBind)
library(DESeq2)
library(rtracklayer)
library(GenommicRanges)
library(GenomicFeatures)

##Starting w/ the count matrix from 
count_matrix <- read.csv("count_matrix.csv", row.names = 1)

##Need to remove the columns from count matrix 
count_data <- count_matrix[, 6:33]

##to check the column names
#colnames(count_data)

##Creating the sample metadata dataframe
    ##NOTE: this will be unique to your samples!
sample_columns <- colnames(count_data)
sample_metadata <- data.frame(
    row.names = sample_columns,
    Condition = c(
        "Song Nuclei", "Song Nuclei", "Song Nuclei", "Song Nuclei",  
        "Surround", "Surround", "Surround", "Surround",  
        "Song Nuclei", "Song Nuclei", "Song Nuclei", "Song Nuclei",  
        "Surround", "Surround", "Surround", "Surround",  
        "Non-brain Control", "Non-brain Control", "Non-brain Control", "Non-brain Control",  
        "Song Nuclei", "Song Nuclei", "Song Nuclei", "Song Nuclei",  
        "Surround", "Surround", "Surround", "Surround" 
        )
    )

##Data must be aas integers for DESeq2
count_data <- round(count_data)

##Creating DESeq2 object
dds <- DESeqDataSetFromMatrix(countData = count_data, colData = sample_metadata, design = ~Condition) 
dds <- DESeq(dds) 
results <- results(dds)

##Setting the Condition comparison as I want: Song Nuclei vs Surround
res_filtered <- results(dds, contrast = c("Condition", "Song Nuclei", "Surround")) 

#If you wan to filter data for significance: padj/FDR 0.05
filtered_results <- res_filtered[which(results$padj < 0.05),] 

##Saving the objects
saveRDS(dds, file="dds_object.rds")
saveRDS(res_filtered, file="sn_v_surr_dds.rds") 
saveRDS(filtered_res, file="filtered_sn_v_surr_dds.rds") 
