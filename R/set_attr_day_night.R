#' 与えられたデータフレームにDayNightという列名にDay/Night/Sunset/Sunriseのカテゴリを付与
#'
#' @param df データフレーム
#' @param datetime_col_name 日時情報が格納された列名
#' @param lat 緯度
#' @param lng 経度
#' @param tz データのタイムゾーン
#' @param datetime_format 時間の列名のフォーマット
#' @param sr_befor 日の出の何分前までをsunsetとするか
#' @param sr_after 日の出の何分後までをsunsetとするか　
#' @param ss_before 日の出の何分前までをsunriseとするか
#' @param ss_after 日の出の何分後までをsunriseとするか
#' @param fixed_time 属性を付与する時間帯を固定するかどうか
#' @param daytime_start 属性を付与する時間帯を固定したときの"day"の属性を付与し始める時間
#' @param daytime_end 属性を付与する時間帯を固定したときの"day"の属性を付与し終わる時間
#' @return DayNightという列名にday/night/sunset/sunriseのカテゴリを付与したデータフレーム
#' @examples
#' set_attr_day_night(df1, Datetime, 45.1 ,135.4)
#' set_attr_day_night(df1, Datetime, 45.1 ,135.4, "Asia/Tokyo", "%Y/%m/%d %H:%M", 0, 30, 15, 15)
set_attr_day_night <- function(df, datetime_col_name, lat, lng, tz="Asia/Tokyo",
                               datetime_format="%Y-%m-%d %H:%M:%S",
                               sr_befor=15, sr_after=15,
                               ss_before=15, ss_after=15,
                               fixed_time=TRUE, daytime_start="06:00:00", daytime_end="18:00:00"
                               ){

  # 新たな列追加
  df[["DayNight"]] <- ""
  # フォーマットに従って時間型に変換
  df[[datetime_col_name]] <- as.POSIXlt(df[[datetime_col_name]], tz=tz, format=datetime_format)
  # 期間を抜き出す
  start_day <- as.Date(min(df[[datetime_col_name]]))
  end_day <- as.Date(max(df[[datetime_col_name]]))
  #
  period <- as.numeric(end_day - start_day)
  #
  start_datetime <- as.POSIXlt(as.POSIXct(start_day), tz=tz)
  start_datetime$hour <- 0
  res <- subset(df, df[[datetime_col_name]] < start_datetime)
  # print(res)
  # 時間を固定するとき
  if(fixed_time == TRUE){
    for(i in 0:period){
      # 日の出日の入り取得
      tmp_datetime <- start_day + i
      tmp_datetime <- as.POSIXlt(as.POSIXct(tmp_datetime), tz=tz)
      tmp_datetime$hour <- 0
      #
      start_time <- paste(tmp_datetime$year+1900, "-", tmp_datetime$mon+1, "-", tmp_datetime$mday, " ", daytime_start, sep="")
      start_time <- as.POSIXlt(as.POSIXct(start_time), tz=tz)
      end_time <- paste(tmp_datetime$year+1900, "-", tmp_datetime$mon+1, "-", tmp_datetime$mday, " ", daytime_end, sep="")
      end_time <- as.POSIXlt(as.POSIXct(end_time), tz=tz)
      #
      tmp <- subset(df, df[[datetime_col_name]] >= tmp_datetime)
      #
      tmp <- subset(tmp, tmp[[datetime_col_name]] < tmp_datetime+24*60*60)
      #
      tmp1 <- subset(tmp, tmp[[datetime_col_name]] < start_time - sr_befor*60)
      #
      if(nrow(tmp1) > 0){
        tmp1[["DayNight"]] <- "night"
        res <- rbind(res, tmp1)
      }
      #
      tmp2 <- extract_data_specified_time_period(tmp,
                                                 datetime_col_name,
                                                 start_time - sr_befor*60,
                                                 start_time + sr_after*60)
      if(nrow(tmp2) > 0){
        tmp2[["DayNight"]] <- "sunrise"
        res <- rbind(res, tmp2)
      }
      #
      tmp3 <- extract_data_specified_time_period(tmp,
                                                 datetime_col_name,
                                                 start_time + sr_after*60,
                                                 end_time - ss_before*60,
                                                 start_equal=FALSE,
                                                 end_equal=FALSE)
      if(nrow(tmp3) > 0){
        tmp3[["DayNight"]] <- "day"
        res <- rbind(res, tmp3)
      }
      #
      tmp4 <- extract_data_specified_time_period(tmp,
                                                 datetime_col_name,
                                                 end_time - ss_before*60,
                                                 end_time + ss_after*60)
      if(nrow(tmp4) > 0){
        tmp4[["DayNight"]] <- "sunset"
        res <- rbind(res, tmp4)
      }
      #
      tmp5 <- subset(tmp, tmp[[datetime_col_name]] > end_time + ss_after*60)
      if(nrow(tmp5) > 0){
        tmp5[["DayNight"]] <- "night"
        res <- rbind(res, tmp5)
      }
    }
  }
  # 時間を固定しないとき
  if(fixed_time == FALSE){
    for(i in 0:period){
      # 日の出日の入り取得
      tmp_datetime <- start_day + i
      tmp_datetime <- as.POSIXlt(as.POSIXct(tmp_datetime), tz=tz)
      tmp_datetime$hour <- 0
      #
      sunrise_sunset <- get_sunrise_sunset(tmp_datetime$year+1900, tmp_datetime$mon+1, tmp_datetime$mday, lat, lng, tz)
      sunrise <- sunrise_sunset[1]
      sunset <- sunrise_sunset[2]
      #
      tmp <- subset(df, df[[datetime_col_name]] >= tmp_datetime)
      #
      tmp <- subset(tmp, tmp[[datetime_col_name]] < tmp_datetime+24*60*60)
      #
      tmp1 <- subset(tmp, tmp[[datetime_col_name]] < sunrise - sr_befor*60)
      #
      if(nrow(tmp1) > 0){
        tmp1[["DayNight"]] <- "night"
        res <- rbind(res, tmp1)
      }
      #
      tmp2 <- extract_data_specified_time_period(tmp,
                                                 datetime_col_name,
                                                 sunrise - sr_befor*60,
                                                 sunrise + sr_after*60)
      if(nrow(tmp2) > 0){
        tmp2[["DayNight"]] <- "sunrise"
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
        tmp3[["DayNight"]] <- "day"
        res <- rbind(res, tmp3)
      }
      #
      tmp4 <- extract_data_specified_time_period(tmp,
                                                 datetime_col_name,
                                                 sunset - ss_before*60,
                                                 sunset + ss_after*60)
      if(nrow(tmp4) > 0){
        tmp4[["DayNight"]] <- "sunset"
        res <- rbind(res, tmp4)
      }
      #
      tmp5 <- subset(tmp, tmp[[datetime_col_name]] > sunset + ss_after*60)
      if(nrow(tmp5) > 0){
        tmp5[["DayNight"]] <- "night"
        res <- rbind(res, tmp5)
      }
    }
  }
  return(res)
}
