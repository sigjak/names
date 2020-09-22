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

  Future<List<dynamic>> insertBatch(List<String> nameStulkur) async {
    Database db = await instance.database;
    Batch batch = db.batch();

    nameStulkur.forEach((name) {
      batch.insert(table, {
        'femaleName': name,
        'isFavorite': 0,
        'isWatched': 0,
      });
    });
    return await batch.commit();
  }

// Check if database exists
  Future<bool> databaseExists() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, databaseName);
    return databaseFactory.databaseExists(path);
  }

// query girls database and retrun girlnames as list of strings
  Future<List<String>> queryGirls() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> fm = [];
    List<String> temp = [];

    fm = await db
        .rawQuery('SELECT femaleName FROM $table Where isWatched = ?', [0]);
    fm.forEach((element) {
      temp.add(element['femaleName']);
    });
    return temp;
  }

  // mark a single girl name in database-table girls as watched
  Future<void> markNameAsWatched(String name) async {
    Database db = await instance.database;
    await db.update('girls', {'isWatched': 1},
        where: 'femaleName = ?', whereArgs: [name]);
  }

// unfavorite name in favorites
  Future<void> markNameNotFavorite(String name) async {
    Database db = await instance.database;
    await db.update('girls', {'isFavorite': 0},
        where: 'femaleName = ?', whereArgs: [name]);
  }

// mark a single girl name in database-table girls as watched and favorite
  Future<void> markNameAsFavoriteAndWatched(String name) async {
    Database db = await instance.database;
    await db.update('girls', {'isWatched': 1, 'isFavorite': 1},
        where: 'femaleName = ?', whereArgs: [name]);
  }

  // get all girl names in database-table marked as variable (isWatched, isFavorite)
  Future<List<String>> getIsGirls(String isSthg) async {
    List<Map<String, dynamic>> temp = [];
    List<String> girlyNames = [];
    Database db = await instance.database;
    temp = await db.rawQuery('SELECT * FROM $table WHERE $isSthg = ?', [1]);
    temp.forEach((element) {
      girlyNames.add(element['femaleName']);
    });
    return girlyNames;
  }

  Future<int> tableEmpty() async {
    List<Map<String, dynamic>> ll = [];
    List<String> tr = [];
    Database db = await instance.database;
    ll = await db.query(table, columns: ['femaleName']);
    ll.forEach((element) {
      tr.add(element['femaleName']);
    });
    return tr.length;
  }

// reset all values to original state
  Future<String> resetTable() async {
    Database db = await instance.database;
    await db.update(table, {'isFavorite': 0, 'isWatched': 0});
    return ('watched and favorite reset');
  }
}
