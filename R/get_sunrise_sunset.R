#' 日付および緯度経度を指定し、日の出と日の入りの時間を取得する
#'
#' @param year 年
#' @param month 月
#' @param day 日
#' @param lat 緯度
#' @param lon 経度
#' @return 日の出の時間と日の入りの時間
#' @examples
#' get_sunrise_sunset(2017, 1, 13, 45.1 ,135.4)
#' get_sunrise_sunset(2010, 3, 31, 25.1 ,138.4)
get_sunrise_sunset <- function(year, month, day, lat, lng){
  # 引数の数足りているか
  if(missing(year) || missing(month) || missing(day) || missing(lat) || missing(lng)){
    stop("arguments is missing!!")
  }
  # 引数が数値か
  if(!is.numeric(year) || !is.numeric(month) || !is.numeric(day) || !is.numeric(lat) || !is.numeric(lng) ){
    stop("arguments is not numeric!!")
  }
  url_name <- "http://labs.bitmeister.jp/ohakon/api/?mode=sun_moon_rise_set"
  url_name <- paste(url_name, "&year=", year, sep="")
  url_name <- paste(url_name, "&month=", month, sep="")
  url_name <- paste(url_name, "&day=", day, sep="")
  url_name <- paste(url_name, "&lat=", lat, sep="")
  url_name <- paste(url_name, "&lng=", lng, sep="")
  res <- xml2::read_xml(url_name)
  # 結果のチェックいるよね
  sunrise_time <- as.numeric(xml_text(xml_find_all(res, ".//sunrise")))
  sunset_time <- as.numeric(xml_text(xml_find_all(res, ".//sunset")))
  sunrise_sunset_hhmm <- c(sunrise_time, sunset_time)
  names(sunrise_sunset_hhmm) <- c("sunrise", "sunset")
  return(sunrise_sunset_hhmm)
}
#
