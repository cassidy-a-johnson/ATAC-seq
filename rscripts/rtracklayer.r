library(rtracklayer)

##For filtering the narrowPeak files to remove peaks mapping the mitochondria

# Set directories for peak and BAM files
peak_dir <- "/lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/bams/unique/peaks"
bam_dir <- "/lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/bams/unique"

peak_files <- list.files(peak_dir, pattern = "filtered*", full.names = TRUE)
bam_files <- list.files(bam_dir, pattern = "*.bam", full.names = TRUE)

# Define the sample names
samples <- c("AX1_S3", "AX2_S7", "AX4_S3", "AX5_S7", 
             "VS1_S4", "VS2_S8", "VS4_S4", "VS5_S8", 
             "RA1_S1", "RA2_S5", "RA4_S1", "RA5_S5", 
             "LAI1_S2", "LAI2_S6", "LAI4_S2", "LAI5_S6", 
             "HVC1_S1", "HVC2_S2", "HVC3_S3", "HVC4_S4", 
             "HCS1_S5", "HCS2_S6", "HCS3_S7", "HCS4_S8", 
             "LIVER1_S9", "LIVER2_S10", "LIVER3_S11", "LIVER4_S12")

# Path to the narrowPeak files (adjust this to match your directory structure)
base_path <- "/lustre/fs5/vgl/scratch/cjohnson02/vocal_learning_data/Lindsey/ZF_ATAC/bams/unique/peaks/"

# Loop through each sample
for (sample in samples) {
  # Construct the file path for the narrowPeak file
  narrowpeak_file <- paste0(base_path, sample, "_peaks.narrowPeak")
  
  # Import the narrowPeak file
  narrow_peaks <- import(narrowpeak_file)
  
  # Filter out mitochondrial reads (CM016613.2)
  filtered_peaks <- narrow_peaks[!grepl("CM016613.2", seqnames(narrow_peaks))]
  
  # Optional: Save filtered peaks to a new file (adjust the output path if necessary)
  output_file <- paste0(base_path, "filtered_", sample, "_peaks.narrowPeak")
  export(filtered_peaks, output_file)
  
  # Print status to console
  cat("Processed and saved filtered peaks for", sample, "\n")
}
