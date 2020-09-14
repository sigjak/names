import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/name_model.dart';

class Data with ChangeNotifier {
  List<String> _names = [];
  List<Name> nameObjects = [];
  List<String> favorites = [];

  Future<List<String>> getNames() async {
    List<String> names = [];
    await rootBundle.loadString('assets/Stulkur.txt').then((q) => {
          for (String i in LineSplitter().convert(q)) {names.add(i)}
        });
    _names = names;

    names.asMap().forEach((i, name) {
      nameObjects.add(Name(
          id: i,
          femaleName: name,
          isFavorite: false,
          isWatched: false,
          createdAt: DateTime.now()));
    });
    //nameObjects = List.from(myNames);
    return names;
  }

  // List<String> get names {

  //   return [..._names];
  // }

  void addAsFavoriteAndWatched(String name) {
    favorites.add(name);
    var result =
        nameObjects.indexWhere((element) => (element.femaleName == name));
    nameObjects[result].isFavorite = true;
    nameObjects[result].isWatched = true;
  }

  void addAsWatched(String name) {
    var result =
        nameObjects.indexWhere((element) => (element.femaleName == name));
    nameObjects[result].isWatched = true;
  }

  void unFavorite(String name) {
    var result =
        nameObjects.indexWhere((element) => (element.femaleName == name));
    nameObjects[result].isFavorite = false;
  }

  List<String> allFavorites() {
    favorites = [];
    nameObjects.forEach((element) {
      if (element.isFavorite) {
        favorites.add(element.femaleName);
      }
    });
    return favorites;
  }

  void test() {
    for (var i = 0; i < nameObjects.length; i++) {
      if (nameObjects[i].isFavorite == true) {
        print(nameObjects[i].femaleName);
      }
    }
  }
}
