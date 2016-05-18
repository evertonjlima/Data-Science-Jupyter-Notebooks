# Features
# @author: Everton J Lima
# @data: April 29, 2016
# @revised: May 18, 2016.
#
# scoring
# term_score
#

# Scoring functon usage.
scoreSumTf = function(tdm,tdm.description){scoring(tdm,control=function(x){x},scoref = function(x,y){ sum(x*y)  },tdm.description)}
scoreMeanTf  = function(tdm,tdm.description){scoring(tdm,control=function(x){x},scoref = function(x,y){ mean(x*y)  },tdm.description)}   
scoreMaxTf = function(tdm,tdm.description){scoring(tdm,control=function(x){x},scoref = function(x,y){ max(x*y)  },tdm.description)}
scoreMinTf = function(tdm,tdm.description){scoring(tdm,control=function(x){x},scoref = function(x,y){ min(x*y)  },tdm.description)} # always return 0. 
scoreVarTf = function(tdm,tdm.description){scoring(tdm,control=function(x){x},scoref = function(x,y){ sd(x*y)^2  },tdm.description)}
  
scoreLogTf = function(tdm,tdm.description){sapply( scoreSum(tdm,tdm.description),function(x){if(x != 0 ) 1+log(x) else 0 })}
scoreTfIdf = function(tdm,tdm.description){scoring(tdm,control=weightTfIdf,tdm.description,scoref = function(x,y){ sum(x*y)  }) }
scoreManTfIdf  = function(tdm,tdm.description){scoring(tdm,control=function(x){x},tdm.description,man.tfidf = T,scoref = function(x,y){ sum(x*y)  }) }

scoring <- function(tdmTf,control=function(x){x},scoref=function(x,y){sum(x*y)},tdm.description=F,man.tfidf=F,subset=train_subset){
  # scoring
  # 
  # args:
  #   tdmTf           TermDocumentMatrix    Term Document Matrix with entries as term frequencies. 
  #   control          function             See Term Document Matrix. This function transform term frequency matrix.
  #   scoref           function             Scoring function to be used. Two vectors are passed.
  #   tdm.description  bool                 Set to True if Term Document Matrix represents the description documents, otherwise False.
  #   man.tfidf        bool                 Manual calculation of TfIdf according to 1+log(tf)/( log(|N|/n_t) ).
  #   
  #
  #  return:  numeric    Value calculated by scoref.

  require(tm)
  require(slam)
  require(SnowballC)

  # transform tdm if necessary (default is identify function).
  tdm = control(tdmTf)

  # computation time calculation.
  startime = Sys.time()

  size = nrow(description)  # only the query x description pair.
  scores = c()              # empty list.
  
  # List of terms.
  terms = row.names(tdm)
  num_docs = ncol(tdm)
  
  for(i in 1:nrow(train[subset,])){
    # construct term column for query.
    query = cleanup(train[subset,"search_term"][i])
    vector_query = rep(0,nrow(tdm))
    
    # construct query vector by setting 1 for rows that equal term in list.    
    index = which(terms %in% query)
    vector_query[index] = 1
    
    # select relevant column in tdm.
    if(tdm.description){
      tdm_col = which(description[,"product_uid"] == train[i,"product_uid"])    
    } else {
      tdm_col = i # title is used.
    }
    
    vector_doc = tdm[,tdm_col]
    
    if(man.tfidf){
      # manually calculate query idf, and normalize.
      idf = log2(num_docs/rowSums( tdmTf[index,] ))
      vector_query = sapply(tdmTf[index,],function(x){ if(x!=0) 1+log(x) else 0 })
      vector_query = vector_query*idf
      vector_query = vector_query/sqrt(sum(vector_query^2)) # normalize vector.
      
      # manually calculate document idf, and normalize.
      idf = log2(num_docs/rowSums( as.matrix(tdmTf[,tdm_col] )))
      vector_doc = sapply(tdmTf[,tdm_col],function(x){ if(x!=0) 1+log(x) else 0 })
      vector_doc = vector_doc*idf
      vector_doc = vector_doc/sqrt(sum(vector_doc^2))
    }
    
    score = scoref(vector_query,vector_doc)                           # calculate score
    scores = c(scores,  score )                                          # append to scores list.
  }

  print(Sys.time() - startime)
  
  scores
}

term_score <- function(a,b,method="prefix",n.size=12L,type="jaccard"){
  # term_score
  # 
  # args:
  #  a         char    Text to be compared. Use search terms in case of coverage and ratio.
  #  b         char    Text to be compared.
  #  method    char    Argument of textcnt function.
  #  n.size            Argument of textcnt function.
  #  type      char    Used to calculate different values of term scoring. Options are 'jaccard','coverage', or 'ratio'.
  #                    jaccard calculates the jaccard distance according to |A AND B|/|A OR B|.
  #                    coverage returns 1 if all terms in A are present in B.
  #                    ratio is similar to jaccard but the divisor is the number of terms in query.
  #
  # return:   numeric  result of the specified function.
  #  
  require(tau)
  require(tm)
  
  a_terms = cleanup(a)    
  b_terms = cleanup(b)    
  
  cnt = textcnt(b_terms,method,n=n.size)
  
  intersection_size = sum(cnt[a_terms],na.rm = T)
  union_size = length(c(a_terms,b_terms))-intersection_size
  
  switch(type,
         jaccard = intersection_size/union_size,
         coverage = if( length(intersection_size) == length(a_terms) ) 1 else 0,
         ratio = intersection_size/length(a_terms))
}






