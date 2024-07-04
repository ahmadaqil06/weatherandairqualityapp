import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weatherandairqualityapp/services/api_service.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ApiService apiService = ApiService();
  final TextEditingController _typeAheadController = TextEditingController();
  String city = 'Jakarta';
  Map<String, dynamic>? weatherData;
  Map<String, dynamic>? airQualityData;

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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TypeAheadField<String>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _typeAheadController,
                        decoration: InputDecoration(
                          labelText: 'Search City',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        return await apiService.fetchCitySuggestions(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        setState(() {
                          city = suggestion;
                          _typeAheadController.text = city;
                        });
                        _fetchData();
                      },
                    ),
                    SizedBox(height: 20),
                    Text('Weather in $city', style: TextStyle(fontSize: 24)),
                    Text('Temperature: ${weatherData!['main']['temp']}°C'),
                    Text('Humidity: ${weatherData!['main']['humidity']}%'),
                    SizedBox(height: 20),
                    Text('Air Quality in $city', style: TextStyle(fontSize: 24)),
                    Text('AQI: ${airQualityData!['list'][0]['main']['aqi']}'),
                    Text('PM2.5: ${airQualityData!['list'][0]['components']['pm2_5']} µg/m³'),
                  ],
                ),
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
