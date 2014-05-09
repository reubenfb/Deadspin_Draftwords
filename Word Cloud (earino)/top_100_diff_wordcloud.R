library(tm)
library(wordcloud)
blackcount <- read.csv("blackcount.csv")
whitecount <- read.csv("whitecount.csv")

is_number <- grep("^\\d+$", blackcount$word)
blackcount <- blackcount[-is_number,]

is_number <- grep("^\\d+$", whitecount$word)
whitecount <- whitecount[-is_number,]
                         
black_valuable <- subset(blackcount, ! word %in% stopwords())
white_valuable <- subset(whitecount, ! word %in% stopwords())
merged <- merge(black_valuable, white_valuable, by="word")
merged$diff <- abs(merged$count.x - merged$count.y)
sm <- merged[with(merged, order(-diff)),]
top_100 <- sm[1:100,]
wordcloud(top_100$word, top_100$diff, max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
