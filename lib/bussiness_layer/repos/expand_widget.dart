import 'package:flutter/material.dart';

Widget expandWidget() {
  List<Map<String, dynamic>> items = [
    {
      "icon": Icons.person,
      "title": "Profile Info",
      "navigation": Icons.chevron_right,
    },
    {
      "icon": Icons.lock,
      "title": "Privacy Policy",
      "navigation": Icons.chevron_right,
    },
    {
      "icon": Icons.message,
      "title": "Feedback",
      "navigation": Icons.chevron_right,
    },
    {
      "icon": Icons.alarm,
      "title": "Reminders",
      "navigation": Icons.chevron_right,
    },
    {
      "icon": Icons.share,
      "title": "Share this App",
      "navigation": Icons.chevron_right,
    },
    {
      "icon": Icons.logout,
      "title": "SignOut",
      "navigation": Icons.chevron_right,
    },
  ];

  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Column(
      children: <Widget>[
        Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.white),
        SizedBox(height: 8),
        Text(
          'Drag On!!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(
                  items[index]['icon'],
                  size: 24,
                ),
                title: Text(
                  items[index]['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  items[index]['navigation'],
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
