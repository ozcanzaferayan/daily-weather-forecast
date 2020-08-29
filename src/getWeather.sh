
getCity () {
  curl -H "Origin:https://mgm.gov.tr" https://servis.mgm.gov.tr/web/merkezler?il=$1
}

getIstNo () {
  cat "$1" |jq -r '.[] | .saatlikTahminIstNo'
}

getDailyWeatherForecast () {
  curl -H "Origin:https://mgm.gov.tr" https://servis.mgm.gov.tr/web/tahminler/saatlik\?istno\=$1
}

getTahminArray () {
  cat "$1" |jq -r '.[] | .tahmin'
}

getHourCountFromTahmin () {
  cat "$1" |jq -r 'length'
}

getWeatherStatusFromLetters () {
  case $1 in
    A) echo "☀️Açık";;
    AB) echo "🌤Az Bulutlu";;
    PB) echo "⛅️Parçalı Bulutlu";;
    CB) echo "☁️Çok Bulutlu";;
    HY) echo "🌦Hafif Yağmurlu";;
    Y) echo "🌧Yağmurlu";;
    KY) echo "🌧Kuvvetli Yağmurlu";;
    KKY) echo "🌨Karla Karışık Yağmurlu";;
    HKY) echo "🌨Hafif Kar Yağışlı";;
    K) echo "❄️Kar Yağışlı";;
    YKY) echo "🌨Yoğun Kar Yağışlı";;
    HSY) echo "🌦Hafif Sağanak Yağışlı";;
    SY) echo "🌧Sağanak Yağışlı";;
    KSY) echo "🌧Kuvvetli Sağanak Yağışlı";;
    MSY) echo "🌧Mevzi Sağanak Yağışlı";;
    DY) echo "🌨Dolu";;
    GSY) echo "⛈Gökgürültülü Sağanak Yağışlı";;
    KGY) echo "⛈Kuvvetli Gökgürültülü Sağanak Yağışlı";;
    SIS) echo "🌫Sisli";;
    PUS) echo "🌫Puslu";;
    DMN) echo "🌫Dumanlı";;
    KF) echo "🌫Kum veya Toz Taşınımı";;
    R) echo "💨Rüzgarlı";;
    GKR) echo "💨Güneyli Kuvvetli Rüzgar";;
    KKR) echo "💨Kuzeyli Kuvvetli Rüzgar";;
    SCK) echo "🥵Sıcak";;
    SGK) echo "🥶Soğuk";;
    HHY) echo "🌧Yağışlı";;
    *) echo Bilinmiyor;;
  esac
}

getCity $CITY > city.json
istNo=$(getIstNo city.json)
getDailyWeatherForecast "$istNo" > forecast.json
getTahminArray forecast.json > tahmin.json
hourCount=$(getHourCountFromTahmin tahmin.json)
tahmin=$(cat tahmin.json)
echo "_\n$CITY Hava durumu" >> sms.txt
for ((i=1; i<$hourCount; i++))
do
  read -a arr < <(echo $(echo $tahmin | jq -r --arg i $i '.[$i|tonumber] | .tarih, .hadise, .sicaklik'))
  date=${arr[0]}
  weatherLetters=${arr[1]}
  temp=${arr[2]}
  hour=$(date --date="$date" +%R)
  weatherText=$(getWeatherStatusFromLetters $weatherLetters)
  echo $hour $temp"ºC" $weatherText >> sms.txt
done