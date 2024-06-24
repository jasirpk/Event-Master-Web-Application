import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SubDatabaseMethods {
  // Sub-categories operations
  Future<void> addSubCategory(String categoryId, String subCategoryId,
      Map<String, dynamic> subCategoryDetails, Uint8List? imageBytes,
      {bool isEditing = false}) async {
    try {
      String? imagePath;

      if (imageBytes != null) {
        imagePath = await uploadImage(
            subCategoryId, subCategoryDetails['image'], imageBytes);
        if (imagePath != null) {
          subCategoryDetails['imagePath'] = imagePath;
        } else {
          throw 'Failed to upload image';
        }
      }

      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(categoryId)
          .collection('SubCategories')
          .doc(subCategoryId)
          .set(subCategoryDetails);

      log('Sub-category added successfully');
      showCustomSnackBar('Success', 'Sub-category added successfully');
    } catch (e) {
      log('Error adding sub-category: $e');
      showCustomSnackBar('Error', 'Failed to add sub-category');
    }
  }

  Future<DocumentSnapshot> getSubCategoryById(
      String categoryId, String subCategoryId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(categoryId)
          .collection('SubCategories')
          .doc(subCategoryId)
          .get();
      return docSnapshot;
    } catch (e) {
      log('Error fetching sub-category detail by ID: $e');
      rethrow;
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

  Stream<QuerySnapshot> getSubCategories(String categoryId) {
    return FirebaseFirestore.instance
        .collection('Categories')
        .doc(categoryId)
        .collection('SubCategories')
        .snapshots();
  }

  Future<void> updateSubCategory(String categoryId, String subCategoryId,
      Map<String, dynamic> subCategoryDetails) async {
    try {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(categoryId)
          .collection('SubCategories')
          .doc(subCategoryId)
          .update(subCategoryDetails);
      showCustomSnackBar('Success', 'Sub-category updated successfully.');
      log('Sub-category updated successfully.');
    } catch (e) {
      log('Error updating sub-category detail: $e');
      showCustomSnackBar(
          'Error', 'Failed to update sub-category details. Please try again.');
    }
  }

  Future<void> deleteSubCategory(
      String categoryId, String subCategoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(categoryId)
          .collection('SubCategories')
          .doc(subCategoryId)
          .delete();
      log('Sub-category deleted successfully.');
    } catch (e) {
      log('Error deleting sub-category detail: $e');
    }
  }
}
