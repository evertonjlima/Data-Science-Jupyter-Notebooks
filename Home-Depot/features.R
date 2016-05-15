# Features
# @author: Everton J Lima
# @data: April 29, 2016
# @revised: NA
#
# jaccard
#

jaccard <- function(x,y){
  # jaccard(x,y)
  #
  #   Returns the jaccard coefficient as calculated by the size of the intersection, divided by the size
  #   of the union of two texts.
  #
  # args:
  #   x  character  text used for measuring.
  #   y  character  as above, text used for measuring.
  #
  # return
  #   numeric  jaccard distance, value within [0,1].
  # 
  # example
  #   jaccard("Spam Spam Spam Spam","Bacon Spam")
  #
  
  str1 = unlist(strsplit(tolower(x),split = " "))
  str2 = unlist(strsplit(tolower(y),split = " "))
  
  union_size = length(unlist(unique(c(str1,str2))))
  intersection_size = length(unlist(intersect(str1,str2)))
  
  intersection_size/union_size
}