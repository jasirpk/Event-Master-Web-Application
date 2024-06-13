import 'dart:ui';
import 'package:event_master_web/bussiness_layer/models/logic_models/admin_detail.dart';
import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:event_master_web/bussiness_layer/repos/snackbar.dart';
import 'package:event_master_web/data_layer/auth_bloc/auth_bloc.dart';
import 'package:event_master_web/presentation_layer/components/ui/appbar.dart';
import 'package:event_master_web/presentation_layer/components/auth/auth_bottom_text.dart';
import 'package:event_master_web/presentation_layer/components/auth/password_field.dart';
import 'package:event_master_web/presentation_layer/components/auth/pushable_button.dart';
import 'package:event_master_web/presentation_layer/components/auth/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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
            Get.toNamed(RoutsClass.getLoginRout());
          },
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomSnackBar('Success', 'Successfully Added');
              Get.offAllNamed(RoutsClass.getHomeRout());
            });
          } else if (state is ValidationSuccess) {
            UserModel user = UserModel(
                email: userEmailController.text,
                password: userPasswordController.text);
            context.read<AuthBloc>().add(SignUp(userModel: user));
          } else if (state is AuthenticatedErrors) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomSnackBar('Error', 'Account Not Registered');
            });
          }
        },
        child: Stack(
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
                                    'Create New Account',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'JacquesFracois',
                                        fontSize: screenHeight * 0.04),
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
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          final email =
                                              userEmailController.text;
                                          final password =
                                              userPasswordController.text;
                                          context.read<AuthBloc>().add(SignUp(
                                              userModel: UserModel(
                                                  email: email,
                                                  password: password)));
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  AuthBottomText(
                                      onpressed: () {
                                        Get.toNamed(RoutsClass.getLoginRout());
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
      ),
    );
  }
}
