import 'package:flutter/material.dart';

Widget previewWidget() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: Color.fromARGB(255, 39, 49, 49),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    child: Container(
      color: Color.fromARGB(255, 39, 49, 49),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 40,
            height: 6,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          ),
          SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.keyboard_arrow_up))
          ]),
          Text('Drag Me',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
