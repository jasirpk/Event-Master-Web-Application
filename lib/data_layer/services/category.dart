import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/data_layer/services/media_service.dart';
import 'package:flutter/material.dart';

/// Thrown by [DatabaseMethods.uploadImage] when the selected file's
/// extension isn't one the Media API accepts (image/jpeg, image/png,
/// image/webp). Caught internally so the existing "upload failed" flow
/// handles it the same way as any other upload failure.
class UnsupportedImageTypeException implements Exception {
  final String fileName;
  UnsupportedImageTypeException(this.fileName);

  @override
  String toString() =>
      'UnsupportedImageTypeException: "$fileName" is not a supported image type (allowed: .jpg, .jpeg, .png, .webp)';
}

/// Maps a selected file's extension to the MIME type the Media API accepts.
/// Throws [UnsupportedImageTypeException] for anything else, so an
/// unsupported file fails before the Media API is ever called.
String _mimeTypeFromFileName(String fileName) {
  final dotIndex = fileName.lastIndexOf('.');
  final extension =
      dotIndex == -1 ? '' : fileName.substring(dotIndex + 1).toLowerCase();
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'webp':
      return 'image/webp';
    default:
      throw UnsupportedImageTypeException(fileName);
  }
}

class DatabaseMethods {
  Future<bool> addVendorCategoryDetail(BuildContext context,Map<String, dynamic> categoryDetails, String id, String imageName, Uint8List imageBytes,
      {bool isEditing = false}) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('Categories').doc(id).get();

      if (docSnapshot.exists && isEditing) {
        await updateVendorCategoryDetail(context,id, categoryDetails);
        return true;
      } else {
        // Upload first, write Firestore only after a successful upload —
        // never the other way around, so a failed upload can't leave
        // Firestore pointing at an objectKey that doesn't exist in R2.
        String? objectKey = await uploadImage(id, imageName, imageBytes);

        if (objectKey != null) {
          categoryDetails['imagePath'] = objectKey;
          await FirebaseFirestore.instance.collection('Categories').doc(id).set(categoryDetails);
          log('Vendor category detail ${isEditing ? 'updated' : 'added'} successfully.');
          return true;
        } else {
          log('Failed to upload image. Category detail not ${isEditing ? 'updated' : 'added'}.');
          showCustomSnackBar(context, 'Error', 'Failed to upload the image. The category was not saved.');
          return false;
        }
      }
    } catch (e) {
      log('Error ${isEditing ? 'updating' : 'adding'} vendor category detail: $e');
      showCustomSnackBar(context, 'Error', 'Something went wrong. The category was not saved.');
      return false;
    }
  }

  Future<DocumentSnapshot> getCategoryDetailById(String id) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('Categories').doc(id).get();
      return docSnapshot;
    } catch (e) {
      log('Error fetching category detail by ID: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getVendorDetail() {
    return FirebaseFirestore.instance.collection('Categories').snapshots();
  }

  Future<void> updateVendorCategoryDetail(BuildContext context,String id, Map<String, dynamic> categoryDetails) async {
    try {
      await FirebaseFirestore.instance.collection('Categories').doc(id).update(categoryDetails);
      showCustomSnackBar(context, 'Success', 'Vendor category detail updated successfully.');
      log('Vendor category detail updated successfully.');
    } catch (e) {
      log('Error updating vendor category detail: $e');
      showCustomSnackBar(context,'Error', 'Failed to update category details. Please try again.');
    }
  }

  Future<void> deleteVendorCategoryDeatail(String id) async {
    try {
      await FirebaseFirestore.instance.collection('Categories').doc(id).delete();
      log('Vendor category detail deleted successfully.');
    } catch (e) {
      log('Error deleting vendor category detail: $e');
    }
  }

  /// Uploads [imageBytes] (the file named [imageName]) for category [id]
  /// through the Media API/R2 and returns the resulting R2 objectKey — not
  /// a download URL. [id] is passed through as MediaService's `entityId`,
  /// and MediaService/the Media API own the actual object-key shape; this
  /// method no longer constructs a Storage path itself.
  ///
  /// Returns null (and logs) on any failure — an unsupported file
  /// extension, a Media API error, or an R2 upload error — so callers can
  /// keep using their existing "imagePath == null" failure check.
  Future<String?> uploadImage(String id, String imageName, Uint8List imageBytes) async {
    try {
      final contentType = _mimeTypeFromFileName(imageName);
      final objectKey = await MediaService().uploadImage(
        bytes: imageBytes,
        entityId: id,
        fileName: imageName,
        contentType: contentType,
        folder: 'category_images',
      );

      log('Image uploaded successfully. objectKey: $objectKey');
      return objectKey;
    } catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }
}
