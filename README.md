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
デフォルトで日の出の時刻の前後15分がsunrise、日の入りの時刻の前後15分がsunsetの属性のが付与されます。
また、時刻データのデフォルトのフォーマットは%Y-%m-%d %H:%M:%Sとしています。
自分の要件やデータに合わせて適宜変更してください。
````
require(rSetDayNightAttr)
# デフォルトの値でデータの処理を実行する場合
res <- set_attr_day_night(df=sample_data, datetime_col_name=Datetime, lat=45.1, lng=135.4, tz="Japan")
# 処理したデータの確認
head(res, 100)
````

## Reference

### set_attr_day_night
