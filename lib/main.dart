import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/data_layer/auth_bloc/auth_bloc.dart';
import 'package:event_master_web/data_layer/category_bloc/vendor_category_bloc.dart';
import 'package:event_master_web/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

Future<void> main() async {
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
        BlocProvider(create: (context) => AuthBloc()..add(CheckUsrEvent())),
        BlocProvider(create: (context) => VendorCategoryBloc()),
      ],
      child: GetMaterialApp(
        initialRoute: '/',
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
