import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/data_layer/services/category.dart';
import 'package:event_master_web/presentation_layer/components/form/user_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListScreen extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String value;

  UserListScreen(
    this.screenWidth,
    this.screenHeight,
    this.value,
  );

  final DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Add Templates',
                    style: TextStyle(
                      fontSize: screenHeight * 0.022,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(RoutsClass.getFormRout());
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                )
              ],
            ),
            SizedBox(height: 16),
            UserListWidget(
                databaseMethods: databaseMethods,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                value: value),
          ],
        ),
      ),
    );
  }
}
