## This script repliactes the Consumer Financial Protection Bureau analysis
## from Egami et al's ''How to Make Causal Inferences with Text.''  The line
## that calls sibp_param_search() takes several hours to run.

# Load data
library(texteffect)
dat <- read.csv("CFPBDt.csv")

# Need to use RNGkind because this script was written in an old version of R
# Otherwise, the random seed changes
RNGkind(sample.kind = "Rounding")
set.seed(1252017)

# Divide into training and test set
train.ind <- sample(1:nrow(dat), round(nrow(dat)/10))
test.ind <- setdiff(1:nrow(dat), train.ind)

# Separate into outcome and document-term matrix
Y <- as.numeric(as.factor(dat[,1])) - 1
X <- dat[,-1]

# Free up memory
rm(dat)

# Run supervised Indian buffet process at many 
sibp.search <- sibp_param_search(X, Y, K = 5, alphas = c(3,5), sigmasq.ns = c(0.2, 0.4, 0.6),
                                 iters = 5, train.ind = train.ind, seed = 1252017)

# Based on quality of discovered treatments, select alpha = 5, sigmasq.n = 0.6, run #3
sibp_rank_runs(sibp.search, X, 10)
sibp.fit <- sibp.search[["5"]][["0.6"]][[3]]

# Table 3
sibp_top_words(sibp.fit, words = colnames(X), verbose = TRUE)

# Table 4 (have to offest x by 1 because we are not plotting the intercept)
sibp.amce <- sibp_amce(sibp.fit, X, Y)
ggplot(sibp.amce[-1,], aes(x = x-1, y = effect)) + geom_errorbar(aes(ymax=U, ymin=L)) + geom_point(size = 5) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=16,face="bold"), axis.title.x=element_text(vjust=-0.25)) + 
  labs(x = "Feature", y = "Effect on Pr(Timely Response)") + geom_hline(yintercept = 0, linetype = 2)
ggsave('CFPB.png', dpi = 300, unit = 'in')
