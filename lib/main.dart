import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/data_layer/auth_bloc/auth_bloc.dart';
import 'package:event_master_web/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(CheckUsrEvent()))
      ],
      child: GetMaterialApp(
        initialRoute: RoutsClass.getSplashRoute(),
        getPages: RoutsClass.routes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: MediaQuery.of(context).platformBrightness,
          textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white)),
        ).copyWith(),
      ),
    );
  }
}
