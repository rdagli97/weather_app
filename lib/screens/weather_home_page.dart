import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _cityController = TextEditingController();

  final WeatherService _weatherService = WeatherService();

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
      final weather = _weather!;
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weather.cityName,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${weather.temperature.round()}°C',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.thermostat),
                      Text('Feels like'),
                      Text('${weather.feelsLike.round()}°C'),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.water_drop),
                      Text('Humidity'),
                      Text('${weather.humidity}%'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return const Text("Press the button to fetch weather");
  }

  Future<void> _fetchWeather() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _weather = null;
    });

    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });

    } catch (e) {
      setState(() {
        _errorMessage = 'Could not fetch weather. Check the city name or your connection.';
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
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Enter a city name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                onSubmitted: (_) => _fetchWeather(),
              ),
              const SizedBox(height: 16),
              // Fetch Weather Button
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