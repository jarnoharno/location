#!/usr/bin/Rscript

library(abind)

# data
rss = read.table('week3table1.csv')

# fix data
rss[rss == 0] = -100

# maximum ap on each measurement
maxs = apply(rss, 1, which.max)

# dwells on aps
dwell = rle(maxs)

# in matrix form
mdwell = cbind(unlist(dwell['values']), unlist(dwell['lengths']))

if (!interactive()) {
  write.table(format(t(mdwell)), row.names=F, col.names=F, quote=F)
}
