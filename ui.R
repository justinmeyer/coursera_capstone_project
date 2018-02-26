library(shiny)
library(plotly)

# Define UI
shinyUI(fluidPage(
  
  # Title
  titlePanel("test"),
  
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
       dataTableOutput("table_predictions"),
       plotlyOutput("plot_predictions")
    )
  )
))
