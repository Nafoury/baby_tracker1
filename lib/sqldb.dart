import 'package:baby_tracker/common_widgets/linkapi.dart';
import 'package:baby_tracker/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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
        onCreate: _oncreate, version: 6, onUpgrade: _onUpgrade);
    return trackerdb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("Updated");
  }

  void getDatabasePath() async {
    String databasePath = await getDatabasesPath();
    String fullPath = '$databasePath/babytracker.db';
    print('Database Path: $fullPath');
  }

  Future<void> exportDatabase() async {
    try {
      // Get the path to the app's internal database file
      String databasePath = await getDatabasesPath();
      String path = '$databasePath/babytracker.db';

      // Check if the database file exists
      bool fileExists = await File(path).exists();
      if (fileExists) {
        // Get the external storage directory
        Directory? externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          String exportPath = '${externalDir.path}/babytracker.db';

          // Copy the database file to the external storage
          await File(path).copy(exportPath);
          print('Database exported to: $exportPath');
        } else {
          print('External storage directory not found');
        }
      } else {
        print('Database file not found');
      }
    } catch (e) {
      print('Error exporting database: $e');
    }
  }

  _oncreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "complete_information"(
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "baby_name" TEXT NOT NULL,
      "first_name" TEXT NOT NULL,
      "gender" TEXT NOT NULL,
      "date_of_birth" TEXT NOT NULL,
      "weight" REAL NOT NULL,
      "height" REAL NOT NULL


    )
''');
    await db.execute('''
    CREATE TABLE "user_authorization"(
      "userid" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "useremail" TEXT NOT NULL,
      "userpassword" TEXT NOT NULL
    )
''');

    print("Table is done");
  }

  Future<List<Map<String, dynamic>>> readData(
      String table, Map<String, dynamic> conditions) async {
    Database? trackerdb = await db;

    List<String> whereConditions = [];
    List<dynamic> whereValues = [];

    conditions.forEach((key, value) {
      whereConditions.add('$key = ?');
      whereValues.add(value);
    });

    String whereClause = whereConditions.join(" AND ");

    List<Map<String, dynamic>> response = await trackerdb!.query(
      table,
      where: whereClause,
      whereArgs: whereValues,
    );

    return response;
  }

  Future<int> insertData(String table, Map<String, dynamic> data) async {
    Database? trackerdb = await db;
    int response = await trackerdb!.insert(table, data);
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
  }
}
