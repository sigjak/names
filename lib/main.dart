import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
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
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FbaseInit(),
        routes: {
          MyList.routeName: (context) => MyList(),
        },
      ),
    );
  }
}

class FbaseInit extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Text('error'));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return SelectNames();
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
