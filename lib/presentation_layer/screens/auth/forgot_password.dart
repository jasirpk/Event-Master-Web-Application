import 'dart:ui';
import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/data_layer/services/forgot_password.dart';
import 'package:event_master_web/presentation_layer/components/ui/appbar.dart';
import 'package:event_master_web/presentation_layer/components/auth/pushable_button.dart';
import 'package:event_master_web/presentation_layer/components/auth/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final formKey = GlobalKey<FormState>();
  final userEmailController = TextEditingController();
  late final ResetPassword resetPassword;
  @override
  void initState() {
    resetPassword = ResetPassword(controller: userEmailController);
    super.initState();
  }

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
            Get.toNamed(RoutsClass.getLoginRout());
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/we_img.webp'),
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
                                  'Change Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'JacquesFracois',
                                      fontSize: screenHeight * 0.04),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Enter Your valid Email and we will send \nyou a password reset link",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors
                                            .white, // Ensure text is readable on the dark background
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
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
                                  child: pushableButton_Widget(
                                    text: 'Submit',
                                    onPressed: () async {
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        await resetPassword.sendResetLink();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
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
