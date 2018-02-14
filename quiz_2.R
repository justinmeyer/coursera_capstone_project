# Get data
source_data <- data.frame(readLines("en_US.blogs.txt"))
names(source_data) <- "text"
source_data$text <- as.character(source_data$text)

# Convert to remove strange characters
source_data$text <- iconv(source_data$text, "utf-8", "ascii", sub = "")

# Format data
source_data$number_chars <- nchar(source_data$text)