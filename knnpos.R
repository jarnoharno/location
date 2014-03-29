#!/usr/bin/Rscript

library(functional)

# rss calibration data
rsscal = read.table('rss.csv', header=TRUE)

# euclidean distance between a and b
norm  = function(a, b) dist(rbind(a, b))

# geometric mean of values in array x
gmean = function(x) exp(mean(log(x)))

# weighting function
wghtf = function(x) 1/exp(x)

knnpos = function(k, rss, weighted = FALSE) {
  # distances between rss and calibration set
  d = apply(rsscal[1:2], 1, Curry(norm, rss))
  # indexes of k nearest data points
  kn = order(d)[1:k]
  # positions of k nearest data points in calibration set
  knp = rsscal[kn,3:4]
  if (weighted) {
    # position weights
    w = sapply(d[kn], wghtf)
    # weighted mean of positions
    apply(w*knp, 2, sum) / sum(w)
  } else {
    # geometric mean of the positions
    apply(knp, 2, gmean)
  }
}

# for command line use

if (!interactive()) {
  args = commandArgs(trailingOnly = TRUE)
  if (length(args) < 3) {
    cat('usage: knnpos k rss1 rss2 [weighted]\n')
  } else {
    weighted = FALSE
    if (length(args) > 3) {
      weighted = as.logical(args[4])
    }
    par = as.numeric(args[1:3])
    pos = knnpos(par[1], par[2:3], weighted)
    cat(pos,'\n')
  }
}
