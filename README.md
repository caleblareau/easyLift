# easyLift
R package for easy `mm9 <-> mm10 / hg19 <-> hg38`

## Install
```
devtools::install_github("caleblareau/easyLift")
```

## Quick Usage
Grab the convenient [Rscript](vignettes/easyLiftOver.R) from the `vignettes` folder
to run everything from the command line like so--

```
lareauc$ Rscript easyLiftOver.R randPeaks.bed hg19_hg38
[1] "Attempted to write to file: randPeaks.bedover"
```

- First parameter is the `.bed` file that one wants to lift over.
- Second parameter is the liftover chain specification. The coding is {FROM}_{TO}.
- Third (optional) parameter is the output file name. If no file is supplied, then "over" will be appened to the `.bed` file supplied in the first argument. 

## Support

For the second (`map`) parameter, we currently support any one of: 
- `mm9_mm10`
- `mm10_mm9`
- `hg19_hg38`
- `hg38_hg19`

For the first (`from`) parameter, the file extension doesn't necessarily need to be `.bed` but just resemble a `.bed` (e.g. `.narrowPeak`

## Advanced Usage
- In the `R` environment, using `easyLift::easyLiftOver` on a `GRanges` object will return a `GRanges` object with lifted over coordinates again specified by the second (`map`) parameter. 

- If you have a `.chain` file that you want to use (e.g. for going from mm10 to hg38), specify that file path in the second argument. This gives a sample URL structure to access these cross-species chain files from UCSC. 

```
http://hgdownload.cse.ucsc.edu/goldenpath/hg38/vsMm10/
```
