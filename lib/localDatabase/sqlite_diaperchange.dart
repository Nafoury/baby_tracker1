import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:baby_tracker/models/diaperData.dart';

class DiaperDatabase {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initalDb();
      return _db;
    } else {
      return _db;
    }
  }

  initalDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'babyrecords.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newverion) {}

  _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE "diaper_records"(
"change_id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
"start_date" TEXT NOT NULL, 
"status" TEXT NOT NULL,
"note" TEXT NOT NULL,
"infoid" TEXT NOT NULL
)
''');
    print("create===");
  }

  Future<List<DiaperData>> loadLocalData() async {
    try {
      Database? mydb = await db;

      final List<Map<String, dynamic>> records =
          await mydb!.query('diaper_records');

      return records.map((record) => DiaperData.fromMap(record)).toList();
    } catch (e) {
      print('Error loading local data: $e');
      return [];
    }
  }

  Future<void> saveToLocalData(DiaperData diaperData) async {
    try {
      Database? mydb = await db;
      await mydb!.insert(
        'diaper_records',
        diaperData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error saving to local database: $e');
    }
  }

  Future<void> saveApiDataToLocal(List<DiaperData> apiData) async {
    // Clear existing local data
    await clearLocalData();

    // Save the new API data to the local database
    for (DiaperData data in apiData) {
      await saveToLocalData(data);
    }
  }

  Future<void> clearLocalData() async {
    Database? mydb = await db;
    await mydb?.delete('diaper_records');
  }
}
