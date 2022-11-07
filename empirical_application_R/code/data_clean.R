
#-------------------
## DATA CLEANING
#--------------------

cigs = read_csv("data/cigs.csv")
cigs.panel.large = spread(cigs,year,cigs)
cp = t(cigs.panel.large[,-(1:8)])
colnames(cp) = cigs.panel.large$state
treated.unit = 3
treated.times = 20:nrow(cp)
years = rownames(cp)
cp = as.data.frame(cp)
cp$years = as.numeric(years)
