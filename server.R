library(shiny)

# Get n-gram frequencies
load("ngram_frequencies.Rdata")

# Define server
shinyServer(function(input, output) {
  
  # Predict next word and output text
  output$output_text <- renderText({
    
          # Get input text
          input_text <- input$input_text
          
          # Get last word from input text
          input_text <- unlist(strsplit(input_text, " "))
          input_text <- input_text[length(input_text)]
          
          # Find bigrams where the match phrase is the sames as the input text
          matches <- subset(grams2_frequency, match_phrase == input_text)
          
          # Return the bigram that is most likely based on frequency
          best_match <- subset(matches, frequency == max(matches$frequency))
          
          # Return the predicted word
          final_word <- as.character(best_match$final_word)
          
          final_word
 
  })
  
})
