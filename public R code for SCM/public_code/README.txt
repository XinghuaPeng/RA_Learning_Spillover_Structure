Synthetic Controls with Spillovers
Jianfei Cao and Connor Dowd

See www.codowd.com/public/SCM_paper.pdf for details.

Most of this code is ported from Matlab code available at
https://voices.uchicago.edu/jianfeicao/research/

- cigs.xls contains the original data from Abadie, Diamond, and Hainmueller (2010)

- clean_data.R takes cigs.xls and converts it to a more usable form.
  - This involves the use of the packages: readxl, dplyr, tidyr
  
- cigs.RData contains the outputs of running clean_data.R
  - which obviates the need for the packages above
  
- functions.R contains all the inferential functions

- run.R actually performs the estimation
  - it contains a flag for running clean_data.R or loading cigs.RData
  - it contains a flag for running the leave-one-out procedure and for quantile based or normal inference
  - it does not do everything in our paper, all of which is in the matlab code on Jianfei's website.
  

  

