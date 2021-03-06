library(shiny)
library(plotly)
library(ggplot2)

# Get n-gram frequencies
load("ngram_frequencies.Rdata")

# Define server
shinyServer(function(input, output) {
  
        # Make reactive
        selectData <- eventReactive(input$go, {

        ### Create table of predicted next words
                
        # Convert to lower
        input_text <- tolower(input$input_text)
        
        # Remove special characters
        input_text <- gsub("[.]|[,]|[!]|[?]|[<]|[>]|[;]|[:]|[@]|[#]|[&]|[(]|[)]|[-]|[/]|[']", "", input_text)
        
        # Remove numbers
        input_text <- gsub("[0-9]+", "", input_text)
        
        # Split input text 
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
                        
                        # Format matches
                        matches <- matches[order(-matches$frequency), ]
                        matches$match_phrase <- NULL
                }
                
                # If no matches are found
                if(nrow(matches) < 1){
                        
                        # Delete empty matches object
                        rm(matches)
                        
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
                        
                        # Format matches
                        matches <- matches[order(-matches$frequency), ]
                        matches$match_phrase <- NULL
                }
                
                # If no matches are found
                if(nrow(matches) < 1){
                        
                        # Delete empty matches object
                        rm(matches)
                        
                        # Cut input_text down to one word
                        input_text <- trimws(paste(word_1), "l")
                        
                        # Format input text
                        input_text <- unlist(strsplit(input_text, " "))
                        
                }
                
                # rm(word_2, word_1, words_to_match, matches)
        }
        
        # If input text is one word
        if(length(input_text) == 1){
                
                # Get last word from input text
                word_1 <- input_text[length(input_text)]
                
                words_to_match <- trimws(paste(word_1), "l")
                # rm(word_1)
                
                # Find n-grams where the match phrase is the sames as the input text
                matches <- subset(grams2_frequency, match_phrase == words_to_match)
                
                # If a match is found
                if(nrow(matches) >= 1){
                        
                        # Format matches
                        matches <- matches[order(-matches$frequency), ]
                        matches$match_phrase <- NULL
                }
                
                # If no matches are found
                if(nrow(matches) < 1){
                        
                        # Delete empty matches object
                        rm(matches)
                        
                        # Return most common unigram
                        matches <- grams1_frequency

                }
                
        }
        return(matches)
  })
        
  # Create table
  output$table_predictions <- renderDataTable({
    
          matches <-  selectData()
          
          # Return table of matches
          names(matches) <- c("Predicted Next Word", "Times Pattern was Observed in Sample Data")
          matches
          
  }, options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
  
  # Create plot
  output$plot_predictions <- renderPlotly({
          
          matches <-  selectData()
          p <- ggplot(data = head(matches, 10), 
                      aes(x = reorder(final_word, -frequency), y = frequency)) +
                  geom_bar(stat="identity", fill = "cornflowerblue") +
                  labs(x = "Predicted Next Word", 
                       y = "Times Pattern was Observed in Sample Data", 
                       title = "Top 10 Predicted Words") +
                  theme_bw()
          
          p <- ggplotly(p)
  })
  
})
