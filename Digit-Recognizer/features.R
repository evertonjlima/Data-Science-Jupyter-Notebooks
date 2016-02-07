featureEng <- function(r){
  # Convert row entry into 28x28 matrix w/ label removed.
  digit <- matrix(as.numeric(r[,-1]),28,28)
  
  # Density
  density <- sum(digit)
  
  # Density by region
  topLeftDensity <- sum( digit[1:14,1:14] )
  topRightDensity <- sum(digit[14:28,1:14])
  bottomLeftDensity <- sum(digit[14:28,1:14])
  bottomRightDensity <- sum(digit[14:28,14:28])
  
  # Location & Length of longest, and shortest line.
  diff <- (r != 0)
  rowSum <- apply(diff,2,sum)
  
  # Longest
  lengthLongestLine <- max(rowSum)
  locationLongestLine <- max(which(rowSum>0))
  
  # Shortest
  lengthShortestLine <- min(rowSum[rowSum > 0])
  locationShortestLine <- min(which(rowSum>0))
  
  # Number of nonzero lines
  NumberNonzeroLines <- sum( rowSum > 0 )
  
  # Vertical Symmetry
  # Horizontal Symmetry
  

}