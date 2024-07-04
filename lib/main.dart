import 'package:flutter/material.dart';
import 'package:weatherandairqualityapp/pages/main_page.dart';
import 'package:weatherandairqualityapp/pages/settings_page.dart';
import 'package:weatherandairqualityapp/pages/camera_page.dart';
import 'package:weatherandairqualityapp/pages/location_list_page.dart';
import 'package:weatherandairqualityapp/services/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoService().connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather and Air Quality Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/settings': (context) => SettingsPage(),
        '/camera': (context) => CameraPage(),
        '/locations': (context) => LocationListPage(),
      },
    );
  }
}
