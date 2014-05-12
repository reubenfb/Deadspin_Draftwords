library(tm)
library(wordcloud)
require(gridExtra)

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

black_with_sentiment$sentiment_with_rate <- abs(black_with_sentiment$sentiment * black_with_sentiment$count)
white_with_sentiment$sentiment_with_rate <- abs(white_with_sentiment$sentiment * white_with_sentiment$count)

p1 <- ggplot(black_with_sentiment, aes(x=sentiment, y=sentiment_with_rate)) + geom_histogram(stat="identity", binwidth=1) + facet_wrap(~race) + ggtitle("Sentiment for Black Players")
p2 <- ggplot(white_with_sentiment, aes(x=sentiment, y=sentiment_with_rate)) + ylab("") + geom_histogram(stat="identity", binwidth=1) + facet_wrap(~race) + ggtitle("Sentiment for White Players")
grid.arrange(p1, p2, ncol=2)
