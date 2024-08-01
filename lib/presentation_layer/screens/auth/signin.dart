import 'dart:ui';
import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/common/style.dart';
import 'package:event_master_web/data_layer/auth_bloc/auth_bloc.dart';
import 'package:event_master_web/presentation_layer/components/ui/appbar.dart';
import 'package:event_master_web/presentation_layer/components/auth/auth_bottom_text.dart';
import 'package:event_master_web/presentation_layer/components/auth/password_field.dart';
import 'package:event_master_web/presentation_layer/components/auth/pushable_button.dart';
import 'package:event_master_web/presentation_layer/components/auth/text_field.dart';
import 'package:event_master_web/presentation_layer/screens/auth/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Get.offAllNamed(RoutsClass.getHomeRout());
          showCustomSnackBar('Success', 'Successfully Added');
        } else if (state is AuthenticatedErrors) {
          showCustomSnackBar('Error', 'Account Not Registered');
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(screenWidth, 100),
          child: AppBarWidget(
            buttonText: 'Sign Up',
            onPressed: () {
              Get.toNamed(RoutsClass.getSignUpRoute());
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
                                    'Login ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenHeight * 0.04,
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
                                    onPressed: () {
                                      final email = userEmailController.text;
                                      final password =
                                          userPasswordController.text;
                                      if (email.isEmpty || password.isEmpty) {
                                        showCustomSnackBar('Error!',
                                            'please Fill All Fields !');
                                        return;
                                      }
                                      authBloc.add(LoginEvent(
                                          email: email, password: password));
                                    },
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
                                      AuthBottomText(
                                        onpressed: () {
                                          Get.toNamed(
                                              RoutsClass.getSignUpRoute());
                                        },
                                        text: 'Don\'t have an account?',
                                        subText: ' Create One',
                                      ),
                                      SizedBox(height: 16),
                                      AuthBottomText(
                                        onpressed: () {
                                          Get.to(() => ChangePassword());
                                        },
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
      ),
    );
  }
}
