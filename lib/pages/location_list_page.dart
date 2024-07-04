import 'package:flutter/material.dart';
import 'package:weatherandairqualityapp/services/api_service.dart';
import 'package:weatherandairqualityapp/services/database_helper.dart';

class LocationListPage extends StatefulWidget {
  @override
  _LocationListPageState createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  final MongoService dbHelper = MongoService();
  List<Map<String, dynamic>> _locations = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    final locations = await dbHelper.queryAllLocations();
    setState(() {
      _locations = locations;
    });
  }

  Future<void> _addLocation() async {
    final newLocation = {
      'name': 'New Location',
      'latitude': 0.0,
      'longitude': 0.0,
    };
    await dbHelper.insertLocation(newLocation);
    _fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Locations')),
      body: ListView.builder(
        itemCount: _locations.length,
        itemBuilder: (context, index) {
          final location = _locations[index];
          return ListTile(
            title: Text(location['name']),
            subtitle: Text('Lat: ${location['latitude']}, Lon: ${location['longitude']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLocation,
        child: Icon(Icons.add),
      ),
    );
  }
}
