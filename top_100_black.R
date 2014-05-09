library(tm)
library(wordcloud)
blackcount <- read.csv("blackcount.csv")

is_number <- grep("^\\d+$", blackcount$word)
blackcount <- blackcount[-is_number,]

black_valuable <- subset(blackcount, ! word %in% stopwords())
black_valuable <- black_valuable[with(black_valuable, order(-count)),]
top_100 <- black_valuable[1:100,]
wordcloud(top_100$word, top_100$count, max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
