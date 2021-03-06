library(shiny)
#setwd("~/Coursera/Data Science Specialization/Data Science Capstone/data product")

# Define UI for application that reads in words and 
shinyUI(fluidPage(
     
     # Application title
     titlePanel("What's the Next Word?"),
     
     sidebarLayout(
          sidebarPanel(
               h3("N-Gram Weights"),
               textInput("gw2","2-Gram: ",.25),
               textInput("gw3","3-Gram: ",1),
               textInput("gw4","4-Gram: ",3)
             #  ,verbatimTextOutput('test')
              
          ),
          mainPanel(
                tabsetPanel(
                    tabPanel(p("Display"),
                             h3("Word Prediction"),
                             textInput("str","Enter a Phrase:"),
                             submitButton("Predict Next Word"),
                             
                             
                             h4("Likely next word:"),
                             textOutput("pred1"),
                             conditionalPanel("output.multi == 'true'",  
                                    h4("Less likely options:"),
                                    textOutput("predNext")
                             )
#                              tableOutput("predtbl"),
#                              p(verbatimTextOutput("tokens"))
#                              verbatimTextOutput("multi"),
                             
                    ),
                    tabPanel(p("About"),
                             h3("About this Application"),
                             p("This page was created as part of the",
                              a(href="https://www.Coursera.org","Coursera"),
                              a(href="https://www.coursera.org/learn/data-science-project/home/welcome","Data Science Specialization Capstone Project"),
                             "."),
                             h4("How to use"),
                             p("To use this application, simply enter a phrase and click the \"Predict Next Word\" button. You can also adjust the weights given to 2, 3, and 4 gram predictions to favor longer phrases (higher 4-gram weight) or shorter phrases (higher 2-gram weight). "),
                             h4("For more information, see:"),
                             p("Github: ",a(href="https://github.com/dannhek/CourseraDatSci_Capstone","github.com/dannhek")),
                             p("RPubs Presentation:", a(href="","http://rpubs.com/tattooed_economist/CourseraDSCapstone")),
                             p("Github ReadMe: ",a(href="https://github.com/dannhek/CourseraDatSci_Capstone/blob/master/README.md","README.MD"))
                             
                     )
                )
           )
)))

               
     