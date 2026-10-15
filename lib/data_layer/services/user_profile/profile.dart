import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  Stream<QuerySnapshot> getUserProfile() {
    return FirebaseFirestore.instance
        .collection('entrepreneurs')
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  /// Marks an entrepreneur's profile discoverable to consumers.
  ///
  /// This is the *profile* flag — `entrepreneurs/{uid}.isValid` — and is a
  /// different decision from accepting a vendor listing, which sets
  /// `isAccepted` on a document in the `vendorDetails` subcollection. The two
  /// share a field name in places and nothing else.
  ///
  /// Writes exactly one field. `update()` rather than `set()` so nothing else
  /// on the document can be touched, and in particular so the rating
  /// aggregate stays intact — the security rules reject an admin write that
  /// changes it, and a wider payload here would simply be refused.
  ///
  /// [uid] always comes from the document being displayed, never from
  /// anything an operator typed.
  ///
  /// Authorization is the rules' job, not this method's: only a caller whose
  /// token carries `role: "admin"` may change this field.
  Future<void> approveEntrepreneur(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('entrepreneurs')
          .doc(uid)
          .update({'isValid': true});

      log('Entrepreneur $uid approved.');
    } catch (e) {
      log('Error approving entrepreneur: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot> getUserDetailById(String uid) async {
    try {
      DocumentSnapshot docSanpshot = await FirebaseFirestore.instance
          .collection('entrepreneurs')
          .doc(uid)
          .get();
      return docSanpshot;
    } catch (e) {
      log('Error fetching category detail by ID: $e');
      print('Data Can\'t find in database');
      rethrow;
    }
  }
}
