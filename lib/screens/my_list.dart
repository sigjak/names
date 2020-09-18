import 'package:flutter/material.dart';
import 'package:more_names/widgets/widgetry.dart';
import 'package:provider/provider.dart';
import '../services/data.dart';
//
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
        backgroundColor: Colors.brown[300],
        title: Text('My List'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/hand.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 130,
              left: 18,
              child: Container(
                padding: EdgeInsets.all(4),
                width: MediaQuery.of(context).size.width - 36,
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(2)),
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
                        child: Expanded(child: myListTile(favNofn[index])));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
