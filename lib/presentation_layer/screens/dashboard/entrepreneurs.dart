import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/data_layer/services/user_profile/profile.dart';
import 'package:event_master_web/data_layer/services/user_profile/vendor_request.dart';
import 'package:event_master_web/presentation_layer/components/shimmer/entrepreneurs.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/checklist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class EntrepreneursListScreen extends StatelessWidget {
  const EntrepreneursListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = UserProfile();
    final VendorRequest vendorRequest = VendorRequest();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Entrepreneurs',
                    style: TextStyle(
                      fontSize: screenHeight * 0.024,
                      color: Colors.white,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: userProfile.getUserProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No Templates Found'),
                    );
                  }
                  final documents = snapshot.data!.docs;
                  return MasonryGridView.count(
                    crossAxisCount: 3,
                    itemCount: documents.length,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemBuilder: (context, index) {
                      var data =
                          documents[index].data() as Map<String, dynamic>;
                      String imagePath = data['profileImage'];
                      String documentId = documents[index].id;

                      return FutureBuilder<DocumentSnapshot>(
                        future: userProfile.getUserDetailById(documentId),
                        builder: (context, detailSnapshot) {
                          if (detailSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ShimmerEntrepreneurs(
                                screenHeight: screenHeight,
                                screenWidth: screenWidth);
                          }
                          if (detailSnapshot.hasError) {
                            return Center(
                              child: Text('Error: ${detailSnapshot.error}'),
                            );
                          }
                          if (!detailSnapshot.hasData ||
                              detailSnapshot.data == null) {
                            return Center(child: Text('Details not found'));
                          }
                          var userDetail = detailSnapshot.data!.data()
                              as Map<String, dynamic>;
                          return StreamBuilder<QuerySnapshot>(
                              stream: vendorRequest
                                  .getGeneratedCategoryDetails(documentId),
                              builder: (context, snapshot) {
                                return FutureBuilder<QuerySnapshot>(
                                    future: vendorRequest
                                        .getGeneratedCategoryDetails(documentId)
                                        .first,
                                    builder: (context, vendorSnapshot) {
                                      if (vendorSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return ShimmerEntrepreneurs(
                                            screenHeight: screenHeight,
                                            screenWidth: screenWidth);
                                      }
                                      if (vendorSnapshot.hasError) {
                                        return Center(
                                          child: Text(
                                              'Error: ${vendorSnapshot.error}'),
                                        );
                                      }
                                      if (!vendorSnapshot.hasData ||
                                          vendorSnapshot.data!.docs.isEmpty) {
                                        return Center(
                                            child: Text(
                                                'Vendor Details not found'));
                                      }
                                      var vendorDetail =
                                          vendorSnapshot.data!.docs.first.data()
                                              as Map<String, dynamic>;
                                      return InkWell(
                                        onTap: () {
                                          Get.to(() => ChecklistScreen(
                                                uid: documentId,
                                              ));
                                        },
                                        child: Container(
                                          height: screenHeight * 0.3,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF37474F),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image:
                                                  imagePath.startsWith('http')
                                                      ? NetworkImage(imagePath)
                                                      : AssetImage(imagePath)
                                                          as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                            border:
                                                Border.all(color: Colors.teal),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3)),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8, top: 8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          userDetail[
                                                              'companyName'],
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                screenHeight *
                                                                    0.028,
                                                            letterSpacing: 1,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      PopupMenuButton(
                                                        onSelected:
                                                            (value) async {
                                                          if (value ==
                                                              'View Detail') {
                                                          } else if (value ==
                                                              'delete') {}
                                                        },
                                                        itemBuilder: (context) {
                                                          return [
                                                            PopupMenuItem(
                                                              child: Text(
                                                                  'Delete'),
                                                              value: 'delete',
                                                            ),
                                                            PopupMenuItem(
                                                              child: Text(
                                                                  'View Detail'),
                                                              value:
                                                                  'View Detail',
                                                            ),
                                                          ];
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: myColor,
                                                        size: 20,
                                                      ),
                                                      Text(
                                                        vendorDetail[
                                                            'location'],
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize:
                                                                screenHeight *
                                                                    0.026,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              });
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
