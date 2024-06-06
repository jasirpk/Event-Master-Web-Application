import 'package:event_master_web/presentation_layer/screens/get_started.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(EventMasterWeb());
}

class EventMasterWeb extends StatelessWidget {
  const EventMasterWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
              textTheme: TextTheme(
                  bodyLarge: TextStyle(color: Colors.white),
                  bodyMedium: TextStyle(color: Colors.white)),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal))
          .copyWith(),
      home: GetStartedScreen(),
    );
  }
}
