import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final databaseName = "Names.db";
  static final databaseVersion = 1;
  static final table = 'girls';
  static final columnId = 'id';
  static final columnfemaleName = 'femaleName';
  static final columnIsFavorite = 'isFavorite';
  static final columnIsWatched = 'isWatched';

  DatabaseHelper.privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, databaseName);
    return await openDatabase(path,
        version: databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table(
      $columnId INTEGER PRIMARY KEY,
      $columnfemaleName TEXT NOT NULL,
      $columnIsFavorite INTEGER NOT NULL,
      $columnIsWatched INTEGER NOT NULL
    )
    ''');
  }
  //   function inserts all girlnames into sql database named girls.db

}
//////////////////////////////////////////////////////////
///
