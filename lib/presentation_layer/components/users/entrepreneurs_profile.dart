import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/data_layer/services/user_profile/profile.dart';
import 'package:event_master_web/data_layer/services/user_profile/vendor_request.dart';
import 'package:event_master_web/presentation_layer/components/shimmer/entrepreneurs.dart';
import 'package:event_master_web/presentation_layer/components/users/entrepreneurs_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class EntrepreneursProfileWidget extends StatelessWidget {
  const EntrepreneursProfileWidget({
    super.key,
    required this.documents,
    required this.userProfile,
    required this.screenHeight,
    required this.screenWidth,
    required this.vendorRequest,
  });

  final List<QueryDocumentSnapshot<Object?>> documents;
  final UserProfile userProfile;
  final double screenHeight;
  final double screenWidth;
  final VendorRequest vendorRequest;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 3,
      itemCount: documents.length,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemBuilder: (context, index) {
        var data = documents[index].data() as Map<String, dynamic>;
        String imagePath = data['profileImage'];
        String documentId = documents[index].id;

        return FutureBuilder<DocumentSnapshot>(
          future: userProfile.getUserDetailById(documentId),
          builder: (context, detailSnapshot) {
            if (detailSnapshot.connectionState == ConnectionState.waiting) {
              return ShimmerEntrepreneurs(
                  screenHeight: screenHeight, screenWidth: screenWidth);
            }
            if (detailSnapshot.hasError) {
              return Center(
                child: Text('Error: ${detailSnapshot.error}'),
              );
            }
            if (!detailSnapshot.hasData || detailSnapshot.data == null) {
              return Center(child: Text('Details not found'));
            }
            var userDetail =
                detailSnapshot.data!.data() as Map<String, dynamic>;
            return StreamBuilder<QuerySnapshot>(
                stream: vendorRequest.getGeneratedCategoryDetails(documentId),
                builder: (context, snapshot) {
                  return FutureBuilder<QuerySnapshot>(
                      future: vendorRequest
                          .getGeneratedCategoryDetails(documentId)
                          .first,
                      builder: (context, vendorSnapshot) {
                        if (vendorSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ShimmerEntrepreneurs(
                              screenHeight: screenHeight,
                              screenWidth: screenWidth);
                        }
                        if (vendorSnapshot.hasError) {
                          return Center(
                            child: Text('Error: ${vendorSnapshot.error}'),
                          );
                        }
                        if (!vendorSnapshot.hasData ||
                            vendorSnapshot.data!.docs.isEmpty) {
                          return Center(
                              child: Text('Vendor Details not found'));
                        }
                        var vendorDetail = vendorSnapshot.data!.docs.first
                            .data() as Map<String, dynamic>;
                        return EntrepreneursFieldsWidget(
                            documentId: documentId,
                            screenHeight: screenHeight,
                            imagePath: imagePath,
                            userDetail: userDetail,
                            vendorDetail: vendorDetail);
                      });
                });
          },
        );
      },
    );
  }
}
