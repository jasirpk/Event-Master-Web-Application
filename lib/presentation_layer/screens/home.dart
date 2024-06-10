import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/data_layer/bloc/auth_bloc.dart';
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
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Color.fromARGB(255, 39, 49, 49),
              expandedHeight: 380,
              // pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Image.asset(
                              'assets/images/admin_image.png',
                              fit: BoxFit.cover,
                              width: constraints.maxWidth * 0.3,
                              height: constraints.maxHeight,
                            ),
                          ),
                          sizedBoxWidth,
                          Flexible(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Templates',
                                  style:
                                      TextStyle(fontSize: screenHeight * 0.022),
                                ),
                                sizedBox,
                                Container(
                                  height: constraints.maxHeight * 0.6,
                                  width: constraints.maxWidth * 0.2,
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
                                          letterSpacing: 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
            SliverToBoxAdapter(child: SizedBox(height: 40)),
            SilverStackAppBar(
                screenWidth: screenWidth, screenHeight: screenHeight),
          ],
        ),
      ),
    );
  }
}
