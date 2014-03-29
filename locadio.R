#!/usr/bin/Rscript

library(abind)

# data
rss = read.table('week3table1.csv')

# rss values within the first 10 measurements
rsswin = rss[1:10,]

# rss mean values within the first 10 measurements
means = apply(rsswin, 2, var)

# index of ap with the maximum mean rss
maxi = which.max(means)

# rss variance of the strongest ap
rssvar = var(rsswin[maxi])
rsssd = sqrt(rssvar)

if (!interactive()) {
  cat('var:', rssvar, '\n')
  cat('sd:', rsssd, '\n')
}
