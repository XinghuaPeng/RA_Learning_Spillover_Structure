#Immigration Survey Experiment, Experiment 1 of Egami et al
#Data from Cohen, Rust, and Steen (2002)
#Available for Download here:  https://www.icpsr.umich.edu/web/NACJD/studies/3988/publications

#Load relevant libraries
library(stringr)
library(foreign)
library(data.table)
library(devtools)
library(stm)

#Ingest and clean data
dta <- read.dta("/Users/xinghua_peng/Dropbox/lss/Data Replication - Causal Inference & Texts/Dataset/data - old paper/ICPSR_03988/DS0001/03988-0001-Data.dta")

#Scenario of previoius prison sentence
firstcondition <- dta[dta$B1SCEN==2,]
#Scenario of no prior offense
secondcondition <- dta[dta$B2SCEN==3,]

firstcondition$treat <- 1
secondcondition$treat <- 0
data <- rbind(firstcondition, secondcondition)

#Merge in verbatim responses
text <- fread("b1text.txt")
names(text) <- c("caseid", "b1text")

text2 <- fread("b2text.txt")
names(text2) <- c("caseid", "b2text")

text$caseid <- as.character(text$caseid)
text2$caseid <- as.character(text2$caseid)
textmerge <- merge(text, text2, by.x="caseid", by.y="caseid", all=T)

data$CASEID <- as.character(data$CASEID)
merged <- merge(textmerge, data, by.x="caseid", by.y="CASEID", all.y=T)
merged$text <- ifelse(merged$treat==1, as.character(merged$b1text), as.character(merged$b2text))
merged$text <- ifelse(merged$treat==1 & merged$B1A==1, "Yes", merged$text)
merged$text <- ifelse(merged$treat==0 & merged$B2A==1, "Yes", merged$text)

merged <- merged[!is.na(merged$text),]

#Training/test split for analysis
#Note that this uses R's old version of sample
RNGkind(sample.kind = "Rounding")
set.seed(02138)
select <- sample(1:nrow(merged), nrow(merged)/2)
notselect <- c(1:nrow(merged))[!(1:nrow(merged)%in%select)]
trainorig <- merged[select,]
testorig <- merged[notselect,]

#Run STM 
#Note, different versions of STM will produce different results
train <- trainorig[trainorig$text!="Yes",]
processed <- textProcessor(train$text, metadata=as.data.frame(train))
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)
K <- 10
#stm.train <- stm(out$documents, out$vocab, K=K, data=out$meta, prevalence = ~treat, init="Spectral")
#save(stm.train, file="TrainedSTM.RData")
load("TrainedSTM.RData")

#Experiment 1 Topic Table, S8.2 and S8.3
labels <- labelTopics(stm.train)
thoughts <- findThoughts(stm.train, out$meta$text, n=3)[[2]]
library(xtable)
mat1 <- matrix(nrow=10, ncol=2)
mat2 <- matrix(nrow=10, ncol=2)
rownames(mat1) <- rownames(mat2) <-  paste("Topic", 1:10)
colnames(mat1) <- c("Label","Highest Probability Words")
colnames(mat2) <- c("Label","Representative Document")
mat1[,2] <- apply(labels[[1]],1, function (x) paste(x, collapse=", "))
#Selected representative documents
select <- c(3, 1, 1, 1,1, 3, 3, 2, 2,2)
mat2[,2] <- sapply(1:10, function (x) thoughts[[x]][select[x]])
topic <- c("He wants a better life", "Send him back", "Small punishment", "Depends on circumstances", "Crime was not violent", "Deport", 
           "Prison is too strict", "Right to freedom", "Deport bc overcrowded", "Deport bc expense")
mat1[,1] <- mat2[,1] <- topic
xtable(mat1)
xtable(mat2)

##################
#Test Set effects
##################

test <- testorig[testorig$text!="Yes",]
processedtest <- textProcessor(test$text, metadata=as.data.frame(test))
new <- stm::alignCorpus(processedtest,out$vocab)
testfit <- fitNewDocuments(stm.train, documents=new$documents, newData=new$meta, 
                           origData=out$meta, prevalencePrior = "Average", prevalence= ~treat)
