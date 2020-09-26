import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../services/database_helper.dart';

class Data with ChangeNotifier {
  //List<String> _names = [];
  //int unWatched;

  Future<List<String>> getNames() async {
    List<String> names = [];
    List<String> trimmedNames = [];
    await rootBundle.loadString('assets/Stulkur_small.txt').then((q) => {
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

  Future<int> getInfo(String isSthg) async {
    List<String> temp = await DatabaseHelper.instance.getIsGirls(isSthg);
    return temp.length;
  }

  Future<int> getUnwatchedGirls() async {
    List<String> temp = await DatabaseHelper.instance.queryUnwatchedGirls();
    return (temp.length);
  }

  Future<void> myAlert(context) async {
    int left = await getUnwatchedGirls();
    int favs = await getInfo('isFavorite');
    int watched = await getInfo('isWatched');
    Alert(
      context: context,
      type: AlertType.info,
      title: "",
      content: Column(
        children: [
          Text('Eftir eru $left nöfn.'),
          Text('$watched nöfn hafa verið skoðuð'),
          Text('og $favs eru í lista yfir valin nöfn.'),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            'CLOSE',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
}
