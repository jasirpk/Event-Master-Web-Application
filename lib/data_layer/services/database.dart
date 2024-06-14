import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ..............................CRUD Operations.......................!

// Create...!

class DatabaseMethods {
  Future<void> addVendorCategoryDetail(Map<String, dynamic> categoryDetails,
      String id, String imageName, Uint8List imageBytes,
      {bool isEditing = false}) async {
    try {
      // Check if the document already exists
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(id)
          .get();

      if (docSnapshot.exists && isEditing) {
        // Update existing document
        await updateVendorCategoryDetail(
            id, categoryDetails, imageName, imageBytes);
      } else {
        // Upload image to Firebase Storage
        String? imagePath = await uploadImage(id, imageName, imageBytes);

        if (imagePath != null) {
          // Add image path to category details
          categoryDetails['imagePath'] = imagePath;

          // Add or update category details in Firestore
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

// read...!

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
  // Update...!

  Future<void> updateVendorCategoryDetail(
      String id,
      Map<String, dynamic> categoryDetails,
      String imageName,
      Uint8List imageBytes) async {
    try {
      // Check if image needs to be updated
      if (imageName.isNotEmpty && imageBytes.isNotEmpty) {
        // Upload new image to Firebase Storage
        String? imagePath = await uploadImage(id, imageName, imageBytes);
        if (imagePath != null) {
          // Update image path in category details
          categoryDetails['imagePath'] = imagePath;
        } else {
          log('Failed to upload new image. Image not updated.');
        }
      }

      // Update category details in Firestore
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(id)
          .update(categoryDetails);

      log('Vendor category detail updated successfully.');
    } catch (e) {
      log('Error updating vendor category detail: $e');
    }
  }

  // delete...!
  Future<void> deleteVendorCategoryDeatail(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(id)
          .delete();
      log('vendor category detail deleted Successfully');
    } catch (e) {
      log('Error deleting vendor category detail: $e');
    }
  }

  Future<String?> uploadImage(
      String id, String imageName, Uint8List imageBytes) async {
    try {
      log('Uploading image...');
      Reference ref =
          FirebaseStorage.instance.ref().child('categories/$id/$imageName');
      final meta = SettableMetadata(contentType: "image/jpeg");
      await ref.putData(imageBytes, meta);
      String url = await ref.getDownloadURL();
      log('Image uploaded successfully. URL: $url');
      return url;
    } catch (e) {
      log('There is an error in image uploading: $e');
      return null;
    }
  }
}
