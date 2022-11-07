# This is the data cleaning function for Cigarette sales raw data ...
# from The Tax Burden on Tobacco, Orzechowski and Walker(2019). 
# Run this function to get the per-capita cigarette consumption (in packs)
# for all 51 states from 1970 to 2000. 


# raw data input
Raw_Cigs = read.csv('data/The_Tax_Burden_on_Tobacco__1970-2019.csv');

# keep vital vars 
Raw_Cigs = subset(Raw_Cigs, select = c(LocationAbbr, Year, Data_Value, Data_Value_Type))

Raw_Cigs = Raw_Cigs[Raw_Cigs$Data_Value_Type == 'Pack', ]

Raw_Cigs = subset(Raw_Cigs, select = -4)

# define data type and rename

names(Raw_Cigs) <- c('state', 'year', 'cigs')

Raw_Cigs$year <- as.numeric(Raw_Cigs$year)
Raw_Cigs$cigs <- as.numeric(Raw_Cigs$cigs)


cigs_all_state <- Raw_Cigs[order(Raw_Cigs$state, Raw_Cigs$year),]

# keep data from 1970 to 2000

cigs_all_state = cigs_all_state[cigs_all_state$year <= 2000, ]  

# output data as excel
write.csv(cigs_all_state,'data/cigs_consumption.csv', row.names = FALSE)
