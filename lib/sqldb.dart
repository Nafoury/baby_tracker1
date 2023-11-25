import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialdb();
      return _db;
    } else {
      return _db;
    }
  }

  intialdb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'babytracker.db');
    Database trackerdb = await openDatabase(path,
        onCreate: _oncreate, version: 4, onUpgrade: _onUpgrade);
    return trackerdb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("Updated");
  }

  _oncreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "complete information"(
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "baby_name" TEXT NOT NULL,
      "first_name" TEXT NOT NULL,
      "gender" TEXT NOT NULL,
      "date_of_birth" INTEGER NOT NULL,
      "weight" REAL NOT NULL,
      "height" REAL NOT NULL


    )
''');
    print("create");
  }

  readData(String sql) async {
    Database? trackerdb = await db;
    List<Map> response = await trackerdb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? trackerdb = await db;
    int response = await trackerdb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? trackerdb = await db;
    int response = await trackerdb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? trackerdb = await db;
    int response = await trackerdb!.rawDelete(sql);
    return response;
  }

  deletedatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'babytracker.db');
    await deleteDatabase(path);
    _db = null;
  }
}
