

# STEP 1 ------------------------------------------------------------------
# authorisation
if (!require('pacman')) install.packages('pacman')
pacman::p_load(twitteR, ROAuth, RCurl)

library(twitteR)
library(ROAuth)
library(plyr)
library(dplyr)
library(stringr)
library(ggplot2)
require(RCurl)


#connect to API
api_key = 'x3eQF2f5u7IGj7BZoCbcx1FeI'
api_secret = 'kE2m4WHn97p3ausjJk7ENkF4DGdGSdYVwq3tRQtbUxqGVHpOQr'
access_token <- "2213381748-LW7seiLJIJCND4pu5mhevb1oYDJBTflx4eTQ2ge"
access_token_secret = "s1diekQTF0uNPQPhsTYEGV40OGRlkuQV7wGU5MA6Rz3Fx" #ut the Consumer Secret from Twitter Application

# Set SSL certs globally
options(RCurlOptions = list(cainfo = system.file('CurlSSL', 'cacert.pem', package = 'RCurl')))
# set up the URLs
reqURL = 'https://api.twitter.com/oauth/request_token'
accessURL = 'https://api.twitter.com/oauth/access_token'
authURL = 'https://api.twitter.com/oauth/authorize'

twitCred = OAuthFactory$new(consumerKey = api_key, consumerSecret = api_secret,requestURL = reqURL, accessURL = accessURL, authURL = authURL)

twitCred$handshake(cainfo = system.file('CurlSSL', 'cacert.pem', package = 'RCurl'))


save(twitCred, file="twitter authentication.Rdata")


# STEP 2: Create A Script to Search Twitter -------------------------------


if (!require('pacman')) install.packages('pacman')
pacman::p_load(twitteR, sentiment, plyr, ggplot2, wordcloud, RColorBrewer, httpuv, RCurl, base64enc)

options(RCurlOptions = list(cainfo = system.file('CurlSSL', 'cacert.pem', package = 'RCurl')))

api_key = 'x3eQF2f5u7IGj7BZoCbcx1FeI'
api_secret = 'kE2m4WHn97p3ausjJk7ENkF4DGdGSdYVwq3tRQtbUxqGVHpOQr'
access_token <- "2213381748-LW7seiLJIJCND4pu5mhevb1oYDJBTflx4eTQ2ge"
access_token_secret = "s1diekQTF0uNPQPhsTYEGV40OGRlkuQV7wGU5MA6Rz3Fx" #ut the Consumer Secret from Twitter Application

setup_twitter_oauth(api_key,api_secret)

# alternate way to search strings in twitter  -----------------------------

load("twitter authentication.Rdata")
setup_twitter_oauth(api_key,api_secret) # set the call back url to http://127.0.0.1:1410 to authenticate.


# STEP 3: Streaming twitter Data in to a file ----------------------------------------------------------------

install.packages("streamR")
library(streamR)

filterStream( file.name="team.json", track="PremierLeague", tweets=1000, oauth=twitCred)

#Searching the tweets with hashtags
arsenal.tweets <- searchTwitter('#arsenal or #afc', n=2000, lang="en")
bou.tweets <- searchTwitter('#bournemouth or #bou', n=2000, lang="en")
chelsea.tweets <- searchTwitter('#chelsea or #cfc', n=2000, lang="en")
mancity.tweets <- searchTwitter('#mancity or #mcfc', n=2000, lang="en")
manutd.tweets <- searchTwitter('#manutd or #mufc', n=2000, lang="en")
stoke.tweets <- searchTwitter('#stoke or #scfc', n=2000, lang="en")
swansea.tweets <- searchTwitter('#swans or #swansea', n=2000, lang="en")
southampton.tweets <- searchTwitter('#southampton or #afc', n=2000, lang="en")
swinden.tweets <- searchTwitter('#stfc', n=2000, lang="en")
liecester.tweets <- searchTwitter('#lcfc', n=2000, lang="en")
liverpool.tweets <- searchTwitter('#thfc', n=2000, lang="en")
everton.tweets <- searchTwitter('#efc', n=2000, lang="en")
wbufc.tweets <- searchTwitter('#wbufc', n=2000, lang="en")
whufc.tweets <- searchTwitter('#whufc', n=2000, lang="en")
cpfc.tweets <- searchTwitter('#cpfc', n=2000, lang="en")
spurs.tweets <- searchTwitter('#spurs', n=2000, lang="en")
hul.tweets <- searchTwitter('#hul', n=2000, lang="en")
burnley.tweets <- searchTwitter('#bur', n=2000, lang="en")
middle.tweets <- searchTwitter('#watfordfc', n=2000, lang="en")

