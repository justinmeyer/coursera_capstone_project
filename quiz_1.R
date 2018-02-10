# 1. The  en_US.blogs.txt file is how many megabytes?

paste0(round(file.info("F:/Professional Development/coursera_data_science_capstone/en_US.blogs.txt")$size / 1048576, 0), "mb")

# 2. The en_US.twitter.txt [Math Processing Error] has how many lines of text?

# us_twitter <- read.table("F:/Professional Development/coursera_data_science_capstone/en_US.twitter.txt")
length(readLines("F:/Professional Development/coursera_data_science_capstone/en_US.twitter.txt"))

# 3. What is the length of the longest line seen in any of the three en_US data sets?
max(nchar(readLines("F:/Professional Development/coursera_data_science_capstone/en_US.blogs.txt")))
max(nchar(readLines("F:/Professional Development/coursera_data_science_capstone/en_US.news.txt")))
max(nchar(readLines("F:/Professional Development/coursera_data_science_capstone/en_US.twitter.txt")))

# 4. In the en_US twitter data set, if you divide the number of lines where the 
# word "love" (all lowercase) occurs by the number of lines the word "hate" 
# (all lowercase) occurs, about what do you get?
us_twitter <- readLines("F:/Professional Development/coursera_data_science_capstone/en_US.twitter.txt")
length(grep("love", us_twitter)) / length(grep("hate", us_twitter))

# 5. The one tweet in the en_US twitter data set that matches the word "biostats" says what?
us_twitter[grep("biostats", us_twitter)]

# 6. How many tweets have the exact characters "A computer once beat me at chess, 
# but it was no match for me at kickboxing". (I.e. the line matches those characters exactly.)
length(grep("^A computer once beat me at chess, but it was no match for me at kickboxing$", us_twitter))
