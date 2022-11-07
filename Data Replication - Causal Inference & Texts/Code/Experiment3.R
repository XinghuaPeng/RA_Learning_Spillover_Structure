#Experiment 3 from Egami Et al
#Run on September 10, 2017 on Mechanical Turk
library(devtools)
library(data.table)
library(stm)
data <- fread("Data/experiment3.csv")

#treat -- whether or not the respondent got treatment
#prison -- wehther the respondent thought the person should be sent to prison
#text -- text of open-ended response

#Training/test split
RNGkind(sample.kind = "Rounding")
set.seed(02138)
select <- sample(1:nrow(data), nrow(data)/2)
notselect <- c(1:nrow(data))[!(1:nrow(data)%in%select)]
train <- data[select,]
test <- data[notselect,]

#STM
#Note, different versions of STM will produce different results
library(stm)
processed <- textProcessor(train$text, metadata=as.data.frame(train))
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)
K <- 11
set.seed(123456)
#stm.train <- stm(out$documents, out$vocab, K=K, prevalence = ~treat, 
#                 data=out$meta)
#save(stm.train, file="2017TrainedSTM.RData")
load("Data/2017TrainedSTM.RData")

#Replication of Table 2 and Table S8.4
labels <- labelTopics(stm.train, n=10)
thoughts <- findThoughts(stm.train, out$meta$text, n=10)[[2]]

library(xtable)
mat1 <- matrix(nrow=K, ncol=2)
mat2 <- matrix(nrow=K, ncol=2)
rownames(mat1) <- rownames(mat2) <-  paste("Topic", 1:K)
colnames(mat1) <- c("Label","Highest Probability Words")
colnames(mat2) <- c("Label","Representative Document")
mat1[,2] <- apply(labels[[1]],1, function (x) paste(x, collapse=", "))
select <- rep(1,11)
mat2[,2] <- sapply(1:K, function (x) thoughts[[x]][select[x]])
topic <- c("Limited punishment with help to stay in country, complaints about immigration system", 
           "Deport", 
           "Deport because of money", 
           "Depends on the circumstances", 
           "More information needed, if violent imprison", "Crime, small amount of jail time, then deportation.", 
           "Punish to full extent of the law",
           "Allow to stay, no prison, rehabilitate, probably another explanation",
           "No prison, deportation",
           "Should be sent back", "Repeat offender, danger to society")
mat1[,1] <- mat2[,1] <- topic
xtable(mat1)
xtable(mat2)

##########
#Test set#
##########
processedtest <- textProcessor(test$text, metadata=as.data.frame(test))
new <- stm::alignCorpus(processedtest, out$vocab)
testfit <- fitNewDocuments(stm.train, documents=new$documents, newData=new$meta, 
                           origData=out$meta, prevalencePrior = "Average", prevalence= ~treat)
trainfit <- fitNewDocuments(stm.train, documents=out$documents, newData=out$meta, 
                            origData=out$meta, prevalencePrior = "Average", prevalence= ~treat)

testeffect <- stm.train
testeffect$theta <- testfit$theta

preptest <- estimateEffect(c(1:K) ~ treat, testeffect, meta=new$meta, uncertainty = "None")

#Replication of Figure 2
pdf("Output/Experiment3Results.pdf", width=8.7, height=10)
preptestplot <- plot(preptest, "treat", method="difference", cov.value1=1, cov.value2=0, 
                     labeltype="custom",
                     custom.labels=topic, xlab="Treatment - Control", main="", xlim=c(-.15,.18),
                     nsims=10000)
dev.off()

#Effects in the Training Set
traineffect <- stm.train
traineffect$theta <- trainfit$theta

prep <- estimateEffect(c(1:K) ~ treat, traineffect, meta=out$meta, uncertainty="None")
plot(prep, "treat", method="difference", cov.value1=1, cov.value2=0, main="", labeltype="custom",
     custom.labels=topic, xlab="Treatment - Control", xlim=c(-.12,.2))
