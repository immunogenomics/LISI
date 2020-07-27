#' Compute Local Inverse Simpson's Index (LISI)
#' 
#' Use this function to compute LISI scores of one or more labels. 
#' 
#' @param X A matrix with cells (rows) and features (columns).
#' @param meta_data A data frame with one row per cell. 
#' @param label_colnames Which variables to compute LISI for. 
#' @param perplexity The effective number of each cell's neighbors.
#' @param nn_eps Error bound for nearest neighbor search with \code{RANN:nn2()}.
#' Default of 0.0 implies exact nearest neighbor search.
#' 
#' @return A data frame of LISI values. Each row is a cell and each
#' column is a different label variable. 
#' 
#' @importFrom RANN nn2
#' @export 
#' 
#' @examples
#' 
#' ## Example with 400 cells. 
#' library(lisi)
#' library(dplyr)
#' library(tidyr)
#' library(ggplot2)
#' library(magrittr)
#' 
#' head(lisi::meta_data)
#' 
#' ## Let's color cells by labels. For label 1, there are mixed and non-mixed
#' ## groups. For label 2, all cells are well mixed. 
#' lisi::X %>% 
#'   cbind(lisi::meta_data) %>% 
#'   sample_frac(1L, FALSE) %>% 
#'   gather(key, val, label1, label2) %>% 
#'   ggplot(aes(X1, X2, color = val)) +
#'     geom_point(shape = 21) + 
#'     facet_wrap(~key)
#'   
#' ## Now to compute and plot the LISI values for each label. 
#' lisi_res <- compute_lisi(lisi::X, lisi::meta_data, c('label1', 'label2'))
#' head(lisi_res)
#' 
#' lisi::X %>% 
#'   cbind(lisi_res) %>% 
#'   sample_frac(1L, FALSE) %>% 
#'   gather(key, lisi_value, label1, label2) %>% 
#'   ggplot(aes(X1, X2, color = lisi_value)) +
#'     geom_point(shape = 21) + 
#'     facet_wrap(~key)
#' 
compute_lisi <- function(
  X, meta_data, label_colnames, perplexity = 30, nn_eps = 0
) {
  N <- nrow(meta_data)
  dknn <- nn2(X, k = perplexity * 3, eps = nn_eps)
  lisi_df <- data.frame(matrix(NA, N, length(label_colnames)))
  lisi_df <- Reduce(cbind, lapply(label_colnames, function(label_colname) {
    labels <- data.frame(meta_data)[, label_colname, drop = TRUE]
    if (any(is.na(labels))) {
      message('Cannot compute LISI on missing values')      
      return(rep(NA, N))
    } else {
      ## don't count yourself in your neighborhood
      dknn$nn.idx <- dknn$nn.idx[, 2:ncol(dknn$nn.idx)]
      dknn$nn.dists <- dknn$nn.dists[, 2:ncol(dknn$nn.dists)]
      labels <- as.integer(factor(labels)) - 1
      n_batches <- length(unique(labels))
      simpson <- compute_simpson_index(
        t(dknn$nn.dists),
        t(dknn$nn.idx) - 1, 
        labels,
        n_batches,
        perplexity
      )
      return(1 / simpson)
    }
  }))
  lisi_df <- as.data.frame(lisi_df)  
  colnames(lisi_df) <- label_colnames
  row.names(lisi_df) <- row.names(meta_data)
  return(lisi_df)
}


