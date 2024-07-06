import 'package:event_master_web/common/style.dart';
import 'package:flutter/material.dart';

class BuildAcceptedWidget extends StatelessWidget {
  const BuildAcceptedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth *
                  0.8, // Set the width as a fraction of the screen width
              margin: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth *
                        0.20, // Adjust the width of the inner container
                    height: screenHeight * 0.17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey, // Just to make the container visible
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Description goes here',
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
                                  'Location',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.014,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 4),
                                decoration: BoxDecoration(
                                    color: myColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  'Tag',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenHeight * 0.010),
                                ),
                              ),
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
      ),
    );
  }
}
