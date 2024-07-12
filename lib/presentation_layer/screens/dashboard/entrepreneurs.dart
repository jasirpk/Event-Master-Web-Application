import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/data_layer/services/user_profile/profile.dart';
import 'package:event_master_web/data_layer/services/user_profile/vendor_request.dart';
import 'package:event_master_web/presentation_layer/components/users/entrepreneurs_profile.dart';
import 'package:flutter/material.dart';

class EntrepreneursListScreen extends StatelessWidget {
  const EntrepreneursListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = UserProfile();
    final VendorRequest vendorRequest = VendorRequest();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
                    'Entrepreneurs',
                    style: TextStyle(
                      fontSize: screenHeight * 0.024,
                      color: Colors.white,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: userProfile.getUserProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No Templates Found'),
                    );
                  }
                  final documents = snapshot.data!.docs;
                  return EntrepreneursProfileWidget(
                      documents: documents,
                      userProfile: userProfile,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      vendorRequest: vendorRequest);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
