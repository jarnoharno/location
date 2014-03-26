#!/usr/bin/Rstudio

# training data
rsscal = read.table('training_set.csv',sep=',')

# grid cell id vector
gid = rsscal[40]

# rss measurements
rssm = rsscal[1:39]
# replace missing values
rssm[rssm==0] = -120

# means and standard deviations of rss measurements in grid cells
means = apply(rssm, 2, function(col) tapply(col, gid, mean))
sds = apply(rssm, 2, function(col) tapply(col, gid, sd))

prpos = function(rss) {
  # point probabilities for each measurement for each beacon and each grid cell
  pr = t(dnorm(rss,t(means),t(sds)))
  return(pr)
  # total log probability of a grid cell
  lpr = apply(log(pr), 1, sum)
  # return id of the cell with maximum log probability
  gid[which.max(lpr)]
}
