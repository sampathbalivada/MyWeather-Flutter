import 'package:flutter/material.dart';
import 'package:myweather/weather.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WeatherPage(),
      ),
      routes: <String, WidgetBuilder> {
        '/weather' : (BuildContext context) => new WeatherPage(),
      },
    );
  }
}