import 'package:flutter/material.dart';
import 'package:more_names/widgets/widgetry.dart';
import 'package:provider/provider.dart';
import '../services/data.dart';
import '../models/name_model.dart';
import '../widgets/widgetry.dart';

class MyList extends StatefulWidget {
  static const routeName = '/my-list';
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context, listen: false);
    final List<String> favNofn = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
      ),
      body: Container(
          child: ListView.builder(
        itemCount: favNofn.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: UniqueKey(),
              background: deleteBgr(),
              onDismissed: (direction) {
                data.unFavorite(favNofn[index]);
                setState(() {
                  favNofn.removeAt(index);
                });
              },
              child: myListTile(favNofn[index]));
        },
      )),
    );
  }
}
