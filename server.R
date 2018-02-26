library(shiny)

# Get n-gram frequencies
load("ngram_frequencies.Rdata")

# Define server
shinyServer(function(input, output) {
  
  # Predict next word and output text
  output$output_text <- renderText({
    
          # Get input text
          input_text <- input$input_text
          
          # Format input text
          input_text <- unlist(strsplit(input_text, " "))
          
          # If input text is three words or longer
          if(length(input_text) >= 3){
                  
                  # Get last three words from input text
                  word_3 <- input_text[length(input_text) - 2]
                  word_2 <- input_text[length(input_text) - 1]
                  word_1 <- input_text[length(input_text)]
                  
                  words_to_match <- trimws(paste(word_3, word_2, word_1), "l")
                  # rm(word_3, word_2, word_1)
                  
                  # Find n-grams where the match phrase is the sames as the input text
                  matches <- subset(grams4_frequency, match_phrase == words_to_match)
                  
                  # If a match is found
                  if(nrow(matches) >= 1){
                        
                        # Return the n-gram that is most likely based on frequency
                        best_match <- subset(matches, frequency == max(matches$frequency))
                        
                        # Return the predicted word
                        final_word <- as.character(best_match$final_word)
                  }
                  
                  # If no match is found
                  if(nrow(matches) < 1){
                          
                          # Cut input_text down to two words
                          input_text <- trimws(paste(word_2, word_1), "l")
                          
                          # Format input text
                          input_text <- unlist(strsplit(input_text, " "))
                          
                          }
                  
                  # rm(word_3, word_2, word_1, words_to_match, matches)
          }
          
          # If input text is two words
          if(length(input_text) == 2){
                  
                  # Get last two words from input text
                  word_2 <- input_text[length(input_text) - 1]
                  word_1 <- input_text[length(input_text)]
                  
                  words_to_match <- trimws(paste(word_2, word_1), "l")
                  # rm(word_2, word_1)
                  
                  # Find n-grams where the match phrase is the sames as the input text
                  matches <- subset(grams3_frequency, match_phrase == words_to_match)
                  
                  # If a match is found
                  if(nrow(matches) >= 1){
                          
                          # Return the n-gram that is most likely based on frequency
                          best_match <- subset(matches, frequency == max(matches$frequency))
                          
                          # Return the predicted word
                          final_word <- as.character(best_match$final_word)
                  }
                  
                  # If no match is found
                  if(nrow(matches) < 1){
                          
                          # Cut input_text down to one word
                          input_text <- trimws(paste(word_1), "l")
                          
                          }
                  
                  # rm(word_2, word_1, words_to_match, matches)
          }
          
          # If input text is one word
          if(length(input_text) == 1){

                  words_to_match <- word_1
                  # rm(word_1)
                  
                  # Find n-grams where the match phrase is the sames as the input text
                  matches <- subset(grams2_frequency, match_phrase == words_to_match)
                  
                  # If a match is found
                  if(nrow(matches) >= 1){
                          
                          # Return the n-gram that is most likely based on frequency
                          best_match <- subset(matches, frequency == max(matches$frequency))
                          
                          # Return the predicted word
                          final_word <- as.character(best_match$final_word)
                  }
                  
                  # If no match is found
                  if(nrow(matches) < 1){
                          
                          # Return an error message for now
                          final_word <- "no one-word matches"
                          }
          }
  final_word
  })
  
})
