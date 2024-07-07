import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/data_layer/services/user_profile/vendor_request.dart';
import 'package:event_master_web/presentation_layer/components/shimmer/alltemplates.dart';
import 'package:flutter/material.dart';

class BuildRequestWidget extends StatelessWidget {
  final String uid;

  const BuildRequestWidget({super.key, required this.uid});
  @override
  Widget build(BuildContext context) {
    final VendorRequest vendorRequest = VendorRequest();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
      stream: vendorRequest.getGeneratedCategoryDetails(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerSubCategoryItem(
              screenHeight: screenHeight, screenWidth: screenWidth);
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
        return Padding(
          padding: EdgeInsets.all(18.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index].data() as Map<String, dynamic>;
              String imagePath = data['imagePathUrl'];
              String documentId = documents[index].id;

              return FutureBuilder<DocumentSnapshot?>(
                future: vendorRequest.getCategoryDetailById(uid, documentId),
                builder: (context, detailSnapshot) {
                  if (detailSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ShimmerSubCategoryItem(
                        screenHeight: screenHeight, screenWidth: screenWidth);
                  }
                  if (detailSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${detailSnapshot.error}'),
                    );
                  }
                  if (!detailSnapshot.hasData || detailSnapshot.data == null) {
                    return Center(child: Text('Details not found'));
                  }
                  var vendorDetail =
                      detailSnapshot.data!.data() as Map<String, dynamic>;
                  bool isAccepted = vendorDetail['isAccepted'] ?? false;
                  bool isRejected = vendorDetail['isRejected'] ?? false;
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      width: screenWidth * 0.8,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenWidth * 0.20,
                            height: screenHeight * 0.17,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                                image: DecorationImage(
                                    image: imagePath.startsWith('http')
                                        ? NetworkImage(imagePath)
                                        : AssetImage(imagePath)
                                            as ImageProvider,
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vendorDetail['categoryName'],
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    vendorDetail['description'],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  SizedBox(height: 4.0),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: myColor,
                                        size: 20,
                                      ),
                                      SizedBox(width: 4.0),
                                      Expanded(
                                        child: Text(
                                          vendorDetail['location'],
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: screenHeight * 0.014,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await vendorRequest
                                              .updateIsAcceptedField(
                                                  uid, documentId,
                                                  isAccepted: true,
                                                  isRejected: false);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all<
                                                  Color>(
                                              myColor), // Ensure myColor is defined
                                        ),
                                        child: Text(
                                          isAccepted ? 'Accepted' : 'Accept',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      sizedBoxWidth,
                                      ElevatedButton(
                                          onPressed: () async {
                                            await vendorRequest
                                                .updateIsRejectedField(
                                                    uid, documentId,
                                                    isRejected: true,
                                                    isAccepted: false);
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all<
                                                      Color>(Colors.red)),
                                          child: Text(isRejected
                                              ? 'Rejected'
                                              : 'Reject')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PopupMenuButton(
                                onSelected: (value) async {
                                  if (value == 'View Detail') {
                                    // View Detail action
                                  } else if (value == 'delete') {
                                    // Delete action
                                  } else if (value == 'update') {
                                    // Update action
                                  }
                                },
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text('Delete'),
                                      value: 'delete',
                                    ),
                                    PopupMenuItem(
                                      child: Text('View Detail'),
                                      value: 'View Detail',
                                    ),
                                    PopupMenuItem(
                                      child: Text('Update'),
                                      value: 'update',
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
