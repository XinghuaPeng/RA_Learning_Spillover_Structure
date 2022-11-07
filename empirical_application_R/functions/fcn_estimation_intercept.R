#' Models
#' Starts with simple OLS model.
#' Moves to SCM (imposes sum-to-one and non-negativity i.e. simplex constraint)
#' 


############################################################################
##                      LINEAR MODEL (Unconstrained betas)
############################################################################

lm.model = function(data1,data2,oob) {
  if (hasArg(data2)) data1= rbind(data1,data2)
  y = data1[,1]
  x =data1[,-1]
  mod = lm(y~x)
  newx = t(c(1,oob[-1]))
  beta = coef(mod)
  pred = sum(beta*newx)
  oob[1]-pred
}
library(compiler)
lm.model = cmpfun(lm.model)


############################################################################
##                      SCM MODEL (Simplex betas)
############################################################################

projection = function(B) {
  #Function projecting a vector onto the unit simplex. 
  beta = B
  beta[beta<0] = 0 #change negatives to 0.
  if (all(beta==0)) beta = rep(1,length(B))
  # there is an edge case where everything is 0 and the normalization breaks.
  beta/sum(beta)   #normalize remaining positive components.
}
scm.loss = function(beta,beta_ols,covX) {
  #' Mahalonobis distance between a vector, and a simplex 
  #' projected vector using a simple projection. 
  #' Designed to take the OLS beta and a pre-calculated covariance matrix
  #' For speed (and to replicate the Li loss)
  B = projection(beta)
  delta = beta_ols-B
  t(delta)%*%covX%*%delta
}

scm.estimator = function(y,x) {
  #Takes y,x. Calculates OLS beta. pre-calculates covariance. 
  #Initializes at diff-in-diff weights. 
  #Optimizes Li loss to find optimal beta in simplex. (No intercept included)
  ols = coef(lm(y~x))
  ols = ols[-1]
  ols[is.na(ols)] = 0
  covx = cov(x)
  d = ncol(x)
  init = rep(1/d,d)
  beta.opt = optim(init,scm.loss,lower=0,upper=1,method="L-BFGS-B",beta_ols=ols,covX=covx)
  beta = projection(beta.opt$par)
  pred.error = y - x%*%beta
  intercept = mean(pred.error)
  c(intercept,beta)
}

scm.model = function(data1,data2,oob,joint=F) {
  #' Joint is a indicator for joint optimization with intercept or not.
  #' In testing, adding the intercept slows things down drastically.
  #' And so far gives numerically identical coefficients.
  #' However, there are likely situations where that is not true.
  if (hasArg(data2)) data1= rbind(data1,data2)
  y = data1[,1]
  x = data1[,-1]
  if (joint)  beta = alt.estimator(y,x) else beta = scm.estimator(y,x)
  oob.x = c(1,oob[-1])
  oob.pred = sum(oob.x*beta)
  oob[1]-oob.pred
}
#compiling.
projection = cmpfun(projection)
scm.loss = cmpfun(scm.loss)
scm.estimator = cmpfun(scm.estimator)
scm.model = cmpfun(scm.model)



############################################################################
##                      SCM ALT MODEL (Simplex betas)
############################################################################
# Jointly optimizing intercept.
projection2 = function(B) {
  #Function projecting a vector onto the unit simplex. 
  beta = B[-1]
  beta[beta<0] = 0 #change negatives to 0.
  if (all(beta == 0)) beta = rep(1,length(beta))
  # there is an edge case where everything is 0 and the normalization breaks.
  c(B[1],beta/sum(beta))   #normalize remaining positive components.
}
scm.alt.loss = function(beta,y,x) {
  B = projection2(beta)
  x1 = cbind(1,x)
  mean((y- x1%*%B)**2)
}

alt.estimator = function(y,x) {
  d = ncol(x)
  beta = coef(lm(y~x))
  init = projection2(beta)
  LB = c(-Inf,rep(0,d))
  UB = c(Inf,rep(1,d))
  beta.opt = optim(init,scm.alt.loss,lower=LB,upper=UB,method="L-BFGS-B",y=y,x=x)
  projection2(beta.opt$par)
}

#compiling.
projection2 = cmpfun(projection2)
scm.alt.loss = cmpfun(scm.alt.loss)
alt.estimator = cmpfun(alt.estimator)







