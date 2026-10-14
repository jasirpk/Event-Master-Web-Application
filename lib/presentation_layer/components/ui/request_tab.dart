import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/data_layer/models/vendor_document.dart';
import 'package:event_master_web/data_layer/services/user_profile/vendor_request.dart';
import 'package:event_master_web/presentation_layer/components/shimmer/alltemplates.dart';
import 'package:event_master_web/presentation_layer/components/media/media_image.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/vendor_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          return ShimmerSubCategoryItem(screenHeight: screenHeight, screenWidth: screenWidth);
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
              // The stream already delivered this document. Re-fetching it
              // per row cost one extra read per vendor on every rebuild and
              // told us nothing new.
              final vendorDetail = documents[index].data() as Map<String, dynamic>;
              final String imagePath = vendorDetail['imagePathUrl'] as String? ?? '';
              final String documentId = documents[index].id;
              final bool isAccepted = vendorDetail['isAccepted'] == true;
              final bool isRejected = vendorDetail['isRejected'] == true;

              return InkWell(
                onTap: () {
                  Get.to(() => VendorDetailScreen(
                      vendorName: vendorText(vendorDetail['categoryName']),
                      vendorImage: imagePath,
                      location: vendorText(vendorDetail['location']),
                      description: vendorText(vendorDetail['description']),
                      images: vendorImages(vendorDetail['images']),
                      // Not Map<String,double>.from: a budget written by the
                      // Media API arrives as Firestore integers, and that cast
                      // throws "type 'int' is not a subtype of type 'double'".
                      budget: vendorBudget(vendorDetail['budget'])));
                },
                child: Padding(
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
                        // imagePathUrl is an R2 object key since the
                        // migration, so it needs signing. startsWith('http')
                        // sent it to AssetImage, which asked Flutter for a
                        // bundled asset named "vendor_images/..." and threw.
                        MediaImage(
                          imagePath: imagePath,
                          placeholder: kMediaPlaceholderImage,
                          builder: (context, image) => Container(
                            width: screenWidth * 0.20,
                            height: screenHeight * 0.17,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                                image: image == null ? null : DecorationImage(image: image, fit: BoxFit.cover)),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vendorText(vendorDetail['categoryName']),
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  vendorText(vendorDetail['description']),
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
                                        vendorText(vendorDetail['location']),
                                        maxLines: 1,
                                        style: TextStyle(fontSize: screenHeight * 0.014, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await vendorRequest.updateIsAcceptedField(uid, documentId, isAccepted: true, isRejected: false);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all<Color>(myColor), // Ensure myColor is defined
                                      ),
                                      child: Text(
                                        isAccepted ? 'Accepted' : 'Accept',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    sizedBoxWidth,
                                    ElevatedButton(
                                        onPressed: () async {
                                          await vendorRequest.updateIsRejectedField(uid, documentId, isRejected: true, isAccepted: false);
                                        },
                                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.red)),
                                        child: Text(isRejected ? 'Rejected' : 'Reject')),
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
                                if (value == 'View Detail') {}
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: Text('View Detail'),
                                    value: 'View Detail',
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
