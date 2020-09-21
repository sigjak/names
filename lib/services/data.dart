import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:more_names/services/database_helper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import './database_helper.dart';
//import 'package:sqflite/sqflite.dart';
import 'dart:convert';
//import '../models/name_model.dart';

class Data with ChangeNotifier {
  List<String> _names = [];

  Future<List<String>> getNames() async {
    List<String> names = [];
    List<String> trimmedNames = [];
    await rootBundle.loadString('assets/stulkurSmall.txt').then((q) => {
          for (String i in LineSplitter().convert(q)) {names.add(i)}
        });
    names.forEach((name) {
      trimmedNames.add(name.trim());
    });
    _names = trimmedNames;

    return trimmedNames;
  }

  Future<void> pop({bool animated}) async {
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
  }
}
