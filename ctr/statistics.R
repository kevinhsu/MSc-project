ipinyou.train <- read.delim("~/Documents/Python/make-ipinyou-data/all/train.log.txt")

library(ggplot2)
library(plyr)

ipinyou.trainc <- ddply(ipinyou.train, c("adexchange", "advertiser"), summarise,
               N    = length(click),
               CTR  = mean(click),
               sd   = sd(click),
               se   = sd / sqrt(N))

ipinyou.trainc$advertiser <- as.character(ipinyou.trainc$advertiser)

ggplot(ipinyou.trainc, aes(x=adexchange, y=CTR, colour=advertiser, group=advertiser)) + 
    geom_errorbar(aes(ymin=CTR-se, ymax=CTR+se), width=.1) +
    geom_line() +
    geom_point(size=1, shape=21, fill="white") +
    theme_bw()



