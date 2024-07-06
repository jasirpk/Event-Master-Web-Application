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
}
