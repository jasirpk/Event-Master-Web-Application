import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/data_layer/services/image_content_type.dart';
import 'package:event_master_web/data_layer/services/media_service.dart';
import 'package:flutter/cupertino.dart';

class SubDatabaseMethods {
  // Sub-categories operations
  /// Returns true only when the sub-category was actually written to
  /// Firestore, so callers don't report success after a failed upload.
  Future<bool> addSubCategory(
      BuildContext context,
      String categoryId,
      String subCategoryId,
      Map<String, dynamic> subCategoryDetails,
      Uint8List? imageBytes,
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
      showCustomSnackBar(context, 'Success', 'Sub-category added successfully');
      return true;
    } catch (e) {
      log('Error adding sub-category: $e');
      showCustomSnackBar(context, 'Error', 'Failed to add sub-category');
      return false;
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

  /// Uploads [imageBytes] (the file named [imageName]) for sub-category [id]
  /// through the Media API/R2 and returns the resulting R2 objectKey — not a
  /// download URL. The Media API owns the object-key shape; this method no
  /// longer builds a Storage path itself.
  ///
  /// Returns null (and logs) on any failure — an unsupported file extension,
  /// a Media API error, or an R2 upload error — so callers can keep using
  /// their existing "imagePath == null" failure check.
  Future<String?> uploadImage(
      String id, String imageName, Uint8List imageBytes) async {
    try {
      final contentType = imageContentTypeFromFileName(imageName);
      final objectKey = await MediaService().uploadImage(
        bytes: imageBytes,
        entityId: id,
        fileName: imageName,
        contentType: contentType,
        folder: 'subcategory_images',
      );

      log('Image uploaded successfully. objectKey: $objectKey');
      return objectKey;
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

  Future<void> updateSubCategory(BuildContext context, String categoryId,
      String subCategoryId, Map<String, dynamic> subCategoryDetails) async {
    try {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(categoryId)
          .collection('SubCategories')
          .doc(subCategoryId)
          .update(subCategoryDetails);
      showCustomSnackBar(
          context, 'Success', 'Sub-category updated successfully.');
      log('Sub-category updated successfully.');
    } catch (e) {
      log('Error updating sub-category detail: $e');
      showCustomSnackBar(context, 'Error',
          'Failed to update sub-category details. Please try again.');
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
