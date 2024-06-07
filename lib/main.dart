import 'package:event_master_web/firebase_options.dart';
import 'package:event_master_web/presentation_layer/screens/get_started.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
