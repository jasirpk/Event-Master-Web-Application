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

  /// Listings the console has accepted.
  ///
  /// Only `isAccepted` is filtered. The two flags are set together by
  /// [updateIsAcceptedField] and [updateIsRejectedField], so a second
  /// `isRejected == false` filter added nothing — and it actively hid older
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

  Future<void> updateIsAcceptedField(String uid, String documentId,
      {required bool isAccepted, required bool isRejected}) async {
    try {
      CollectionReference vendorDetailsRef = FirebaseFirestore.instance
          .collection('entrepreneurs')
          .doc(uid)
          .collection('vendorDetails');

      await vendorDetailsRef
          .doc(documentId)
          .update({'isAccepted': isAccepted, 'isRejected': isRejected});

      print('isAccepted field updated successfully.');
    } catch (e) {
      log('Error updating isValid field: $e');
      throw Exception('Failed to update isValid field: $e');
    }
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

  Future<void> updateIsRejectedField(String uid, String documentId,
      {required bool isRejected, required bool isAccepted}) async {
    try {
      CollectionReference vendorDetailsRef = FirebaseFirestore.instance
          .collection('entrepreneurs')
          .doc(uid)
          .collection('vendorDetails');

      await vendorDetailsRef
          .doc(documentId)
          .update({'isRejected': isRejected, 'isAccepted': isAccepted});

      print('isRejected field updated successfully.');
    } catch (e) {
      log('Error updating isValid field: $e');
      throw Exception('Failed to update isValid field: $e');
    }
  }
}
