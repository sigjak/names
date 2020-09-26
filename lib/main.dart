import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './services/data.dart';
import './screens/my_list.dart';

import 'screens/select_names.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          buttonColor: Colors.brown[400],
          fontFamily: 'Raleway',
          primarySwatch: Colors.brown,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SelectNames(),
        routes: {
          // MyList.routeName: (context) => MyList(),
        },
      ),
    );
  }
}
