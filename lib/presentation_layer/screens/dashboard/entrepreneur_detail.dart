import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/presentation_layer/components/users/richtext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntrepreneurDetailScreen extends StatelessWidget {
  final String companyName;
  final String about;
  final String phoneNumber;
  final String bussinessEmail;
  final String website;
  final String imagePath;
  final List<Map<String, dynamic>> links;
  final List<Map<String, dynamic>> images;

  const EntrepreneurDetailScreen(
      {super.key,
      required this.companyName,
      required this.about,
      required this.phoneNumber,
      required this.bussinessEmail,
      required this.website,
      required this.imagePath,
      required this.links,
      required this.images});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                  Stack(clipBehavior: Clip.none, children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        image: DecorationImage(
                          image: AssetImage('assets/images/we_img.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: -70,
                        left: (screenWidth - 100) / 2 - 150,
                        child: CircleAvatar(
                          backgroundImage: imagePath.startsWith('http')
                              ? NetworkImage(imagePath)
                              : AssetImage(imagePath) as ImageProvider,
                          radius: 80,
                          backgroundColor: Colors.blue,
                        ))
                  ]),
                  SizedBox(height: 80),
                  Text(companyName,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              RichTextWidget(
                                size: screenHeight * 0.026,
                                screenHeight: screenHeight,
                                text: bussinessEmail,
                                suggestText: 'Email Address:',
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Row(
                            children: [
                              RichTextWidget(
                                size: screenHeight * 0.026,
                                screenHeight: screenHeight,
                                text: phoneNumber,
                                suggestText: 'Phone Number:',
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Row(
                            children: [
                              RichTextWidget(
                                size: screenHeight * 0.026,
                                screenHeight: screenHeight,
                                text: website,
                                suggestText: 'Website:',
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Row(
                            children: [
                              Text('links ',
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      fontSize: screenHeight * 0.026)),
                              Icon(
                                Icons.link,
                              ),
                            ],
                          ),
                          sizedBox,
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Card(
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, indext) {
                                    var data = links[indext];
                                    return Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              data['link'],
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor: Colors.blue),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return sizedBox;
                                  },
                                  itemCount: links.length),
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
                          sizedBox,
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Card(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(about,
                                          style: TextStyle(
                                              letterSpacing: 1,
                                              fontSize: screenHeight * 0.026)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          sizedBox,
                          Row(
                            children: [
                              Text('Media ',
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      fontSize: screenHeight * 0.026)),
                            ],
                          ),
                          sizedBox,
                          GridView.builder(
                              shrinkWrap: true,
                              itemCount: images.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 220,
                              ),
                              itemBuilder: (context, index) {
                                var data = images[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: data['image'].startsWith('http')
                                            ? NetworkImage(data['image'])
                                            : AssetImage(data['image'])
                                                as ImageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
