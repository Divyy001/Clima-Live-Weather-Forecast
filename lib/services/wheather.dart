import 'location.dart';
import 'package:clima/screens/location_screen.dart';
import 'package:clima/services/networking.dart';
import 'package:http/http.dart' as http;

const String apiKey = '58ea825d71528b1f299d5e202f25e2d3';
double? latitude;
double? longitude;
String? cityName;
String latlonurl =
    'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
String cityUrl =
    'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityname) async {
    cityName = cityname;
    NetworkHelper networkHelper = NetworkHelper(url: cityUrl);
    var weatherData = await networkHelper.getNetworkData();
    return weatherData;
  }

  Future<dynamic> getweatheLocation() async {
    Location loc = Location();
    await loc.getCurrentLocation();
    longitude = loc.longitude;
    latitude = loc.latitude;
    NetworkHelper networkHelper = NetworkHelper(url: latlonurl);

    var weatherData = await networkHelper.getNetworkData();

    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
