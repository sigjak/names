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
    padding: const EdgeInsets.all(8),
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
            Container(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
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
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
        ),
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