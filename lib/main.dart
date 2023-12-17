import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'secrets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController _cityController = TextEditingController();
  String _weatherData = '';

  Future<void> _fetchWeather(String city) async {
    final apiKey = Secrets.openWeatherMapApiKey;
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _weatherData = 'Temperature: ${data['main']['temp']}°C\n'
            'Description: ${data['weather'][0]['description']}';
      });
    } else {
      setState(() {
        _weatherData = 'Error fetching weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Enter city'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _fetchWeather(_cityController.text),
              child: Text('Get Weather'),
            ),
            SizedBox(height: 16),
            Text(_weatherData),
          ],
        ),
      ),
    );
  }
}
