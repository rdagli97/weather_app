import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/secrets.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: WeatherHomePage()
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  Widget _buildContext() {
    if(_isLoading) {
      return const CircularProgressIndicator();
    }

    if (_errorMessage != null) {
      return Text(_errorMessage!);
    }

    if (_weather != null) {
      return Column(
        children: [
          Text(_weather!.cityName),
          Text('${_weather!.temperature}°C'),
          Text('Feels like ${_weather!.feelsLike}°C'),
          Text(_weather!.description),
          Text('Humidity: ${_weather!.humidity}%'),
        ],
      );
    }

    return const Text("Press the button to fetch weather");
  }

  Future<void> _fetchWeather() async {

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=Belgrade&appid=$openWeatherApiKey&units=metric');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _weather = Weather.fromJson(data);
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = 'Error: City not found (code ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to connect. Check your internet connection';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _fetchWeather,
                child: const Text('Fetch Weather'),
              ),
              const SizedBox(height: 20),
              _buildContext(),
            ],
          ),
        ),
      ),
    );
  }
}
