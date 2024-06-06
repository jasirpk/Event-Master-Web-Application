import 'dart:ui';
import 'package:event_master_web/presentation_layer/components/appbar.dart';
import 'package:event_master_web/presentation_layer/components/auth_bottom_text.dart';
import 'package:event_master_web/presentation_layer/components/password_field.dart';
import 'package:event_master_web/presentation_layer/components/pushable_button.dart';
import 'package:event_master_web/presentation_layer/components/text_field.dart';
import 'package:event_master_web/presentation_layer/screens/signin.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
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
          buttonText: 'Login',
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return LoginScreen();
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
                image: AssetImage('assets/images/google_ath_img.jpg'),
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
                              'assets/images/Screenshot 2024-05-22 205021.png'),
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
                                  'Create New Account',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'JacquesFracois',
                                      fontSize: screenHeight * 0.08),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    "Looks like you don't have an account. Let's create a new account",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors
                                          .white, // Ensure text is readable on the dark background
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: TextFieldWidget(
                                    Controller: userEmailController,
                                    hintText: 'Email',
                                    obscureText: false,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: PasswordField(
                                    controller: userPasswordController,
                                    hintText: 'Password',
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  child: pushableButton_Widget(
                                    text: 'Sign UP',
                                    onPressed: () {},
                                  ),
                                ),
                                SizedBox(height: 20),
                                AuthBottomText(
                                    onpressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (ctx) {
                                        return LoginScreen();
                                      }));
                                    },
                                    text: 'Already have an account?',
                                    subText: 'Login')
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
