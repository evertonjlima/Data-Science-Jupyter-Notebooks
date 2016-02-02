plotDigit <- function( r ){
# Plots an entry of the MNIST dataset.
#
# Args:
#  p   data.frame   Labeled entry of the mnist dataset (1 by 785 vector).
#
# Return:
#   None    function is executed for side effects only.
#
  # Helper functions  
  rotate <- function(x) t(apply(x, 1, rev))
  
  # Convert entry into a 28x28 matrix

  label <- ""
  
  if(!is.null(dim(r))){
    digit <- matrix(as.numeric(r[,-1]),28,28)
  }
  else{
    digit <- matrix(r[-1],28,28)
  }

  # Plot
  image(rotate(digit), col = palette(gray(seq(0, .2, len=32))),
        zlim = c(1,255) , axes = F, asp = 1, main = label) 
}

generatePlots <- function(m, range=15,s=T){

  for( e in 1:range){
    png(paste("train",e,".png",sep = ""), width = 200, height = 200)
    plotDigit(m[e,])
    
    if(s){
      dev.off()
    }
  }
  
}