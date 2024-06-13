import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  Future<void> addVendorCategoryDetail(Map<String, dynamic> categoryDetails,
      String id, String imageName, Uint8List imageBytes) async {
    try {
      // Upload image to Firebase Storage
      String? imagePath = await uploadImage(id, imageName, imageBytes);

      if (imagePath != null) {
        // Add image path to category details
        categoryDetails['imagePath'] = imagePath;

        // Add category details to Firestore
        await FirebaseFirestore.instance
            .collection('Categories')
            .doc(id)
            .set(categoryDetails);

        log('Vendor category detail added successfully.');
      } else {
        log('Failed to upload image. Category detail not added.');
      }
    } catch (e) {
      log('Error adding vendor category detail: $e');
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

  Stream<QuerySnapshot> getVendorDetail() {
    return FirebaseFirestore.instance.collection('Categories').snapshots();
  }
}
