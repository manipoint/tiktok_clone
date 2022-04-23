import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/model/user_model.dart';
import 'package:tiktok_clone/view/pages/auth/login_page.dart';

import '../view/pages/home_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;

  XFile? get displayPhoto => mediaController.displayPhoto;
  User get user => _user.value!;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController usernameController;
  late final TextEditingController conformPasswordController;

  @override
  void onInit() {
    super.onInit();

    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    conformPasswordController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
    conformPasswordController.dispose();
    usernameController.dispose();
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => const HomePage());
    }
  }

  registerUser(
      String username, String email, String password, XFile? image) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String downloadUrl = await mediaController.upload(File(image!.path));
      UserModel userModel = UserModel(
          name: username,
          displayPhoto: downloadUrl,
          email: email,
          uid: credential.user!.uid);
      await userCollection
          .doc(credential.user!.uid)
          .set(userModel.toJson());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  String? validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  String? validatePassword(String value) {
    if (value.length < 6) {
      return "Password must be of 6 characters";
    }
    return null;
  }

  String? validateUsername(String value) {
    if (value.length < 3) {
      return "User name must be of 3 characters";
    }
    return null;
  }

  String? conformPassword(String value) {
    if (passwordController.text != conformPasswordController.text) {
      return "Password Dose not Matched";
    }
    return null;
  }

  void checkLogin(String email, String password) {
    try {
      auth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error Logging in',
        e.toString(),
      );
      if (kDebugMode) {
        print("error while login :${e.toString()}");
      }
    }
  }

  signOut() async {
    await auth.signOut();
  }
}
