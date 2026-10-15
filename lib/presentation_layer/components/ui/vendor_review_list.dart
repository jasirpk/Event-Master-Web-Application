import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/data_layer/services/user_profile/vendor_request.dart';
import 'package:event_master_web/presentation_layer/components/shimmer/alltemplates.dart';
import 'package:event_master_web/presentation_layer/components/ui/vendor_review_card.dart';
import 'package:flutter/material.dart';

/// The body shared by the Requests, Accepted and Rejected tabs.
///
/// Only the query and the wording of the empty state differ between them, so
/// only those are parameters. Everything else — loading, failure, the card
/// itself and the decision actions on it — is one implementation.
class VendorReviewList extends StatelessWidget {
  const VendorReviewList({
    super.key,
    required this.uid,
    required this.stream,
    required this.emptyMessage,
    required this.vendorRequest,
  });

  final String uid;
  final Stream<QuerySnapshot> stream;
  final String emptyMessage;
  final VendorRequest vendorRequest;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerSubCategoryItem(
              screenHeight: screenHeight, screenWidth: screenWidth);
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final documents = snapshot.data?.docs ?? const <QueryDocumentSnapshot>[];
        if (documents.isEmpty) {
          return Center(child: Text(emptyMessage));
        }

        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              // The stream already delivered this document. Re-fetching it per
              // row cost an extra read per vendor on every rebuild and told us
              // nothing new.
              final document = documents[index];

              return VendorReviewCard(
                // Keyed by document id so that a listing leaving the tab
                // disposes its own State rather than handing an in-flight
                // "saving" flag to whichever listing shifts into its place.
                key: ValueKey(document.id),
                uid: uid,
                vendorId: document.id,
                vendorDetail: document.data() as Map<String, dynamic>,
                vendorRequest: vendorRequest,
              );
            },
          ),
        );
      },
    );
  }
}
