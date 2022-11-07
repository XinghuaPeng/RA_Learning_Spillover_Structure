

#-------------------
## Placebo Test 
#--------------------


# generate the 39 scm estimates and their gap between scm and original
for (x in 1:39) {
  pretreat = as.matrix(subset(cp,cp$years<1989,select=-c(years,x)))
  weights = scm.weight(cp[,x][cp$years<1989],pretreat)
  pred.periods = as.matrix(subset(cp,select=-c(years,x)))
  #pred.periods = cbind(1,pred.periods)
  all(colnames(pred.periods)==names(weights))
  cp.sum$scm = pred.periods%*%weights
  cp.sum$gap = cp[,x]-cp.sum$scm 
  names(cp.sum)[names(cp.sum) =="scm"] <- paste("scm", x, sep = "_")
  names(cp.sum)[names(cp.sum) =="gap"] <- paste("gap", x, sep = "_")
}


#-------------------
## Inference by Placebo Test 
#--------------------

cp.gap <- cp.sum %>% select(starts_with('g'))
cp.gap <- cp.gap %>% select(-c('gap_CA'))
cp.gap.T <- as.data.frame(t(cp.gap))
cp.gap.T.abs <- cp.gap.T %>% 
  select_if(is.numeric) %>%
  abs()
cp.gap.abs <- cp.gap %>% 
  select_if(is.numeric) %>%
  abs()

#delete california 
cp.gap.T.abs <- cp.gap.T.abs[-c(3), ]

#define columns we want to find percentiles for
dput(names(cp.gap.T.abs))
cp.gap.T.abs.percentile<- cp.gap.T.abs[ , dput(names(cp.gap.T.abs))]

#use apply() function to find 90th percentile for every column
cp.sum$CV <- apply(cp.gap.T.abs.percentile, 2, function(x) quantile(x, probs = .9))
cp.sum$upper <-  cp.sum$gap_CA - cp.sum$CV 
cp.sum$lower <- cp.sum$gap_CA + cp.sum$CV
cp.sum$upper[cp.sum$years < 1989] <- NA
cp.sum$lower[cp.sum$years < 1989] <- NA

