import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';

Widget myHeader() {
  return Align(
    child: ListTile(
      leading: Text(
        DateTime.now().day.toString(),
        style: TextStyle(fontSize: 50, color: Colors.amber),
      ),
      title: Text(
        DateFormat.MMMM().format(DateTime.now()),
        style: TextStyle(fontSize: 34, color: Colors.white),
      ),
      subtitle: Text(
        DateTime.now().year.toString(),
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    ),
  );
}

Widget myListTile(String name) {
  RandomColor randomColor = RandomColor();
  Color _color = randomColor.randomColor();
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Container(
      height: 80,
      child: Material(
        color: Colors.white,
        elevation: 14,
        shadowColor: Color(0xff802196F3),
        child: Row(
          children: [
            Container(
              height: 80,
              width: 10,
              color: _color,
            ),
            Expanded(
              child: Container(
                // padding: EdgeInsets.only(right: 15),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget deleteBgr() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}

Widget archiveBgr() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      color: Colors.green,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(
            Icons.archive,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

ListTile favListTile(List<String> favNofn, int index) {
  RandomColor randomColor = RandomColor();
  Color _color = randomColor.randomColor();
  Color _color2 = randomColor.randomColor();
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 0),
    title: Text(
      favNofn[index],
      style: TextStyle(fontSize: 25),
      textAlign: TextAlign.center,
    ),
    trailing: Container(
      width: 15,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_color, _color2]),
      ),
      // child: Icon(
      //   Icons.leak_remove,
      //   color: Colors.white,
      //   size: 35,
      // ),
    ),
  );
}

kBoxDec() {
  return BoxDecoration(
    color: Color(0xff5a348b),
    gradient: LinearGradient(
      colors: [Colors.brown, Colors.brown[300]],
      begin: Alignment.centerRight,
      end: Alignment(-1.0, -1.0),
    ),
  );
}