trainfit <- fitNewDocuments(stm.train, documents=out$documents, newData=out$meta, 
                            origData=out$meta, prevalencePrior = "Average", prevalence= ~treat)
nocovfit <- fitNewDocuments(stm.train, documents=new$documents, newData=new$meta, 
                            origData=out$meta, prevalencePrior = "None", prevalence= ~treat)

#We do this to trick estimate effect into working on the test set
testeffect <- stm.train
testeffect$theta <- testfit$theta
traineffect <- stm.train
traineffect$theta <- trainfit$theta
nocov <- stm.train
nocov$theta <- nocovfit$theta

#Using estimate effects
prepfulltrain <- estimateEffect(c(1:K) ~ treat, stm.train, meta=out$meta, uncertainty = "None")
prepfulltrainplot <- plot(prepfulltrain, "treat", method="difference", cov.value1=1, cov.value2=0, 
                          main="Training Set", labeltype="custom",
                          custom.labels=topic, xlab="Treatment - Control",xlim=c(-.06,.07))
preptest <- estimateEffect(c(1:K) ~ treat, testeffect, meta=new$meta, uncertainty = "None")
preptestplot <- plot(preptest, "treat", method="difference", cov.value1=1, cov.value2=0, 
                     main="Test Set", labeltype="custom",
                     custom.labels=topic, xlab="Treatment - Control",xlim=c(-.06,.07))
prep <- estimateEffect(c(1:K) ~ treat, traineffect, meta=out$meta, uncertainty="None")
prepnocov <- estimateEffect(c(1:K) ~ treat, nocov, meta=new$meta, uncertainty = "None")
prepnocovplot <- plot(prepnocov, "treat", method="difference", cov.value1=1, cov.value2=0, 
                      main="Test Set", labeltype="custom",
                      custom.labels=topic, xlab="Treatment - Control",xlim=c(-.06,.07))

#Figure S7
pdf("Output/TestEffectExperiment1.pdf", width=8, height=6)
par(mfrow=c(1,1))
plot(preptest, "treat", method="difference", cov.value1=1, cov.value2=0, main="", labeltype="custom",
     custom.labels=topic, xlab="Treatment - Control", xlim=c(-.06,.1), nsims = 10000)
dev.off()

#Figure S6
pdf("Output/TestTrainComparisonAppendix.pdf", width=8, height=6)
#par(mar=c(5.1,8.1,4.1,2.1))
par(mfrow=c(1,1))
plot(prep, "treat", method="difference", cov.value1=1, cov.value2=0, main="", labeltype="custom",
     custom.labels=topic, xlab="Treatment - Control", xlim=c(-.1,.12), nsims = 10000)
points <- unlist(preptestplot$means)
lower <- unlist(lapply(preptestplot$cis, function (x) x[1]))
upper <- unlist(lapply(preptestplot$cis, function (x) x[2]))
pointstr <- unlist(prepfulltrainplot$means)
lowertr <- unlist(lapply(prepfulltrainplot$cis, function (x) x[1]))
uppertr <- unlist(lapply(prepfulltrainplot$cis, function (x) x[2]))
pointsnc <- unlist(prepnocovplot$means)
lowernc <- unlist(lapply(prepnocovplot$cis, function (x) x[1]))
uppernc <- unlist(lapply(prepnocovplot$cis, function (x) x[2]))
for(i in 1:K){
  points(points[i], K-i+.7, col="red", pch=15)
  lines(c(lower[i], upper[i]),  c( K-i+.7, K-i+.7), col="red", lty=2)
  points(pointstr[i], K-i+1.3, col="darkgreen", pch=17)
  lines(c(lowertr[i], uppertr[i]),  c( K-i+1.3, K-i+1.3), col="darkgreen", lty=3)
  #points(pointsnc[i], K-i+.9, col="purple", pch=19)
  #lines(c(lowernc[i], uppernc[i]),  c( K-i+.9, K-i+.9), col="purple", lty=4)
}
legend(.043, 3, c("Training Set", "Training Set With \n Averaged Prior", "Test Set"),
       col=c("darkgreen", "black", "red"), lty=c(3,1,2), pch=c(17,16,15))
dev.off()
