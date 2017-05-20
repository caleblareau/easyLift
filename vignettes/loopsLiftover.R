library(diffloop)
library(easyLift)
library(rtracklayer)

old <- readRDS("/Users/lareauc/Desktop/H3k27R1-HiChIP.rds")

# Liftover anchors
map <- "mm10_mm9"
chf<-paste0(system.file('extdata',package='easyLift'),'/chains/',map, '.over.chain')
ch <- import.chain(chf)
pickOneOutput <- pickOne(liftOver(x=addchr(old@anchors), chain=ch), returnBooVec = TRUE)

# Filter out loops whose anchors could not be mapped
keepLoops <- !(old@interactions[,1] %in% which(!pickOneOutput[[2]]) | old@interactions[,2] %in% which(!pickOneOutput[[2]]))
filt <- subsetLoops(old, keepLoops)

# Do the liftover again to make sure
pickOneOutput2 <- pickOne(liftOver(x=addchr(filt@anchors), chain=ch), returnBooVec = TRUE)
filt@anchors <- pickOneOutput2[[1]]
saveRDS(filt, "RR_HiChIP_H3K27ac_Rep1.rds")
