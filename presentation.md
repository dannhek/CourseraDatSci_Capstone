Data Science Specialization Capstone Project
========================================================
author: Dann Hekman
date: 2016-04-11

Description of Project and Data Source
========================================================

This presentation describes a [Shiny](https://tattooedeconomist.shinyapps.io/CourseraDSCapstone/) application created as part of the [Coursera](https://www.coursera.org) [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) taught by professors [Jeff Leek](https://github.com/jtleek), [Rodger Peng](https://github.com/rdpeng).

Data for this project were collected by [SwiftKey](https://swiftkey.com/en) and retrieved from the Coursera Website. For this project, I used 20,000 lines from the twitter file and 65,000 lines from the news and blogs files for a total of 150,000 lines of text.

Algorithm, Part 1
========================================================

To build this prediction algorithm, I used a weighted variant of [Katz's Back-off Model](https://en.wikipedia.org/wiki/Katz%27s_back-off_model). I parsed the 150,000 lines of text into 3 document-feature matrices (using data frames in R) of 2-gram, 3-gram, and 4-gram tokenized strings.  
I removed profanity from the final column of each data frame to prevent my algorithm from predicting profanity. Finally, I then saved these data frames off as RDS Files so the user doesn't need to wait for shiny to do the processing.

Algorithm, Part 2
========================================================

Then the user loads my Shiny app, they can enter a phrase and click the "Predict Next Word" button. The server code will tokenize the phrase, calculate the frequency of the phrase in each document-feature data frame, and get a frequency of the next word. It will then multiply the frequency against the weights given in the side panel for each n-gram and predict the 4 most likely words, based on weighted prevalence in the dataset.  
  
The user can adjust the weights to each n-gram to favor longer (4-gram) or shorter (2-gram) phrases. 

How to Use
========================================================

To use this application, simply go to the shiny website, enter a phrase, and click the "Predict Next Word" button. You can also adjust the weights given to 2, 3, and 4 gram predictions to favor longer phrases (higher 4-gram weight) or shorter phrases (higher 2-gram weight). 

Github and other links
========================================================

- [Shiny App](https://tattooedeconomist.shinyapps.io/CourseraDSCapstone/)  
- [Github Repo](https://github.com/dannhek/CourseraDatSci_Capstone/)  
- [Katz's Back-off Model](https://en.wikipedia.org/wiki/Katz%27s_back-off_model)  
- [Quanteda Package](https://cran.r-project.org/web/packages/quanteda/index.html)
