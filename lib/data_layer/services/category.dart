import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  Future<void> addVendorCategoryDetail(Map<String, dynamic> categoryDetails,
      String id, String imageName, Uint8List imageBytes,
      {bool isEditing = false}) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(id)
          .get();

      if (docSnapshot.exists && isEditing) {
        await updateVendorCategoryDetail(id, categoryDetails);
      } else {
        String? imagePath = await uploadImage(id, imageName, imageBytes);

        if (imagePath != null) {
          categoryDetails['imagePath'] = imagePath;
          await FirebaseFirestore.instance
              .collection('Categories')
              .doc(id)
              .set(categoryDetails);
          log('Vendor category detail ${isEditing ? 'updated' : 'added'} successfully.');
        } else {
          log('Failed to upload image. Category detail not ${isEditing ? 'updated' : 'added'}.');
        }
      }
    } catch (e) {
      log('Error ${isEditing ? 'updating' : 'adding'} vendor category detail: $e');
    }
  }

  Future<DocumentSnapshot> getCategoryDetailById(String id) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(id)
          .get();
      return docSnapshot;
    } catch (e) {
      log('Error fetching category detail by ID: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getVendorDetail() {
    return FirebaseFirestore.instance.collection('Categories').snapshots();
  }

  Future<void> updateVendorCategoryDetail(
      String id, Map<String, dynamic> categoryDetails) async {
    try {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(id)
          .update(categoryDetails);
      showCustomSnackBar(
          'Success', 'Vendor category detail updated successfully.');
      log('Vendor category detail updated successfully.');
    } catch (e) {
      log('Error updating vendor category detail: $e');
      showCustomSnackBar(
          'Error', 'Failed to update category details. Please try again.');
    }
  }

  Future<void> deleteVendorCategoryDeatail(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(id)
          .delete();
      log('Vendor category detail deleted successfully.');
    } catch (e) {
      log('Error deleting vendor category detail: $e');
    }
  }

  Future<String?> uploadImage(
      String id, String imageName, Uint8List imageBytes) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('category_images/$id/$imageName');
      UploadTask uploadTask = storageRef.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      String downloadUrl = await snapshot.ref.getDownloadURL();

      log('Image uploaded successfully. URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }
}
