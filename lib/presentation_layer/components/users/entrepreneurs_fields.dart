import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/checklist.dart';
import 'package:event_master_web/presentation_layer/screens/dashboard/entrepreneur_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntrepreneursFieldsWidget extends StatelessWidget {
  const EntrepreneursFieldsWidget({
    super.key,
    required this.documentId,
    required this.screenHeight,
    required this.imagePath,
    required this.userDetail,
    required this.vendorDetail,
  });

  final String documentId;
  final double screenHeight;
  final String imagePath;
  final Map<String, dynamic> userDetail;
  final Map<String, dynamic> vendorDetail;

  @override
  Widget build(BuildContext context) {
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
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: imagePath.startsWith('http')
                ? NetworkImage(imagePath)
                : AssetImage(imagePath) as ImageProvider,
            fit: BoxFit.cover,
          ),
          border: Border.all(color: Colors.teal),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3)),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 8, top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        userDetail['companyName'],
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.028,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      onSelected: (value) async {
                        if (value == 'View Detail') {
                          Get.to(() => EntrepreneurDetailScreen(
                              companyName: userDetail['companyName'],
                              about: userDetail['description'],
                              phoneNumber: userDetail['phoneNumber'],
                              bussinessEmail: userDetail['emailAddress'],
                              website: userDetail['website'],
                              imagePath: imagePath,
                              links: List<Map<String, dynamic>>.from(
                                  userDetail['links']),
                              images: List<Map<String, dynamic>>.from(
                                  userDetail['images'])));
                        } else if (value == 'delete') {}
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
                      vendorDetail['location'],
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: screenHeight * 0.026,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
