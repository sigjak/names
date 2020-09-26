import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import '../services/database_helper.dart';
import '../services/data.dart';
import './my_list.dart';
import '../widgets/widgetry.dart';

class SelectNames extends StatefulWidget {
  static const routeName = '/select-names';
  @override
  _SelectNamesState createState() => _SelectNamesState();
}

class _SelectNamesState extends State<SelectNames> {
  List<String> allNames = [];
  bool isMore = true;
  @override
  void initState() {
    _setup();
    super.initState();
  }

  _setup() async {
    if (await Provider.of<Data>(context, listen: false).checkIfDbCreated()) {
      await Provider.of<Data>(context, listen: false)
          .loadUnwatchedNamesFromDatabase();
    } else
      await Provider.of<Data>(context, listen: false).createDb();
  }

  // noMoreNames() {
  //   Alert(
  //     context: context,
  //     type: AlertType.success,
  //     title: "EKKI FLEIRI NÖFN !",
  //     desc: "Nafnalist tæmdur...",
  //     buttons: [
  //       DialogButton(
  //         child: Text(
  //           "VALIN NÖFN",
  //           style: TextStyle(color: Colors.white, fontSize: 20),
  //         ),
  //         onPressed: () async {
  //           Navigator.of(context).pop();
  //           // Navigator.pushNamed(context, MyList.routeName,
  //           //     arguments:
  //           //         await DatabaseHelper.instance.getIsGirls('isFavorite'));
  //         },
  //         width: 200,
  //       )
  //     ],
  //   ).show();
  // }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Data>(context);
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
                child: (data.onlyNames.isEmpty && isMore)
                    ? Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        itemCount: data.onlyNames.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                              key: Key(data.onlyNames[index]),
                              background: deleteBgr(),
                              secondaryBackground: archiveBgr(),
                              child: Card(
                                  child: myListTile(data.onlyNames[index])),
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  await data
                                      .markasWatched(data.onlyNames[index]);

                                  setState(() {
                                    data.onlyNames.removeAt(index);
                                  });
                                } else {
                                  await data.markasFavAndWatched(
                                      data.onlyNames[index]);

                                  setState(() {
                                    data.onlyNames.removeAt(index);
                                  });
                                }
                                if (data.onlyNames.isEmpty) {
                                  setState(() {
                                    isMore = false;
                                  });
                                  data.noMoreNames(context);
                                }
                              });
                        }),
              ),
            ),
            !isMore
                ? Positioned(
                    top: 300,
                    left: 70,
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
          backgroundColor: Colors.brown[400],
          foregroundColor: Color(0xffffffff),
          child: Icon(
            Icons.thumb_up,
            size: 35,
          ),
          onPressed: () async {
            Navigator.pushNamed(context, MyList.routeName,
                arguments: await data.loadAllFavorites());
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.brown[400],
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(Icons.restore),
                color: Colors.white,
                onPressed: () async {
                  data.reset(context);
                  isMore = true;
                }),
            IconButton(
                icon: Icon(Icons.exit_to_app),
                color: Colors.white,
                onPressed: () async {
                  // exit the app
                  data.pop();
                }),
          ],
        ),
      ),
    );
  }
}
