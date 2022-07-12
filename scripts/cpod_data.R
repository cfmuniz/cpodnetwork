####
# Description: Query database for CPOD data and prepare APELAFICO stations for analysis.
# Date: 2022-07-12
# Author: Carlota Muniz
#### 


# Load dependencies -------------------------------------------------------

library(lwdataexplorer)
library(tidyverse)
source('~/cpodnetwork/functions/cpod_query_maker.R')

df_clean <- function(df){
  
  # Format data columns
  
  return(df %>% 
           mutate(time = as.POSIXct(time),
                  species = as.factor(species),
                  station = as.factor(station)) %>% 
           arrange(time))
}

# Query database ----------------------------------------------------------

# Warning: query may take VERY long to run. For long periods of time, keep bins short (i.e. `date_freq`) 


# 1 min data 

cpod_data <- cpod_query_maker(start_date = '2022-06-01',
                              stop_date = Sys.Date(),       # current date
                              date_freq = 'week',
                              query_freq = '1 min')

# Format columns

cpod_df <- df_clean(cpod_data)


# Export data -------------------------------------------------------------

# save(cpod_df, file = paste0('~/cpodnetwork/data/cpod_query_date_', format(Sys.Date(), '%Y%m%d')))
