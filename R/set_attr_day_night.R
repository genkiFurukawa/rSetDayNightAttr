#' 与えられたデータフレームにDayNightという列名にDay/Night/Sunset/Sunriseのカテゴリを付与
#'
#' @param df データフレーム
#' @param datetime_col_name 日時情報が格納された列名
#' @param lat 緯度
#' @param lng 経度
#' @param tz タイムゾーン
#' @param datetime_format 時間の列名のフォーマット
#' @param sr_befor 日の出の何分前までをsunsetとするか
#' @param sr_after 日の出の何分後までをsunsetとするか　
#' @param ss_before 日の出の何分前までをsunriseとするか
#' @param ss_after 日の出の何分後までをsunriseとするか
#' @return DayNightという列名にDay/Night/Sunset/Sunriseのカテゴリを付与したデータフレーム
#' @examples
#' set_attr_day_night(df1, Datetime, 45.1 ,135.4)
#' set_attr_day_night(df1, Datetime, 45.1 ,135.4, "Asia/Tokyo", "%Y/%m/%d %H:%M", 0, 30, 15, 15)
set_attr_day_night <- function(df, datetime_col_name, lat, lng, mytz, datetime_format="%Y-%m-%d %H:%M:%S", sr_befor=15, sr_after=15, ss_before=15, ss_after=15){
  # 型チェック
  # 新たな列追加
  df[["DayNight"]] <- ""
  # フォーマットに従って時間型に変換
  df[[datetime_col_name]] <- as.POSIXlt(df[[datetime_col_name]], tz=mytz, format=datetime_format)
  # print(str(df))
  print(head(df))
  # print(df[[datetime_col_name]])
  # 期間を抜き出す
  start_day <- as.Date(min(df[[datetime_col_name]]))
  # print(start_day)
  end_day <- as.Date(max(df[[datetime_col_name]]))
  # print(end_day)
  period <- as.numeric(end_day - start_day)
  # 日別に処理する
  # print(head(df))
  start_datetime <- as.POSIXlt(as.POSIXct(start_day), tz=mytz)
  start_datetime$hour <- 0
  res <- subset(df, df[[datetime_col_name]] < start_datetime)
  # print(res)
  for(i in 0:period){
    # 日の出日の入り取得
    tmp_datetime <- start_day + i
    print(tmp_datetime)
    tmp_datetime <- as.POSIXlt(as.POSIXct(tmp_datetime), tz=mytz)
    tmp_datetime$hour <- 0
    print(tmp_datetime)
    sunrise_sunset <- get_sunrise_sunset(tmp_datetime$year+1900, tmp_datetime$mon+1, tmp_datetime$mday, lat, lng, mytz)
    # print(sunrise_sunset[1])
    # print(str(sunrise_sunset))
    sunrise <- sunrise_sunset[1]
    sunset <- sunrise_sunset[2]
    # print(sunrise)
    # print(sunset)
    #
    tmp <- subset(df, df[[datetime_col_name]] >= tmp_datetime)
    # print(sunset)
    tmp <- subset(tmp, tmp[[datetime_col_name]] < tmp_datetime+24*60*60)
    # print(head(tmp))
    #
    # print(sunrise - sr_befor*60)
    tmp1 <- subset(tmp, tmp[[datetime_col_name]] < sunrise - sr_befor*60)
    # print(head(tmp1))
    print(tmp1)
    if(nrow(tmp1) > 0){
      tmp1[["DayNight"]] <- "Night"
      res <- rbind(res, tmp1)
    }
    #
    tmp2 <- extract_data_specified_time_period(tmp,
                                               datetime_col_name,
                                               sunrise - sr_befor*60,
                                               sunrise + sr_after*60)
    if(nrow(tmp2) > 0){
      tmp2[["DayNight"]] <- "Sunrise"
      res <- rbind(res, tmp2)
    }
    #
    tmp3 <- extract_data_specified_time_period(tmp,
                                               datetime_col_name,
                                               sunrise + sr_after*60,
                                               sunset - ss_before*60,
                                               start_equal=FALSE,
                                               end_equal=FALSE)
    if(nrow(tmp3) > 0){
      tmp3[["DayNight"]] <- "Day"
      res <- rbind(res, tmp3)
    }
    #
    tmp4 <- extract_data_specified_time_period(tmp,
                                               datetime_col_name,
                                               sunset - ss_before*60,
                                               sunset + ss_after*60)
    if(nrow(tmp4) > 0){
      tmp4[["DayNight"]] <- "Sunset"
      res <- rbind(res, tmp4)
    }
    #
    tmp5 <- subset(tmp, tmp[[datetime_col_name]] > sunset + ss_after*60)
    if(nrow(tmp5) > 0){
      tmp5[["DayNight"]] <- "Night"
      res <- rbind(res, tmp5)
    }
    # print(res)
  }
  return(res)
}
