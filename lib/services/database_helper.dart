import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<void> initDatabase() async {
    _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE locations(id INTEGER PRIMARY KEY, name TEXT, latitude REAL, longitude REAL)",
    );
  }

  Future<void> insertLocation(Map<String, dynamic> row) async {
    final db = _database;
    if (db == null) return;
    await db.insert('locations', row);
  }

  Future<List<Map<String, dynamic>>> queryAllLocations() async {
    final db = _database;
    if (db == null) return [];
    return await db.query('locations');
  }

  Future<void> updateLocation(int id, Map<String, dynamic> row) async {
    final db = _database;
    if (db == null) return;
    await db.update('locations', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteLocation(int id) async {
    final db = _database;
    if (db == null) return;
    await db.delete('locations', where: 'id = ?', whereArgs: [id]);
  }
}
