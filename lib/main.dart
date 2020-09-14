import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './services/data.dart';
import './screens/my_list.dart';

import './screens/dismiss_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Dismiss(),
        routes: {
          MyList.routeName: (context) => MyList(),
        },
      ),
    );
  }
}
