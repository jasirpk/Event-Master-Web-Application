import 'package:event_master_web/presentation_layer/screens/signin.dart';
import 'package:event_master_web/presentation_layer/screens/signup.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 100),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: AppBar(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/images/Screenshot 2024-05-22 205021.png',
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.1,
                fit: BoxFit.contain,
              ),
            ),
            title: Text(
              'Event Master',
              style: TextStyle(
                  fontFamily: 'JacquesFracois',
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return LoginScreen();
                  }));
                },
                child: Text('Login'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (ctx) => SignupScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.teal),
                ),
                child: Text(
                  'SignUp',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/coktail_category.jpg',
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Change Your Mind To \nBecome Success',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(Colors.teal),
                              ),
                              child: Text(
                                'Get Started',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 10),
                              child: Text(
                                ''' "One of the crucial roles of the Super Admin Web App is to validate and approve admin profiles.This feature ensures that  only verified and legitimate event planners and vendors are allowed to operate on the platform. It involves a thorough review process to maintain the integrity and reliability of the services offered" ''',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