# STEP 5::: getting text from tweets----------------------------------------------
require(plyr)
arsenal.text = laply(arsenal.tweets, function(t) t$getText())
manutd.text = laply(manutd.tweets, function(t) t$getText())
mancity.text = laply(mancity.tweets, function(t) t$getText())
stoke.text = laply(stoke.tweets, function(t) t$getText())
swansea.text = laply(swansea.tweets, function(t) t$getText())
southampton.text = laply(southampton.tweets, function(t) t$getText())
swinden.text = laply(swinden.tweets, function(t) t$getText())
bou.text = laply(bou.tweets, function(t) t$getText())
chelsea.text = laply(chelsea.tweets, function(t) t$getText())
liecester.text = laply(liecester.tweets, function(t) t$getText())
liverpool.text = laply(liverpool.tweets, function(t) t$getText())
everton.text = laply(everton.tweets, function(t) t$getText())
wbufc.text = laply(wbufc.tweets, function(t) t$getText())
whufc.text = laply(whufc.tweets, function(t) t$getText())
cpfc.text = laply(cpfc.tweets, function(t) t$getText())
spurs.text = laply(spurs.tweets, function(t) t$getText())
hul.text = laply(hul.tweets, function(t) t$getText())
burnley.text = laply(burnley.tweets, function(t) t$getText())
middle.text = laply(middle.tweets, function(t) t$getText())

# STEP 5 Cleaning the data------------------------------------------------------------------

arsenal.text = gsub("[^[:alnum:]|^[:space:]]", "", arsenal.text)
manutd.text = gsub("[^[:alnum:]|^[:space:]]", "", manutd.text)
mancity.text = gsub("[^[:alnum:]|^[:space:]]", "", mancity.text)
stoke.text = gsub("[^[:alnum:]|^[:space:]]", "", stoke.text)
swansea.text = gsub("[^[:alnum:]|^[:space:]]", "", swansea.text)
southampton.text = gsub("[^[:alnum:]|^[:space:]]", "", southampton.text)
swinden.text = gsub("[^[:alnum:]|^[:space:]]", "", swinden.text)
bou.tex = gsub("[^[:alnum:]|^[:space:]]", "", bou.text)
chelsea.text = gsub("[^[:alnum:]|^[:space:]]", "", chelsea.text)
liecester.text = gsub("[^[:alnum:]|^[:space:]]", "", liecester.text)
liverpool.text = gsub("[^[:alnum:]|^[:space:]]", "", liverpool.text)
everton.text = gsub("[^[:alnum:]|^[:space:]]", "", everton.text)
wbufc.text = gsub("[^[:alnum:]|^[:space:]]", "", wbufc.text)
whufc.text = gsub("[^[:alnum:]|^[:space:]]", "", whufc.text)
cpfc.text = gsub("[^[:alnum:]|^[:space:]]", "", cpfc.text)
spurs.text = gsub("[^[:alnum:]|^[:space:]]", "", spurs.text)
hul.text = gsub("[^[:alnum:]|^[:space:]]", "", hul.text)
burnley.text = gsub("[^[:alnum:]|^[:space:]]", "", burnley.text)
middle.text = gsub("[^[:alnum:]|^[:space:]]", "", middle.text)

# STEP 6:::::Sentiment analysis function-------------------------------------------

pos.words <- scan('C:/Users/Bhavana/Desktop/R/positive-words.txt',what='character', comment.char=';')
neg.words <- scan('C:/Users/Bhavana/Desktop/R/negative-words.txt',what='character', comment.char=';')

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  require(stringr)
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    # Remove punctuations, Emoticons, Digits
    sentence = gsub('[[:punct:]]', '', sentence) 
    sentence = gsub('[[:cntrl:]]', '', sentence) 
    sentence = gsub('\\d+', '', sentence)
    #Convert tweets to lower case
    sentence = tolower(sentence) 
    # split sentence into words using str_split 
    word.list = str_split(sentence, '\\s+') 
    words = unlist(word.list)
    # compare words with positive & negative words in dictionaries. 
    #match function returns the positions of matched term or NA
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    # Return a boolean value-> true=1 & false=0:
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    score = sum(pos.matches) - sum(neg.matches)
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}
arsenal.scores <- score.sentiment(arsenal.text, pos.words,neg.words, .progress='text')
burnley.scores <- score.sentiment(burnley.text, pos.words,neg.words, .progress='text')
bou.scores <- score.sentiment(bou.text, pos.words,neg.words, .progress='text')
chelsea.scores <- score.sentiment(chelsea.text, pos.words,neg.words, .progress='text')
everton.scores <- score.sentiment(everton.text, pos.words,neg.words, .progress='text')
liecester.scores <- score.sentiment(liecester.text, pos.words,neg.words, .progress='text')
liverpool.scores <- score.sentiment(liverpool.text, pos.words,neg.words, .progress='text')
manutd.scores <- score.sentiment(manutd.text, pos.words,neg.words, .progress='text')
mancity.scores <- score.sentiment(mancity.text, pos.words,neg.words, .progress='text')
cpfc.scores <- score.sentiment(cpfc.text, pos.words,neg.words, .progress='text')
stoke.scores <- score.sentiment(stoke.text, pos.words,neg.words, .progress='text')
wbufc.scores <- score.sentiment(wbufc.text, pos.words,neg.words, .progress='text')
whufc.scores <- score.sentiment(whufc.text, pos.words,neg.words, .progress='text')
spurs.scores <- score.sentiment(spurs.text, pos.words,neg.words, .progress='text')
hul.scores <- score.sentiment(hul.text, pos.words,neg.words, .progress='text')
middle.scores <- score.sentiment(middle.text, pos.words,neg.words, .progress='text')
swinden.scores <- score.sentiment(swinden.text, pos.words,neg.words, .progress='text')
swansea.scores <- score.sentiment(swansea.text, pos.words,neg.words, .progress='text')
southampton.scores <- score.sentiment(southampton.text, pos.words,neg.words, .progress='text')

