import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addCategoryDetail(
      Map<String, dynamic> categoryDetails, String id, String imagePath) async {
    categoryDetails['imagePath'] =
        imagePath; // Adding image path to categoryDetails
    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(id)
        .set(categoryDetails);
  }
}
