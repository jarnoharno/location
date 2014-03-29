#!/usr/bin/Rscript

# data
data = scan('week3table2.csv', what=integer())
ndata = length(data)

# locations
locs = sort(unique(data))
nlocs = length(locs)

# transition matrix
tm = matrix(0, nlocs, nlocs, dimnames=list(locs,locs))
# this sucks
for (i in 1:(ndata-1)) tm[as.character(data[i]),as.character(data[i+1])] = 
  tm[as.character(data[i]),as.character(data[i+1])] + 1

# total transitions from state
totaltfrom = apply(tm, 1, sum)
# fix values for which there is no value
totaltfrom[totaltfrom == 0] = 1

# mle transition probabilities
tp = tm / matrix(rep(totaltfrom,nlocs),nlocs)

if (!interactive()) {
  write.table(format(signif(tp,3)), quote=F)
}
