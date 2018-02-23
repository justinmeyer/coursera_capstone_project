# Get data
blogs_data <- data.frame(readLines("en_US.blogs.txt"))
names(blogs_data) <- "text"
blogs_data$text <- as.character(blogs_data$text)

news_data <- data.frame(readLines("en_US.news.txt"))
names(news_data) <- "text"
news_data$text <- as.character(news_data$text)

twitter_data <- data.frame(readLines("en_US.twitter.txt"))
names(twitter_data) <- "text"
twitter_data$text <- as.character(twitter_data$text)

# Sample 10% of data
library(dplyr)
blogs_data <- sample_frac(blogs_data, 0.1)
news_data <- sample_frac(news_data, 0.1)
twitter_data <- sample_frac(twitter_data, 0.1)

# Convert format to remove strange characters
blogs_data$text <- iconv(blogs_data$text, "utf-8", "ascii", sub = "")
news_data$text <- iconv(news_data$text, "utf-8", "ascii", sub = "")
twitter_data$text <- iconv(twitter_data$text, "utf-8", "ascii", sub = "")

# Format data
# https://rstudio-pubs-static.s3.amazonaws.com/265713_cbef910aee7642dc8b62996e38d2825d.html
# http://rstudio-pubs-static.s3.amazonaws.com/169109_dcd8434e77bb43da8cf057971a010a56.html
library(tm)
test <- tm_map(news_data, removePunctuation)   

#############################################################

# Get data
blogs <- readLines("en_US.blogs.txt")

# Convert data to corpus
library(quanteda)
blogs <- corpus(blogs)

# Explore data
summary(blogs)
ndoc(blogs)

# Create tokens
blogs_tokens <- tokens(blogs, remove_punct = TRUE)
head(blogs_tokens)

# Remove stop words
blogs_tokens <- tokens_select(blogs_tokens, stopwords('en'), selection = 'remove')
head(blogs_tokens[[1]], 50)

# Create n-grams
ngram <- tokens_ngrams(blogs_tokens, n = 2:4)
head(ngram[[1]], 50)
