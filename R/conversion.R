#' @include easyLift.R
NULL

#' easyLiftOver
#'
#' Function to get permuted data while maintaining biases
#' @param from .bed file 
#' @param map Reference genome mapping logic {FROM}_{TO}
#' @param to .bed file of the output after lifting over
#' @param write Either write (by default) to file if TRUE 
#' or return a GRanges object of the result. 
#' @import rtracklayer
#' @importFrom utils write.table
#' @return A GRanges if write == FALSE; spits out a new
#' bed file if write == TRUE. 
#' 
#' @export
#' @examples 
#' sf <- paste0(system.file('extdata',package='easyLift'),'/exbed/hg19.quick.bed')
#' #easyLiftOver(sf, map = "hg19_hg38") # spits out the lifted over bed file
#' liftedGRanges <- easyLiftOver(sf, map = "hg19_hg38", write = FALSE)
#' 
easyLiftOver <- function(from, to = NULL, map = "hg19_hg38", write = TRUE) {
  
  support <- c("hg19_hg38", "hg38_hg19", "mm9_mm10", "mm10_mm9")
  stopifnot(map %in% support)
  chf<-paste0(system.file('extdata',package='easyLift'),'/chains/',map, '.over.chain')
  ch <- import.chain(chf)
  original <- import(from)
  toOut <- liftOver(x=original, chain=ch)
  toOut <- unlist(toOut)
  
  if(!write) return(toOut)
  if(is.null(to)) to <- paste0(from, "over")
  if(write) write.table(data.frame(toOut)[,1:3], sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE, file = to)
  return(paste0( "Attempted to write to file: ", to))
  
}
