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
        // kMediaPlaceholderImage is an AssetImage, not a String: assigning it
        // here threw a TypeError for any entrepreneur with no profileImage.
        // An empty string is the honest "nothing stored" value, and
        // MediaImage already renders its placeholder for one.
        final String imagePath = (data['profileImage'] as String?) ?? '';
        // Read from the stream document, not the FutureBuilder below: this
        // one is live, so the card flips to Approved the moment the write
        // lands without needing a manual refresh.
        final bool isValid = data['isValid'] == true;
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
            // One stream, not a stream wrapping a future built from a
            // second copy of the same stream: the old pair opened two
            // listeners and re-ran `.first` on every rebuild.
            return StreamBuilder<QuerySnapshot>(
                stream: vendorRequest.getVendorListingsForProfile(documentId),
                builder: (context, vendorSnapshot) {
                  if (vendorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ShimmerEntrepreneurs(
                        screenHeight: screenHeight, screenWidth: screenWidth);
                  }
                  // The listings supply one line of this card — the location.
                  // Letting an empty or failed read return an error widget
                  // replaced the entrepreneur entirely, so accepting their
                  // last pending listing blanked the whole grid. An empty map
                  // degrades that line and leaves the profile standing.
                  final docs = vendorSnapshot.data?.docs ??
                      const <QueryDocumentSnapshot<Object?>>[];
                  final vendorDetail = docs.isEmpty
                      ? const <String, dynamic>{}
                      : docs.first.data() as Map<String, dynamic>;
                  return EntrepreneursFieldsWidget(
                      documentId: documentId,
                      screenHeight: screenHeight,
                      imagePath: imagePath,
                      isValid: isValid,
                      userProfile: userProfile,
                      userDetail: userDetail,
                      vendorDetail: vendorDetail);
                });
          },
        );
      },
    );
  }
}
