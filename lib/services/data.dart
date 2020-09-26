import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import './database_helper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'dart:convert';

class Data with ChangeNotifier {
  List<String> names = [];
  List<String> onlyNames = [];
  List<String> favorites = [];
  // List<Map<String, dynamic>> clonedNamesMap = [];

  /////////////////////////

  Future<void> createDb() async {
    await rootBundle.loadString('assets/Stulkur_small.txt').then((q) => {
          for (String i in LineSplitter().convert(q)) {names.add(i)}
        });

    names.forEach((name) {
      onlyNames.add(name.trim());
    });
    onlyNames.shuffle();
    notifyListeners();
    Database db = await DatabaseHelper.instance.database;
    Batch batch = db.batch();
    onlyNames.forEach((name) {
      batch.insert(DatabaseHelper.table, {
        'femaleName': name,
        'isFavorite': 0,
        'isWatched': 0,
      });
    });

    await batch.commit();
  }

  Future<List<String>> queryAllNamesFromDb() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> femaleMap = [];
    List<String> temp = [];
    femaleMap =
        await db.rawQuery('Select femaleName from ${DatabaseHelper.table}');
    femaleMap.forEach((element) {
      temp.add(element['femaleName']);
    });
    return temp;
  }

  Future addToOnlyListAndDb() async {
    Database db = await DatabaseHelper.instance.database;
    await db.insert('${DatabaseHelper.table}',
        {'femaleName': 'sig', 'isFavorite': 0, 'isWatched': 0});
    onlyNames.add('sig');
    notifyListeners();
  }

  Future<bool> checkIfDbCreated() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DatabaseHelper.databaseName);
    return databaseFactory.databaseExists(path);
  }

// populate onlyNames  from database where by unwatched names
  Future<void> loadUnwatchedNamesFromDatabase() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> temp = [];
    onlyNames = [];
    temp = await db
        .rawQuery('Select femaleName from "girls" where isWatched = ?', [0]);
    temp.forEach((item) {
      onlyNames.add(item['femaleName']);
    });
    onlyNames.shuffle();
    notifyListeners();
  }

  Future<void> markasFavAndWatched(String name) async {
    Database db = await DatabaseHelper.instance.database;
    await db.update("girls", {'isFavorite': 1, 'isWatched': 1},
        where: 'femaleName = ?', whereArgs: [name]);
  }

  Future<void> markasWatched(String name) async {
    Database db = await DatabaseHelper.instance.database;
    await db.update("girls", {'isWatched': 1},
        where: 'femaleName = ?', whereArgs: [name]);
  }

  Future<void> unFavorite(String name) async {
    Database db = await DatabaseHelper.instance.database;
    await db.update("girls", {'isFavorite': 0},
        where: 'femaleName = ?', whereArgs: [name]);
  }

  Future<List<String>> loadAllFavorites() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> temp = [];
    favorites = [];
    temp = await db
        .rawQuery('select femaleName from "girls" where isFavorite = ?', [1]);
    temp.forEach((element) {
      favorites.add(element['femaleName']);
    });
    // notifyListeners();
    return favorites;
  }

  Future<List<String>> getWatchedNames() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> temp = [];
    List<String> watch = [];
    temp = await db
        .rawQuery('select femaleName from "girls" where isWatched = ?', [1]);
    temp.forEach((element) {
      watch.add(element['femaleName']);
    });
    return watch;
  }

  Future<void> unWatch() async {
    Database db = await DatabaseHelper.instance.database;
    await db.update("girls", {'isWatched': 0});
    await loadUnwatchedNamesFromDatabase();
  }

  Future<void> reset(context) async {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "RFLUTTER ALERT",
      desc: "Flutter is more awesome with RFlutter Alert.",
      buttons: [
        DialogButton(
          child: Text(
            "Unwatch",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
            await unWatch();
            Navigator.pop(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();
  }
}
