import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static final MongoService _instance = MongoService._internal();
  factory MongoService() => _instance;
  MongoService._internal();

  late Db db;
  late DbCollection collection;

  Future<void> connect() async {
    db = await Db.create('mongodb://localhost:27017');
    await db.open();
    collection = db.collection('location');
  }

  Future<void> insertLocation(Map<String, dynamic> row) async {
    await collection.insert(row);
  }

  Future<List<Map<String, dynamic>>> queryAllLocations() async {
    return await collection.find().toList();
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final data = await collection.find().toList();
    return data;
  }

  Future<void> close() async {
    await db.close();
  }
}
