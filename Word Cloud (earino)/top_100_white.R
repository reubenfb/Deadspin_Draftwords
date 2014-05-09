library(tm)
library(wordcloud)
whitecount <- read.csv("whitecount.csv")

is_number <- grep("^\\d+$", whitecount$word)
whitecount <- whitecount[-is_number,]

white_valuable <- subset(whitecount, ! word %in% stopwords())
white_valuable <- white_valuable[with(white_valuable, order(-count)),]
top_100 <- white_valuable[1:100,]
wordcloud(top_100$word, top_100$count, max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
