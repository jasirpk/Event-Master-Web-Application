import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemplateCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  TemplateCard(this.screenWidth, this.screenHeight);

  final DatabaseMethods _databaseMethods = DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: const Color(0xFF263238), // Dark theme background color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Add Templates',
                  style: TextStyle(
                    fontSize: screenHeight * 0.022,
                    color: Colors.white, // White text for contrast
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Get.toNamed(RoutsClass.getFormRout());
                    },
                    icon: Icon(Icons.add))
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _databaseMethods.getVendorDetail(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No Templates Found',
                        style: TextStyle(
                          color: Colors.white, // White text for consistency
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.builder(
                          physics:
                              NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                          shrinkWrap: true, // Take up only necessary space
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 4 / 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xFF37474F), // Another shade of grey
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  data['categoryName'] ?? 'No Name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenHeight * 0.022,
                                    color: Colors
                                        .white, // White text for readability
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatabaseMethods {
  Future<void> addVendorCategoryDetail(
      Map<String, dynamic> categoryDetails, String id, String imagePath) async {
    categoryDetails['imagePath'] =
        imagePath; // Adding image path to categoryDetails
    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(id)
        .set(categoryDetails);
  }

  Stream<QuerySnapshot> getVendorDetail() {
    return FirebaseFirestore.instance.collection('Categories').snapshots();
  }
}
