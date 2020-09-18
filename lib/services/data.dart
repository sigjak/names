import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../models/name_model.dart';

class Data with ChangeNotifier {
  List<String> _names = [];
  List<Name> nameObjects = [];
  List<String> favorites = [];
  List<String> testNames = [];

  Future<List<String>> getNames() async {
    print('in getnames');
    List<String> names = [];
    nameObjects = [];
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

  Future<void> addData() async {
    await FirebaseFirestore.instance
        .collection('names')
        .get()
        .then((QuerySnapshot querySnapShot) {
      querySnapShot.docs.forEach((doc) {
        testNames.add(doc.get('femaleName'));
      });
    });
    print('done');
    // for (var i = 2000; i < 2229; i++) {
    //   childrenNames.add({
    //     'id': nameObjects[i].id,
    //     'femaleName': nameObjects[i].femaleName,
    //     'isFavorite': nameObjects[i].isFavorite,
    //     'isWatched': nameObjects[i].isWatched,
    //     'createdAt': nameObjects[i].createdAt,
    //   });
    // }
    // nameObjects.forEach((element) {
    //   return childrenNames.add({
    //     'id': element.id,
    //     'femaleName': element.femaleName,
    //     'isFavorite': element.isFavorite,
    //     'isWatched': element.isWatched,
    //     'createdAt': element.createdAt,
    //   });
    // });
  }

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
    print(nameObjects.length);
    for (var i = 0; i < nameObjects.length; i++) {
      if (nameObjects[i].isFavorite == true) {
        print(nameObjects[i].femaleName);
      }
    }
  }
}
