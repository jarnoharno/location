#!/usr/bin/Rscript

library(abind)

# data
rss = read.table('week3table1.csv')
n = dim(rss)[1]

# filter zeros
rss[rss == 0] = -100

# tanimoto
tanimoto = function(a, b) (a %*% b) /
  (a %*% a + b %*% b - a %*% b)

# successive rows
succ = abind(rss[1:(n-1),], rss[2:n,], along = 3)

# tanimoto between successive rows
tsucc = apply(succ, 1, function(x) tanimoto(x[,1], x[,2]))

if (!interactive()) {
  cat(signif(tsucc, 4), '\n')
  pdf('tanimoto.pdf')
  plot(tsucc,type='b',ylab=expression(
    T(bold(x)[i], bold(x)[i+1])),xlab=expression(i))
  dev.off()
}
