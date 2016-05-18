# Features
# @author: Everton J Lima
# @data: April 29, 2016
# @revised: May 18, 2016.
#
# preprocess
# cleanup
#
preprocess <- function(frame){
  require(tm)
  require(slam)
  require(SnowballC)
  startime = Sys.time()
  
  control = list(weighting = weightTf)
  
  # set up corpus
  src = DataframeSource(frame)
  corpus = Corpus(src)

  # clean up
  corpus = tm_map(corpus,removeWords,stopwords("SMART")) # removing 'english' stopwords is not helpful. SMART is better.
  corpus = tm_map(corpus,removeNumbers)
  corpus = tm_map(corpus,stemDocument)
  corpus = tm_map(corpus,removePunctuation)
  
  # compute term document matrix
  tdm = TermDocumentMatrix(corpus,control)
  
  # Calculate run time.
  print(Sys.time() - startime)
  
  # return tdm
  tdm
}

cleanup <- function(query){
  query = iconv(query,to="utf-8")
  
  frame =  data.frame(query)
  control = list(weighting = weightTfIdf)
  
  src = DataframeSource(frame)
  corpus = Corpus(src)
  
  # clean up
  corpus = tm_map(corpus,removeWords,stopwords("SMART")) # removing english stopwords is not helpful. SMART is better.
  corpus = tm_map(corpus,removeNumbers) # Other options may be better.
  corpus = tm_map(corpus,stemDocument)
  corpus = tm_map(corpus,removePunctuation)
  
  tdm = TermDocumentMatrix(corpus,control)
  
  tdm$dimnames$Terms
}