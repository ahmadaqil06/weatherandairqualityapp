import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String apiKey = '826b28ddbf6d91c83bb317ce07c5ac17';

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> fetchAirQualityData(String city) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/air_pollution?q=$city&appid=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load air quality data');
    }
  }

  Future<List<String>> fetchCitySuggestions(String query) async {
    // Replace with your actual API call to fetch city suggestions
    // Here we use a simple hardcoded list for demonstration
    List<String> cities = [
      'Jakarta',
      'Surabaya',
      'Bandung',
      'Medan',
      'Semarang',
      'Palembang',
      'Makassar',
      'Batam',
      'Pekanbaru',
      'Bogor'
    ];

    return cities.where((city) => city.toLowerCase().startsWith(query.toLowerCase())).toList();
  }
}
