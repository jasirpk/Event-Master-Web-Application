import 'package:event_master_web/presentation_layer/components/ui/accepted.dart';
import 'package:event_master_web/presentation_layer/components/ui/rejected.dart';
import 'package:event_master_web/presentation_layer/components/ui/request_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChecklistScreen extends StatelessWidget {
  final String uid;

  const ChecklistScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Requests'),
              Tab(text: 'Accepted'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRequestsTab(screenWidth, screenHeight),
            _buildAcceptedTab(screenWidth, screenHeight),
            _buildRejectdTab(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsTab(double screenWidth, double screenHeight) {
    return BuildRequestWidget(
      uid: uid,
    );
  }

  Widget _buildAcceptedTab(double screenWidth, double screenHeight) {
    return BuildAcceptedWidget(
      uid: uid,
    );
  }

  Widget _buildRejectdTab(double screenWidth, double screenHeight) {
    return BuildRejectedWidget(
      uid: uid,
    );
  }
}