# STEP 7:::Naming the teams -----------------------------------------------

#Naming the teams and their hashtag name
southampton.scores$team = 'Southampton F.C.'
southampton.scores$code = 'Southampton'
swansea.scores$team = 'Swansea City A.F.C'
swansea.scores$code = 'Swansea'
middle.scores$team = 'Middlesbrough F.C.'
middle.scores$code = 'Middlesbrough'
hul.scores$team = 'Hull City A.F.C'
hul.scores$code = 'Hullcity'
everton.scores$team = 'Everton F.C.'
everton.scores$code = 'Everton'
whufc.scores$team = 'West Ham United F.C.'
whufc.scores$code = 'West Ham'
wbufc.scores$team = 'West Bromwich Albion F.C.'
wbufc.scores$code = 'West Brom'
stoke.scores$team = 'Stoke City F.C.'
stoke.scores$code = 'Stoke'
cpfc.scores$team = 'Crystal Palace F.C.'
cpfc.scores$code = 'Crystal Palace'
mancity.scores$team = 'Manchester City F.C.'
mancity.scores$code = 'Man City'
manutd.scores$team = 'Manchester United F.C.'
manutd.scores$code = 'Man UTD'
liverpool.scores$team = 'Liverpool F.C.'
liverpool.scores$code = 'Liverpool'
liecester.scores$team = 'Leicester City F.C.'
liecester.scores$code = 'Leister'
chelsea.scores$team = 'Chelsea F.C.'
chelsea.scores$code = 'Chelsea'
bou.scores$team = 'A.F.C. Bournemouth'
bou.scores$code = 'Bournemouth'
burnley.scores$team = 'Burnley F.C.'
burnley.scores$code = 'Burnley'
arsenal.scores$team = 'Arsenal F.C.'
arsenal.scores$code = 'Arsenal'
spurs.scores$team = 'Tottenham Hotspur F.C.'
spurs.scores$code = 'Spurs'


# Visualization -----------------------------------------------------------

team.scores = rbind(southampton.scores, swansea.scores, middle.scores, hul.scores, everton.scores, whufc.scores, 
                wbufc.scores, stoke.scores, cpfc.scores, mancity.scores, manutd.scores, liverpool.scores, liecester.scores, chelsea.scores, 
                spurs.scores,burnley.scores, bou.scores$team, arsenal.scores)


#Sentiment Analysis Graph
ggplot(data=team.scores) +
  geom_histogram(mapping=aes(x=score, fill=team), binwidth=1) +
  facet_grid(team~.) +
  theme_bw() + scale_color_brewer() +
  labs(title="Sentiment Analysis of Premier League Teams")
#Create Wordcloud
tweets <- searchTwitter("#chelsea", n=1499,lang="en")
tweets.text <- sapply(tweets, function(x) x$getText()) 
#Remove retweet entities 
tweets.text <- gsub("rt", "", tweets.text) 
#remove all @people
tweets.text <- gsub("@\\w+", "", tweets.text) 
#remove all the punctuation
tweets.text <- gsub("[[:punct:]]", "", tweets.text) 
#remove html links
tweets.text <- gsub("http\\w+", "", tweets.text) 
#remove unnecessary spaces
tweets.text <- gsub("[ |\t]{2,}", "", tweets.text) 
#Remove unnecessary sysmbols
tweets.text <- gsub("^ ", "", tweets.text)
tweets.text <- gsub(" $", "", tweets.text)

library("tm")
#Construct a corpus.VectorSource specifies that the source is character vectors.
tweets.text.corpus <- Corpus(VectorSource(tweets.text)) 
#remove stop words
tweets.text.corpus <- tm_map(tweets.text.corpus, function(x)removeWords(x,stopwords()))

library("wordcloud")
pal<-brewer.pal(7, "Pastel1")
par(bg="darkgray")
wordcloud(tweets.text.corpus,min.freq = 2, scale=c(7,0.5),colors=pal,
          random.color= TRUE, random.order = FALSE, max.words = 150)

