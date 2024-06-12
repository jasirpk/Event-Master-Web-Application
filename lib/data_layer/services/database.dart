import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addVendorCategoryDetail(
      Map<String, dynamic> categoryDetails, String id, String imagePath) async {
    categoryDetails['imagePath'] =
        imagePath; // Adding image path to categoryDetails
    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(id)
        .set(categoryDetails);
  }

  Future<Stream<QuerySnapshot>> getVendorDetail() async {
    return await FirebaseFirestore.instance
        .collection('Categories')
        .snapshots();
  }
}
