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

l <- ! (black_valuable$word %in% white_valuable$word)
black_not_in_white <- black_valuable[l,]
black_not_in_white <- black_not_in_white[with(black_not_in_white, order(-count)),]
top_100 <- black_not_in_white[1:100,]

wordcloud(top_100$word, top_100$count, max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))

#white_valuable <- white_valuable[with(white_valuable, order(-count)),]
