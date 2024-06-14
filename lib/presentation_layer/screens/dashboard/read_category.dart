import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/presentation_layer/components/ui/custom_appbar.dart';
import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> categoryData;

  CategoryDetailScreen({required this.categoryData});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(screenWidth, screenHeight * 0.1),
          child: CusotmAppBar(),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: screenHeight * 0.6,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(categoryData['imagePath']),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      categoryData['categoryName'],
                      style: TextStyle(
                          fontSize: screenHeight * 0.06,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 12, top: 12),
                child: Row(
                  children: [
                    Text(
                      'Author:',
                      style: TextStyle(
                          color: Colors.blue, fontSize: screenHeight * 0.022),
                    ),
                    sizedBoxWidth,
                    Text(
                      categoryData['value'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.022,
                          letterSpacing: 2),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 12, top: 12),
                child: Row(
                  children: [
                    Text(
                      categoryData['description'],
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: screenHeight * 0.022,
                          letterSpacing: 2),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
