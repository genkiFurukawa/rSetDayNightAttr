#' 指定した時間帯のデータを抜き出す
#'
#' @param df データフレーム
#' @param datetime_col_name 日時情報が格納された列名
#' @param start 開始時間
#' @param end 終了時間
#' @param start_equal 開始時間を含めるかどうか
#' @param end_equal 終了時間を含めるかどうか
#' @return 指定した時間帯のみを抜き出したデータ
#' @examples
#' extract_data_specified_time_period(df1, Datetime, "2017-10-12 05:00", "2017-10-12 05:30", TRUE, TRUE)
#' extract_data_specified_time_period(df2, JST, "2017-10-12 05:00", "2017-10-12 05:30", False, TRUE)
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
