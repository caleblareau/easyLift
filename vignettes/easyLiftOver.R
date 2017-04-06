#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)

bedFile <- args[1]
mapping <- args[2]
outFile <- unlist(strsplit(args[c(-1,-2)], split = " "))

easyLift::easyLiftOver(from = bedFile, map = mapping, to = outFile)
