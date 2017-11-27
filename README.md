# rSetDayNightAttr

### 時系列データにday/night/sunset/sunriseの属性を付与するRのパッケージです。緯度と経度とタイムゾーンを指定することで、日別で日の出と日の入りを計算し、day/night/sunset/sunriseの属性を付与します。

# Installation

```` 
install.packages("devtools")
# suncalパッケージを利用するため
install.packages("suncalc")
devtools::install_github("genkiFurukawa/rSetDayNightAttr")
````
# Use（属性を付与する時間を固定するとき）
デフォルトでは、日の出の時刻の前後15分をsunrise、日の入りの時刻の前後15分をsunsetとしています。
またデフォルトでは、06:15から17:45の間の時間のデータに"day"の属性を付与します。
時刻データのデフォルトのフォーマットは%Y-%m-%d %H:%M:%Sとしています。
要件やデータの列名に合わせてパラメータを適宜変更してください。
````
require(rSetDayNightAttr)
# デフォルトの値でデータの処理を実行する場合
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime")
# Excelでエクスポートしたデータをそのまま使うとき
# 日付のフォーマットを%Y/%m/%d %H:%M:%Sにする
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", datetime_format="%Y/%m/%d %H:%M:%S")
# 処理したデータの確認
head(res, 100)
# sunrise・sunsetの属性を付与せず、06:00 ~ 18:00の時間帯のデータにday、それ以外の時間帯のデータはnightの属性を付与するとき
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", sr_befor=0, sr_after=0, ss_before=0, ss_after=0)
# sunrise・sunsetの属性を付与せず、07:30 ~ 19:45の時間帯のデータにday、それ以外の時間帯のデータはnightの属性を付与するとき
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", sr_befor=0, sr_after=0, ss_before=0, ss_after=0, daytime_start="07:00:00", daytime_end="19:45:00")
# 処理したデータの上から100行を確認
head(res, 100)
````

# Use（属性を付与する時間を固定しないとき）
デフォルトでは、日の出の時刻の前後15分をsunrise、日の入りの時刻の前後15分をsunsetとしています。
また、時刻データのデフォルトのフォーマットは%Y-%m-%d %H:%M:%Sとしています。
要件やデータの列名に合わせてパラメータを適宜変更してください。
````
require(rSetDayNightAttr)
# デフォルトの値でデータの処理を実行する場合
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", lat=45.1, lng=135.4, tz="Japan", fixed_time=FALES)
# Excelでエクスポートしたデータをそのまま使うとき
# 日付のフォーマットを%Y/%m/%d %H:%M:%Sにする
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", datetime_format="%Y/%m/%d %H:%M:%S", lat=45.1, lng=135.4, tz="Japan", fixed_time=FALES)
# 処理したデータの確認
head(res, 100)
# 日の出から15分後までをsunriseの属性を付与し、sunsetの属性は付与したくないとき
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", lat=45.1, lng=135.4, tz="Japan", sr_befor=0, sr_after=15, ss_before=0, ss_after=0, fixed_time=FALES)
# 処理したデータうを上から100行を確認
head(res, 100)
````

## Reference

### set_attr_day_night
処理したいデータフレームにDayNightという名前の列を追加し、その列にday/night/sunset/sunriseの値を付与したデータフレームを返します。
 * `df`: 処理したいデータフレーム。データフレーム。
 * `datetime_col_name`: 処理したいデータの時系列の情報が格納されている列名。文字列。
 * `lat`: 緯度。数値。南半球の場合は負の値で指定。
 * `lng`: 経度。数値。南半球の場合は負の値で指定。
 * `tz`: タイムゾーン。文字列。'OlsonNames()'で指定できるタイムゾーンを確認できる。デフォルトは'Asia/Tokyo'。
 * `datetime_format`: `datetime_col_name`のフォーマット。文字列。デフォルトは'%Y-%m-%d %H:%M:%S'。
 * `sr_befor`: 日の出前の何分間をsunriseとするか。数値。デフォルトは15。
 * `sr_after`: 日の出前の何分間をsunriseとするか。数値。デフォルトは15。
 * `ss_befor`: 日の出前の何分間をsunriseとするか。数値。デフォルトは15。
 * `ss_after`: 日の出前の何分間をsunriseとするか。数値。デフォルトは15。
 * `fixed_time`: day/night/sunset/sunriseの属性を付与する時間帯を固定するかどうか。TRUE/FALSE。デフォルトはTRUE。
 * `daytime_start`: dayの属性を付与し始める時間。文字列。デフォルトは06:00。
 * `daytime_end`: dayの属性を付与し終える時間。文字列。デフォルトは18:00。
 
