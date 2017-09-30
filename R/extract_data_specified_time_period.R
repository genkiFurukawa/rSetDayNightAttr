# sample
extract_data_specified_time_period <- function(df, datetime_col_name, start, end, start_equal=TRUE, end_equal=TRUE){
  tmp <- df
  if(start_equal == TRUE){
    tmp <- subset(tmp, tmp[[datetime_col_name]] >= start)
  }
  else if(start_equal == FALSE){
    tmp <- subset(tmp, tmp[[datetime_col_name]] > start)
  }
  if(end_equal == TRUE){
    tmp <- subset(tmp, tmp[[datetime_col_name]] <= end)
  }
  else if(end_equal == FALSE){
    tmp <- subset(tmp, tmp[[datetime_col_name]] < end)
  }
  return(tmp)
}
