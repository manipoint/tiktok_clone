import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/const/text_felid_const.dart';
import 'package:tiktok_clone/view/pages/auth/sign_up_page.dart';
import 'package:tiktok_clone/view/widgets/text_input_field.dart';

import '../../../const/constants.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          key: loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              vertical120,
              const Text("Tictok Clone",
                  style: TextStyle(
                    fontSize: 38,
                    color: buttonColor,
                    fontWeight: FontWeight.w900,
                  )),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 24,
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
                height: 24,
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
                height: 32,
              ),
              Container(
                height: 48,
                width: MediaQuery.of(context).size.width - 40,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: buttonColor),
                child: InkWell(
                  onTap: () {
                    final isValid = loginFormKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    authController.checkLogin(
                        authController.emailController.text,
                        authController.passwordController.text);
                    loginFormKey.currentState!.save();
                  },
                  child: const Center(
                    child: Text(
                      "Login",
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
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have an account? ',
                    style: TextStyle(fontSize: 20, color: Colors.white38),
                  ),
                  InkWell(
                    onTap: () => Get.to(() => SignUpPage()),
                    child: const Text(
                      'Register',
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
