import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/data_layer/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenWidth, screenHeight * 0.1),
        child: AppBar(
          leading: ClipOval(
            child: Image.asset(
              'assets/images/Screenshot 2024-05-22 205021.png',
              filterQuality: FilterQuality.high,
              fit: BoxFit.fill,
            ),
          ),
          title: Text(
            'Event Master',
            style: TextStyle(
              fontFamily: 'JacquesFrancois',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
            sizedBoxWidth,
            IconButton(onPressed: () {}, icon: Icon(Icons.message)),
            sizedBoxWidth,
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(Logout());
              },
              icon: Icon(Icons.logout),
            ),
            sizedBoxWidth,
          ],
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Get.offAllNamed(RoutsClass.getLoginRout());
          }
        },
        child: Stack(
          children: [
            CustomScrollView(),
            // BottomSheetWidget(),
          ],
        ),
      ),
    );
  }
}
