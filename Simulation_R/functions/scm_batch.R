scm_weights = function(Y,treat.col=1) {
  # Takes a Matrix of outcomes, Y,
  # with columns representing units and rows representing times
  # Where (by default) the first column is the treated unit,
  # and (by necessity), none of the rows represents treatment yet.
  # Returns weights and intercept.
  
  #Checking input
  if (!is.matrix(Y)) Y = as.matrix(Y)
  #Grabbing dimensions
  t = nrow(Y)
  n = ncol(Y)
  
  #Splitting into treatment, control, as well as demeaning
  Y_treated = Y[,treat.col]
  Y_untreated = Y[,-treat.col]
  
  means = colMeans(Y)
  demeaned = t(apply(Y,1,function(x) x-means))
  Y_demeaned = demeaned[,treat.col]
  X_demeaned = demeaned[,-treat.col]
  
  #Optimization
  #
  #Initial guess -- diff-in-diff weights (ish)
  b_init = rep(1,n-1)/n 
  #Criterion function
  Q = function(b) sum((Y_demeaned - (X_demeaned%*%b)[,1])^2)
  #Constraints
  A_eq = rbind(matrix(-1,ncol=n-1),diag(n-1)) #ui
  B_eq = c(-1,rep(0,n-1)) #ci
  
  opt = constrOptim(b_init,Q,grad=NULL,ui=A_eq,ci=B_eq)
  if (opt$convergence != 0) warning("convergence may be in doubt.")
  b_hat = rep(0,n)
  b_hat[-treat.col] = opt$par
  a_hat = means[treat.col]-means%*%b_hat
  return(list(a_hat=a_hat[1,1],b_hat=b_hat))
}


scm_batch_weights = function(Y) {
  #Takes a matrix Y
  #Where columns are units
  #and rows are time periods
  #Runs SCM, taking each column as the column to be predicted in turn.
  #Returns vector of intercepts and matrix of weights (0 on diag).
  n = ncol(Y)
  #Apply scm to each column.
  listed = lapply(1:n,
                  function(i) scm_weights(Y,treat.col=i))
  #Unlist outputs. Make each row the weights for one unit.
  B_hat = t(sapply(listed,function(x) x$b_hat))
  A_hat = sapply(listed,function(x) x$a_hat)
  return(list(A_hat=A_hat,B_hat=B_hat))
}
