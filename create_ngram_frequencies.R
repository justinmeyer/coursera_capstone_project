# Prepare ngram frequencies for use in word prediction app.

# From http://www.szuhuiwu.com/wp-content/uploads/2016/04/ngram_generation_Final60.html
# From https://github.com/sriharshams/coursera-data-science-capstone
# From https://cran.r-project.org/web/packages/ANLP/vignettes/ANLP_Documentation.html

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
sample <- gsub("[.]|[,]|[!]|[?]|[<]|[>]|[;]|[:]|[@]|[#]|[&]|[(]|[)]|[-]|[/]|[']", "", sample)

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

# Create phrase to match with user input text
library(stringr)
temp <- data.frame(str_split_fixed(grams2_frequency$content, " ", 2))
temp$match_phrase <- temp$X1
temp$final_word <- temp$X2
# temp <- subset(temp, select = c("match_phrase", "final_word"))
grams2_frequency <- cbind(grams2_frequency, temp)
# grams2_frequency$content <- NULL
grams2_frequency$match_phrase <- as.character(grams2_frequency$match_phrase)
grams2_frequency$final_word <- as.character(grams2_frequency$final_word)
grams2_frequency <- subset(grams2_frequency, select = c("match_phrase", "final_word", "frequency"))
rm(temp)

temp <- data.frame(str_split_fixed(grams3_frequency$content, " ", 3))
temp$match_phrase <- paste(temp$X1, temp$X2)
temp$final_word <- temp$X3
# temp <- subset(temp, select = c("match_phrase", "final_word"))
grams3_frequency <- cbind(grams3_frequency, temp)
# grams3_frequency$content <- NULL
grams3_frequency$match_phrase <- as.character(grams3_frequency$match_phrase)
grams3_frequency$final_word <- as.character(grams3_frequency$final_word)
grams3_frequency <- subset(grams3_frequency, select = c("match_phrase", "final_word", "frequency"))
rm(temp)

temp <- data.frame(str_split_fixed(grams4_frequency$content, " ", 4))
temp$match_phrase <- paste(temp$X1, temp$X2, temp$X3)
temp$final_word <- temp$X4
# temp <- subset(temp, select = c("match_phrase", "final_word"))
grams4_frequency <- cbind(grams4_frequency, temp)
# grams4_frequency$content <- NULL
grams4_frequency$match_phrase <- as.character(grams4_frequency$match_phrase)
grams4_frequency$final_word <- as.character(grams4_frequency$final_word)
grams4_frequency <- subset(grams4_frequency, select = c("match_phrase", "final_word", "frequency"))
rm(temp)

# Save frequencies
save(grams2_frequency, grams3_frequency, grams4_frequency, file = "ngram_frequencies.Rdata")
rm(grams2_frequency, grams3_frequency, grams4_frequency)

