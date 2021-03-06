import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                height: MediaQuery.of(context).size.height / 4,
                decoration: kBoxDec(),
                child: myHeader(),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 4.5,
              left: 18,
              child: Container(
                margin: EdgeInsets.only(right: 18),
                color: Colors.grey[200],
                width: MediaQuery.of(context).size.width - 36,
                height: MediaQuery.of(context).size.height / 1.3,
                child: (data.onlyNames.isEmpty && isMore)
                    ? Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(10),
                        itemCount: data.onlyNames.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                              key: Key(data.onlyNames[index]),
                              background: deleteBgr(),
                              secondaryBackground: archiveBgr(),
                              child: myListTile(data.onlyNames[index]),
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  await data
                                      .markAsWatched(data.onlyNames[index]);

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
                                  data.noMoreNamesAlert(context);
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
                  data.resetAlert(context);
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
