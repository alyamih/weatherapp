import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


fetchWeatherData(Client client, double lat, double lon) async {
  final resp = await client.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&exclude=minutely,alerts&appid=a9ac1745bc8669b6800d1f8c1b49063f'));
  final respFromJson = jsonDecode(resp.body);
  // log(respFromJson[0].toString(), name: 'respFromJson');
  // log(respFromJson.toString(), name: 'fetchWeatherData');
  return respFromJson;
}

class Weather {
  var temp = 0;
  var pressure = 0.0;
  var humidity = 0.0;
  var wind = 0.0;
  var dt = 0;
  var weatherType = 0;

  Weather({required this.temp, required this.pressure, required this.humidity, required this.wind, required this.dt, required this.weatherType});



  factory Weather.fromJSON(Map<String, dynamic> json) {
    // log(json.toString());
    return Weather(temp: json['temp'].round(), pressure: json['pressure'].toDouble(),
        humidity: json['humidity'].toDouble(), weatherType: json['weather'][0]['id'], dt: json['dt'], wind: json['wind_speed'].toDouble());
  }

}


