import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class GetWeatherData {
  final appId = "e3e5732cf33a7ca9d96b0bb93d8ee0cb";
  var city = "Vishakhapatnam";
  var country = "IN";
  var minTemp = 0, maxTemp = 0, currentTemp = 0;

  Future<GetWeatherData> refresh() async {
    http.Response response = await http.get(
      Uri.encodeFull("http://api.openweathermap.org/data/2.5/weather?q=" +
          city +
          "," +
          country +
          "&APPID=" +
          appId),
    );
    var data = json.decode(response.body);
    currentTemp = (data['main']['temp'] - 273.15).toInt();
    minTemp = (data['main']['temp_min'] - 273.15).toInt();
    maxTemp = (data['main']['temp_max'] - 273.15).toInt();
    return this;
  }
}
