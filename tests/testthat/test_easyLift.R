
context("Basic liftOver conversion works")

test_that("hg19 mapping is behaving as expected.", {
  sf <- paste0(system.file('extdata',package='easyLift'),'/exbed/hg19.quick.bed')
  from <- rtracklayer::import(sf)
  liftedGRanges <- easyLiftOver(from, map = "hg19_hg38")
  trueLG <- readRDS(paste0(system.file('extdata',package='easyLift'),'/rds/hg19quick_lifted_results.rds'))
  expect_equal(liftedGRanges, trueLG)
})
