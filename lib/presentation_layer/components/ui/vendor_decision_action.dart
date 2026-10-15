import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/common/error_diagnostics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:event_master_web/data_layer/services/user_profile/vendor_request.dart';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';

/// Confirming and recording a decision about one vendor listing.
///
/// Both the Checklist cards and the vendor details screen offer Accept and
/// Reject, and both go through here, so there is one confirmation wording,
/// one write and one way of reporting the outcome. The two are split rather
/// than combined into a single call because each caller shows its own
/// in-flight state, and that should begin when the write begins — not while
/// the administrator is still reading the confirmation.

/// Asks before changing a decision. Returns true only on an explicit yes.
Future<bool> confirmVendorDecision(
  BuildContext context, {
  required String vendorName,
  required bool accept,
}) async {
  final subject = vendorName.trim().isEmpty ? 'this listing' : '"$vendorName"';

  logStage('VendorDecision', 'confirmation requested (accept=$accept)');

  final answer = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(accept ? 'Accept listing?' : 'Reject listing?'),
      content: Text(
        accept
            ? 'Accept $subject. It becomes visible to consumers browsing this '
                'category.'
            : 'Reject $subject. It stops being offered to consumers.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: accept
              ? null
              : FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(accept ? 'Accept' : 'Reject'),
        ),
      ],
    ),
  );

  logStage('VendorDecision', 'confirmation completed (confirmed=${answer == true})');
  return answer == true;
}

/// Writes the decision and reports the outcome. Returns whether it succeeded.
///
/// The messenger is passed in rather than looked up here: a card that accepts
/// a listing is removed from its tab by the resulting snapshot, so by the time
/// this returns the caller's own context may be gone.
Future<bool> applyVendorDecision({
  required ScaffoldMessengerState messenger,
  required VendorRequest vendorRequest,
  required String uid,
  required String vendorId,
  required bool accept,
}) async {
  logStage('VendorDecision', 'write started (accept=$accept)');

  try {
    await vendorRequest.setVendorDecision(uid, vendorId, accepted: accept);

    logStage('VendorDecision', 'write succeeded; requesting feedback');
    showCustomSnackBarOn(
      messenger,
      accept ? 'Listing accepted' : 'Listing rejected',
      accept
          ? 'It now appears under Accepted.'
          : 'It now appears under Rejected.',
    );
    return true;
  } catch (error, stack) {
    // Captured here, at the boundary, because by the time an error reaches
    // Flutter's reporter the original stack is no longer recoverable.
    logStage('VendorDecision', 'write failed: ${error.runtimeType}');
    if (kErrorDiagnostics) {
      developer.log('Vendor decision write failed',
          name: 'VendorDecision', error: error, stackTrace: stack);
    }

    // Nothing moved, because nothing was written. Showing the real message
    // rather than a generic one is what makes a permission failure
    // distinguishable from an offline one.
    showCustomSnackBarOn(
      messenger,
      accept ? 'Could not accept listing' : 'Could not reject listing',
      _describe(error),
    );
    return false;
  }
}

/// A FirebaseException keeps the useful part in `message`; its `toString`
/// buries it in brackets and plugin noise.
String _describe(Object error) {
  if (error is FirebaseException) {
    final message = error.message;
    if (message != null && message.trim().isNotEmpty) return message;
  }

  final text = error.toString();
  return text.startsWith('Exception: ')
      ? text.substring('Exception: '.length)
      : text;
}
