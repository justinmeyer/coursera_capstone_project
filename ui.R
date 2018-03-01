library(shiny)
library(plotly)

# Define UI
shinyUI(fluidPage(
  
  # Title
  titlePanel("Next Word Predictor"),
  p("Enter a word or words below to return a prediction of possible next words."),
  p("The predicted words are based on a corpora of blogs, news, and Twitter text using the backoff method. If the dashboard can find a match to the final three words in the entered text it uses those words to provide a list of predicted next words. If no match is found for three words it attempts to match the last two words. If no match is found for two words it attempts to match the last word."),
  em("This dashboard was created to fulfill the requirements of the Coursera/Johns Hopkins School of Public Health Data Science Capstone."),
  
  # Create sidebar layout
  sidebarLayout(
    sidebarPanel(
       # Provide users with a place to input text
       textInput("input_text",
                 "Enter text here:",
                 placeholder = "Enter text here"),
       actionButton("go", "Show Predicted Words")
    ),
    
    # Show the predicted word
    mainPanel(
       dataTableOutput("table_predictions"),
       plotlyOutput("plot_predictions")
    )
  )
))
