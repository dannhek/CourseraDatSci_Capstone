#Model v1.2
setwd("~/Coursera/Data Science Specialization/Data Science Capstone")
load("~/Coursera/Data Science Specialization/Data Science Capstone/.RData")
source("core functions.R")

#First, Create a massive Corpus (List)
twitterCorpus <- getStrings(language="en_US",type="twitter", asCorpus=FALSE,lines=20000)
newsCorpus    <- getStrings(language="en_US",type="news", asCorpus=FALSE,lines=65000)
blogCorpus    <- getStrings(language="en_US",type="blogs", asCorpus=FALSE,lines=65000)
fullCorpus    <- append(twitterCorpus,append(newsCorpus,blogCorpus))
rm(twitterCorpus,newsCorpus,blogCorpus) ; gc()

#Second, Convert that list into a Series of Data Frames
##4-Gram
dfm4 <- as.data.frame(matrix(nrow=1,ncol=4))
for (i in 1:length(fullCorpus)) {
     tokens <- tolower(unlist(getTokens(fullCorpus[[i]])))
     dfm4 <- rbind(dfm4,df4gram(tokens))
     print(c(4,i))
}
#Remove all the things I don't want to predic
dfm4 <- subset(dfm4, (!is.na(V4) & !(V4 %in% stopwords()) &
                      !(V4 %in% profanity) & !grepl("(?!')[[:punct:]]",V4,perl=TRUE)),TRUE)

##3-Gram
dfm3 <- as.data.frame(matrix(nrow=1,ncol=3))
for (i in 1:length(fullCorpus)) {
     tokens <- tolower(unlist(getTokens(fullCorpus[[i]])))
     dfm3 <- rbind(dfm3,df3gram(tokens))
     print(c(3,i))
}
dfm3 <- subset(dfm3, (!is.na(V3) & !(V3 %in% stopwords()) &
                      !(V3 %in% profanity) & !grepl("(?!')[[:punct:]]",V3,perl=TRUE)),TRUE)

##2-Gram
dfm2 <- as.data.frame(matrix(nrow=1,ncol=2))
for (i in 1:length(fullCorpus)) {
     tokens <- unlist(getTokens(fullCorpus[[i]]))
     tokens <- tolower(padArray(2,tokens))
     dfm2 <- rbind(dfm2,df2gram(tokens))
     print(c(2,i))
}
dfm2 <- subset(dfm2, (!is.na(V2) & !(V2 %in% stopwords()) &
                      !(V2 %in% profanity) & !grepl("(?!')[[:punct:]]",V2,perl=TRUE)),TRUE)
gc() ; save.image()

#Finally, Save off the Data Frames to disk. 
saveRDS(dfm2,file=paste0("dfm2_",gsub("-","",Sys.Date()),".RDS"))
saveRDS(dfm3,file=paste0("dfm3_",gsub("-","",Sys.Date()),".RDS"))
saveRDS(dfm4,file=paste0("dfm4_",gsub("-","",Sys.Date()),".RDS"))
