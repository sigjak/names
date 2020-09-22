import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class Data with ChangeNotifier {
  //List<String> _names = [];

  Future<List<String>> getNames() async {
    List<String> names = [];
    List<String> trimmedNames = [];
    await rootBundle.loadString('assets/Stulkur.txt').then((q) => {
          for (String i in LineSplitter().convert(q)) {names.add(i)}
        });
    names.forEach((name) {
      trimmedNames.add(name.trim());
    });
    //_names = trimmedNames;

    return trimmedNames;
  }

  Future<void> pop({bool animated}) async {
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', animated);
  }
}
