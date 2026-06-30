import 'dart:convert';

import 'package:weather_app/models/weather.dart';
import 'package:weather_app/secrets.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeather(String city) async {
    final url = Uri.parse('$_baseUrl?q=$city&appid=$openWeatherApiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('City not found');
    } else {
      throw Exception('Failed to load weather (code ${response.statusCode})');
    }
  }
}