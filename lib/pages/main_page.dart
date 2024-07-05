import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherandairqualityapp/services/api_service.dart';
import 'package:weatherandairqualityapp/services/database_helper.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ApiService apiService = ApiService();
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController _cityController = TextEditingController();
  String city = 'Jakarta';
  Map<String, dynamic>? weatherData;
  List<dynamic>? airQualityData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final weather = await apiService.fetchWeatherData(city);
      final lat = weather['coord']['lat'];
      final lon = weather['coord']['lon'];
      final airQuality = await apiService.fetchAirQualityData(lat, lon);
      setState(() {
        weatherData = weather;
        airQualityData = airQuality['list'];
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _addLocation() async {
    await dbHelper.insertLocation({
      'name': city,
      'latitude': weatherData!['coord']['lat'],
      'longitude': weatherData!['coord']['lon'],
    });
  }

  Future<void> _updateLocation(int id) async {
    await dbHelper.updateLocation(id, {
      'name': city,
      'latitude': weatherData!['coord']['lat'],
      'longitude': weatherData!['coord']['lon'],
    });
  }

  Future<void> _deleteLocation(int id) async {
    await dbHelper.deleteLocation(id);
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
                    TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'Enter City',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              city = _cityController.text;
                            });
                            _fetchData();
                          },
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Weather in $city', style: TextStyle(fontSize: 24)),
                    Text('Temperature: ${weatherData!['main']['temp']}°C'),
                    Text('Humidity: ${weatherData!['main']['humidity']}%'),
                    SizedBox(height: 20),
                    Text('Air Quality in $city',
                        style: TextStyle(fontSize: 24)),
                    Text('AQI: ${airQualityData![0]['main']['aqi']}'),
                    Text(
                        'PM2.5: ${airQualityData![0]['components']['pm2_5']} µg/m³'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addLocation,
                      child: Text('Add Location'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Provide the ID of the location you want to update
                        await _updateLocation(1); // Replace with the correct ID
                      },
                      child: Text('Update Location'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Provide the ID of the location you want to delete
                        await _deleteLocation(1); // Replace with the correct ID
                      },
                      child: Text('Delete Location'),
                    ),
                    SizedBox(height: 20),
                    AirQualityDashboard(airQualityData: airQualityData!),
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

class AirQualityDashboard extends StatelessWidget {
  final List<dynamic> airQualityData;

  const AirQualityDashboard({Key? key, required this.airQualityData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'The RBS - AirVisual Outdoor',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Jakarta, Indonesia',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        // Air Quality Card
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Air Quality Icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: const Icon(Icons.masks, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    '166',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'AQI US',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Air Quality Status
              Text(
                'Tidak sehat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
              ),
              const SizedBox(height: 8),
              // PM2.5 Level
              Row(
                children: [
                  const Icon(Icons.air_rounded),
                  const SizedBox(width: 8),
                  Text(
                    'PM2.5 77.0 μg/m³',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Weather Information
              Row(
                children: [
                  const Icon(Icons.sunny),
                  const SizedBox(width: 8),
                  const Text('33°'),
                  const SizedBox(width: 32),
                  const Icon(Icons.arrow_forward),
                  const SizedBox(width: 8),
                  const Text('14,8 km/h'),
                ],
              ),
              const SizedBox(height: 8),
              // Humidity
              Row(
                children: [
                  const Icon(Icons.water_drop),
                  const SizedBox(width: 8),
                  const Text('94%'),
                ],
              ),
              const SizedBox(height: 16),
              // Station Information
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Stasiun dioperasikan oleh The RBS'),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Hourly Forecast
        const Text(
          'Perkiraan 7-Hari',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Hourly Forecast Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Selasa'),
                  const Text('Rabu'),
                  const Text('Kamis'),
                ],
              ),
              const SizedBox(height: 16),
              // Hourly Forecast Grid
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: airQualityData.length,
                  itemBuilder: (context, index) {
                    final data = airQualityData[index];
                    final timeString = DateFormat('HH:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000));
                    final aqi = data['main']['aqi'];
                    final pm25 = data['components']['pm2_5'];
                    final temp = data['main']['temp'];
                    final windSpeed = data['wind']['speed'];

                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(timeString),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$aqi',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.air),
                            ],
                          ),
                          Text('$temp°'),
                          Text(
                            '$windSpeed km/h',
                            style: const TextStyle(fontSize: 10),
                          ),
                          Text(
                            '$pm25 μg/m³',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Add Location Button
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 32,
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Tambahkan tempat'),
        ),
        const SizedBox(height: 8),
        // Manage Location Button
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 32,
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Kelola'),
        ),
      ],
    );
  }
}
