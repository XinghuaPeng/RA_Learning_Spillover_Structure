# 2010 SCM method
# weights = arg min {(y-wx)' V (y-wx)}
# s.t. sum(W) = 1 & 0<w<1
# solve W*(V) 
# v = arg min (z1 - z0 W*(V))'(z1 - z0 W*(V))
# solve V*
# get weights = W*(V*) 


# Note:
# Set V = Identical Matrix. 
# weights = arg min {(y-wx)'(y-wx)}
scm.weight = function(y,x){
  # set up QP problem
  H <- t(x)%*% (x)
  a <- y
  c <- -1*c(t(a) %*% (x) )
  A <- t(rep(1, length(c)))
  b <- 1
  l <- rep(0, length(c))
  u <- rep(1, length(c))
  r <- 0
  require(LowRankQP)
  res <- LowRankQP(Vmat=H,dvec=c,Amat=A,bvec=1,uvec=rep(1,length(c)),method="LU")
  solution.w <- as.matrix(res$alpha)
}
scm.weight = cmpfun(scm.weight)  
  
  
  