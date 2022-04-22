import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tiktok_clone/view/pages/auth/login_page.dart';
import 'package:tiktok_clone/view/widgets/text_input_field.dart';

import '../../../constants.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 24,
              ),
              const Text("Tictok Clone",
                  style: TextStyle(
                    fontSize: 32,
                    color: buttonColor,
                    fontWeight: FontWeight.w900,
                  )),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Stack(
                children: [
                  Obx(() => authController.displayPhoto == null
                      ? const CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage("assets/images/dp.png"),
                        )
                      : SizedBox(
                          height: 120,
                          width: 120,
                          child: mediaController.previewImage(),
                        )),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () => mediaController.selectImage(context),
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 18),
                child: TextInputFieldWithValidator(
                  validator: ((value) =>
                      authController.validateUsername(value!)),
                  controller: authController.usernameController,
                  labelText: "UserName",
                  isObscure: false,
                  icon: Icons.person,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 18),
                child: TextInputFieldWithValidator(
                  validator: ((value) => authController.validateEmail(value!)),
                  controller: authController.emailController,
                  labelText: "Email",
                  isObscure: false,
                  icon: Icons.email,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 18),
                child: TextInputFieldWithValidator(
                  validator: ((value) =>
                      authController.validatePassword(value!)),
                  controller: authController.passwordController,
                  labelText: "Password",
                  isObscure: true,
                  icon: Icons.lock,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 18),
                child: TextInputFieldWithValidator(
                  validator: ((value) =>
                      authController.conformPassword(value!)),
                  controller: authController.conformPasswordController,
                  labelText: "Re-enter Password",
                  isObscure: true,
                  icon: Icons.lock,
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 40,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: buttonColor),
                child: InkWell(
                  onTap: () => authController.registerUser(
                      authController.usernameController.text,
                      authController.emailController.text,
                      authController.passwordController.text,
                      mediaController.displayPhoto),
                  child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 20, color: Colors.white38),
                  ),
                  InkWell(
                    onTap: () => Get.to(LoginPage()),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: buttonColor),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
