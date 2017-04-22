#!/usr/bin/env Rscript

# Check for install; install if missing
install_pkgs <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg)) install.packages(new.pkg, dependencies = TRUE)
}

install_pkgs_gh <- function(ghrepo, pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg)) devtools::install_github(paste0(ghrepo, "/", new.pkg))
}

install_pkgs(c("devtools"))
install_pkgs_gh("buenrostrolab", "easyLift")

# Parse arguments
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) <= 3)

bedFile <- args[1]
mapping <- args[2]
outFile <- unlist(strsplit(args[c(-1,-2)], split = " "))

# Do the liftover
easyLift::easyLiftOver(from = bedFile, map = mapping, to = outFile)
