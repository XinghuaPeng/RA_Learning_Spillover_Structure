---
title: "README"
subtitle: Replication Files for ``Estimation and Inference for Synthetic Control Methods with Spillover Effects" 
date: "May 19, 2022"
output:
  pdf_document: default
---


This code replicates the empirical example in Cao and Dowd (2019), which estimates the treatment effects of Proposition 99 in the presence of spillovers. This code applies to other datasets when adjusted accordingly.



# 1. Folder Structure

## **$\bullet$ main.m**

  Run this MATLAB file to obtain all results, including estimation \& inference, Figure 6, and Figure 7 in Cao and Dowd (2019). 
  

## **$\bullet$ code/**

  - **data_cleaning.m**: This code cleans the raw dataset and outputs the per-capita cigarette consumption table for 51 states from 1970 to 2000. 

  - **data_input.m**: This code inputs the cigarette consumption table and the spillover structure matrix according to the settings for the number of states and the spillover states list.
  
  - **scm_estimation.m**: This code estimates the treatment effect by synthetic California using the 38 states.
  
  - **sp_estimation.m**: This code estimates the treatment effect by spillover-adjusted synthetic California using the 50 states. This code also estimates the spillover effect on Arizona/Nevada/Oregon, and outputs the spillover effect table.
  
  - **sp_inference.m**: This code tests for the treatment effect on California, the spillover effect on Arizona/Nevada/Oregon, and tests whether there is spillover at each post-treatment period. 
  
  - **output_results.m**: This code outputs the treatment effect table, Figure 6, and Figure 7 in Cao and Dowd (2019).  

## **$\bullet$  functions/**

  - **scm_batch.m**: 
    This function estimates the weights by using each row as the treated and the others as the controls, separately. 
    
  - **sp_andrews_te.m**:
    This function conducts the end-of-sample instability test for treatment effects. 
    
  - **sp_andrews.m**: This function conducts the end-of-sample instability test for any hypothesis of the form $C\alpha = d$ including the existence of spillover effects. 
    
## **$\bullet$ data/**

  
  - **The_Tax_Burden_on_Tobacco\_\_1970-2019.csv**: This table contains the raw per-capita cigarette consumption data from *The Tax Burden on Tobacco (1970-2019), 	Centers for Disease Control and Prevention*. 
  
  - **state_list.csv**: This table contains the indicators for the 12 missing states in Abadie et al. (2010) and the neighboring states of California. 
  
  - **cigs_consumption.csv**: This table contains the per-capita cigarette consumption data for 51 states from 1970 to 2000, after running data_cleaning.m.
  



## **$\bullet$ output/**

  This folder stores the output figures and tables.

#  2. Data Input

Set the number of states (38 or 50) and spillover states list before running the data_input.m.

To apply the code to other datasets, modify data_input.m and/or the data input section in main.m.
The input variables are defined as follows:

- Y: N-by-(T+S) outcome matrix with the first row being treated unit

- N: number of units

- T: number of pre-treatment time periods

- S: number of post-treatment time periods

- A: matrix of spillover exposure

The user may need to modify the plot section of the output_results.m for visualizing the results. 


