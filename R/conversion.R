#' @include easyLift.R
NULL


#' Pick one GRange from many in a list
#'
#' Function to pick a single GRanges object per
#' many in a given GRangeslist If none map, then a 
#' return a "chrZ" seqname is returned.
#' 
#' @param grl A GRangeslist object to be picked on 
#' @param returnBooVec If true, returns an S3
#' object where the first element is the flattened
#' GRanges object and the second is a boolean vector
#' indicating whether the region was successfully mapped or not. 
#' 
#' @import rtracklayer
#' @import GenomicRanges
#' @importFrom IRanges IRanges
#' @return A flattened GRanges object of the same length
#' 
#' @export
#' @examples 
#' from <- paste0(system.file('extdata',package='easyLift'),'/exbed/hg19.quick.bed')
#' #easyLiftOver(sf, map = "hg19_hg38") # spits out the lifted over bed file
#' liftedGRanges <- easyLiftOver(from, map = "hg19_hg38", pickOne = TRUE)
#' 
pickOne <- function(grl, returnBooVec = FALSE) {
  n <- length(grl)
  
  # Make a null data frame to become a GRanges object shortly 
  flat <- data.frame(seqnames = rep("chrZ", n), start = rep(1, n), end = rep(10, n), width = rep(10, n),
                     strand = as.factor(c("+", "-", rep("*", n-2))), stringsAsFactors = FALSE)
  
  # Make T/F vector whether a range matched. 
  boo <- sapply(1:n, function(i){
    gr <- grl[[i]]
    if(length(gr) >= 1){
      flat[i,] <<- data.frame(gr[which.max(end(gr) - start(gr))])[,1:5]
      TRUE
    } else {
       flat[i,] <<- data.frame(GRanges("chrZ", IRanges(start = c(1), end = c(10))))
      FALSE
    }
  })
  
  grout <- GRanges(flat)
  
  if(returnBooVec){
    return(list(grout, boo))
  } else {
    return(grout)
  }

}

#' easyLiftOver
#'
#' Function to get lifted over coordinates using
#' rtracklayer + chain file for a couple of different
#' inputs. Returns all mapped regions as a GRanges/bed
#' file unless "pickOne" is true, in which case 
#' the range with the longest genomic positioning will be
#' returned. 
#'
#' @param from A .bed file or GRanges object containing
#' coordinates to be lifted over.
#' @param map Reference genome mapping logic {FROM}_{TO}
#' or alternatively, the filepath associated with a valid
#' .chain file.
#' @param to File to write liftover output to. By default,
#' we just append "over" to the input file name. This 
#' parameter is ignored if the user specifies a GRanges object.
#' @param pickOne Choose one region to represent the liftover
#' (the longest) rather than all possible regions (default).
#' 
#' @import rtracklayer
#' @import GenomicRanges
#' 
#' @importFrom utils write.table
#' @return A GRanges if "from" is a GRanges. 
#' Otherwise, it will write a file with "over" appeneded
#' with the lifted over coordinates
#' 
#' @export
#' @examples 
#' from <- paste0(system.file('extdata',package='easyLift'),'/exbed/hg19.quick.bed')
#' #easyLiftOver(sf, map = "hg19_hg38") # spits out the lifted over bed file
#' liftedGRanges <- easyLiftOver(from, map = "hg19_hg38")
#' 
easyLiftOver <- function(from, map = "hg19_hg38", to = NULL, pickOne = FALSE) {
  
  # Handle mapping
  support <- c("hg19_hg38", "hg38_hg19", "mm9_mm10", "mm10_mm9")
  if(map %in% support){
    chf<-paste0(system.file('extdata',package='easyLift'),'/chains/',map, '.over.chain')
  } else {
    chf <- map
  }
  stopifnot(file.exists(chf))
  ch <- import.chain(chf)
  
  # Handle input
  if( as.character(class(from)) == "GRanges"){
    if(pickOne){
      return(pickOne(liftOver(x=from, chain=ch)))
    } else {
      return(unlist(liftOver(x=from, chain=ch)))
    }
  } else {
    
    # Input is a .bed file; output will be a .bed file
    stopifnot(file.exists(from))
    original <- import(from,  format="bed")
    if(pickOne){
      toOut <- pickOne(liftOver(x=original, chain=ch))
    } else {
      toOut <- unlist(liftOver(x=original, chain=ch))
    }
    if(is.null(to)) to <- paste0(from, "over")
    odf <- GenomicRanges::as.data.frame(toOut)[,c(1,2,3)]
    write.table(odf, sep = "\t", row.names = FALSE,
                col.names = FALSE, quote = FALSE, file = to)
    return(paste0( "Attempted to write to file: ", to))
  }
}


