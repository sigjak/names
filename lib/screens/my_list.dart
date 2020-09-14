import 'package:flutter/material.dart';
import '../models/name_model.dart';

class MyList extends StatefulWidget {
  static const routeName = '/my-list';
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  @override
  Widget build(BuildContext context) {
    final List<String> nofn = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
      ),
      body: Container(
          child: ListView.builder(
        itemCount: nofn.length,
        itemBuilder: (context, index) {
          return Text('name:${nofn[index]}- id: ${index}');
        },
      )),
    );
  }
}
