set_attr_day_night <- function(df, datetime_col_name, lat, lng, datetime_format="%Y-%m-%d %H:%M:%S", sr_befor=15, sr_after=15, ss_before=15, ss_after=15){
  # 型チェック
  # 新たな列追加
  df[["DayNight"]] <- ""
  # フォーマットに従って時間型に変換
  df[[datetime_col_name]] <- as.POSIXlt(df[[datetime_col_name]], tz="UTC", format=datetime_format)
  # 期間を抜き出す
  start_day <- as.Date(min(df[[datetime_col_name]]))
  end_day <- as.Date(max(df[[datetime_col_name]]))
  period <- as.numeric(end_day - start_day)
  # 日別に処理する
  print(head(df))
  res <- subset(df, df[[datetime_col_name]] < as.POSIXlt(start_day))
  # print(res)
  for(i in 0:period){
    # 日の出日の入り取得
    tmp_datetime <- as.POSIXlt(start_day + i)
    # print(tmp_datetime)
    sunrise_sunset <- get_sunrise_sunset(tmp_datetime$year+1900, tmp_datetime$mon+1, tmp_datetime$mday, lat, lng)
    sunrise <- sunrise_sunset["sunrise"]
    sunset <- sunrise_sunset["sunset"]
    # print(sunrise)
    # print(sunset)
    #
    tmp <- subset(df, df[[datetime_col_name]] >= tmp_datetime)
    tmp <- subset(tmp, tmp[[datetime_col_name]] < tmp_datetime+24*60*60)
    # print(tmp)
    #
    tmp1 <- subset(tmp, tmp[[datetime_col_name]] < tmp_datetime + sunrise*60*60 - sr_befor*60)
    if(nrow(tmp1) > 0){
      tmp1[["DayNight"]] <- "Night"
      res <- rbind(res, tmp1)
    }
    #
    tmp2 <- extract_data_specified_time_period(tmp,
                                               datetime_col_name,
                                               tmp_datetime + sunrise*60*60 - sr_befor*60,
                                               tmp_datetime + sunrise*60*60 + sr_after*60)
    # tmp2 <- subset(tmp, tmp[[datetime_col_name]] >= tmp_datetime + sunrise*60*60 - sr_befor*60)
    # tmp2 <- subset(tmp2, tmp2[[datetime_col_name]] <= tmp_datetime + sunrise*60*60 + sr_after*60)
    if(nrow(tmp2) > 0){
      tmp2[["DayNight"]] <- "Sunrise"
      res <- rbind(res, tmp2)
    }
    #
    # tmp3 <- subset(tmp, tmp[[datetime_col_name]] > tmp_datetime + sunrise*60*60 + sr_after*60)
    # tmp3 <- subset(tmp3, tmp3[[datetime_col_name]] < tmp_datetime + sunset*60*60 - ss_before*60)
    tmp3 <- extract_data_specified_time_period(tmp,
                                               datetime_col_name,
                                               tmp_datetime + sunrise*60*60 + sr_after*60,
                                               tmp_datetime + sunset*60*60 - ss_before*60,
                                               start_equal=FALSE,
                                               end_equal=FALSE)
    if(nrow(tmp3) > 0){
      tmp3[["DayNight"]] <- "Day"
      res <- rbind(res, tmp3)
    }
    #
    tmp4 <- extract_data_specified_time_period(tmp,
                                               datetime_col_name,
                                               tmp_datetime + sunset*60*60 - ss_before*60,
                                               tmp_datetime + sunset*60*60 + ss_after*60)
    # tmp4 <- subset(tmp, tmp[[datetime_col_name]] >= tmp_datetime + sunset*60*60 - ss_before*60)
    # tmp4 <- subset(tmp4, tmp4[[datetime_col_name]] <= tmp_datetime + sunset*60*60 + ss_after*60)
    if(nrow(tmp4) > 0){
      tmp4[["DayNight"]] <- "Sunset"
      res <- rbind(res, tmp4)
    }
    #
    tmp5 <- subset(tmp, tmp[[datetime_col_name]] > tmp_datetime + sunset*60*60 + ss_after*60)
    if(nrow(tmp5) > 0){
      tmp5[["DayNight"]] <- "Night"
      res <- rbind(res, tmp5)
    }
  }
  return(res)
}
