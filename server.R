library(shiny)


#source("core functions.R")
dfm2 <- readRDS("dfm2_20160324.RDS")
dfm3 <- readRDS("dfm3_20160324.RDS")
dfm4 <- readRDS("dfm4_20160324.RDS")



shinyServer <- function(input, output,session) {
     output$test <- reactive({
          invalidateLater(1000, session)
          paste("The current time is", Sys.time())
     })
     #Get Side Panel Inputs and Make Weights List
     gw.2 <- renderText(input$gw2)
     gw.3 <- renderText(input$gw3)
     gw.4 <- renderText(input$gw4)
     weightList <-  reactive({
           list('2' = as.numeric(gw.2())
               ,'3' = as.numeric(gw.3())
               ,'4' = as.numeric(gw.4()))})
    
     #Get input phrase, tokenize it, and make predictions.
     tokensInput <- reactive({
         tmp <- renderText(input$str)
         tmp <- unlist(getTokens(tmp()))
         tolower(tmp)
     })
     pred.df <- reactive({
          predictNextWordTable(dfm2,dfm3,dfm4,getTokens(tokensInput()),weights=weightList(),numwords = 4)
     })
     
     predAry  <- reactive({pred.df()$x})
     multi    <- reactive({
          if (length(predAry()) == 1) return('false')
          else return('true')
     })
     output$tokens  <- renderText(predAry())
     output$predtbl <- renderTable(pred.df())
     output$pred1   <- renderText(paste(predAry()[1], collapse=", "))
     output$predNext<- renderText(paste(predAry()[2:length(predAry())], collapse=", "))
     output$multi   <- renderText(multi())
     outputOptions(output, "multi", suspendWhenHidden = FALSE)
     output
     
}
