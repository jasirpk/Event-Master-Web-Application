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
        final UserCredential = await auth.signInWithEmailAndPassword(email: event.email, password: event.password);
        final user = UserCredential.user!;
        final isPlatformAdmin = await _hasAdminClaim(user);
        if (isPlatformAdmin) {
          await saveAuthState(user.uid, user.email!);
          print('Account is Authenticated');

          emit(Authenticated(UserModel(uid: user.uid, email: user.email, password: '')));
        } else {
          await auth.signOut();
          await cleareAuthState();
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
        final UserCredential =
            await auth.createUserWithEmailAndPassword(email: event.userModel.email.toString(), password: event.userModel.password.toString());
        final user = UserCredential.user;
        if (user != null) {
          // Account bookkeeping only — no 'password' and no 'platform' field.
          // Authorization is decided solely by the 'role' Firebase custom
          // claim, which is assigned out-of-band by the Firebase Admin SDK.
          await FirebaseFirestore.instance
              .collection('developer')
              .doc(user.uid)
              .set({'uid': user.uid, 'email': user.email, 'createAt': DateTime.now()});
          await user.updateProfile(displayName: 'web');

          // A brand-new sign-up never carries the admin claim, but this is
          // verified rather than assumed so SignUp never grants access itself.
          final isPlatformAdmin = await _hasAdminClaim(user);
          if (isPlatformAdmin) {
            await saveAuthState(user.uid, user.email!);
            log('Account is Authenticated');
            emit(Authenticated(UserModel(uid: user.uid, email: user.email!, password: '')));
          } else {
            await auth.signOut();
            emit(AuthenticatedErrors(message: 'Account created. An administrator must grant access before you can sign in.'));
          }
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

      // Wait for Firebase Auth to finish restoring its persisted session
      // (currentUser can be null for an instant on startup, e.g. on web,
      // before persistence has loaded) instead of trusting SharedPreferences.
      final user = await auth.authStateChanges().first;

      if (user == null) {
        await cleareAuthState();
        emit(UnAuthenticated());
        print('No active Firebase Auth session');
        return;
      }

      final isPlatformAdmin = await _hasAdminClaim(user);
      if (isPlatformAdmin) {
        await saveAuthState(user.uid, user.email ?? '');
        Get.offAllNamed(RoutsClass.getHomeRout());
        emit(Authenticated(UserModel(uid: user.uid, email: user.email, password: '')));
        print('Session restored for platform admin');
      } else {
        await auth.signOut();
        await cleareAuthState();
        emit(UnAuthenticated());
        print('Firebase session found but role=admin claim is missing');
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
// Platform-admin authorization...!
// Source of truth is the verified Firebase ID-token 'role' custom claim —
// never Firestore developer/{uid}.platform and never SharedPreferences.

  Future<bool> _hasAdminClaim(User user) async {
    final tokenResult = await user.getIdTokenResult(true);
    return tokenResult.claims?['role'] == 'admin';
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

  FutureOr<void> validateTextField(TextFieldTextChanged event, Emitter<AuthState> emit) {
    try {
      emit(isValidEmail(event.text) ? TextValid() : TextInvalid(message: 'Enter Valid Email'));
    } catch (e) {
      emit(AuthenticatedErrors(message: e.toString()));
    }
  }

  bool isValidEmail(String text) {
    return text.isNotEmpty && text.contains('@gmail.com');
  }

  FutureOr<void> validatePasswordField(TextFieldPasswordChanged event, Emitter<AuthState> emit) {
    try {
      emit(isvalidPassword(event.password) ? passwordValid() : passwordInvalid(message: 'Enter Valid Passwoword'));
    } catch (e) {
      emit(AuthenticatedErrors(message: e.toString()));
    }
  }

  bool isvalidPassword(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  FutureOr<void> togglePasswordVisibility(TogglePasswordVisiblility event, Emitter<AuthState> emit) {
    isPasswordVisible = !isPasswordVisible;
    emit(PasswordVisibilityToggled(isVisible: isPasswordVisible));
  }
}
