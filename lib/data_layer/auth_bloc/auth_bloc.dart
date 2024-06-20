import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/models/logic_models/admin_detail.dart';
import 'package:event_master_web/bussiness_layer/models/ui_models/routs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isPasswordVisible = false;
  AuthBloc() : super(AuthInitial()) {
    // Login status...!

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final UserCredential = await auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        final user = UserCredential.user!;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        String platform = userDoc['platform'];
        if (platform == 'web') {
          await saveAuthState(user.uid, user.email!);
          print('Account is Authenticated');

          emit(Authenticated(
              UserModel(uid: user.uid, email: user.email, password: '')));
        } else {
          emit(AuthenticatedErrors(message: 'Not Authenticated this Platform'));
          print('Authentication Failed: Not Authenticated for this platform');
        }
      } catch (e) {
        emit(AuthenticatedErrors(message: 'Not Authenticated'));
        print('Authentication Failed  $e');
      }
    });

// Sign UP...!

    on<SignUp>((event, emit) async {
      emit(AuthLoading());
      try {
        final UserCredential = await auth.createUserWithEmailAndPassword(
            email: event.userModel.email.toString(),
            password: event.userModel.password.toString());
        final user = UserCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'email': user.email,
            'password': event.userModel.password,
            'platform': 'web',
            'createAt': DateTime.now()
          });
          await FirebaseAuth.instance.currentUser!.getIdToken(true);
          await FirebaseAuth.instance.currentUser!
              .updateProfile(displayName: 'web');
          await saveAuthState(user.uid, user.email!);

          log('Account is Authenticated');
          print('Current FirebaseAuth user UID: ${user.uid}');
          print('Current FirebaseAuth user Email: ${user.email}');
          emit(Authenticated(
              UserModel(uid: user.uid, email: user.email!, password: '')));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedErrors(message: 'Creation Failed'));
        print('Authentication Faile $e');
      }
    });

// is Registerd...!

    on<CheckUsrEvent>((event, emit) async {
      emit(AuthLoading());

      await Future.delayed(Duration(seconds: 2));
      final prefs = await SharedPreferences.getInstance();
      final uid = await prefs.getString('uid');
      final email = await prefs.getString('email');

      print('SharedPreferences UID: $uid');
      print('SharedPreferences Email: $email');

      if (uid != null) {
        print('User found in sharedPreferenc');
        Get.offAllNamed(RoutsClass.getHomeRout());
        emit(Authenticated(UserModel(uid: uid, email: email, password: '')));
      } else {
        print('User NOt found in FirebaseAuth');
        emit(UnAuthenticated());
        Get.offAllNamed(RoutsClass.getSplashRoute());
        final user = auth.currentUser;

        if (user != null) {
          print('User Fount in FireBase');
          Get.offAllNamed(RoutsClass.getHomeRout());
          emit(Authenticated(UserModel(uid: uid, email: email, password: '')));
        } else {
          emit(UnAuthenticated());
          print('User Not found in FirebaseAuth');
          Get.offAllNamed(RoutsClass.getSplashRoute());
        }
      }
    });

// Handle Logout..!

    on<Logout>((event, emit) async {
      try {
        await auth.signOut();
        cleareAuthState();
        emit(UnAuthenticated());
      } catch (e) {
        emit(AuthenticatedErrors(message: e.toString()));
      }
    });

    // .....................Validation............!

    on<TextFieldTextChanged>(validateTextField);
    on<TextFieldPasswordChanged>(validatePasswordField);
    on<TogglePasswordVisiblility>(togglePasswordVisibility);

    on<AuthenticationErrors>((event, emit) {
      emit(AuthenticatedErrors(message: event.errorMessage));
    });
  }
// store Credential storing in sharedPreference...!

  Future<void> saveAuthState(String uid, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('email', email);
    log('saved UID: $uid');
    log('saved email $email');
  }

// user Credential Clearing...!

  Future<void> cleareAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('email');
    log('Cleared User Credential');
  }

// ..................Validation..............!

  FutureOr<void> validateTextField(
      TextFieldTextChanged event, Emitter<AuthState> emit) {
    try {
      emit(isValidEmail(event.text)
          ? TextValid()
          : TextInvalid(message: 'Enter Valid Email'));
    } catch (e) {
      emit(AuthenticatedErrors(message: e.toString()));
    }
  }

  bool isValidEmail(String text) {
    return text.isNotEmpty && text.contains('@gmail.com');
  }

  FutureOr<void> validatePasswordField(
      TextFieldPasswordChanged event, Emitter<AuthState> emit) {
    try {
      emit(isvalidPassword(event.password)
          ? passwordValid()
          : passwordInvalid(message: 'Enter Valid Passwoword'));
    } catch (e) {
      emit(AuthenticatedErrors(message: e.toString()));
    }
  }

  bool isvalidPassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  FutureOr<void> togglePasswordVisibility(
      TogglePasswordVisiblility event, Emitter<AuthState> emit) {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityToggled(isVisible: isPasswordVisible));
  }
}
