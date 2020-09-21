import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:sqflite/sqflite.dart';
import '../services/database_helper.dart';
import '../services/data.dart';
import 'my_list.dart';
import '../widgets/widgetry.dart';

class SelectNames extends StatefulWidget {
  static const routeName = '/select-names';
  @override
  _SelectNamesState createState() => _SelectNamesState();
}

class _SelectNamesState extends State<SelectNames> {
  List<String> girlNames = [];
  bool testing = true;

  _setup() async {
    // if database empty initiate databases girls and fav
    bool check = await DatabaseHelper.instance.databaseExists();

    if (check == false) {
      girlNames = await Provider.of<Data>(context, listen: false).getNames();

      await DatabaseHelper.instance.insertBatch(girlNames);

      girlNames.shuffle();
      setState(() {});
    } else {
      print(check);
      girlNames = await DatabaseHelper.instance.queryGirls();
      if (girlNames.isEmpty) {
        setState(() {
          testing = false;
        });
      }
      // if (girlNames.isEmpty) {
      //   Navigator.pushReplacementNamed(context, MyList.routeName,
      //       arguments: await DatabaseHelper.instance.getIsGirls('isFavorite'));
      // }
      girlNames.shuffle();
      setState(() {});
    }
  }

  _myAlert(context) {
    Alert(
      context: context,
      title: 'Byrja aftur?',
      desc: 'Ertu viss? Fyrra vali verður eytt!',
      buttons: [
        DialogButton(
          color: Colors.green,
          child: Text(
            'Nei',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        DialogButton(
            color: Colors.red,
            child: Text(
              'Já',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await DatabaseHelper.instance.resetTable();
              girlNames = await DatabaseHelper.instance.queryGirls();
              girlNames.shuffle();
              testing = true;
              setState(() {});
            })
      ],
    ).show();
  }

  @override
  void initState() {
    _setup();
    super.initState();
  }

  Future<void> basicAlert() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ekki fleiri nöfn'),
            actions: [
              FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, MyList.routeName,
                        arguments: await DatabaseHelper.instance
                            .getIsGirls('isFavorite'));
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //final data = Provider.of<Data>(context, listen: false);
    return Scaffold(
      // appBar: AppBar(title: Text(testing)),
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
                child: (girlNames.isEmpty && testing)
                    ? Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        itemCount: girlNames.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                              key: UniqueKey(),
                              background: deleteBgr(),
                              secondaryBackground: archiveBgr(),
                              child: myListTile(girlNames[index]),
                              onDismissed: (direction) {
                                if (direction == DismissDirection.startToEnd) {
                                  DatabaseHelper.instance
                                      .markNameAsWatched(girlNames[index]);

                                  setState(() {
                                    girlNames.removeAt(index);
                                  });
                                } else {
                                  DatabaseHelper.instance
                                      .markNameAsFavoriteAndWatched(
                                          girlNames[index]);
                                  setState(() {
                                    girlNames.removeAt(index);
                                  });
                                }
                                if (girlNames.isEmpty) {
                                  setState(() {
                                    testing = false;
                                  });
                                  basicAlert();
                                }
                              });
                        }),
              ),
            ),
            !testing
                ? Positioned(
                    top: 300,
                    left: 50,
                    child: Center(
                      child: Container(
                          width: 300,
                          height: 400,
                          child: Text(
                            'Ekki fleiri nöfn!',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          )),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff2da9ef),
          foregroundColor: Color(0xffffffff),
          child: Icon(
            Icons.thumb_up,
            size: 35,
          ),
          onPressed: () async {
            Navigator.pushNamed(context, MyList.routeName,
                arguments:
                    await DatabaseHelper.instance.getIsGirls('isFavorite'));
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
                icon: Icon(Icons.restore),
                onPressed: () async {
                  print('reset');
                  _myAlert(context);
                  // await DatabaseHelper.instance.resetTable();
                  // girlNames = await DatabaseHelper.instance.queryGirls();
                  // girlNames.shuffle();
                  // setState(() {});
                }),
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  // exit the app
                  // data.pop();

                  print(await DatabaseHelper.instance.tableEmpty());
                  // List<String> watched = [];
                  // watched =
                  //     await DatabaseHelper.instance.getIsGirls('isWatched');
                  // print(watched);
                }),
          ],
        ),
      ),
    );
  }
}
