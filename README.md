#Coursera Data Science Capstone Project
Repo: CourseraDatSci_Capstone  
Author: dannhek  

This repo contains the a submission for the [Coursera](https://www.coursera.org) [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) taught by professors [Jeff Leek](https://github.com/jtleek), [Rodger Peng](https://github.com/rdpeng), and [Brian Caffo](https://github.com/bcaffo) of the Johns Hopkins Bloomberg School of Public Health. 

In addition to this repo, I have made a [Shiny Application](https://tattooedeconomist.shinyapps.io/CourseraDSCapstone/) and a [R Presentation](http://rpubs.com/tattooed_economist/CourseraDSCapstone).  

##Purpose of project
This project takes text files provided by [SwiftKey](https://swiftkey.com/en) to class participants and uses basic Natural Language Processing (NLP) to predict the next work in a phrase. For this application, I use a variant of the [Katz's Back-off Model](https://en.wikipedia.org/wiki/Katz%27s_back-off_model) with weights assigned to the preceding 2, 3, and 4-grams. 

##Construction of Algorithm
This algorithm works by first downloading the SwiftKey data from the Coursera Website (see [core functions.R](https://github.com/dannhek/CourseraDatSci_Capstone/blob/master/core%20functions.R)). These files include TXT files of entries from blogs, news articles, and twitter tweets. For example, from the news file:  
>[1]He wasn't home alone, apparently.  
[2]The St. Louis plant had to close. It would die of old age. Workers had been making cars there since the onset of mass automotive production in the 1920s.
WSU's plans quickly became a hot topic on local online sites. Though most people applauded plans for the new biomedical center, many deplored the potential loss of the building.

Second, I load lines of text into a corpus-like list, tokenize each phrase, and load the tokenized phrases into 3 data frames (similar to a document-feature matrix) of 2-grams, 3-grams, and 4-grams (see [build rds.R](https://github.com/dannhek/CourseraDatSci_Capstone/blob/master/build%20rds.R)) and save each data frame to the server as an RDS file. For my purposes, I used 20,000 lines from the twitter file and 65,000 lines from the news and blogs files for a total of 150,000 lines of text. After creating the data frames, I removed all profanity from the last place of each n-gram so the model will not predict any profanity. 

Finally, I used a weighted version of the Katz Back Off model to read in a phrase, tokenize it, and then multiply the frequency of each n-gram by the weight, giving 4-grams the most weight and 2-grams the least weight. This gives a weighted frequency of likely next words. 

##How to Use
To use this application, simply go to the shiny website, enter a phrase, and click the "Predict Next Word" button. You can also adjust the weights given to 2, 3, and 4 gram predictions to favor longer phrases (higher 4-gram weight) or shorter phrases (higher 2-gram weight). 