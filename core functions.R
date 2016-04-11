#Coursera Data Science Specialization Capstone Project
library(tm) ; library(quanteda) ; library(plyr)
dfm2 <- readRDS("dfm2_20160324.RDS")
dfm3 <- readRDS("dfm3_20160324.RDS")
dfm4 <- readRDS("dfm4_20160324.RDS")

# 
# #Download the Data if needed
# if (!file.exists("final")) {
#      #Get Data from Coursera
#      url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
#      download.file(url,"datazip.zip")
#      unzip(paste0(getwd(),"/","datazip.zip"))
#      rm(url)
# 
#      #Get "badwords" filter
#      url <- "http://static.urbanoalvarez.es/blog/?download=badwords"
#      download.file(url,"badwords.zip")
#      unzip("badwords.zip")
#      rm(url)
# }
profanity <- read.delim("badwords.txt",header=FALSE); profanity <- as.character(profanity$V1)
profanity <- c(profanity,"damn")

#Function to read in a subset of the data
getStrings <- function(language="en_US", type="news", lines=-1, asCorpus=FALSE) {
     con <- file(paste0("final/",language,"/",paste(language,type,"txt",sep=".")),"r")
     out <- readLines(con,lines)
     close(con)
     if (asCorpus) {out<-corpus(out)}
     return(out)
}

#Function to check if a string has obscene language
hasProfanity <- function(profanity,check) {
    length(intersect(profanity,tolower(as.character(strsplit(check,"[[:space:]]{1,}")[[1]]))))>0
}

#Function to tokenize
getTokens <- function(str) {
     str <- gsub("([[:punct:]])"," \\1 ",str) #pad the punctuation with spaces
     str <- gsub(" \\' ","\\'",str) #put apostrophes back as they were
     str <- gsub("\\s+"," ",str)   #remove multiple spaces
     out <- strsplit(str," ")
     return(out)
}

#Functions to take tokens and put them into data frames
df4gram <-function(tokens) {
     df <- as.data.frame(matrix(data=NA,nrow=length(tokens),ncol=4))
     df$V4 <- tokens
     df$V3 <- c(NA,tokens[1:length(tokens)-1])
     df$V2 <- c(NA,NA,tokens[1:(length(tokens)-2)])
     df$V1 <- c(NA,NA,NA,tokens[1:(length(tokens)-3)])
     return(df)
}
df3gram <-function(tokens) {
     df <- as.data.frame(matrix(data=NA,nrow=length(tokens),ncol=3))
     df$V3 <- tokens
     df$V2 <- c(NA,tokens[1:length(tokens)-1])
     df$V1 <- c(NA,NA,tokens[1:(length(tokens)-2)])
     return(df)
}
df3gram <-function(tokens) {
     df <- as.data.frame(matrix(data=NA,nrow=length(tokens),ncol=3))
     df$V3 <- tokens
     df$V2 <- c(NA,tokens[1:length(tokens)-1])
     df$V1 <- c(NA,NA,tokens[1:(length(tokens)-2)])
     return(df)
}
df2gram <-function(tokens) {
     df <- as.data.frame(matrix(data=NA,nrow=length(tokens),ncol=2))
     df$V2 <- tokens
     df$V1 <- c(NA,tokens[1:length(tokens)-1])
     return(df)
}

#Function to pad token array to max n-gram
padArray<-function(len,tokens) {
     numTokens <- length(tokens)
     if (numTokens == len) return(tokens)
     if (numTokens  < len) return(c(rep(NA,(len-numTokens)),tokens))
     if (numTokens  > len) return(c(tokens[(numTokens-len+1):numTokens]))
}

#Given an ngram dataframe and the user-entered words, get the top words for that ngram
getTopWords <- function(currentWords,tokens.df,numWords=3) {
     ngrams <- ncol(tokens.df)
     currentWords <- padArray(ngrams-1,currentWords)
     if (ngrams==2) {filtered.df <- subset(tokens.df, ((is.na(currentWords[1]) & is.na(V1)) | (V1 == currentWords[1])),TRUE)}
     if (ngrams==3) {filtered.df <- subset(tokens.df, ((is.na(currentWords[1]) & is.na(V1)) | (V1 == currentWords[1]))
                                           & ((is.na(currentWords[2]) & is.na(V2)) | (V2 == currentWords[2])),TRUE)}
     if (ngrams==4) {filtered.df <- subset(tokens.df, (is.na(V1) | (V1 == currentWords[1]))
                                           & ((is.na(currentWords[2]) & is.na(V2)) | (V2 == currentWords[2]))
                                           & ((is.na(currentWords[3]) & is.na(V3)) | (V3 == currentWords[3])),TRUE)}

     names(filtered.df)[ngrams] <- "pred"
     topWords <- count(filtered.df$pred)
     topWords <- topWords[order(-topWords$freq),]
     return(head(topWords,numWords))
}

#function to actually get the list of predicted words
predictNextWordTable <- function(dfm2 = NULL, dfm3 = NULL, dfm4 = NULL, currentWords, weights = list('2'=1,'3'=1.5,'4'=2), default = "the", numwords = 3) {
     pred <- data.frame(x=NULL,freq=NULL)
     if (!is.null(dfm2)) {
          temp <- getTopWords(currentWords,dfm2)
          temp$freq <- temp$freq * weights$'2'[1]
          pred <- rbind(pred,temp)
     }
     if (!is.null(dfm3)) {
          temp <- getTopWords(currentWords,dfm3)
          temp$freq <- temp$freq * weights$'3'[1]
          pred <- rbind(pred,temp)
     }
     if (!is.null(dfm4)) {
          temp <- getTopWords(currentWords,dfm4)
          temp$freq <- temp$freq * weights$'4'[1]
          pred <- rbind(pred,temp)
     }
     pred <- rbind(pred,data.frame(x=default,freq=0.01))
     pred <- aggregate(freq~x,data=pred,sum)
     pred <- pred[order(-pred$freq),]
     return(head(pred, numwords))
}
predictNextWord <- function(dfm2 = NULL, dfm3 = NULL, dfm4 = NULL, currentWords, weights = list('2'=1,'3'=1.5,'4'=2), default = "the", numwords = 3){
     predictNextWordTable(dfm2, dfm3, dfm4, currentWords, weights, default, numwords)$x
}
