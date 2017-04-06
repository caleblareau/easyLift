# easyLift
R package for easy `mm9 <-> mm10 / hg19 <-> hg38`

## Install
```
devtools::install_github("buenrostrolab/easyLift")
```

## Usage
Grab the convenient Rscript from the `vignettes` folder
to run everything from the command line like so--

```
lareauc$ Rscript easyLiftOver.R randPeaks.bed hg19_hg38
[1] "Attempted to write to file: randPeaks.bedover"
```

- First parameter is the `.bed` file that one wants to lift over.
- Second parameter is the liftover chain specification. The coding is {FROM}_{TO}.
- Third (optional) parameter is the output file name. 

