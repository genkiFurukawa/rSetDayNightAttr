# rSetDayNightAttr

### 時系列データにday/night/sunset/sunriseの属性を付与するパッケージです。緯度と経度とタイムゾーンを指定することで、日別で日の出と日の入りを計算し、day/night/sunset/sunriseの属性を付与します。

# Installation

```` 
install.packages("devtools")
install.packages("suncalc")
devtools::install_github("genkiFurukawa/rSetDayNightAttr")
````

# Use

````
require(rSetDayNightAttr)
set_attr_day_night(df1, Datetime, 45.1 ,135.4, "Japan")
````

## Reference

### set_attr_day_night
