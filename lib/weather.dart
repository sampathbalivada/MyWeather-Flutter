import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class WeatherData {
  final city;
  final country;
  final minTemp;
  final maxTemp;
  final currentTemp;
  final humidity;

  WeatherData(this.city, this.country, this.currentTemp, this.minTemp,
      this.maxTemp, this.humidity);
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class WeatherPage extends StatefulWidget {
  @override
  createState() => _WeatherPage();
}

class _WeatherPage extends State<WeatherPage> {
  final appId = "e3e5732cf33a7ca9d96b0bb93d8ee0cb";
  var city = "Vishakhapatnam";
  var country = "IN";
  var hasLocation = false;

  Future<WeatherData> _refresh() async {
    Location _location = new Location();
    Map<String, double> location;

    try {
      location = await _location.getLocation();
    } on PlatformException {
      location = null;
    }

    final lat = location['latitude'];
    final lon = location['longitude'];

    http.Response response = await http.get(
      Uri.encodeFull("http://api.openweathermap.org/data/2.5/weather?lat=" +
          lat.toString() +
          "&lon=" +
          lon.toString() +
          "&APPID=" +
          appId),
    );
    var jsonData = json.decode(response.body);
    print(jsonData);
    WeatherData data = WeatherData(
        jsonData['name'],
        jsonData['sys']['country'],
        (jsonData['main']['temp'] - 273.15).toInt(),
        (jsonData['main']['temp_min'] - 273.15).toInt(),
        (jsonData['main']['temp_max'] - 273.15).toInt(),
        (jsonData['main']['humidity']));
    city = jsonData['name'];
    country = jsonData['sys']['country'];
    setState(() {
      hasLocation = true;
    });
    return data;
  }

  var background = Image.asset(
    'images/bkg-day.png',
    fit: BoxFit.fill,
    height: 1920,
    width: 1080,
  );

  var weatherCard = Container(
    child: Image.asset('images/sunny.png'),
  );

  Widget foreground() {
    return Scaffold(
      floatingActionButton: hasLocation
          ? FloatingActionButton.extended(
              backgroundColor: Colors.deepOrange,
              onPressed: () {},
              icon: Icon(IconData(0xe7f1, fontFamily: 'MaterialIcons')),
              label: Text(city + ", " + country))
          : FloatingActionButton.extended(
              onPressed: _refresh,
              icon: Icon(IconData(0xe55c, fontFamily: 'MaterialIcons')),
              label: Text('Get Location')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(IconData(0xe5d5, fontFamily: 'MaterialIcons')),
            onPressed: _refresh,
          )
        ],
        title: Text('My Weather'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: weatherCard,
          ),
          weatherDataBuilder()
        ],
      ),
    );
  }

  Widget weatherDataBuilder() {
    return FutureBuilder(
      future: _refresh(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Center(
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Center(
                  child: Text(
                    snapshot.data.currentTemp.toString() + '\u2103',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                      'Humudity: ' + snapshot.data.humidity.toString() + "%"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background,
        foreground(),
      ],
    );
  }
}
