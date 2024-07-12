import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/presentation_layer/components/users/richtext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VendorDetailScreen extends StatelessWidget {
  final String vendorName;
  final String vendorImage;
  final String location;
  final String description;
  final List<Map<String, dynamic>> images;
  final Map<String, double> budget;

  const VendorDetailScreen(
      {super.key,
      required this.vendorName,
      required this.vendorImage,
      required this.location,
      required this.description,
      required this.images,
      required this.budget});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(CupertinoIcons.back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 120, vertical: 80),
          child: Card(
            color: Colors.white12,
            child: Container(
              width: double.infinity,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      image: DecorationImage(
                        image: vendorImage.startsWith('http')
                            ? NetworkImage(vendorImage)
                            : AssetImage(vendorImage) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            RichTextWidget(
                                size: screenHeight * .034,
                                screenHeight: screenHeight,
                                suggestText: 'Vendor Name: ',
                                text: vendorName),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            Flexible(child: Text(location)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.attach_money),
                            Text(
                              '${budget['from']} - ${budget['to']}',
                              style: TextStyle(color: myColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Card(
                          child: Container(
                            height: 300,
                            child: ListView.builder(
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                var data = images[index];
                                return Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(Icons.arrow_right,
                                                  color: Colors.white),
                                              SizedBox(width: 10),
                                              Text(
                                                data['text'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        screenHeight * 0.028),
                                              ),
                                            ],
                                          ),
                                        ),
                                        CircleAvatar(
                                          maxRadius: 30,
                                          backgroundColor: Colors.blue,
                                          backgroundImage: data['imageUrl']
                                                  .startsWith('http')
                                              ? NetworkImage(data['imageUrl'])
                                              : AssetImage(data['imageUrl'])
                                                  as ImageProvider,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        sizedBox,
                        Row(
                          children: [
                            Text('About Us ',
                                style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: screenHeight * 0.026)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          child: Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      'In your case, the issue arises because List.generate is being nested directly inside a Column, which might cause the layout constraints to be violated. To fix this, you can use a ListView.builder inside a SizedBox with a fixed height, which will ensure proper rendering of the list items.',
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: screenHeight * 0.026)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
