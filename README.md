# rSetDayNightAttr

### 時系列データにday/night/sunset/sunriseの属性を付与するパッケージです。緯度と経度とタイムゾーンを指定することで、日別で日の出と日の入りを計算し、day/night/sunset/sunriseの属性を付与します。

# Installation

```` 
install.packages("devtools")
# suncalパッケージを利用するため
install.packages("suncalc")
devtools::install_github("genkiFurukawa/rSetDayNightAttr")
````

# Use
デフォルトでは、日の出の時刻の前後15分をsunrise、日の入りの時刻の前後15分をsunsetとしています。
また、時刻データのデフォルトのフォーマットは%Y-%m-%d %H:%M:%Sとしています。
要件やデータの列名に合わせてパラメータを適宜変更してください。
````
require(rSetDayNightAttr)
# デフォルトの値でデータの処理を実行する場合
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", lat=45.1, lng=135.4, tz="Japan")
# 処理したデータの確認
head(res, 100)
# 日の出から15分後までをsunrise、sunsetの属性を付与したくないとき
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", lat=45.1, lng=135.4, tz="Japan", sr_befor=0, sr_after=15, ss_before=0, ss_after=0)
# 処理したデータの確認
head(res, 100)
````

## Reference

### set_attr_day_night
処理したいデータフレームにDayNightという名前の列を追加し、その列にday/night/sunset/sunriseの値を付与したデータフレームを返します。
 * `df`: 処理したいデータフレーム。データフレーム。
 * `datetime_col_name`: 処理したいデータの時系列の情報が格納されている列名。文字列。
 * `lat`: 緯度。数値。南半球の場合は負の値で指定。
 * `lng`: 経度。数値。南半球の場合は負の値で指定。
 * `tz`: タイムゾーン。文字列。'OlsonNames()'で指定できるタイムゾーンを確認できる。
 * `datetime_format`: `datetime_col_name`のフォーマット。文字列。デフォルトは'%Y-%m-%d %H:%M:%S'。
 * `sr_befor`: 日の出前の何分間をsunriseとするか。数値。デフォルトは15。
 * `sr_after`: 日の出前の何分間をsunriseとするか。数値。デフォルトは15。
 * `ss_befor`: 日の出前の何分間をsunriseとするか。数値。デフォルトは15。
 * `ss_after`: 日の出前の何分間をsunriseとするか。数値。デフォルトは15。
 
