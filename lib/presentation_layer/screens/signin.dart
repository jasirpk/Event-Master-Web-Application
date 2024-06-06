import 'dart:ui';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/presentation_layer/components/appbar.dart';
import 'package:event_master_web/presentation_layer/components/auth_bottom_text.dart';
import 'package:event_master_web/presentation_layer/components/password_field.dart';
import 'package:event_master_web/presentation_layer/components/pushable_button.dart';
import 'package:event_master_web/presentation_layer/components/squretile.dart';
import 'package:event_master_web/presentation_layer/components/text_field.dart';
import 'package:event_master_web/presentation_layer/screens/signup.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenWidth, 100),
        child: AppBarWidget(
          buttonText: 'Sign Up',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return SignupScreen();
            }));
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_background_img.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          SingleChildScrollView(
            child: Center(
              child: Container(
                width: screenWidth * 0.9,
                constraints: BoxConstraints(
                  maxWidth: 600,
                ),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/Screenshot 2024-05-22 205021.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                          padding: EdgeInsets.all(16.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Text(
                                  'Login With Registered Account',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenHeight * 0.08,
                                      fontFamily: 'JacquesFracois'),
                                ),
                                sizedBox,
                                TextFieldWidget(
                                  Controller: userEmailController,
                                  hintText: 'Email',
                                  obscureText: false,
                                ),
                                SizedBox(height: 16),
                                PasswordField(
                                  controller: userPasswordController,
                                  hintText: 'Password',
                                ),
                                SizedBox(height: 16),
                                pushableButton_Widget(
                                  text: 'Login',
                                  onPressed: () {},
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Or',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SqureTile(
                                      onpressed: () {},
                                      imagePath: 'assets/images/google.png',
                                      title: 'Continue with Google',
                                    ),
                                    SizedBox(height: 16),
                                    AuthBottomText(
                                      onpressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (ctx) {
                                          return SignupScreen();
                                        }));
                                      },
                                      text: 'Don\'t have an account?',
                                      subText: ' Create One',
                                    ),
                                    SizedBox(height: 16),
                                    AuthBottomText(
                                      onpressed: () {},
                                      text: 'Forgot Password?',
                                      subText: 'click',
                                    ),
                                  ],
                                ),
                              ],
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
        ],
      ),
    );
  }
}
