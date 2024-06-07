import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_master_web/bussiness_layer/models/logic_models/admin_detail.dart';
import 'package:event_master_web/presentation_layer/screens/get_started.dart';
import 'package:event_master_web/presentation_layer/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
        await saveAuthState(user.uid, user.email!);
        print('Account is Authenticated');

        emit(Authenticated(
            UserModel(uid: user.uid, email: user.email, password: '')));
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
            'createAt': DateTime.now()
          });
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
        Get.offAll(() => HomeScreen());
        emit(Authenticated(UserModel(uid: uid, email: email, password: '')));
      } else {
        print('User NOt found in FirebaseAuth');
        emit(UnAuthenticated());
        Get.offAll(() => GetStartedScreen());
        final user = auth.currentUser;

        if (user != null) {
          print('User Fount in FireBase');
          Get.offAll(() => HomeScreen());
          emit(Authenticated(UserModel(uid: uid, email: email, password: '')));
        } else {
          emit(UnAuthenticated());
          print('User Not found in FirebaseAuth');
          Get.offAll(() => GetStartedScreen());
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

// Google Authentication...!

    on<GoogleAuth>((event, emit) async {
      emit(AuthLoading());

      try {
        final GoogleSignInAccount? googlUser = await GoogleSignIn().signIn();
        if (googlUser == null) {
          emit(AuthenticatedErrors(message: 'Google SignIn Canceled'));
          return;
        }
        final GoogleSignInAuthentication? googleAuth =
            await googlUser.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

        final UserCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final user = UserCredential.user;

        if (user != null) {
          await saveAuthState(user.uid, user.email!);
          emit(Authenticated(
              UserModel(uid: user.uid, email: user.email, password: '')));
          print('Google Authentication Success');
        } else {
          emit(AuthenticatedErrors(
              message: 'Failed to authenticate with Google'));
        }
      } catch (e) {
        emit(AuthenticatedErrors(message: 'Google Authentication Errror $e'));
      }
    });

// Googel sign Out...!

    on<SignOutWithGoogle>((event, emit) async {
      try {
        await GoogleSignIn().signOut();
        cleareAuthState();
      } catch (e) {
        emit(AuthenticatedErrors(message: 'SignOut Error'));
      }
    });
    // .....................Validation............!

    on<TextFieldTextTexChanged>(validateTextField);
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
      TextFieldTextTexChanged event, Emitter<AuthState> emit) {
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
