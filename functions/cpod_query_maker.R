#' Query CPOD database in batches to retrieve high frequency data (i.e. per minute data).
#' Default returns raw data of high and moderate quality.
#' 
#' @param start_date A string. First day of period of interest. Format: `"yyyy-mm-dd"`.
#' @param stop_date  A string. Last day of period of interest. Format: `"yyyy-mm-dd"`.
#' @param date_freq  A string. Creates a sequence of the selected window size between `start_date` and `stop_date`.
#' Default: `"week`. 
#' Options:  `"day"`, `"week"`, `"month"`. Important: larger window size will crash when retrieving 1 minute frequency data.
#' Calls `seq.Date`. See more details \url{https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/seq.Date}
#' @param query_freq  A string. Frequency of data to retrieve.
#' Default: hourly data, `"60 min"`.
#' Options: `"1 day"`, `"1 week"`, `"60 min"`, `"10 min"`, `"1 min"`.
#' Calls `lwdataexplorer::getCpodData`. See more details \url{https://rdrr.io/github/lifewatch/lwdataexplorer/man/getCpodData.html}
#' @param processing A string. One of (`"Raw"`, `"Validated`). Inherits from `lwdataexplorer::getCpodData`.
#' @param quality A string. One of (`"Hi"`,  `"Mod"`, `"Lo`) data. Inherits from `lwdataexplorer::getCpodData`.
#' 
#' @return Database query result between \code{start_date} and \code{stop_date}.
#' @examples
#' # Query hourly data in batches of 1 week:
#' cpod_query <- cpod_query_maker('2021-01-01', '2021-03-01')
#' # Query per minute data in batches of 1 week:
#' cpod_query <- cpod_query_maker('2021-01-01', '2021-03-01', 'week', '1 min')



cpod_query_maker <- function(start_date, stop_date, date_freq = 'week', query_freq = '60 min',
                             processing = 'Raw', quality = c('Hi', 'Mod')){
  
  # Generate query period of selected frequency
  
  date_list <- seq.Date(from = as.Date(start_date), to = as.Date(stop_date), by = date_freq)
  
  # Query
  
  tmp_list <- list()
  df_list <- list()
  
  i <- 1

  len <- length(date_list)
  
  while(i <= len){
    
    startdate = date_list[i]
    
    stopdate = if(i < len) date_list[i+1] else stop_date
    
    tmp_list <- getCpodData(startdate = startdate,
                            stopdate = stopdate,
                            processing = processing,
                            quality = quality,
                            by = query_freq)
    
    df_list[[i]] <- tmp_list
    
    i <- i+1
  }
  
  # Return dataframe format

  df <- bind_rows(df_list)

  return(df)
}
