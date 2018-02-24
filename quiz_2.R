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

# Lower case
library(quanteda)
blogs <- char_tolower(blogs, keep_acronyms = TRUE)

# Convert data to corpus
blogs <- corpus(blogs)

# Sample corpus
blogs <- corpus_sample(blogs, ndoc(blogs) * 0.1)

# Explore corpus
ndoc(blogs)
summary(blogs)

# Create tokens
blogs_tokens <- tokens(blogs, remove_punct = TRUE)
head(blogs_tokens)

# Remove stop words
blogs_tokens <- tokens_select(blogs_tokens, stopwords('en'), selection = 'remove')
head(blogs_tokens[[1]], 50)

# Create n-grams
ngram <- tokens_ngrams(blogs_tokens, n = 2:4, concatenator = " ")
head(ngram[[1]], 50)

#####################################################

# From https://cran.r-project.org/web/packages/ANLP/vignettes/ANLP_Documentation.html

# Get data
library(ANLP)
twitter.data <- readTextFile("en_US.blogs.txt", "UTF-8")

# Sample
train.data <- sampleTextData(twitter.data, 0.1)

# Clean text
train.data.cleaned <- cleanTextData(train.data)
train.data.cleaned[[1]]$content[1:100]

# Generate n grams
# This doesn't seem to work right, always returns unigrams
unigramModel <- generateTDM(train.data.cleaned, 1)
bigramModel <- generateTDM(train.data.cleaned, 2)
trigramModel <- generateTDM(train.data.cleaned, 3)

head(unigramModel)
head(bigramModel)
head(trigramModel)

# NGramTokenizer(train.data.cleaned, Weka_control(min = 3, max = 3, delimiters = " \\r\\n\\t.,;:\"()?!"))
# 
# tdm = TermDocumentMatrix(train.data.cleaned, 
#                          control = list(tokenize = NGramTokenizer(train.data.cleaned, Weka_control(min = 3, max = 3, delimiters = " \\r\\n\\t.,;:\"()?!"))))
# 
# tdm = TermDocumentMatrix(train.data.cleaned, control = list(tokenize = buildNgramModel(4)))
# 
# tdm.df = data.frame(word=tdm$dimnames[[1]],freq=rowSums(as.matrix(tdm)),row.names = NULL)
# 
# tdm.df = tdm.df[order(-tdm.df$freq),]

# Combine models
nGramModelsList <- list(trigramModel,bigramModel,unigramModel)
testString <- "I am the one who"
predict_Backoff(testString, nGramModelsList)
testString <- "what is my"
predict_Backoff(testString,nGramModelsList)
testString <- "the best movie"
predict_Backoff(testString,nGramModelsList)

#################################################

# From http://www.szuhuiwu.com/wp-content/uploads/2016/04/ngram_generation_Final60.html
# From https://github.com/sriharshams/coursera-data-science-capstone

# Get data
blogs <- readLines("en_US.blogs.txt", skipNul = TRUE, encoding = "UTF-8")
news <- readLines("en_US.news.txt", skipNul = TRUE, encoding = "UTF-8")
twitter <- readLines("en_US.twitter.txt", skipNul = TRUE, encoding = "UTF-8")

# Combine data
all_text <- c(blogs, news, twitter)
rm(blogs, news, twitter)

# Sample to avoid large sizes
set.seed(1)
sample <- sample(all_text, length(all_text) * 0.1)
rm(all_text)

# Convert ASCII characters to avoid error due to weird characters
sample <- iconv(sample, "latin1", "ASCII", sub = "")

# Convert to lower
sample <- tolower(sample)

# Remove special characters
sample <- gsub("[.]|[,]|[!]|[;]|[:]|[@]|[#]|[&]|[(]|[)]|[-]|[/]|[']", "", sample)

# Remove numbers
sample <- gsub("[0-9]+", "", sample)

# Create ngrams
library(quanteda)
grams2 <- dfm(paste(sample, collapse = " "), ngrams = 2, concatenator = " ")
grams3 <- dfm(paste(sample, collapse = " "), ngrams = 3, concatenator = " ")
grams4<- dfm(paste(sample, collapse = " "), ngrams = 4, concatenator = " ")
rm(sample)

# Create frequency table of grams
# From https://stackoverflow.com/questions/36181361/convert-dfmsparse-from-quanteda-package-to-data-frame-or-data-table-in-r
grams2_frequency <- data.frame(content = featnames(grams2), frequency = colSums(grams2),
                               row.names = NULL, stringsAsFactors = FALSE)
grams3_frequency <- data.frame(content = featnames(grams3), frequency = colSums(grams3),
                               row.names = NULL, stringsAsFactors = FALSE)
grams4_frequency <- data.frame(content = featnames(grams4), frequency = colSums(grams4),
                               row.names = NULL, stringsAsFactors = FALSE)
rm(grams2, grams3, grams4)

# Save frequencies
save(grams2_frequency, grams3_frequency, grams4_frequency, file = "frequencies.Rdata")
rm(grams2_frequency, grams3_frequency, grams4_frequency)
