library(tm)
library(wordcloud)
blackcount <- read.csv("blackcount.csv")
whitecount <- read.csv("whitecount.csv")

is_number <- grep("^\\d+$", whitecount$word)
whitecount <- whitecount[-is_number,]

is_number <- grep("^\\d+$", blackcount$word)
blackcount <- blackcount[-is_number,]

black_valuable <- subset(blackcount, ! word %in% stopwords())
white_valuable <- subset(whitecount, ! word %in% stopwords())

sentiment <- read.delim("AFINN-111.txt", header=FALSE)
names(sentiment) <- c("word", "sentiment")

black_with_sentiment <- merge(black_valuable, sentiment, by="word")
white_with_sentiment <- merge(white_valuable, sentiment, by="word")

black_with_sentiment$race <- "black"
white_with_sentiment$race <- "white"

#ggplot(sentiment_data, aes(x=sentiment)) + geom_histogram(stat="bin", binwidth=1) + facet_wrap(~race)

l <- ! (white_with_sentiment$word %in% black_with_sentiment$word)
white_not_in_black <- white_with_sentiment[l,]
white_not_in_black <- white_not_in_black[with(white_not_in_black, order(-count)),]

#ggplot(white_not_in_black, aes(x=sentiment)) + geom_histogram(stat="bin", binwidth=1)

l <- ! (black_with_sentiment$word %in% white_with_sentiment$word)
black_with_sentiment <- black_with_sentiment[l,]
black_with_sentiment <- black_with_sentiment[with(black_with_sentiment, order(-count)),]

ggplot(black_with_sentiment, aes(x=sentiment)) + geom_histogram(stat="bin", binwidth=1)

merged <- rbind(white_with_sentiment, black_with_sentiment)
ggplot(merged, aes(x=sentiment)) + geom_histogram(stat="bin", binwidth=1) + facet_wrap(~race) + ggtitle("Sentiment Difference in Scouting Reports Related to Race")
