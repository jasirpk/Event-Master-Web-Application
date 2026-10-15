import 'package:event_master_web/common/style.dart';
import 'dart:developer' as developer;

import 'package:event_master_web/common/error_diagnostics.dart';
import 'package:event_master_web/data_layer/models/vendor_document.dart';
import 'package:event_master_web/data_layer/services/user_profile/vendor_request.dart';
import 'package:event_master_web/presentation_layer/components/media/media_image.dart';
import 'package:event_master_web/presentation_layer/components/ui/vendor_decision_action.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/vendor_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One vendor listing as the console reviews it.
///
/// All three Checklist tabs render this. They used to carry a copy each, which
/// is how the Accepted and Rejected tabs ended up with no way to change a
/// decision: the buttons existed only in the copy the Requests tab held.
///
/// Which actions appear is decided by the listing's own recorded state rather
/// than by the tab showing it, so the three tabs cannot drift apart again:
///
///  * pending  — Accept, Reject
///  * accepted — Reject
///  * rejected — Accept
class VendorReviewCard extends StatefulWidget {
  const VendorReviewCard({
    super.key,
    required this.uid,
    required this.vendorId,
    required this.vendorDetail,
    required this.vendorRequest,
  });

  /// The entrepreneur who owns the listing.
  final String uid;

  /// The `vendorDetails` document id.
  final String vendorId;

  final Map<String, dynamic> vendorDetail;
  final VendorRequest vendorRequest;

  @override
  State<VendorReviewCard> createState() => _VendorReviewCardState();
}

class _VendorReviewCardState extends State<VendorReviewCard> {
  /// Set while a decision is being written.
  ///
  /// The card is driven by a snapshot stream, so a successful write removes it
  /// from the tab on its own. Until that lands the buttons stay disabled, so a
  /// second tap cannot queue a contradictory write behind the first.
  bool _busy = false;

  Future<void> _decide({required bool accept}) async {
    if (_busy) return;

    logStage('VendorReviewCard', 'decision tapped (accept=$accept)');
    try {
      await _runDecision(accept: accept);
    } catch (error, stack) {
      // An exception escaping a gesture callback is reported by the framework,
      // and on web that report is what gets mangled. Logging it here keeps the
      // original type and stack.
      if (kErrorDiagnostics) {
        developer.log('Decision callback failed',
            name: 'VendorReviewCard', error: error, stackTrace: stack);
      }
      rethrow;
    }
  }

  Future<void> _runDecision({required bool accept}) async {
    final confirmed = await confirmVendorDecision(
      context,
      vendorName: vendorText(widget.vendorDetail['categoryName']),
      accept: accept,
    );
    if (!confirmed || !mounted) return;

    // Captured before the await: a successful decision moves the listing to
    // another tab, disposing this State, and the outcome still has to be
    // reported somewhere.
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _busy = true);
    try {
      await applyVendorDecision(
        messenger: messenger,
        vendorRequest: widget.vendorRequest,
        uid: widget.uid,
        vendorId: widget.vendorId,
        accept: accept,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _openDetails() {
    Get.to(() => VendorDetailScreen(
          uid: widget.uid,
          vendorId: widget.vendorId,
          initial: widget.vendorDetail,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final vendorDetail = widget.vendorDetail;
    final decision = vendorDecisionOf(vendorDetail);
    final imagePath = vendorText(vendorDetail['imagePathUrl']);

    return InkWell(
      onTap: _openDetails,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: screenWidth * 0.8,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white38,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // imagePathUrl is an R2 object key since the migration, so it
              // needs signing. MediaImage tells a key from a legacy HTTPS URL
              // and handles both; AssetImage would ask Flutter for a bundled
              // asset named "vendor_images/..." and throw.
              MediaImage(
                imagePath: imagePath,
                placeholder: kMediaPlaceholderImage,
                builder: (context, image) => Container(
                  width: screenWidth * 0.20,
                  height: screenHeight * 0.17,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                    image: image == null
                        ? null
                        : DecorationImage(image: image, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendorText(vendorDetail['categoryName']),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        vendorText(vendorDetail['description']),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: myColor, size: 20),
                          const SizedBox(width: 4.0),
                          // Expanded, or a long location takes its full
                          // intrinsic width inside the Row and overflows
                          // before the ellipsis can engage.
                          Expanded(
                            child: Text(
                              vendorText(vendorDetail['location']),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: screenHeight * 0.014,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      _Actions(
                        decision: decision,
                        busy: _busy,
                        onAccept: () => _decide(accept: true),
                        onReject: () => _decide(accept: false),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<String>(
                enabled: !_busy,
                onSelected: (value) {
                  if (value == 'details') _openDetails();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem<String>(
                    value: 'details',
                    child: Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The decision buttons for one listing, and the progress they replace
/// themselves with.
class _Actions extends StatelessWidget {
  const _Actions({
    required this.decision,
    required this.busy,
    required this.onAccept,
    required this.onReject,
  });

  final VendorDecision decision;
  final bool busy;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    if (busy) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text('Saving…', style: TextStyle(fontSize: 13)),
          ],
        ),
      );
    }

    final accept = ElevatedButton(
      onPressed: onAccept,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(myColor),
      ),
      child: const Text('Accept', style: TextStyle(color: Colors.black)),
    );

    final reject = ElevatedButton(
      onPressed: onReject,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
      ),
      child: const Text('Reject', style: TextStyle(color: Colors.white)),
    );

    // Wrap, not Row: at narrow console widths two buttons beside a thumbnail
    // do not fit on one line.
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        if (decision != VendorDecision.accepted) accept,
        if (decision != VendorDecision.rejected) reject,
      ],
    );
  }
}
