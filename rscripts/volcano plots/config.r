
#### Setup ####

library(DiffBind)
library(DESeq2)
library(dplyr)
library(ggplot2)
library(data.table)
library(gtools)

source("Rscripts/Volcano Plots/import.R")
source("Rscripts/Volcano Plots/data_munge.R")

#### Import ####

count_matrix <- get_counts()
s_metadata <- get_metadata(colnames(count_matrix))

#### Processing ####

all_possible_comparisons <- data_CreateAllPossibleCombinations(s_metadata, names(s_metadata))

targeted_DES <- data_RunAllDES( # modifying to targets, for time; if want to do others, can eliminate the filter on all pos comparisons
  counts = count_matrix, meta = s_metadata, combos = all_possible_comparisons[c(3, 14, 16, 20),], as_df = T
)

hex_code_list <- list(
  "Brain_Region.RA.LAI" = c("RA" = "#f607eb", "LAI" = "#5a1357"),
  "Brain_Region.AX.VS" = c("AX" =  "#47e7f8", "VS" = "#3180ba"),
  "Brain_Region.HVC.HCS" = c("HVC" = "#36ec3d", "HCS" = "#1d6920"),
  "Condition.Song_Nuclei.Surround" = c("Song_Nuclei" = "#eb572a", "Surround" = "#0b0403")
)

figures_and_counts <- data_PlotDES(l = targeted_DES, hex_codes = hex_code_list)

#### Write Out ####

data_ExportGraphs(figures_and_counts)
