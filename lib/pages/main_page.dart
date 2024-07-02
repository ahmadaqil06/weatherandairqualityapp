import 'package:flutter/material.dart';
import 'package:weatherandairqualityapp/services/api_service.dart';
import 'package:weatherandairqualityapp/model/air_quality_data.dart';
import 'package:weatherandairqualityapp/model/weather_data.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ApiService apiService = ApiService();
  String city = 'Jakarta';
  late Map<String, dynamic> weatherData;
  late Map<String, dynamic> airQualityData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final weather = await apiService.fetchWeatherData(city);
      final airQuality = await apiService.fetchAirQualityData(city);
      setState(() {
        weatherData = weather;
        airQualityData = airQuality;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather and Air Quality Monitor')),
      body: weatherData == null || airQualityData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Text('Weather in $city', style: TextStyle(fontSize: 24)),
                  Text('Temperature: ${weatherData['main']['temp']}°C'),
                  Text('Humidity: ${weatherData['main']['humidity']}%'),
                  SizedBox(height: 20),
                  Text('Air Quality in $city', style: TextStyle(fontSize: 24)),
                  Text('AQI: ${airQualityData['list'][0]['main']['aqi']}'),
                  Text('PM2.5: ${airQualityData['list'][0]['components']['pm2_5']} µg/m³'),
                ],
              ),
            ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              title: Text('Locations'),
              onTap: () {
                Navigator.pushNamed(context, '/locations');
              },
            ),
          ],
        ),
      ),
    );
  }
}
