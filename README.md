# rSetDayNightAttr
時刻データの列を含むデータフレームに対し、day/night/sunrise/sunsetの属性の列を追加するRのパッケージです。  
日の出と日の入りの時間を指定し、day/night/sunrise/sunsetの属性の列を追加することができます。
また、緯度と経度とタイムゾーンを指定することで、日別で日の出と日の入りを計算し、day/night/sunset/sunriseの属性の列を追加することも可能です。sunrise/sunsetの属性は任意で付与可能です。  
バイオロギングなどで取得したcsvデータをデータフレームとして読み込み、利用されることを想定しています。

# インストール

```` 
install.packages("devtools")
# suncalパッケージを利用するため
install.packages("suncalc")
devtools::install_github("genkiFurukawa/rSetDayNightAttr")
````

# 使い方

## 日の出と日の入りの時間を固定し、day/night/sunrise/sunsetの属性を付与するとき
デフォルトでは日の出の時刻を06:00、日の入りの時刻を18:00としています。また、日の出の前後15分がsunriseと分類され、日の入りの前後15分がsunsetと分類されます。
時刻データのデフォルトのフォーマットは%Y-%m-%d %H:%M:%Sとしています。
要件やデータの列名に合わせてパラメータを適宜変更してください。
````
require(rSetDayNightAttr)
# デフォルトの値でデータの処理を実行する場合
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime")
# 処理したデータの確認
head(res, 100)
# sunrise・sunsetの属性を付与しないとき
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", sr_before=0, sr_after=0, ss_before=0, ss_after=0)
# 07:15を日の出、19:00を日の入りとするとき
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", daytime_start="07:15:00", daytime_end="19:00:00")
````

## 自動計算された日の出・日の入り時間でday/night/sunrise/sunsetの属性を付与するとき
緯度・経度・タイムゾーンを指定し、fixed_timeをFALSEとすることで、日別で自動計算された日の出・日の入り時間でday/night/sunrise/sunsetの属性を付与します。
````
require(rSetDayNightAttr)
# デフォルトの値でデータの処理を実行する場合
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", lat=45.1, lng=135.4, tz="Japan", fixed_time=FALSE)
# 処理したデータの上から100行を確認
head(res, 100)
````

# Reference

## set_attr_day_night
処理したいデータフレームにDayNightという名前の列を追加し、その列にday/night/sunset/sunriseの値を付与したデータフレームを返します。
### 指定可能なパラメータ
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
 
# Tips

## Excelでエクスポートしたデータを使うとき
Excelでそのままcsvとして保存すると、日時の列が2017/11/3 10:05のような形式で保存されます。
その場合、以下のようにdatetime_formatを"%Y/%m/%d %H:%M"とすると実行できます。
````
res <- set_attr_day_night(df=sample_data, datetime_col_name="Datetime", datetime_format="%Y/%m/%d %H:%M", lat=45.1, lng=135.4, tz="Japan", fixed_time=FALSE)
````
また、セルの書式設定でユーザ設定を選択し、yyyy-mm-dd hh:mm:ssと指定した上でcsvとして保存するとdatetime_formatを指定せず実行できます。


