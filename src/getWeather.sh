
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

case $ans in
A) echo "The sum of $a and $b is $x & exit" ;;
2) echo "The subtraction of $a and $b is $y & exit" ;;
3) echo "The multiplication of $a and $b is $z & exit" ;;
*) echo "Invalid entry"
esac

getWeatherStatusFromLetters () {
  case $1 in
    A) echo "☀️Açık";;
    AB) echo "🌤Az";;
    PB) echo "⛅️Parçalı";;
    CB) echo "☁️Çok";;
    HY) echo "🌦Hafif";;
    Y) echo "🌧Yağmurlu";;
    KY) echo "🌧Kuvvetli";;
    KKY) echo "🌨Karla";;
    HKY) echo "🌨Hafif";;
    K) echo "❄️Kar";;
    YKY) echo "🌨Yoğun";;
    HSY) echo "🌦Hafif";;
    SY) echo "🌧Sağanak";;
    KSY) echo "🌧Kuvvetli";;
    MSY) echo "🌧Mevzi";;
    DY) echo "🌨Dolu";;
    GSY) echo "⛈Gökgürültülü";;
    KGY) echo "⛈Kuvvetli";;
    SIS) echo "🌫Sisli";;
    PUS) echo "🌫Puslu";;
    DMN) echo "🌫Dumanlı";;
    KF) echo "🌫Kum";;
    R) echo "💨Rüzgarlı";;
    GKR) echo "💨Güneyli";;
    KKR) echo "💨Kuzeyli";;
    SCK) echo "🥵Sıcak";;
    SGK) echo "🥶Soğuk";;
    HHY) echo "🌧Yağışlı";;
    *) echo Bilinmiyor;;
  esac
}

getCity "istanbul"> city.json
istNo=$(getIstNo city.json)
getDailyWeatherForecast "$istNo" > forecast.json
getTahminArray forecast.json > tahmin.json
hourCount=$(getHourCountFromTahmin tahmin.json)
tahmin=$(cat tahmin.json)
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