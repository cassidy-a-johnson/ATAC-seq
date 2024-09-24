
my_combinations <- function (n, r, v = 1:n, set = TRUE, repeats.allowed = FALSE){
  # modified from gtools
  
  if (mode(n) != "numeric" || length(n) != 1 || n < 1 || (n%%1) != 
      0) 
    stop("bad value of n")
  if (mode(r) != "numeric" || length(r) != 1 || r < 1 || (r%%1) != 
      0) 
    stop("bad value of r")
  if (!is.atomic(v) || length(v) < n) 
    stop("v is either non-atomic or too short")
  if ((r > n) & repeats.allowed == FALSE) 
    stop("r > n and repeats.allowed=FALSE")
  if (set) {
    v <- unique((v)) # taking out the sort here
    if (length(v) < n) 
      stop("too few different elements")
  }
  v0 <- vector(mode(v), 0)
  if (repeats.allowed) 
    sub <- function(n, r, v) {
      if (r == 0) 
        v0
      else if (r == 1) 
        matrix(v, n, 1)
      else if (n == 1) 
        matrix(v, 1, r)
      else rbind(cbind(v[1], Recall(n, r - 1, v)), Recall(n - 
                                                            1, r, v[-1]))
    }
  else sub <- function(n, r, v) {
    if (r == 0) 
      v0
    else if (r == 1) 
      matrix(v, n, 1)
    else if (r == n) 
      matrix(v, 1, n)
    else rbind(cbind(v[1], Recall(n - 1, r - 1, v[-1])), 
               Recall(n - 1, r, v[-1]))
  }
  sub(n, r, v[1:n])
}

data_CreateDESResults <- function(
  counts, meta, column_comparison, comparison_set, as_df
){
  
  # May not need this, but safer
  meta_proc <- meta %>%
    filter(
      !!as.symbol(column_comparison) %in% comparison_set 
    )
  
  col_names_keep <- row.names(meta_proc)
  
  design_formula <- as.formula(paste0("~", column_comparison))
  dds <- DESeq(DESeqDataSetFromMatrix(counts[,col_names_keep], meta_proc, design_formula))
  
  res <- results(dds, contrast = c(column_comparison, comparison_set))
  
  if (as_df){
    res <- data.frame(res) %>%
      filter( # adding in an NA filter
        complete.cases(.)
      ) %>%
      mutate(
        FoldChange = logratio2foldchange(log2FoldChange),
        Significant = (padj <= 0.05) & (abs(FoldChange) >= 2),
        `-log10(FDR)` = -log(padj, base = 10),
        Differential_Peaks = if_else(
          Significant & (log2FoldChange > 0), comparison_set[1], "Not Significant"
        ),
        Differential_Peaks = if_else(
          Significant & (log2FoldChange < 0), comparison_set[2], Differential_Peaks
        )
      )
  }
  
  return(res)
}

data_CreateAllPossibleCombinations <- function(d, cols_use){
  
  res <- lapply(cols_use, function(i){
    
    uni_chars <- unique(as.character(d[[i]]))
    combos <- my_combinations(n = length(uni_chars), r = 2, v = uni_chars) %>%
      data.frame %>%
      mutate(
        Column_Name = i, .before = 1
      )
    
  }) %>%
    rbindlist %>%
    data.frame %>%
    rename(
      Comparison1 = X1,
      Comparison2 = X2
    )
    
  return(res)
}

data_RunAllDES <- function(counts, meta, combos, as_df = T){
  
  res <- lapply(1:nrow(combos), function(i){
    
    c_row <- combos[i,]
    col <- c_row[[1]]
    comparisons <- c(c_row[[2]], c_row[[3]])
    
    out <- data_CreateDESResults(
      counts, meta, col, comparisons, as_df
    )
    
    print(i)
    return(out)
  })
  
  names(res) <- paste(combos[[1]], combos[[2]], combos[[3]], sep = ".")
  return(res)
}

data_PlotDES <- function(l, hex_codes = NULL){
  
  res <- lapply(names(l), function(nm){
    
    c_l <- l[[nm]]

    plot <- ggplot(c_l, aes(x = log2FoldChange, y = `-log10(FDR)`, color = Differential_Peaks)) +
      xlab("FoldChange") + 
      geom_point() + 
      geom_vline(xintercept = c(-1, 1)) +
      geom_hline(yintercept = -log(0.05, base = 10)) +
      theme_minimal()
    
    if (nm %in% names(hex_codes)){
      
      vals <- c(hex_codes[[nm]], "Not Significant" = "#8f8e8f")
      
      plot <- plot + scale_color_manual(values = vals)
    }
    
    counts <- c_l %>% group_by(Differential_Peaks) %>% count
    
    out <- list(
      figure = plot,
      n_counts = counts
    )
    
    return(out)
  })
  
  names(res) <- names(l)
  return(res)
}

data_ExportGraphs <- function(l){
  
  for (i in names(l)){
    pdf(paste0("volcano/", i, ".pdf"))
    print(l[[i]]$figure)
    dev.off()
  }
  
  return("DONE")
}
