library(shiny)

# Get n-gram frequencies
load("ngram_frequencies.Rdata")

# Define server
shinyServer(function(input, output) {
  
  # Predict next word and output text
  output$output_text <- renderText({
    
          # Get input text
          input_text <- input$input_text
          input_text <- "dog cat"
          
          # Get last word from input text
          input_text <- unlist(strsplit(input_text, " "))
          input_text <- input_text[length(input_text)]
          
          # Find bigrams where the first word is the input text
          test <- subset(grams2_frequency, match_phrase = input_text)
 
  })
  
})
