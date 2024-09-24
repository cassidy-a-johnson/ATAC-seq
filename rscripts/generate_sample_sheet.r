##Rscript to create sampleSheet from macs2 called peaks (narrowPeak) for DiffBind input

# Load necessary libraries
library(tidyverse)

# Set directories for peak and BAM files
peak_dir <- "/lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/bams/unique/peaks"
bam_dir <- "/lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/bams/unique"


# List all peak files and BAM files
peak_files <- list.files(peak_dir, pattern = "*.narrowPeak", full.names = TRUE)
bam_files <- list.files(bam_dir, pattern = "*.bam", full.names = TRUE)

# Create a data frame for the sample sheet
sample_sheet <- data.frame(
  SampleID = character(),
  Condition = character(),
  Replicate = integer(),
  Tissue = character(),
  bamReads = character(),
  Peaks = character(),
  PeakCaller = character(),
  stringsAsFactors = FALSE
)

# Loop over peak files and fill in the data frame
for (i in seq_along(peak_files)) {
  sample_name <- basename(peak_files[i])
  sample_id <- sub("_.*", "", sample_name) # Extract the sample identifier
  
  
  # Determine condition based on sample name prefix
 if (grepl("^AX", sample_name, ignore.case = TRUE) || 
    grepl("^HVC", sample_name, ignore.case = TRUE) || 
    grepl("^RA", sample_name, ignore.case = TRUE)) 
{
    condition <- "Song Nuclei"
} else if (grepl("^VS", sample_name, ignore.case = TRUE) || 
           grepl("^HCS", sample_name, ignore.case = TRUE) || 
           grepl("^LAI", sample_name, ignore.case = TRUE))
{
    condition <- "Surround"
} else if (grepl("^LIVER", sample_name, ignore.case = TRUE)) 
{
    condition <- "Non-brain Control"
} else 
{
    condition <- "Unknown"
}
  
  # Determine tissue type based on sample name prefix
  if (grepl("^LIVER", sample_name, ignore.case = TRUE)) {
    tissue <- "Liver"
  } else {
    tissue <- "Brain"
  }
  
  # Extract replicate number from sample name
  replicate <- as.numeric(sub("[^0-9]", "", sample_name)) # Extract the numeric part of the sample name
  
  # Find the corresponding BAM file
  bam_file <- bam_files[grepl(sample_id, bam_files)]
  
  # Add a row to the sample sheet data frame
  sample_sheet <- rbind(sample_sheet, data.frame(
    SampleID = sample_id,
    Condition = condition,
    Replicate = replicate,
    Tissue = tissue,
    bamReads = bam_file,
    Peaks = peak_files[i],
    PeakCaller = "macs2"
  ))
}

# Save the sample sheet to a CSV file
write.csv(sample_sheet, "Sample_sheet.csv", row.names = FALSE)
