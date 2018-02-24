library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       textInput("text_input",
                 "Enter text here:",
                 placeholder = "Enter text here")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       textOutput("output_text")
    )
  )
))
