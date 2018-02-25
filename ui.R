library(shiny)

# Define UI
shinyUI(fluidPage(
  
  # Title
  titlePanel("Coursera Data Science Capstone Word Predictor"),
  
  # Create sidebar layout
  sidebarLayout(
    sidebarPanel(
       # Provide users with a place to input text
       textInput("input_text",
                 "Enter text here:",
                 placeholder = "Enter text here")
    ),
    
    # Show the predicted word
    mainPanel(
       textOutput("output_text")
    )
  )
))
