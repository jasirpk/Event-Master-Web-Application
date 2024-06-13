import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/data_layer/auth_bloc/auth_bloc.dart';
import 'package:event_master_web/presentation_layer/components/ui/image_card.dart';
import 'package:event_master_web/presentation_layer/components/ui/silver_appbar.dart';
import 'package:event_master_web/presentation_layer/components/ui/template_card.dart';
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
        child: CustomScrollViewWidget(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
      ),
    );
  }
}

class CustomScrollViewWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  CustomScrollViewWidget(
      {required this.screenWidth, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SilverStackAppBar(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
        SliverToBoxAdapter(child: SizedBox(height: 20)),
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
                    flex: 1, child: TemplateCard(screenWidth, screenHeight)),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: ImageCard(screenWidth, screenHeight),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
