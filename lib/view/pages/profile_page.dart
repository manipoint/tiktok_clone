import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/view/pages/auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  final String uid;
  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            authController.signOut();
            Get.to(() =>  LoginPage());
          },
          child: const Text("Sign Out")),
    );
  }
}
