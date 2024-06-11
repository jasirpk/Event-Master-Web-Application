import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/data_layer/auth_bloc/auth_bloc.dart';
import 'package:event_master_web/presentation_layer/components/bottom_sheet.dart';
import 'package:event_master_web/presentation_layer/components/silver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenWidth, screenHeight * 0.1),
        child: AppBar(
          leading: ClipOval(
            child: Image.asset(
              'assets/images/Screenshot 2024-05-22 205021.png',
              filterQuality: FilterQuality.high,
              fit: BoxFit.fill,
            ),
          ),
          title: Text(
            'Event Master',
            style: TextStyle(
              fontFamily: 'JacquesFrancois',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
            sizedBoxWidth,
            IconButton(onPressed: () {}, icon: Icon(Icons.message)),
            sizedBoxWidth,
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(Logout());
              },
              icon: Icon(Icons.logout),
            ),
            sizedBoxWidth,
          ],
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Get.offAllNamed(RoutsClass.getLoginRout());
          }
        },
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SilverStackAppBar(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                SliverToBoxAdapter(child: SizedBox(height: 40)),
                SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.8,
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 380,
                            decoration: BoxDecoration(
                              // color: Color.fromARGB(255, 39, 49, 49),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Templates',
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.022,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  InkWell(
                                    onTap: () =>
                                        Get.toNamed(RoutsClass.getFormRout()),
                                    child: Container(
                                      height: 228,
                                      width: 228,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Add Template \n +',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenHeight * 0.022,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 440,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/all_projects_right_image.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 40)),
                SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.06,
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
            BottomSheetWidget(),
          ],
        ),
      ),
    );
  }
}
