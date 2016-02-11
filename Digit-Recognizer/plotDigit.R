plotDigit <- function( r, label="" ){
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

generatePlots <- function(m, range=12,s=F, labels=c()){

  #dev.off()
  #png(width = 1200,height=1200)
  par(mfrow=c(3,4))
  for( e in 1:range){
    #dev.new(width=20, height=20,".png")
    #options(repr.plot.width=8, repr.plot.height=3)
    #png(width = 200,height = 200)
   
		if(!is.null(labels)) l <- labels[e] 
		else l <- ""

    plotDigit(m[e,],label=l)
    
    if(s){
      #dev.off()
    }
  }
  
}
