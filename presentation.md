Coursera Data Science Capstone Next Word Predictor
========================================================
author: Justin Meyer
date: 3/1/2018
autosize: true

Introduction to Next Word Prediction
========================================================

You may have noticed that when you text or type an email on a smartphone it offers you a few words to choose from that it thinks might be the next word. If you select one of the predicted words it saves you some typing. These words aren't random but instead are based on sophisticated predictions.

![Image of a smartphone keyboard with predicted words](presentation-figure/_SWIFKEY.GIF)

Next Word Predictor Web App
========================================================

To meet the requirements of the [Coursera/Johns Hopkins School of Public Health Data Science Specialization] (https://www.coursera.org/specializations/jhu-data-science) capstone I've created a [Shiny](https://shiny.rstudio.com/) web app that, when given one or more words, predicts the next word.

The app can be found at <https://justinmeyer.shinyapps.io/coursera_capstone_project/>. *Enter a word or words to return a table of predicted words and a chart of their frequencies in the source data.*

![Screenshot of the word predictor app](presentation-figure/word_predictor.png)

How Does It Work? 
========================================================

- First, all of the n-grams (combinations of n words) are extracted from a corpora of text. In this case, blogs, news, and Twitter data were used.  
- Next, a table of the number of times each bigram, trigram, and quadgram appears is created.
- If the user enters **one word**, that word is matched to the first word in the **bigram table**. The app returns a list of second words that typically follow the word that the user entered.
- If **two words** are entered the **trigram table** is used.
- If **three words** are entered the **quadgram table** is used.
- If **more words** are entered then only the last three words are considered and the **quadgram table** is used.

Back-off Model
========================================================

Sometimes the words that are entered do not have a match. When this happens the [back-off model](https://en.wikipedia.org/wiki/Katz%27s_back-off_model) is used.  

For example, imagine that three words are entered.
- First the app tries to match all three words. If there is a match, a predicted word is returned.
- If there is no match, the app tries to match only the last two words. If there is a match, a predicted word is returned.
- If there is no match, the app tries to match only the last word. If there is a match, a predicted word is returned.
