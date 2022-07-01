import 'package:flutter/material.dart';
import 'package:clima/constants.dart';
import 'loading_screen.dart';
import 'package:clima/services/wheather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  final dynamic currentWheather;
  LocationScreen({this.currentWheather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int? temprature;
  String? tempText;
  String? weatherIcon;
  String? cityName;

  WeatherModel weatherModel = WeatherModel();

  @override
  void initState() {
    super.initState();

    updateUI(widget.currentWheather);
  }

  void updateUI(weatherData) {
    setState(() {
      if (weatherData == null) {
        temprature = 0;
        tempText = 'Unable to get weather';
        weatherIcon = 'Error';
        cityName = ' ';
        return;
      }
      double temp = weatherData['main']['temp'];
      temprature = temp.toInt();
      tempText = weatherModel.getMessage(temprature!);
      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      cityName = weatherData['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weatherModel.getweatheLocation();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedcity = await Navigator.push(
                        this.context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (typedcity != null) {
                        var weatherData =
                            await weatherModel.getCityWeather(typedcity);
                        updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temprature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon!,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$tempText in $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
