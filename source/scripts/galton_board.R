rm(list = ls())
graphics.off()

tri.num <- function(n) {
  output <- n* (n+ 1)/ 2
  return(output)
}

# see https://stat.ethz.ch/pipermail/r-help/2010-July/244299.html
is.even <- function(n) {
  output <- n %% 2 == 0
  return(output)
}

n.rows = 10

x <- rep(0, tri.num(n.rows))
y <- rep(n.rows, tri.num(n.rows))

for (i in 2: n.rows) {
  els <- seq(tri.num(i)- (i- 1), tri.num(i), by = 1)
  if (is.even(i)) {
    x[els] <- seq(-((i- 1)/ 2), ((i- 1)/ 2), by = 1)
  } else {
    x[els] <- seq(-(i- 1)/ 2, (i- 1)/ 2, by = 1)
  }
  y[els] <- n.rows- (i- 1)
}

plot(x, y, type = 'p', bty = 'n', xlab = '', ylab = '')

x2 <- cumsum(c(0, sample(c(-0.5, 0.5), n.rows- 1, replace = TRUE)))
y2 <- seq(n.rows, 1, by = -1)

points(x2, y2, pch = 16, type = 'b')