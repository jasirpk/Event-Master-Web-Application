import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class VendorRequest {
  Future<DocumentSnapshot?> getCategoryDetailById(
      String uid, String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('generatedVendors')
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

  Stream<QuerySnapshot> getGeneratedCategoryDetails(String uid) {
    return FirebaseFirestore.instance
        .collection('generatedVendors')
        .doc(uid)
        .collection('vendorDetails')
        .where('isValid', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAcceptedVendorList(String uid) {
    return FirebaseFirestore.instance
        .collection('generatedVendors')
        .doc(uid)
        .collection('vendorDetails')
        .where('isAccepted', isEqualTo: true)
        .where('isRejected', isEqualTo: false)
        .snapshots();
  }

  Future<void> updateIsAcceptedField(String uid, String documentId,
      {required bool isAccepted, required bool isRejected}) async {
    try {
      CollectionReference vendorDetailsRef = FirebaseFirestore.instance
          .collection('generatedVendors')
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

  Stream<QuerySnapshot> getRejectedVendorList(String uid) {
    return FirebaseFirestore.instance
        .collection('generatedVendors')
        .doc(uid)
        .collection('vendorDetails')
        .where('isRejected', isEqualTo: true)
        .where('isAccepted', isEqualTo: false)
        .snapshots();
  }

  Future<void> updateIsRejectedField(String uid, String documentId,
      {required bool isRejected, required bool isAccepted}) async {
    try {
      CollectionReference vendorDetailsRef = FirebaseFirestore.instance
          .collection('generatedVendors')
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
