import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:event_master_web/data_layer/services/sub_category.dart';

class SubCategoryWidget extends StatelessWidget {
  final String templateId;
  final SubDatabaseMethods subDatabaseMethods = SubDatabaseMethods();

  SubCategoryWidget({Key? key, required this.templateId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: subDatabaseMethods.getSubCategories(templateId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No Templates Found for $templateId',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        var documents = snapshot.data!.docs;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics:
                    NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  var document = documents[index];
                  var data = document.data() as Map<String, dynamic>;
                  String imagePath =
                      data['imagePath'] ?? 'assets/images/default.png';
                  String subCategoryId = document.id;

                  return FutureBuilder<DocumentSnapshot>(
                    future: subDatabaseMethods.getSubCategoryById(
                        templateId, subCategoryId),
                    builder: (context, detailSnapshot) {
                      if (detailSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!detailSnapshot.hasData ||
                          detailSnapshot.data == null ||
                          detailSnapshot.data!.data() == null) {
                        return Center(
                          child: Text(
                            'Details not found for $subCategoryId',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      var detailData =
                          detailSnapshot.data!.data() as Map<String, dynamic>;

                      return Container(
                        height: MediaQuery.of(context).size.height * 0.018,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imagePath.startsWith('http')
                                  ? NetworkImage(imagePath)
                                  : AssetImage(imagePath) as ImageProvider,
                              fit: BoxFit.cover),
                          color: Color(0xFF37474F),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.teal),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              detailData['subCategoryName'] ?? 'No Name',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
