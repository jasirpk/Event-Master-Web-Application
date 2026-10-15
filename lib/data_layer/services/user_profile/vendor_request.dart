import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class VendorRequest {
  Future<DocumentSnapshot?> getCategoryDetailById(
      String uid, String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('entrepreneurs')
          .doc(uid)
          .collection('vendorDetails')
          .doc(documentId)
          .get();

      if (documentSnapshot.exists) {
        return documentSnapshot;
      } else {
        log('Document with ID $documentId not found.');
        return null;
      }
    } catch (e) {
      log('Error getting document by ID: $e');
      throw Exception('Failed to get document by ID: $e');
    }
  }

  /// Listings submitted for review and not yet decided.
  ///
  /// The two decision filters are what make this an inbox: accepting or
  /// rejecting only flips those flags, so without them a listing stayed in
  /// Requests for ever while also appearing under Accepted or Rejected.
  Stream<QuerySnapshot> getGeneratedCategoryDetails(String uid) {
    return FirebaseFirestore.instance
        .collection('entrepreneurs')
        .doc(uid)
        .collection('vendorDetails')
        .where('isValid', isEqualTo: true)
        .where('isAccepted', isEqualTo: false)
        .where('isRejected', isEqualTo: false)
        .snapshots();
  }

  /// Every listing this entrepreneur has submitted, whatever the console has
  /// since decided about it.
  ///
  /// This is deliberately *not* [getGeneratedCategoryDetails]. That one is the
  /// Requests inbox and excludes anything already accepted or rejected, which
  /// is right for the inbox and wrong for anywhere that just needs to show the
  /// entrepreneur: accepting their last pending listing emptied the inbox and
  /// took the profile card with it.
  Stream<QuerySnapshot> getVendorListingsForProfile(String uid) {
    return FirebaseFirestore.instance
        .collection('entrepreneurs')
        .doc(uid)
        .collection('vendorDetails')
        .where('isValid', isEqualTo: true)
        .snapshots();
  }

  /// Listings the console has accepted.
  ///
  /// Only `isAccepted` is filtered. The two flags are set together by
  /// [setVendorDecision], so a second `isRejected == false` filter adds
  /// nothing — and it actively hid older
  /// listings written before `isRejected` existed, because Firestore does not
  /// match a document whose field is absent.
  Stream<QuerySnapshot> getAcceptedVendorList(String uid) {
    return FirebaseFirestore.instance
        .collection('entrepreneurs')
        .doc(uid)
        .collection('vendorDetails')
        .where('isAccepted', isEqualTo: true)
        .snapshots();
  }

  /// Listings the console has rejected. See [getAcceptedVendorList] for why
  /// the complementary filter is deliberately absent.
  Stream<QuerySnapshot> getRejectedVendorList(String uid) {
    return FirebaseFirestore.instance
        .collection('entrepreneurs')
        .doc(uid)
        .collection('vendorDetails')
        .where('isRejected', isEqualTo: true)
        .snapshots();
  }

  /// One listing, watched live.
  ///
  /// The details screen reads the document rather than the arguments it was
  /// opened with, so a decision taken on that screen is reflected by it
  /// instead of leaving a stale badge behind.
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchVendor(
      String uid, String vendorId) {
    return FirebaseFirestore.instance
        .collection('entrepreneurs')
        .doc(uid)
        .collection('vendorDetails')
        .doc(vendorId)
        .snapshots();
  }

  /// Records the console's decision about one listing.
  ///
  /// The two flags are deliberately written together in a single update. They
  /// are not independent — they encode one tri-state — and setting them apart
  /// is what would let a listing show up under two tabs at once, or vanish
  /// from all three.
  ///
  /// This writes nothing else. In particular it does not touch the listing's
  /// own `isValid`, which records that the listing was submitted rather than
  /// what was decided about it, and it does not touch
  /// `entrepreneurs/{uid}.isValid`, which is the separate question of whether
  /// the *person* is approved. Those two share a name and nothing else.
  ///
  /// Errors are left to propagate: the caller is a UI that has to tell the
  /// administrator the write failed, and it can only do that honestly if the
  /// failure reaches it.
  Future<void> setVendorDecision(
    String uid,
    String vendorId, {
    required bool accepted,
  }) {
    return FirebaseFirestore.instance
        .collection('entrepreneurs')
        .doc(uid)
        .collection('vendorDetails')
        .doc(vendorId)
        .update({'isAccepted': accepted, 'isRejected': !accepted});
  }
}
