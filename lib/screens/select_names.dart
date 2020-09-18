import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data.dart';
import 'my_list.dart';
import '../widgets/widgetry.dart';

class SelectNames extends StatefulWidget {
  static const routeName = '/select-names';
  @override
  _SelectNamesState createState() => _SelectNamesState();
}

class _SelectNamesState extends State<SelectNames> {
  List<String> myNames = [];

  _setup() async {
    myNames = await Provider.of<Data>(context, listen: false).getNames();

    myNames.shuffle();
    setState(() {});
  }

  @override
  void initState() {
    _setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context, listen: false);
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: kBoxDec(),
                child: myHeader(),
              ),
            ),
            Positioned(
              top: 160,
              left: 18,
              child: Container(
                margin: EdgeInsets.only(right: 18),
                color: Colors.grey[200],
                width: MediaQuery.of(context).size.width - 36,
                height: MediaQuery.of(context).size.height / 1.5,
                child: myNames.isEmpty
                    ? Center(
                        child: Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()))
                    : ListView.builder(
                        itemCount: myNames.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                              key: UniqueKey(),
                              background: deleteBgr(),
                              secondaryBackground: archiveBgr(),
                              child: myListTile(myNames[index]),
                              onDismissed: (direction) {
                                if (direction == DismissDirection.startToEnd) {
                                  data.addAsWatched(myNames[index]);
                                  setState(() {
                                    myNames.removeAt(index);
                                  });
                                } else {
                                  data.addAsFavoriteAndWatched(myNames[index]);
                                  setState(() {
                                    myNames.removeAt(index);
                                  });
                                }
                              });
                        }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff2da9ef),
          foregroundColor: Color(0xffffffff),
          child: Icon(Icons.add),
          tooltip: 'increment',
          onPressed: () async {
            await data.addData();
            print('float');
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff2da9ef),
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(Icons.access_alarm),
                onPressed: () {
                  Navigator.pushNamed(context, MyList.routeName,
                      arguments: data.allFavorites());
                }),
            IconButton(
                icon: Icon(Icons.adb),
                onPressed: () {
                  data.test();
                }),
          ],
        ),
      ),
    );
  }
}
