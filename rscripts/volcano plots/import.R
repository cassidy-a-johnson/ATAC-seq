
get_counts <- function(){
  res <- read.csv("count_matrix.csv", header = T) %>%
    mutate(
      across(where(is.numeric), round)
    ) %>%
    select( # hardcoded, only genes
      7:ncol(.)
    )
  
  as.matrix(res)
}

get_metadata <- function(nm){
  data.frame( 
    row.names = nm, 
    Condition = c( 
      "Song Nuclei", "Song Nuclei", "Song Nuclei", "Song Nuclei",  
      "Surround", "Surround", "Surround", "Surround",  
      "Song Nuclei", "Song Nuclei", "Song Nuclei", "Song Nuclei",  
      "Surround", "Surround", "Surround", "Surround",  
      "Non-Brain Control", "Non-Brain Control", "Non-Brain Control", "Non-Brain Control",  
      "Song Nuclei", "Song Nuclei", "Song Nuclei", "Song Nuclei",  
      "Surround", "Surround", "Surround", "Surround" 
    ),
    Brain_Region = substr(nm, 1, nchar(nm) - 1)
  ) %>%
    arrange(Condition, Brain_Region) %>%
    mutate(
      Condition = gsub(" |-", "_", Condition),
      across(where(is.character), as.factor)
    )
}
