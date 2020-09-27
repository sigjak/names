import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data.dart';
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
        centerTitle: true,
        title: Text('Valin nöfn'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.info,
                size: 40,
              ),
              onPressed: () async {
                data.infoAlert(context);
              }),
        ],
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
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 36,
                height: MediaQuery.of(context).size.height / 1.7,
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
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                        child: favListTile(favNofn, index),
                      ),
                      // child: myListTile(favNofn[index]),
                    );
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
