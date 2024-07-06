import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/data_layer/auth_bloc/auth_bloc.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/entrepreneurs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CusotmAppBar extends StatelessWidget {
  const CusotmAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        ElevatedButton(
            onPressed: () {
              Get.to(() => EntrepreneursListScreen());
            },
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(myColor)),
            child: Text(
              'CheckList',
              style: TextStyle(color: Colors.black),
            )),
        sizedBoxWidth,
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
    );
  }
}
