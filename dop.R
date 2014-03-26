#!/usr/bin/Rscript

library(functional)

ecefname = 'ecef.csv'
if (!interactive() && length(commandArgs(trailingOnly=T)) > 0) {
  ecefname = commandArgs(trailingOnly=T)[1]
}

# satellite location data
ecef = read.table(ecefname, header=TRUE, stringsAsFactors=FALSE)

# euclidean distance between a and b
norm  = function(a, b) dist(rbind(a, b))

# satellite positions
sat = data.matrix(ecef[2:5,2:4])

# reference position
ref = unlist(ecef[1,2:4])

# distances between satellites and reference position
d = apply(sat, 1, Curry(norm, ref))

# reference position matrix
refm = t(matrix(rep(ref, 4), 3))

# distance matrix
dm = matrix(rep(d, 3), 4)

# A matrix
A = cbind(((sat - refm) / dm), rep(-1, 4))

# DoP matrix
Q = solve(crossprod(A))

# Q diagonal
qd = diag(Q)

# DoP values
dgop = sqrt(sum(qd))
tdop = sqrt(sum(qd[4]))
pdop = sqrt(sum(qd[1:3]))
hdop = sqrt(sum(qd[1:2]))
vdop = sqrt(sum(qd[3]))

if (!interactive()) {
  write.table(format(Q),row.names=F,col.names=F,quote=F)
  cat('HDOP', hdop, '\n')
  cat('VDOP', vdop, '\n')
  cat('PDOP', pdop, '\n')
}
