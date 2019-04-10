# LISI
Methods to compute Local Inverse Simpson's Index (LISI)

Check out how we use LISI to measure single cell integration methods in the Harmony paper: [bioRxiv](https://www.biorxiv.org/content/early/2018/11/04/461954)

# Getting started

install LISI with devtools: 

```
install.packages('devtools')
devtools::install_github("immunogenomics/lisi")
```

With a matrix of PCA embeddings and meta data table, compute LISI with respect to one or more cell labels: 

```
library(lisi)
lisi_res <- lisi::compute_lisi(lisi::X, lisi::meta_data, c('label1', 'label2'))
head(lisi_res)
```
