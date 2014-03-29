#!/usr/bin/Rscript

# training data
rsscal = read.table('training_set.csv',sep=',')

# grid cell id vector
gid = unlist(rsscal[40])

# rss measurements
rssm = data.matrix(rsscal[1:39])
# replace missing values
rssm[rssm==0] = -120

# means and standard deviations of rss measurements in grid cells
means = apply(rssm, 2, function(col) tapply(col, gid, mean))
# sample standard deviation
sds = apply(rssm, 2, function(col) tapply(col, gid, sd))

prpos = function(rss) {
  # point probabilities for each measurement for each beacon and each grid cell
  pr = t(dnorm(rss,t(means),t(sds)))
  # total log probability of a grid cell
  lpr = apply(log(pr), 1, sum)
  # return id of the cell with maximum log probability
  # is unique guaranteed to produce values at the same order as tapply?
  # i hope so...
  unique(gid)[which.max(lpr)]
}

if (!interactive()) {
  testf = 'test_set.csv'
  cmd = commandArgs(trailingOnly=T)
  if (length(cmd) > 0) {
    testf = cmd[1]
  }
  test = read.table(testf,sep=',')
  cat(apply(test, 1, prpos), '\n')
}
