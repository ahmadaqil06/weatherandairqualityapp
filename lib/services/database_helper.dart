import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE locations(id INTEGER PRIMARY KEY, name TEXT, latitude REAL, longitude REAL)",
    );
  }

  Future<int> insertLocation(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('locations', row);
  }

  Future<List<Map<String, dynamic>>> queryAllLocations() async {
    Database db = await database;
    return await db.query('locations');
  }
}
