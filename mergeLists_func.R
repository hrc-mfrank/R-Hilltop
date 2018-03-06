mergeListSites <- function(x, y, ...){
  
  listNo <- nargs()
  argList <- list(...)

  temp <- mapply(cbind, x, y)
  
  for (i in argList) {
    temp <- mapply(cbind, temp, i)
  }
  
  return(temp)
}
