import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  String _result = 'Press the button to fetch weather';
  bool _isLoading = false;

  Future<void> _fetchWeather() async {

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=Belgrade&appid=$openWeatherApiKey&units=metric');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _result = response.body;
        });
      } else {
        setState(() {
          _result = 'Error: City not found (code ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Failed to connect. Check your internet connection';
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
              _isLoading
              ? const CircularProgressIndicator()
              : Text(_result)
            ],
          ),
        ),
      ),
    );
  }
}
