import 'package:event_master_web/data_layer/services/user_profile/vendor_request.dart';
import 'package:event_master_web/presentation_layer/components/ui/vendor_review_list.dart';
import 'package:flutter/material.dart';

/// Listings awaiting a decision.
class BuildRequestWidget extends StatelessWidget {
  final String uid;

  const BuildRequestWidget({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final VendorRequest vendorRequest = VendorRequest();

    return VendorReviewList(
      uid: uid,
      stream: vendorRequest.getGeneratedCategoryDetails(uid),
      emptyMessage: 'No pending requests',
      vendorRequest: vendorRequest,
    );
  }
}
