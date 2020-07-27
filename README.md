LISI
================

[![R-CMD-check](https://github.com/immunogenomics/LISI/workflows/R-CMD-check/badge.svg)](https://github.com/immunogenomics/LISI/actions)

To assess whether clusters of cells in a single-cell RNA-seq dataset are
well-mixed across some categorical variable (e.g. batch, technology,
donor), we provide an algorithm for computing a Local Inverse Simpson’s
Index (LISI).

Citation
--------

Learn more about how we use LISI to measure single cell integration
methods in the Harmony paper:

-   Korsunsky, I. et al. [Fast, sensitive and accurate integration of
    single-cell data with
    Harmony.](https://www.nature.com/articles/s41592-019-0619-0) Nat.
    Methods (2019)

Or see the freely available pre-print at
[bioRxiv](https://www.biorxiv.org/content/early/2018/11/04/461954).

Installation
------------

Install the lisi R package with devtools:

    install.packages("devtools")
    devtools::install_github("immunogenomics/lisi")

Example
-------

We can compute the LISI for each cell with these inputs:

-   a matrix of cells (rows) and coordinates (PC scores, tSNE or UMAP
    dimensions, etc.)

-   a data frame with categorical variables (one row for each cell)

Here is a small example that uuses the data provided with the lisi R
package.

    library(lisi)
    #> Loading required package: Rcpp

    head(X)
    #>          X1           X2
    #> 1 -5.043102  1.296301452
    #> 2 -6.110305 -0.734483462
    #> 3 -6.069576  0.009776544
    #> 4 -4.552468  0.170646253
    #> 5 -4.601112 -0.074033337
    #> 6 -5.026126 -1.822653071

    head(meta_data)
    #>   label1 label2
    #> 1      A      A
    #> 2      A      A
    #> 3      A      B
    #> 4      A      A
    #> 5      A      B
    #> 6      A      B

    table(meta_data$label1)
    #> 
    #>   A   B 
    #> 200 200

    table(meta_data$label2)
    #> 
    #>   A   B 
    #> 201 199

    res <- compute_lisi(X, meta_data, c('label1', 'label2'))
    head(res)
    #>     label1   label2
    #> 1 1.925592 1.997943
    #> 2 1.994034 1.988416
    #> 3 1.959509 1.714524
    #> 4 1.999995 1.801086
    #> 5 1.960422 1.863254
    #> 6 1.999498 1.984862

Each row in the output data frame corresponds to a cell from `X`. The
score (e.g. 1.92) indicates the effective number of different categories
represented in the local neighborhood of each cell. If the cells are
well-mixed, then we might expect the LISI score to be near 2 for a
categorical variable with 2 categories.

Learn more by running `?compute_lisi` in R.
