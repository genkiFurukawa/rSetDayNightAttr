#' 日付および緯度経度を指定し、日の出と日の入りの時間を取得する
#'
#' @param year 年
#' @param month 月
#' @param day 日
#' @param lat 緯度
#' @param lng 経度
#' @param tz タイムゾーン
#' @return 日の出の時間と日の入りの時間の数値のリスト
#' @examples
#' get_sunrise_sunset(2017, 1, 13, 35.774781, 139.606076, "Asia/Tokyo")
#' get_sunrise_sunset(2010, 3, 31, 25.1 ,138.4, "UTC")
get_sunrise_sunset <- function(year, month, day, lat, lng, tz){
  date <- as.Date(paste(year, month, day, sep="-"))
  res <- getSunlightTimes(date, lat, lng, keep = c("sunrise", "sunset"), tz=tz)
  sunrise_time <- as.POSIXlt(res[["sunrise"]])
  sunset_time <- as.POSIXlt(res[["sunset"]])
  print(sunrise_time)
  print(sunset_time)
  # print(str(sunrise_time))
  # print(str(sunset_time))
  sunrise_sunset_posixlt <- c(sunrise_time, sunset_time)
  names(sunrise_sunset_posixlt) <- c("sunrise", "sunset")
  return(sunrise_sunset_posixlt)
}
#
